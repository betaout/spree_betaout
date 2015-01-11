Spree::BaseController.class_eval do
  before_filter :betaout_check_for_ott
  before_filter :betaout_set_email
  before_filter :betaout_set_name

  private

    def betaout_check_for_ott
      if session[:betaout_ott].nil?
        logger.debug "spree_betaout: didn't have an OTT, so fetching it"
        ott = Betaout.fetch_ott(session)
        logger.debug "spree_betaout: fetched OTT: #{ott.inspect}"
        session[:betaout_ott] = ott
      else
        logger.debug "spree_betaout: had OTT, so doing nothing: #{session[:betaout_ott]}"
      end
    end

    def betaout_set_email
      session[:betaout_email] = (current_order && current_order.email) || (spree_current_user && spree_current_user.email) || nil
    end

    def betaout_set_name
      session[:betaout_name] = current_order.name if current_order && current_order.name
    end
end
