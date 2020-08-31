module M2yLkr

	class Links < Base


            def self.getLinkAccountStatus(id)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{id}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  parse_response(req, url, {id: id}.to_s, "Getting Link Account Status")
            end

            def self.createLinkAccount(id)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{id}"
                  req = HTTParty.post(url, headers: basicHeaders)
                  parse_response(req, url, {id: id}.to_s, "Creating Link Account")
            end

            def self.getChargesLinks(id)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{id}#{LINKS_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders)
                  parse_response(req, url, {id: id}.to_s, "Getting Charges Links")
            end


	end
end


