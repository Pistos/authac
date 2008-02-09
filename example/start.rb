require 'ramaze'
require '../lib/auth-ac'  # change this to where the /lib/auth-ac.rb file is
require 'auth'
require 'access'

class MainController < Ramaze::Controller
  def index
    'AuthAC!'
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
        #:user_group_flags => 'user_group_flags',
      #}
    },
  }
)