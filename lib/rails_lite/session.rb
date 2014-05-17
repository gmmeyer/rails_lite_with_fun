require 'json'
require 'webrick'

class Session
  # finds the cookie for this app
  # deserializes the cookie into a hash
  def initialize(req)
    @cookies = {}
    req.cookies.each do |cookie|
      if /_rails_lite_app/ =~ cookie.name
        value = JSON.parse(cookie.value)
        unless value.nil? || value.empty?
          @cookies.merge!(value)
        end
      end
    end
    @cookies
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  # serializes the hash into json and save in a cookie
  # adds to the responses cookies
  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookies.to_json)
  end
end

