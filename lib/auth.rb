require 'digest/sha1'

module AuthAC
  class MissingUsernameException < Exception; end
  class MissingPasswordException < Exception; end
  class PasswordLengthException < Exception; end
  class UserExistsException < Exception; end
  class InvalidCredentialsException < Exception; end
  
  VERSION = '0.6.0'
  LAST_MODIFIED = '2008-02-08'

  # Override retrieve_user_record as appropriate for your ORM and modeller.
  # Input is a hash of :fieldname => value pairs. 
  # Output should be the user model instance of the matching user.
  def retrieve_user_record( fields )
    User.one_where( fields )
  end
  
  # Override create_user_record as appropriate for your ORM and modeller.
  # Input is a hash of :fieldname => value pairs. 
  # Output should be the user model instance of the created user.
  def create_user_record( fields )
    User.create( fields )
  end
  
  # ----------------------------------------------------------
  
  def encrypt( password )
    Digest::SHA1.hexdigest( password )
  end
  
  # Input is a hash containing at least :username and :password.
  # This returns a new User object.
  # Any extra processing, such as adding the member to certain groups
  # automatically, will have to be done by you.  See example app.
  def register( fields )
    username = fields[ :username ]
    password = fields[ :password ]
    if username.nil?
      raise MissingUsernameException.new( "Nil username." )
    end
    if password.nil?
      raise MissingPasswordException.new( "Nil password." )
    end
    #if password.length < MIN_PASSWORD_LENGTH
      #raise PasswordLengthException.new( "Password must be at least #{MIN_PASSWORD_LENGTH} characters long." )
    #end
    
    fields[ :encrypted_password ] = encrypt( password )
    fields.delete :password
      
    new_user = nil
    begin
      new_user = create_user_record( fields )
    rescue DBI::ProgrammingError => e
      if e.message =~ /duplicate key violates unique constraint/
        raise UserExistsException.new( "User '#{username}' already exists." )
      else
        raise e
      end
    end
    
    new_user
  end
  
  # Returns true iff a user is logged in.
  def logged_in?
    session[ :user ] != nil
  end
  
  # Sets session[ :user ] to the User record on success.
  # Returns session[ :user ].
  def login( username, password )
    if username.nil?
      raise MissingUsernameException.new( "Nil username." )
    end
    if password.nil?
      raise MissingPasswordException.new( "Nil password." )
    end
    encrypted_password = encrypt( password )
    
    user = retrieve_user_record(
      :username => username,
      :encrypted_password => encrypted_password
    )
    
    if user
      session[ :user ] = user
    else
      raise InvalidCredentialsException.new( "Invalid login credentials." )
    end
  end
  
  def logout
      session[ :user ] = nil
  end
end

