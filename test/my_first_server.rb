require 'webrick'
require'json'

root = '/'

server = WEBrick::HTTPServer.new Port: 8080, DocumentRoot: root

# res = HTTPResponse.new.content_type = 'text/text'
# req = HTTPRequest.new.path = 'body'

server.mount_proc('/') do |req,res|
  #res.body = 'boogie woogie doodle'
  res.body = res.inspect + '


  ' + req.inspect
  # res.body
end

trap('INT') { server.shutdown } # stop server with Ctrl-C
server.start