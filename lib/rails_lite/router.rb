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
    (http_method == req.request_method.downcase.to_sym) && !!(pattern =~ req.path)
  end

  # uses pattern to pull out route params
  # instantiates controller and calls controller action
  def run(req, res)
    match_data = @pattern.match(req.path)

    route_params = {}
    match_data.names.each do |name|
      route_params[name] = match_data[name]
    end

    @controller_class
      .new(req, res, route_params)
      .invoke_action(action_name)
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

  # evaluates the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    instance_eval(&proc)
  end

  # makes each of these methods that
  # when called adds route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, method, controller_class|
      add_route(pattern, method, controller_class, http_method)
    end
  end

  # should return the route that matches this request
  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    a_match = match(req)
    if a_match.nil?
      res.status = 404
    else
      a_match.run(req,res)
    end
  end
end
