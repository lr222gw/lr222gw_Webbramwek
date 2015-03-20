# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application


use Rack::Cors do
  allow do
    origins 'localhost:3000', '127.0.0.1:3000',
            /http:\/\/192\.168\.0\.\d{1,3}(:\d+)?/
    # regular expressions can be used here

    #Denna fil kan vi configurera Cors i, detta är med gemmet rack-cors

    #
    #     resource '/api/v1/login/',
    #              :methods => [:get, :post];



    # resource '/file/list_all/', :headers => 'x-domain-token'
    # resource '/file/at/*',
    #          :methods => [:get, :post, :put, :delete, :options],
    #          :headers => 'x-domain-token',
    #          :expose  => ['Some-Custom-Response-Header'],
    #          :max_age => 600
    # headers to expose
  end

  # allow do
  #   origins '*'
  #   resource '/public/*', :headers => :any, :methods => :get
  # end
end