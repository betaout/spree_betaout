Spree::UserSessionsController.class_eval do
  after_filter :betaout_call_identify, only: :create

  private
    def betaout_call_identify
      logger.debug "spree_betaout: after login, calling identify"
      if cookies[:_betaoutUITN].nil? && cookies[:_betaoutEMAIL].nil?
        logger.debug "spree_betaout: didn't have an OTT, so fetching it"
        ott=SecureRandom.uuid
        session[:betaout_ott]=ott
        session[:betaout_ip] = request.env['REMOTE_ADDR']
        session[:betaout_systemInfo] = request.env['HTTP_USER_AGENT']
        if spree_current_user && spree_current_user.email
           session[:betaout_email] =spree_current_user.email
           cookies[:_betaoutEMAIL] =spree_current_user.email
        end
        Betaout.fetch_ott(session)
        cookies[:_ampUITN] = ott
        cookies[:_betaoutUITN] = ott
      else
        if spree_current_user && spree_current_user.email
          session[:betaout_email] =spree_current_user.email
          cookies[:_betaoutEMAIL] =spree_current_user.email
        end
        Betaout.fetch_ott(session);
      end
    end
end
