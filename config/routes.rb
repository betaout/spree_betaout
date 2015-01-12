Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :betaout_settings, only: [:edit, :update]
  end
end
