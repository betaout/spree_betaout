Spree::UserSessionsController.class_eval do
  after_filter :betaout_call_identify, only: :create

  private
    def betaout_call_identify
      logger.debug "spree_betaout: after login, calling identify#{Spree::Betaout::Config.account_id}"
      if cookies[:_ampUITN].nil? && cookies[:_ampEm].nil?
        logger.debug "spree_betaout: didn't have an OTT, so fetching it"
        ott=SecureRandom.uuid
        session[:betaout_ott]=ott
        session[:betaout_ip] = request.env['REMOTE_ADDR']
        session[:betaout_systemInfo] = request.env['HTTP_USER_AGENT']
        session[:betaout_host] = request.env['HTTP_HOST']
        if spree_current_user && spree_current_user.email
           session[:betaout_email] =spree_current_user.email
           session[:betaout_name] =spree_current_user.first_name
           cookies[:_ampEm] =Base64.encode64(spree_current_user.email)
        end
        Betaout.fetch_ott(session)
        cookies[:_ampUITN]="";
      else
        logger.debug "spree_betaout: have an OTT login"
        if spree_current_user && spree_current_user.email
          session[:betaout_email] =spree_current_user.email
          session[:betaout_name] =spree_current_user.first_name
          cookies[:_ampEm] =Base64.encode64(spree_current_user.email)
          Betaout.fetch_ott(session);
          cookies[:_ampUITN]="";
        end
        

      end
    end
end
