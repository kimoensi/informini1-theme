# -*- encoding : utf-8 -*-
class AddUserIdToTunisianLaws < ActiveRecord::Migration

  def self.up
    change_table(:tunisian_laws) do |t|
      t.references :user
    end
  end

  def self.down
    remove_column :tunisian_laws, :user_id
  end

end
