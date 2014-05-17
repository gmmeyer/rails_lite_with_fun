require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'


class ControllerBase
  attr_reader :params, :req, :res

  # initializes the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
  end

  # populates the response with content
  # sets the responses content type to the given type
  # later raises an error if the developer tries to double render
  def render_content(content, type)
    raise 'DOH' if already_rendered?
    @res.body = content
    @res.content_type = type
    @already_built_response = true
    return
  end

  # helper method to alias @already_rendered
  def already_rendered?
    @already_built_response ||= false
  end

  # sets the response status code and header
  def redirect_to(url)
    raise 'DOH' if already_rendered?
    @res.header['location'] = url
    @res.status = 302
    @already_built_response = true
  end

  # uses ERB and binding to evaluate templates
  # passes the rendered html to render_content
  def render(template_name)
    file_name = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    erb_file = File.read(file_name)
    template = ERB.new(erb_file).result(binding)
    render_content(template, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # used with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
  end
end
