# -*- encoding : utf-8 -*-
# Uninstall hook code here
#

def table_exists?(table)
  ActiveRecord::Base.connection.table_exists?(table)
end

def column_exists?(table, column)
  if table_exists?(table)
    ActiveRecord::Base.connection.column_exists?(table, column)
  end
end

if ENV['REMOVE_MIGRATIONS']

  if table_exists?(:tunisian_laws)
    migration_file_path = '../db/migrate/create_tunisian_laws'
    require File.expand_path migration_file_path, __FILE__
    CreateTunisianLaws.down
  end

  if column_exists?(:tunisian_laws, :user_id)
    migration_file_path = '../db/migrate/add_user_id_to_tunisian_laws'
    require File.expand_path migration_file_path, __FILE__
    AddUserIdToTunisianLaws.down
  end
end