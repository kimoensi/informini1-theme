# -*- encoding : utf-8 -*-
# This file is executed in the Rails evironment by the `rails-post-install` script
#

def table_exists?(table)
  ActiveRecord::Base.connection.table_exists?(table)
end

def column_exists?(table, column)
  if table_exists?(table)
    ActiveRecord::Base.connection.column_exists?(table, column)
  end
end

unless table_exists?(:tunisian_laws)
  migration_file_path = '../db/migrate/create_tunisian_laws'
  require File.expand_path migration_file_path, __FILE__
  CreateTunisianLaws.up
end

unless column_exists?(:tunisian_laws, :user_id)
  migration_file_path = '../db/migrate/add_user_id_to_tunisian_laws'
  require File.expand_path migration_file_path, __FILE__
  AddUserIdToTunisianLaws.up
end

# Create any necessary global Censor rules
require File.expand_path(File.dirname(__FILE__) + '/lib/censor_rules')