Rails.application.routes.draw do
  resources :likes do
    collection do
      get 'search'
    end
  end
  resources :images do
    collection do
      get 'search'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
