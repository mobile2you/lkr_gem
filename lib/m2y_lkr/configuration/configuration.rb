# frozen_string_literal: true

module M2yFlash
  class Configuration    

    attr_writer :api_server_url, :api_server_token, :billet_server_url

    def initialize #:nodoc:
      @api_server_url = nil
      @billet_server_url = nil
      @api_server_token = nil
    end

    def api_server_url
      @api_server_url 
    end

    def api_server_token
     "Basic #{@api_server_token}"
    end
    
    def billet_server_url
      @billet_server_url 
    end
    
  end
end
