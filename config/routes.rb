Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'querylogger/index'
  match 'channel-icon/findmissing', to: 'querylogger#findmissing', via: [:get, :post ]
  match 'channel-icon/lookup', to: 'querylogger#lookup', via: [:get, :post ]
  match 'channel-icon/search', to: 'querylogger#search', via: [:get, :post ]
  match 'channel-icon/submit', to: 'querylogger#submit', via: [:post ]
end
