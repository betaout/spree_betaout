require 'spec_helper'

describe "Betaout configuration" do

  it "has an account_id with nil" do
    config = Spree::Betaout::Configuration.new
    expect(config.account_id).to eql(nil)
  end


end
