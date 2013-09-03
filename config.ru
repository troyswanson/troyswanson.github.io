use Rack::Static

run lambda { |env|
  [
    200, 
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=6400'
    },
    File.open(File.dirname(__FILE__) + '/_site' + env['PATH_INFO'] + 'index.html', File::RDONLY)
  ]
}
