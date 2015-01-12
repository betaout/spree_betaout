module Spree
  module Betaout
    class Configuration < Spree::Preferences::Configuration
      preference :account_id, :string
      preference :account_key, :string
    end
  end
end
