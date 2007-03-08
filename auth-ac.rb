conf_file = File.expand_path 'part/auth-ac/conf/auth-ac.conf'
if File.exist?( conf_file )
    load conf_file
else
    $stderr.puts "Failed to read #{conf_file}."
    exit 1
end
require 'part/auth-ac/src/model'
require 'part/auth-ac/helper/auth'
require 'part/auth-ac/helper/access'

# Example code:
require 'part/auth-ac/src/controller/auth'
require 'part/auth-ac/src/controller/access'
