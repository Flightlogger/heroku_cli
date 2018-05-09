require "spec_helper"

RSpec.describe HerokuCLI::PG do
  let(:subject) { HerokuCLI::PG.new('test') }

  before do
    allow(subject).to receive(:heroku) { file_fixture('pg_info_multi') }
  end

  it 'will parse multible databases' do
    expect(subject.info).to be_a(Array)
    expect(subject.info.size).to eq 2
  end

  it { expect(subject.main.name).to eq 'DATABASE' }
  it { expect(subject.forks.map(&:name)).to eq ['HEROKU_POSTGRESQL_ORANGE'] }
end
