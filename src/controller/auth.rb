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
    
    def logout
        super
    end
    
    # Example page that shows the login state.
    def home
        @user = session[ :user ]
    end
end
end

Ramaze::Global.mapping[ AuthAC::AUTH_BASE_URL ] = AuthAC::AuthenticationController

