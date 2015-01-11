module Spree
  AppConfiguration.class_eval do
    preference :betaout_project_id, :string
    preference :betaout_api_key, :string
  end
end
