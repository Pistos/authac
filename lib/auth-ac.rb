require __DIR__/'auth'
require __DIR__/'access'
require __DIR__/'hash'

require 'pp'

module AuthAC
  class Startup
    def Startup::startup( options = {} )
      # Default settings
      AuthAC.trait(
        :tables => {
          :users => 'users',
          :user_groups => 'user_groups',
          :users_groups => 'users_groups',
          :flags => 'flags',
          :user_group_flags => 'user_group_flags',
        }
      )
      
      # Overrides given from user
      AuthAC.trait.recursive_merge!( options[ :authac ] )
      
      load __DIR__/'model.rb'
    end
    
  end
end

Ramaze.trait[ :essentials ].put_before( Ramaze::Adapter, AuthAC::Startup )
