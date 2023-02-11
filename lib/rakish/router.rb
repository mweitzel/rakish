require 'json'
require "base64"

class Thing
  def initialize
    x = self
    @router = Hanami::Router.new do
      get "/", to: -> (env) {
        person = {name: 'x'}
        x.callx(env, person)
      }

      get "/about", to: -> (env) {
        person = {name: 'h'}
        x.callx(env, person)
      }

      get "/rx", to: -> (env) {
        person = {name: 'carl'}
        x.callx(env, person)
      }

      get "/x", to: -> (env) {
        person = {name: 'CARL'}
        x.callx(env, person)
      }

      get "/:foo", to: -> (env) {
        person = {name: 'foo', date: `date`, x: "#{Random.rand}"}
        x.callx(env, person)
      }

      get "/examples/*glob", to: -> (env) {
        person = {name: 'foo', date: `date`, x: "glob-#{Random.rand}"}
        x.callx(env, person)
      }
    end
  end

  def call(env)
    @router.call(env)
  end
  def callx(env, person)
    props = person
    if env["HTTP_X_BASSLINE"] == "just-the-data"
      [200,
       {"Vary" => "x-bassline", "Content-type"=> "application/json; charset=utf-8", "Cache-Control" => "max-age=3600"},
       [person.to_json]
      ]
    else
      render_templater = {
        template: '../cache/server-example.js',
        props: props,
        ssrUrl: env["REQUEST_PATH"]
      }
      rendered = post(render_templater)
      body_data = JSON.parse(rendered.body)


      encoded_props = Base64.encode64(props.to_json)

      html = File.open("app/views/index.html").read
      html = insert_at(html, encoded_props, "{initial-props}")
      html = insert_at(html, body_data["render"], "{mount}")
      [200, {"Content-type"=> "text/html; charset=utf-8"}, [html]]
    end
  end

  def insert_at(template, thing, place)

    template_parts = template.split(place)
    pre = template_parts[0]
    post = template_parts[1..-1]
    html = [pre, thing, *post].join("\n")
  end

  def post(data)
    uri = URI "http://localhost:8987/"
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = data.to_json
    http.request(req)
  end
end

class Router < Hanami::Router
  def initialize
    super { routes }
  end

  private

  def routes
    get "/js/:file_name", to: ->(env) {
      [200, {"Content-type"=> "text/javascript; charset=utf-8"}, [File.open("./cache/"+env["router.params"][:file_name]).read]] }

    get "/ping", to: ->(env) {
      Global.instance.logger.info "ping"
      [200, {}, ["pong\n"]] }

    get "/", to: ->(env) {
      Thing.new.call(env)
    }

    get "/:rx", to: ->(env) {
      Thing.new.call(env)
    }
    get "/*else", to: ->(env) {
      Thing.new.call(env)
    }
  end
end
