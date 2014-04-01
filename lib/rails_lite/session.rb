require 'json'
require 'webrick'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @cookies = {}
    req.cookies.each do |cookie|
      if /_rails_lite_app/ =~ cookie.name
        value = JSON.parse(cookie.value)
        unless value.nil? || value.empty?
          @cookies[value.keys] = value.values
        end
      end
    end
    puts @cookies
    @cookies
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
      res[:cookies] = @cookies.to_json
  end
end

