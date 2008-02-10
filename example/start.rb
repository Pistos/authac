require 'ramaze'
require 'auth-ac'
require __DIR__/'auth'    # Example controller
require __DIR__/'access'  # Example controller

class MainController < Ramaze::Controller
  # include the AuthAC module to get all the authentication and
  # access control functionality
  include AuthAC
  
  def member_home
    requires_flag 'membership'
    @user = session[ :user ]
  end
  
  def restricted
    requires_flags 'see-admin'
  end
end

AuthAC.options(
  {
    :db => {
      :vendor => 'Pg',
      :user => 'authac',
      :password => 'authac',
      :host => nil,
      :database => 'authac',
    },
    #:tables => {
      #:users => 'users',
      #:user_groups => 'user_groups',
      #:users_groups => 'users_groups',
      #:flags => 'flags',
      #:user_groups_flags => 'user_groups_flags',
    #}
    #:auth_base_path => '/auth',
    #:access_base_path => '/access'
  }
)

Ramaze.start