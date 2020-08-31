module M2yLkr

	class Base 

            def self.baseUrl
                  M2yFlash.configuration.api_server_url
            end

            def self.basicAuth
                  M2yFlash.configuration.api_server_token
            end

            def self.basicHeaders
                  { 'Content-Type' => "application/json", 'Authorization' => basicAuth }
            end

	end
end


