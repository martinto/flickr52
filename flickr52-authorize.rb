#!/usr/bin/ruby1.9.1
require 'flickraw'
#FlickRaw.secure = false

FlickRaw.api_key="d50121117e66df746c45fa9114640828"
FlickRaw.shared_secret="9aaf3c67263862dc"

token = flickr.get_request_token
auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

puts "Open this url in your process to complete the authication process : #{auth_url}"
puts "Copy here the number given when you complete the process."
verify = gets.strip

begin
  flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
  login = flickr.test.login
  puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
rescue FlickRaw::FailedResponse => e
  puts "Authentication failed : #{e.msg}"
end

#http://www.flickr.com/services/oauth/authorize?oauth_token=72157632418188255-35e71bc0deff139a&perms=delete
#773-582-281

#You are now authenticated as MartinTomes with token 72157632418191157-e2172523defff69a and secret 083952baca009ff7
