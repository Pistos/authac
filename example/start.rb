require 'ramaze'
require '../lib/auth-ac'  # change this to where the /lib/auth-ac.rb file is
require 'auth'
require 'access'

class MainController < Ramaze::Controller
  # include the AuthAC module to get all the authentication and
  # access control functionality
  include AuthAC
  helper :stack
  
  def member_home
    requires_flag 'membership'
    
    @user = session[ :user ]
  end
end

Ramaze.start(
  :authac => {
    :db => {
      :vendor => 'Pg',
      :user => 'authac',
      :password => 'authac',
      :host => nil,
      :database => 'authac',
      #:tables => {
        #:users => 'users',
        #:user_groups => 'user_groups',
        #:users_groups => 'users_groups',
        #:flags => 'flags',
        #:user_groups_flags => 'user_groups_flags',
      #}
    },
  }
)