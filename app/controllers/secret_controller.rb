class SecretController < ApplicationController
    http_basic_authenticate_with :name => 'amazon', :password => 'candidate', :only => :login
    def login
      render plain: "SUCCESS\n"
    end
end
