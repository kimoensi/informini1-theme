# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :general_law do
    date_of_birth Date.yesterday
    marital_status 'single'
    occupation 'programmer'
    domicile 'Nicaragua'
  end

end
