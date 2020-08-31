module M2yLkr

	class Billet < Base

            def self.baseUrl
                  M2yLkr.configuration.billet_server_url
            end

            def self.createBillet(params, ip = nil)
                  url = "#{baseUrl}#{BILLETS_PATH}#{INVOICE_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: params )
                  parse_response(req, url, params.to_s, "Creating Billets")
            end

            def self.showBillet(id, account)
                  url = "#{baseUrl}#{BILLETS_PATH}/#{id}#{PDF_PATH}?linkerId=#{account}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  parse_response(req, url, {id: id, account: account}.to_s, "Show Billet")
            end

            def self.findBillet(id)
                  url = "#{baseUrl}#{BILLETS_PATH}#{STATUS_PATH}/#{id}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  parse_response(req, url, {id: id}.to_s, "Find Billet")
            end

            def self.getBillets(cpnj)
                  url = "#{baseUrl}#{BILLETS_PATH}/cnpj/#{cpnj.gsub(/[^0-9]/, '')}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  parse_response(req, url, {cpnj: cpnj}.to_s, "Get Billets")
            end

            def self.createFav(fav)
                  url = "#{baseUrl}#{CONTACT_PATH}#{CREATE_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: fav.to_json )
                  parse_response(req, url, fav.to_json, "Ceate Fav")
            end

            def self.checkFav(doc)
                  url = "#{baseUrl}#{CONTACT_PATH}"
                  body = { data: { document: doc } }.to_json
                  req = HTTParty.post(url, headers: basicHeaders, body: body )
                  parse_response(req, url, body.to_s, "Check Fav")
            end

            def self.createRecharge(params)
                  url = "#{baseUrl}#{BILLETS_PATH}#{RECHARGE_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: params )
                  parse_response(req, url, params.to_s, "Create Recharge")
            end

	end
end


