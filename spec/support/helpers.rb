module Helpers
  def file_fixture(name)
    file_name = File.join(__dir__, '..', 'fixtures', "#{name}.fixture")
    raise "Fixture #{file_name} does not exists" unless File.exist?(file_name)
    File.read(file_name)
  end
end