module AuthAC
  def login_required
    if not logged_in?
      call( Rs( :login ) )
    end
  end
  
  # Override if desired
  def deny_access
    call( "/access/denied" )
  end
  
  # Accepts a list/array of flags (as Strings) needed for access.
  # In your controller action, call requires_flags to restrict access.
  # This will redirect to /access/denied if there is no user logged in,
  # or if the user does not have the required_flags.
  # If the user has the required_flags, no further action is taken,
  # and processing continues in your controller action.
  def requires_flags( *required_flags )
    user = session[ :user ]
    if user.nil? or not user.has_flags?( *required_flags )
      deny_access
    end
  end
  alias requires_flag requires_flags
  alias require_flags requires_flags
  alias require_flag requires_flags
end