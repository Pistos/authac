require 'digest/sha1'

module AuthAC
class AuthenticationController < Ramaze::Controller
    trait :engine => Ramaze::Template::Ezamar
    trait :template_root => "part/auth-ac/template/auth"
    
    include Helper
    
    def index
        redirect( R( self, :login ) )
    end
    
    def register
        begin
            @new_user = super( [ 'realname' ] )  # call AuthAC::Helper::register
        rescue MissingUsernameException => e
            # do nothing
        rescue PasswordLengthException => e
            @error = e.message
        rescue UserExistsException => e
            @error = e.message
        end
    end
    
    def login
        begin
            super  # call AuthAC::Helper::login
            redirect( R( self, :home ) )
        rescue MissingUsernameException => e
            # do nothing
        rescue MissingPasswordException => e
            # do nothing
        rescue InvalidCredentialsException => e
            @error = e.message
        end
        @user = session[ :user ]
    end
    
    # Example page that shows the login state.
    def home
        if logged_in?
            @user = session[ :user ]
            %{
                You're logged in as #{@user.username}.<br />
                <a href="#{AuthAC::ACCESS_BASE_URL}/restricted">Enter restricted area</a>
            }
        else
            %{
                You are not logged in.
                <a href="#{AuthAC::AUTH_BASE_URL}/login">Login</a>
            }
        end
    end
end
end

Ramaze::Global.mapping[ AuthAC::AUTH_BASE_URL ] = AuthAC::AuthenticationController

