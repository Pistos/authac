require 'kansas'

$dbh = KSDatabase.new(
    "dbi:#{AuthAC::DB_VENDOR}:#{AuthAC::DB_NAME}:#{AuthAC::DB_HOST}",
    AuthAC::DB_USER,
    AuthAC::DB_PASSWORD
)

$dbh.table( :Users, :users )
$dbh.table( :Flags, :flags )
$dbh.table( :UserGroups,  :user_groups )

$dbh.table( :UserGroupsFlags, :user_groups_flags )
KSDatabase::UserGroupsFlags.to_one( :user_group, :user_group_id, :UserGroups )
KSDatabase::UserGroupsFlags.to_one( :flag, :flag_id, :Flags )

$dbh.table( :UsersGroups,  :users_groups )
KSDatabase::UsersGroups.to_one( :user, :user_id, :Users )
KSDatabase::UsersGroups.to_one( :user_group, :user_group_id, :UserGroups )

KSDatabase::UserGroups.to_many( :flags, :UserGroupsFlags, :user_group_id )
KSDatabase::Users.to_many( :user_groups, :UsersGroups, :user_id )
KSDatabase::UserGroups.to_many( :users, :UsersGroups, :user_group_id )

