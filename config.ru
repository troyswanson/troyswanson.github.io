use Rack::Static,
  :urls => [""],
  :root => File.dirname(__FILE__) + "/_site",
  :index => "index.html"

run lambda { |env| }
