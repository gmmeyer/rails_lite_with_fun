require 'uri'
require 'debugger'
require "hashie"

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    parse_www_encoded_form(req)
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
  end

  def require(key)
  end

  def permitted?(key)
  end

  def to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  #private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    @params = {}
    body_params = {}
    query_params = {}
    decoded_string = []
    unless www_encoded_form.nil?

      if !www_encoded_form.query_string.nil? && !www_encoded_form.query_string.empty?
        decoded_string += URI.decode_www_form(www_encoded_form.query_string)
      elsif !www_encoded_form.body.nil? && !www_encoded_form.body.empty?
        decoded_string += URI.decode_www_form(www_encoded_form.body)
      end

      decoded_string.each do |arr|
        keys = parse_key( arr[0] )
        new_hash = {}
        if keys.length > 1
          new_hash = Hashie::Mash.new {}
          keys.each_with_index do |key, i|
            new_keys = '.' + keys[0..i].join('.')
            #"['"+keys.join("']['") + "']"
                          #new_hash = Hashie::Mash.new {}
            self.class.class_eval <<-EVAL

              new_hash#{new_keys} = {}
              new_hash#{new_keys} = arr[1] if i == keys.length - 1

            EVAL
          end
          new_hash = new_hash.to_hash
        else
          new_hash[arr[0]] = arr[1]
        end
        @params.merge!(new_hash)
      end

    end

    @params
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

end
