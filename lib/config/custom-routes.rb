# -*- encoding : utf-8 -*-
# Here you can override or add to the pages in the core website

Rails.application.routes.draw do

  match '/profile/tunisian_law/edit' => 'tunisian_laws#edit',
        :as => :edit_tunisian_law,
        :via => :get

  match '/profile/tunisian_law' => 'tunisian_laws#update',
        :as => :tunisian_law,
        :via => :put
end
