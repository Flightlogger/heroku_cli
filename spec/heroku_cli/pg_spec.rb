require "spec_helper"

RSpec.describe HerokuCLI::PG do
  let(:subject) { HerokuCLI::PG.new('test') }

  before do
    allow(subject).to receive(:heroku) { nil }
  end

  context 'info' do
    before do
      allow(subject).to receive(:heroku) { file_fixture('pg_info_multi') }
    end

    it 'will parse multiple databases' do
      expect(subject.info).to be_a(Array)
      expect(subject.info.size).to eq 2
    end

    it { expect(subject.main.name).to eq 'DATABASE' }
    it { expect(subject.forks.map(&:name)).to eq ['HEROKU_POSTGRESQL_ORANGE'] }
  end

  context 'create_follower' do
    let(:db_name) { file_fixture('pg_info').split("\n").first.split(' ').last }
    let(:db_info) { file_fixture('pg_info').split("\n")[1..-1] }
    let (:database) { HerokuCLI::PG::Database.new(db_name, db_info) }

    it 'with same plan' do
      expect(subject).to receive(:heroku).with("addons:create heroku-postgresql:Standard-0 --follow postgresql-curved-14316")
      subject.create_follower(database)
    end

    it 'with the plan specified' do
      expect(subject).to receive(:heroku).with("addons:create heroku-postgresql:foobar --follow postgresql-curved-14316")
      subject.create_follower(database, plan: 'foobar')
    end
  end

  context 'un_follower' do
    before do
      allow(subject).to receive(:heroku).with('pg:info') { file_fixture('pg_info_multi') }
    end

    it 'fails if not follower' do
      database = subject.main
      expect { subject.un_follow(database) }.to raise_exception('Not a following database DATABASE')
    end

    it 'will unfollow' do
      database = subject.forks.first
      expect(subject).to receive(:heroku).with("pg:unfollow HEROKU_POSTGRESQL_ORANGE_URL -c test")
      subject.un_follow(database)
    end
  end
end
