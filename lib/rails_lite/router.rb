class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    return false if req.path.nil? || http_method.nil? || req.request_method.nil?
    return pattern.match(req.path) && http_method == req.request_method if req.request_method.class == Symbol
    pattern.match(req.path) && http_method == req.request_method.downcase.to_sym
  end

  # uses pattern to pull out route params
  # instantiates controller and calls controller action
  def run(req, res)
    if matches?(req)
      controller_class.new(req, res).invoke(action_name)
    end
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, method, controller_class|
      add_route(pattern, method, controller_class, http_method)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.each do |route|
      return route.matches?(req)
    end
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    a_match = match(req)
    if a_match
      a_match.run(req,res)
    else
      res.status = '404'
    end
  end
end
