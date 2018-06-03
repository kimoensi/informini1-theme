# -*- encoding : utf-8 -*-
# Here you can override or add to the pages in the core website
Rails.application.routes.draw do

  match '/profile/general_law/edit' => 'general_laws#edit',
        :as => :edit_general_law,
        :via => :get

  match '/profile/general_law' => 'general_laws#update',
        :as => :general_law,
        :via => :put

  match '/profile/identity_card_number/edit' => 'user_identity_card_number#edit',
        :as => :user_edit_identity_card_number,
        :via => :get

  match '/profile/identity_card_number' => 'user_identity_card_number#update',
        :as => :user_update_identity_card_number,
        :via => :put
end
