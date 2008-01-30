module AuthAC
    module Helper
        def login_required
            if not logged_in?
                call( R( self, :login ) )
            end
        end
        
        # Returns a Hash of the access flags of the currently logged in user.
        # The hash keys are the flags, and the values are true or false.
        # Returns an empty hash if no user is logged in.
        def user_flags
            flags = Hash.new
            user = session[ :user ]
            if user
                user.groups.each do |group|
                    group.group.flags.each do |flag|
                        flags[ flag.flag.name ] = true
                    end
                end
            end
            flags
        end
        
        def user_has_flags( *flags )
            has_them = true
            _user_flags = user_flags()
            flags.each do |flag|
                if not _user_flags[ flag ]
                    has_them = false
                    break
                end
            end
            has_them
        end
        alias user_has_flag user_has_flags
        
        def deny_access
            call( "#{SITE_ROOT || ''}/access/denied" )
        end
        
        # Accepts a list/array of flags (as Strings) needed for access.
        # In the controller action, call requires_flags to restrict access.
        # This will redirect to /access/denied if there is no user logged in,
        # or if the user does not have the required_flags.
        # If the user has the required_flags, no further action is taken,
        # and processing continues in your controller action.
        def requires_flags( *required_flags )
            if not user_has_flags( *required_flags )
                deny_access
            end
        end
        alias requires_flag requires_flags
        alias require_flags requires_flags
        alias require_flag requires_flags
    end
end