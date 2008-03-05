require __DIR__/'auth'
require __DIR__/'access'
require __DIR__/'hash'

require 'ramaze/helper/stack'
require 'pp'

module AuthAC
  include Ramaze::StackHelper
  
  class Startup
    def Startup::startup( options = {} )
      load __DIR__/'model.rb'
    end
    
  end
  
  def self.options( hash )
      # Default settings
      AuthAC.trait(
        :tables => {
          :users => 'users',
          :user_groups => 'user_groups',
          :users_groups => 'users_groups',
          :flags => 'flags',
          :user_groups_flags => 'user_groups_flags',
        },
        :auth_base_path => '/auth',
        :access_base_path => '/access'
      )
      
      # Overrides given from user
      AuthAC.trait.recursive_merge!( hash )
  end
end

Ramaze.trait[ :essentials ].put_before( Ramaze::Adapter, AuthAC::Startup )
