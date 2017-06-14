Rails.application.routes.draw do
  resources :out_of_band_auths do
    collection do
      get :login
      post :login
    end
  end
end
