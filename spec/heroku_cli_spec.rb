require "spec_helper"

RSpec.describe HerokuCLI do
  it "has a version number" do
    expect(HerokuCLI::VERSION).not_to be nil
  end

  it "can return an application object" do
    expect(HerokuCLI.application('test')).to be_a(HerokuCLI::Application)
  end
end
