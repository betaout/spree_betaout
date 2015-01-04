Spree::BaseController.class_eval do
  before_filter :betaout_check_for_ott

  private

    def betaout_check_for_ott
      if session[:betaout_ott].nil?
        logger.debug "spree_betaout: didn't have an OTT, so fetching it"
        ott = Betaout.fetch_ott
        logger.debug "spree_betaout: fetched OTT: #{ott.inspect}"
        session[:betaout_ott] = ott
      else
        logger.debug "spree_betaout: had OTT, so doing nothing: #{session[:betaout_ott]}"
      end
    end
end
