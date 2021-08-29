Rails.application.routes.draw do
  root to: 'main#index'
  post '/', to: 'main#index'
  get '/logs', to: 'main#logs'
end
