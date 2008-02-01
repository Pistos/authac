require __DIR__/'auth'
require __DIR__/'access'

require 'pp'

class Hash
  def recursive_merge!( h2 )
    h2.each do |k2,v2|
      case v2
      when Hash
        ( self[ k2 ] || {} ).recursive_merge!( h2[ k2 ] )
      else
        self[ k2 ] = h2[ k2 ]
      end
    end
  end
end

module AuthAC
  class Startup
    def Startup::startup( options = {} )
      # Default settings
      AuthAC.trait(
        :db => {
          :tables => {
            :users => 'users',
            :user_groups => 'user_groups',
            :users_groups => 'users_groups',
            :flags => 'flags',
            :user_group_flags => 'user_group_flags',
          },
        }
      )
      
      # Overrides given from user
      AuthAC.trait.recursive_merge!( options )
      
      Ramaze::Inform.debug "AUTHAC: #{AuthAC.trait.pretty_inspect}"
      
      load __DIR__/'model.rb'
    end
    
  end
end

Ramaze.trait[ :essentials ].put_before( Ramaze::Adapter, AuthAC::Startup )
