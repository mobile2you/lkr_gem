module M2yLkr

	class Links < Base


            def self.getLinkAccountStatus(idLinker)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{idLinker}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  { status: req.code, content: req.parsed_response}
            end

            def self.createLinkAccount(idLinker)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{idLinker}"
                  req = HTTParty.post(url, headers: basicHeaders)
                  { status: req.code, content: req.parsed_response}
            end

            def self.getChargesLinks(idLinker)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{idLinker}#{LINKS_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders)
                  { status: req.code, content: req.parsed_response}
            end


	end
end


