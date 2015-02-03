Spree::BaseController.class_eval do
  before_filter :betaout_check_for_ott, if: "Spree::Betaout::Config.track_via_backend?"
  before_filter :betaout_set_email, if: "Spree::Betaout::Config.track_via_backend?"
  before_filter :betaout_set_name, if: "Spree::Betaout::Config.track_via_backend?"

  private

    def betaout_check_for_ott
      if cookies[:_betaoutUITN].nil?
        logger.debug "spree_betaout: didn't have an OTT, so fetching it"
        ott=SecureRandom.uuid
        session[:betaout_ott]=ott
        session[:betaout_ip] = request.env['REMOTE_ADDR']
        session[:betaout_systemInfo] = request.env['HTTP_USER_AGENT']
        Betaout.fetch_ott(session)
        cookies[:_ampUITN] = ott
        cookies[:_betaoutUITN] = ott
        logger.debug "spree_betaout: basic fetched OTT: #{ott.inspect}"
      else
       logger.debug "spree_betaout basic : had OTT, so doing nothing: #{cookies[:_ampUITN]}"
        session[:betaout_ott]=cookies[:_betaoutUITN]
        session[:betaout_ip] = request.env['REMOTE_ADDR']
        session[:betaout_systemInfo] = request.env['HTTP_USER_AGENT']
      end
      
    end

    def betaout_set_email
      if order && order.email
        session[:betaout_email] = order.email
      elsif spree_current_user && spree_current_user.email
        logger.debug "spree_betaout: set email basic : #{session[:betaout_email]}"
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
