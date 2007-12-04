require 'digest/sha1'

module AuthAC
class AuthenticationController < Ramaze::Controller
    map "/auth"
    
    include Helper
    helper :stack
    
    def index
        redirect( R( self, :login ) )
    end
    
    def register
        # Process POST, if any.
        
        if request.post?
            begin
                if request[ 'password' ] == request[ 'password2' ] and request[ 'username' ]
                    request[ 'username' ] = request[ 'username' ].clean_username
                    
                    @new_user = super( [] )
                    @new_user = $dbh.select( :Users ) { |u| u.username == @new_user.username }.first
                    
                    # Add to 'members' user group.
                    
                    $dbh.do(
                        %{
                            INSERT INTO users_groups (
                                user_id, user_group_id
                            ) VALUES (
                                ( SELECT id FROM users WHERE username = ? ),
                                ( SELECT id FROM user_groups WHERE name = 'members' )
                            );
                        },
                        @new_user.username
                    )
                    
                else
                    @error = "Typed passwords do not match.  Please re-enter your password."
                end
            rescue MissingUsernameException => e
                # do nothing
            rescue PasswordLengthException, UserExistsException => e
                @error = e.message
            end
        end
    end
    
    def login
        begin
            super  # call AuthAC::Helper::login
            redirect( '/' )
        rescue MissingUsernameException => e
            # do nothing
        rescue MissingPasswordException => e
            # do nothing
        rescue InvalidCredentialsException => e
            @error = e.message
        end
        @user = session[ :user ]
    end
    
    def logout
        super
    end
    
    # Example page that shows the login state.
    def home
        @user = session[ :user ]
    end
    
end
end


