require "spec_helper"

RSpec.describe HerokuCLI::PG::Database do
  let(:db_name) { file_fixture('pg_info').split("\n").first.split(' ').last }
  let(:db_info) { file_fixture('pg_info').split("\n")[1..-1] }
  let(:subject) { HerokuCLI::PG::Database.new(db_name, db_info) }

  it { expect(subject.url_name).to eq 'DATABASE_URL' }
  it { expect(subject.name).to eq 'DATABASE' }
  it { expect(subject.plan).to eq 'Standard-0' }
  it { expect(subject.data_size).to eq '16.3 GB' }
  it { expect(subject.status).to eq 'Available' }
  it { expect(subject.tables).to eq 136 }
  it { expect(subject.version.to_s).to eq '9.5.10' }
  it { expect(subject.followers).to eq 'HEROKU_POSTGRESQL_ORANGE' }
  it { expect(subject.main?).to eq true }
  it { expect(subject.fork?).to eq false }
  it { expect(subject.behind?).to eq false }
  it { expect(subject.region).to eq 'eu' }
  it { expect(subject.resource_name).to eq 'postgresql-curved-12345' }
  it { expect(subject.to_s).to eq file_fixture('pg_info') }
end
