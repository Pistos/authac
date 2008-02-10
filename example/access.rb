require 'digest/sha1'

class AccessController < Ramaze::Controller
    map "/access"
    
    include AuthAC
    helper :stack
    
    #def index
        #redirect( R( AuthenticationController, :login ) )
    #end
    
    # This action is used to inform a visitor or user that she does not
    # have access to the given page/area.
    def denied
    end
    
    # Example page that shows how to restrict access to users with
    # certain user flags.
    def restricted
        requires_flags 'see-admin'
    end
end

