Rails.application.routes.draw do
  # Components Documentation Routes
  get "components", to: redirect("/components/button")
  get "components/:component", to: "components#show", as: :component_doc
  get "components/examples/table_demo", to: "components#table_demo", as: :table_demo

  root "home#index"
end
