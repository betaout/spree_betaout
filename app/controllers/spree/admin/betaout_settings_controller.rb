module Spree
  module Admin
    class BetaoutSettingsController < Admin::BaseController
      def edit
        render :edit
      end

      def update
        Spree::Betaout::Config[:account_id] = params[:account_id]
        Spree::Betaout::Config[:account_key] = params[:account_key]
        flash[:success] = Spree.t(:successfully_updated, :resource => Spree.t(:betaout_settings))
        render :edit
      end
    end
  end
end
