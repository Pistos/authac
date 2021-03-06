require 'digest/sha1'

class AuthenticationController < Ramaze::Controller
    map "/auth"
    
    include AuthAC
    
    def index
        redirect( R( self, :login ) )
    end
    
    def register
        # Process POST, if any.
        
        if request.post?
            begin
                if request[ 'password' ] == request[ 'password2' ] and request[ 'username' ]
                    
                    @new_user = super( # AuthAC::register
                      {
                        :username => request[ 'username' ],
                        :password => request[ 'password' ],
                        :realname => request[ 'realname' ],
                      }
                    )
                    @new_user = User.where( :username => @new_user.username ).first
                    
                    # Add to 'members' user group.
                    
                    $authac_dbh.i(
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
            super( request[ :username ], request[ :password ] )  # call AuthAC::login
            answer if inside_stack?
            redirect( R( MainController, "member_home" ) )
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


