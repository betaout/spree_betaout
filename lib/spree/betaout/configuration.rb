module Spree
  module Betaout
    class Configuration < Spree::Preferences::Configuration
      preference :account_id, :string
      preference :account_key, :string
      preference :tracking_method, :string

      def track_via_backend?
        tracking_method == 'backend'
      end
    end
  end
end
