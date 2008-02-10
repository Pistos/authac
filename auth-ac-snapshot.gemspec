#!/usr/bin/env ruby

require 'rubygems'

spec = Gem::Specification.new do |s|
    s.name = 'auth-ac'
    #s.version = '0.3.0'
    s.version = Time.now.strftime( "%Y.%m.%d" )
    s.summary = 'AuthAC for Ramaze'
    s.description = 'AuthAC is an authentication and access control module for the Ramaze web development framework.'
    #s.homepage = 'http://rome.purepistos.net/auth-ac'
    s.add_dependency( 'ramaze' )
    
    s.authors = [ 'Pistos' ]
    s.email = 'pistos at purepistos dot net'
    
    #s.platform = Gem::Platform::RUBY
    
    s.files = [
        'README',
        #'CHANGELOG',
        *( Dir[
          'lib/**/*.rb',
          'spec/**/*.rb',
          'example/**/*',
        ] )
    ]
    s.extra_rdoc_files = [ 'README' ]
    s.test_files = Dir.glob( 'spec/*.rb' )
end

if $PROGRAM_NAME == __FILE__
    Gem::Builder.new( spec ).build
end