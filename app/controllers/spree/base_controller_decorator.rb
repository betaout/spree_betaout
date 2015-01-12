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
      if order && order.email
        session[:betaout_email] = order.email
      elsif spree_current_user && spree_current_user.email
        session[:betaout_email] = spree_current_user.email
      end
    end

    def betaout_set_name
      session[:betaout_name] = order.name if order && order.name
    end

    def order
      defined?(current_order) && current_order ? current_order : nil
    end
end
