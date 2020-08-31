# frozen_string_literal: true

module M2yLkr
  class Configuration    

    attr_writer :lkr_server_url, :lkr_server_token, :billet_server_url

    def initialize #:nodoc:
      @lkr_server_url = nil
      @billet_server_url = nil
      @lkr_server_token = nil
    end

    def lkr_server_url
      @lkr_server_url 
    end

    def lkr_server_token
     @lkr_server_token
    end
    
    def billet_server_url
      @billet_server_url 
    end
    
  end
end
