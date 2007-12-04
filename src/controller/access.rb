require 'digest/sha1'

module AuthAC
class AccessController < Ramaze::Controller
    map "/access"
    
    include Helper
    helper :stack
    
    #def index
        #redirect( R( AuthenticationController, :login ) )
    #end
    
    # This action is used to inform a visitor or user that she does not
    # have access to the given page/area.
    def denied
        %{
            <p>
            Access denied!<br />
            <a href="#{MainController::SITE_ROOT}/auth/login">Login</a>
            </p>
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
            <a href="#{MainController::SITE_ROOT}/#{AuthAC::AUTH_BASE_URL}/logout">logout</a>
            </body></html>
        }
    end
end
end

module AuthAC
    module Helper
        SITE_ROOT = MainController::SITE_ROOT
    end
end

