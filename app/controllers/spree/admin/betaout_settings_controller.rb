module Spree
  module Admin
    class BetaoutSettingsController < Spree::Admin::BaseController

      def edit
        @preferences = [:betaout_project_id, :betaout_api_key, :betaout_api_secret]
      end

      def update
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          Spree::Config[name] = value
        end
        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:betaout_settings))

        redirect_to edit_admin_betaout_settings_path
      end

    end
  end
end
