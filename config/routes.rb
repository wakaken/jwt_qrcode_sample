Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :jwt_qrcode
  resource :jwt_qrcode_google_chart
end
