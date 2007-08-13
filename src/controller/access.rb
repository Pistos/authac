require 'digest/sha1'

module AuthAC
class AccessController < Ramaze::Controller
    # You can comment out these traits if you wish to change these things.
    trait :engine => Ramaze::Template::Ezamar
    trait :template_root => "part/auth-ac/template/access"
    
    map '/access'
    
    include Helper
    helper :stack
    
    #def index
        #redirect( R( AuthenticationController, :login ) )
    #end
    
    # This action is used to inform a visitor or user that she does not
    # have access to the given page/area.
    def denied
        %{
            Access denied!
        }
    end
    
    # Example page that shows how to restrict access to users with
    # certain user flags.
    def restricted
        requires_flags 'see-admin'
        
        %{
            <html><body>
            <h2>Admin</h2>
            
            <p>This is the secret admin page that has restricted access.</p>
            <a href="#{AuthAC::AUTH_BASE_URL}/logout">logout</a>
            </body></html>
        }
    end
end
end

Ramaze::Global.mapping[ AuthAC::ACCESS_BASE_URL ] = AuthAC::AccessController

