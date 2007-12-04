require 'digest/sha1'

module AuthAC
    class MissingUsernameException < Exception; end
    class MissingPasswordException < Exception; end
    class PasswordLengthException < Exception; end
    class UserExistsException < Exception; end
    class InvalidCredentialsException < Exception; end
    
    VERSION = '0.5.1'
    LAST_MODIFIED = '2007-12-04'
    
    module Helper
        
        def encrypt( password )
            Digest::SHA1.hexdigest( password )
        end
        
        # Registers a new user based on the POSTed variables 'username' and 'password'.
        # Additional Users table fields can be passed as an Array of Strings or Symbols.
        def register( other_fields )
            if request[ 'username' ].nil?
                raise MissingUsernameException.new( "Nil username." )
            end
            if request[ 'password' ].nil?
                raise MissingPasswordException.new( "Nil password." )
            end
            if request[ 'password' ].length < MIN_PASSWORD_LENGTH
                raise PasswordLengthException.new( "Password must be at least #{MIN_PASSWORD_LENGTH} characters long." )
            end
            
            username = request[ 'username' ]
            encrypted_password = encrypt( request[ 'password' ] )
            fields = Hash.new
            other_fields.each do |field|
                fields[ field ] = request[ field.to_s ]
            end
            
            new_user = nil
            begin
                new_user = $kansas_dbh.new_object(
                    :Users,
                    {
                        :username => username,
                        :encrypted_password => encrypted_password,
                    }.merge( fields )
                )
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
        
        # Logs in a user based on the POSTed variables 'username' and 'password'.
        # Sets session[ :user ] to the User record on success.
        # Returns session[ :user ].
        def login
            username = request[ 'username' ]
            password = request[ 'password' ]
            if username.nil?
                raise MissingUsernameException.new( "Nil username." )
            end
            if password.nil?
                raise MissingPasswordException.new( "Nil password." )
            end
            encrypted_password = encrypt( password )
            
            user = $kansas_dbh.select( :Users ) { |user|
                ( user.username == username ) &
                ( user.encrypted_password == encrypted_password )
            }[ 0 ]
            
            if user
                session[ :user ] = user
            else
                raise InvalidCredentialsException.new( "Invalid login credentials." )
            end
        end
        
        def logout
            session[ :user ] = nil
            #redirect_referer
        end
    end
end

