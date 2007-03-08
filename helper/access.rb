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
                    group.flags.each do |flag|
                        flags[ flag ] = true
                    end
                end
            end
            flags
        end
        
        def requires_flags( *required_flags )
            _user_flags = user_flags()
            required_flags.each do |flag|
                if not _user_flags[ flag ]
                    redirect( R( AuthAC::AccessController, :denied ) )
                end
            end
        end
        alias requires_flag requires_flags
        alias require_flags requires_flags
        alias require_flag requires_flags
    end
end