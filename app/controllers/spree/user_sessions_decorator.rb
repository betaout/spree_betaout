Spree::UserSessionsController.class_eval do
  after_filter :betaout_call_identify, only: :create

  private
    def betaout_call_identify
      logger.debug "spree_betaout: after login, calling identify"
      if cookies[:amplifyUid].nil?
        logger.debug "spree_betaout: didn't have an OTT, so fetching it"
        ott = Betaout.fetch_ott(session)
        logger.debug "spree_betaout: fetched OTT: #{ott.inspect}"
        cookies[:amplifyUid] = ott
      else
        logger.debug "spree_betaout: had OTT, so doing nothing: #{cookies[:amplifyUid]}"
      end
      session[:betaout_ott] = cookies[:amplifyUid]
    end
end
