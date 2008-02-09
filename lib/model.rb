require 'm4dbi'

connection_str = "DBI:#{AuthAC.trait[ :db ][ :vendor ]}:#{AuthAC.trait[ :db ][ :database ]}"
h = AuthAC.trait[ :db ][ :host ]
if h and not h.empty?
  connection_str << "@#{AuthAC.trait[ :db ][ :host ]}"
end
$authac_dbh = DBI.connect(
  connection_str,
  AuthAC.trait[ :db ][ :user ],
  AuthAC.trait[ :db ][ :password ]
)

class User < DBI::Model( AuthAC.trait[ :tables ][ :users ] )
  def groups
    UserGroup.s(
      %{
        SELECT
          g.*
        FROM
          #{AuthAC.trait[ :tables ][ :user_groups ]} g,
          #{AuthAC.trait[ :tables ][ :users_groups ]} ug
        WHERE
          g.id = ug.group_id
          AND ug.user_id = ?
      },
      pk
    ).all
  end
  
  def flags
    groups.collect { |g| g.flags }.flatten
  end
  
  def has_flags?( *fs )
    my_flags = flags.copy
    fs.each do |f|
      if not my_flags.find { |mf| mf.name == f }
        return false
      end
    end
    true
  end
  alias has_flag? has_flags?
  
end

class Flag < DBI::Model( AuthAC.trait[ :tables ][ :flags ] )
  def to_s
    name
  end
end

class UserGroup < DBI::Model( AuthAC.trait[ :tables ][ :user_groups ] )
  def flags
    Flag.s(
      %{
        SELECT
          f.*
        FROM
          #{AuthAC.trait[ :tables ][ :flags ]} f,
          #{AuthAC.trait[ :tables ][ :user_group_flags ]} gf
        WHERE
          f.id = gf.flag_id
          AND gf.user_group_id = ?
      },
      pk
    )
  end
end

