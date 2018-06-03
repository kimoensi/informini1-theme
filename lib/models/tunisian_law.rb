# -*- encoding : utf-8 -*-
class TunisianLaw < ActiveRecord::Base
  belongs_to :user

  validates :person_status,
            :presence => { :message => _('Please enter your person status') }

  validates :postal_addresse,
            :presence => { :message => _('Please enter your addresse') }

  def display_attributes
    attributes.slice('person_status', 'postal_addresse')
  end

end
