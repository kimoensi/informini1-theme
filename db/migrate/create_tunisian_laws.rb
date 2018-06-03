# -*- encoding : utf-8 -*-
class CreateTunisianLaws < ActiveRecord::Migration
  def self.up
    create_table :tunisian_laws do |t|
      t.column :person_status, :string, :null => false
      t.column :postal_addresse, :text, :null => false
    end
  end

  def self.down
    drop_table :tunisian_laws
  end
end
