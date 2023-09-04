require 'sidekiq/web'
require 'sidekiq/cron/web'

if ENV['SIDEKIQ_WEB_USERNAME'].present? && ENV['SIDEKIQ_WEB_PASSWORD'].present?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_WEB_USERNAME'])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_WEB_PASSWORD']))
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users

  root to: "pages#home"

  resources :quotes do
    resources :line_item_dates, except: [:index, :show]
  end

  resources :quotes do
    resources :line_item_dates, except: [:index, :show] do
      resources :line_items, except: [:index, :show]
    end
  end
end
