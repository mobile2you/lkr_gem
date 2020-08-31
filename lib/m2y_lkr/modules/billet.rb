module M2yLkr

	class Billet < Base

            def self.baseUrl
                  M2yFlash.configuration.billet_server_url
            end


            def self.createBillet(params, ip = nil)
                  url = "#{baseUrl}#{BILLETS_PATH}#{INVOICE_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: params )
                  {:status => req.code, :content => req.parsed_response}
            end

            # Get
            def self.showBillet(id, account)
                  url = "#{baseUrl}#{BILLETS_PATH}/#{id}#{PDF_PATH}?linkerId=#{account}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  {:status => req.code, :content => req.parsed_response}
            end

            # Get
            def self.findBillet(id)
                  url = "#{baseUrl}#{BILLETS_PATH}#{STATUS_PATH}/#{id}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  {:status => req.code, :content => req.parsed_response}
            end

            def self.getBillets(cpnj)
                  url = "#{baseUrl}#{BILLETS_PATH}/cnpj/#{cpnj.gsub(/[^0-9]/, '')}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  {:status => req.code, :content => req.parsed_response}
            end

            def self.createFav(fav)
                  url = "#{baseUrl}#{CONTACT_PATH}#{CREATE_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: fav.to_json )
                  {:status => req.code, :content => req.parsed_response}
            end

            def self.checkFav(doc)
                  url = "#{baseUrl}#{CONTACT_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: { data: { document: doc } }.to_json )
                  { status: req.code, content: req.parsed_response }
            end

            def self.createRecharge(params)
                  url = "#{baseUrl}#{BILLETS_PATH}#{RECHARGE_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: params )
                  { status: req.code, :content => req.parsed_response}
            end

	end
end


