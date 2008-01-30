require 'kansas'

$kansas_dbh = KSDatabase.new(
    "dbi:#{AuthAC::DB_VENDOR}:#{AuthAC::DB_NAME}:#{AuthAC::DB_HOST}",
    AuthAC::DB_USER,
    AuthAC::DB_PASSWORD
)

$kansas_dbh.table( :Users, :users )
$kansas_dbh.table( :Flags, :flags )
$kansas_dbh.table( :UserGroups,  :user_groups )

$kansas_dbh.table( :UserGroupsFlags, :user_groups_flags )
KSDatabase::UserGroupsFlags.to_one( :user_group, :user_group_id, :UserGroups )
KSDatabase::UserGroupsFlags.to_one( :group, :user_group_id, :UserGroups )
KSDatabase::UserGroupsFlags.to_one( :flag, :flag_id, :Flags )

$kansas_dbh.table( :UsersGroups,  :users_groups )
KSDatabase::UsersGroups.to_one( :user, :user_id, :Users )
KSDatabase::UsersGroups.to_one( :user_group, :user_group_id, :UserGroups )
KSDatabase::UsersGroups.to_one( :group, :user_group_id, :UserGroups )

KSDatabase::UserGroups.to_many( :flags, :UserGroupsFlags, :user_group_id )
KSDatabase::Users.to_many( :user_groups, :UsersGroups, :user_id )
KSDatabase::Users.to_many( :groups, :UsersGroups, :user_id )
KSDatabase::UserGroups.to_many( :users, :UsersGroups, :user_group_id )

