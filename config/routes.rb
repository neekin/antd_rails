Rails.application.routes.draw do
  # Components Documentation Routes
  get "components", to: redirect("/components/button")
  get "components/:component", to: "components#show", as: :component_doc

  root "home#index"
end
