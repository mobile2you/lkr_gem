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

            def self.parse_response(req, url, body, name)
              {status: req.code, content: req.parsed_response, url: url, body: body, name: name, has_error: req.code > 220}
            end

	end
end


