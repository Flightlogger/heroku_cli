require "spec_helper"

RSpec.describe HerokuCLI::PG do
  let(:subject) { HerokuCLI::PG.new('test') }

  before do
    allow(subject).to receive(:heroku) { nil }
  end

  context 'info' do
    context 'only main' do
      before do
        allow(subject).to receive(:heroku) { file_fixture('pg_info') }
      end

      it 'will parse multiple databases' do
        expect(subject.info).to be_a(Array)
        expect(subject.info.size).to eq 1
      end

      it { expect(subject.main.name).to eq 'DATABASE' }
      it { expect(subject.forks.map(&:name)).to eq [] }
    end

    context 'follower' do
      before do
        allow(subject).to receive(:heroku) { file_fixture('pg_info_follow') }
      end

      it 'will parse multiple databases' do
        expect(subject.info).to be_a(Array)
        expect(subject.info.size).to eq 2
      end

      it { expect(subject.main.name).to eq 'DATABASE' }
      it { expect(subject.forks.map(&:name)).to eq [] }
      it { expect(subject.followers.map(&:name)).to eq ['HEROKU_POSTGRESQL_ORANGE'] }
    end

    context 'fork' do
      before do
        allow(subject).to receive(:heroku) { file_fixture('pg_info_fork') }
      end

      it 'will parse multiple databases' do
        expect(subject.info).to be_a(Array)
        expect(subject.info.size).to eq 2
      end

      it { expect(subject.main.name).to eq 'DATABASE' }
      it { expect(subject.forks.map(&:name)).to eq ['HEROKU_POSTGRESQL_GRAY'] }
      it { expect(subject.followers.map(&:name)).to eq [] }
    end
  end

  context 'create_follower' do
    let(:db_info) { file_fixture('pg_info').split("\n") }
    let (:database) { HerokuCLI::PG::Database.new(db_info) }

    it 'with same plan' do
      expect(subject).to receive(:heroku).with("addons:create heroku-postgresql:standard-0 --follow postgresql-curved-12345")
      subject.create_follower(database)
    end

    it 'with the plan specified' do
      expect(subject).to receive(:heroku).with("addons:create heroku-postgresql:foobar --follow postgresql-curved-12345")
      subject.create_follower(database, plan: 'foobar')
    end
  end

  context 'un_follow' do
    before do
      allow(subject).to receive(:heroku).with('pg:info') { file_fixture('pg_info_follow') }
    end

    it 'fails if not follower' do
      database = subject.main
      expect { subject.un_follow(database) }.to raise_exception('Not a following database DATABASE')
    end

    it 'will unfollow' do
      database = subject.followers.first
      expect(subject).to receive(:heroku).with("pg:unfollow HEROKU_POSTGRESQL_ORANGE_URL -c test")
      subject.un_follow(database)
    end
  end

  context 'promote' do
    before do
      allow(subject).to receive(:heroku).with('pg:info') { file_fixture('pg_info_follow') }
    end

    it 'fails if already main' do
      database = subject.main
      expect { subject.promote(database) }.to raise_exception('Database already main DATABASE')
    end

    it 'will un_follow first' do
      database = subject.followers.first
      expect(subject).to receive(:un_follow).with(database, wait: false) { nil }
      expect(subject).to receive(:heroku).with('pg:promote postgresql-animated-12345')
      subject.promote(database, wait: false)
    end

    context 'ensure promoted master ready' do
      before do
        allow(subject).to receive(:heroku).with('pg:info') { file_fixture('pg_info_promote') }
      end

      it 'fails if already main' do
        database = subject.main
        expect(subject.main.follower?).to eq true
      end
    end
  end

  context 'reload' do
    it 'pick up changes in info' do
      allow(subject).to receive(:heroku).with('pg:info') { file_fixture('pg_info_follow') }
      expect(subject.main.name).to eq 'DATABASE'
      expect(subject.forks.map(&:name)).to eq []
      expect(subject.followers.map(&:name)).to eq ['HEROKU_POSTGRESQL_ORANGE']

      allow(subject).to receive(:heroku).with('pg:info') { file_fixture('pg_info_fork') }
      subject.reload
      expect(subject.main.name).to eq 'DATABASE'
      expect(subject.forks.map(&:name)).to eq ['HEROKU_POSTGRESQL_GRAY']
      expect(subject.followers.map(&:name)).to eq []
    end
  end

  context 'destroy' do
    before do
      allow(subject).to receive(:heroku).with('pg:info') { file_fixture('pg_info_fork') }
    end

    it 'fails if main' do
      database = subject.main
      expect { subject.destroy(database) }.to raise_exception('Cannot destroy test main database')
    end

    it 'will destroy addon' do
      database = subject.forks.first
      expect(subject).to receive(:heroku).with('addons:destroy HEROKU_POSTGRESQL_GRAY_URL -c test')
      subject.destroy(database)
    end
  end
end
