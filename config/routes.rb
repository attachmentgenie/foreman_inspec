Rails.application.routes.draw do
  get 'new_action', to: 'foreman_inspec/hosts#new_action'
end
