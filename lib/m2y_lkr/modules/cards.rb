module M2yLkr

	class Cards < Base


            def self.getLinkAccountStatus(idLinker)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{idLinker}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  { status: req.code, content: req.parsed_response}
            end

            def self.requestCard(id_linker, cpf, id_partner, id)
                  url = URI("#{baseUrl}#{CARD_PATH}#{NEW_PATH}")
                  https = Net::HTTP.new(url.host, url.port);
                  https.use_ssl = true
                  request = Net::HTTP::Post.new(url)
                  request["Content-Type"] = "application/json"
                  request["Authorization"] = basicAuth
                  request.body = JSON.pretty_generate(id_linker: id_linker, cpf: cpf.gsub(/[^0-9]/, ''), id_partner: id_partner, fingerprint: id.to_s )
                  response = https.request(request)
                  begin
                    response = { status: response.code.to_i, content: JSON.parse(response.read_body)}
                  rescue
                    response = { status: response.code.to_i, content: {}}
                  end
                  response
            end

            def self.cancelCard(id_linker, cpf, card_id, reason, reason_desc, id)
                  url = URI("#{baseUrl}#{CARD_PATH}#{CANCEL_PATH}")
                  https = Net::HTTP.new(url.host, url.port);
                  https.use_ssl = true
                  request = Net::HTTP::Post.new(url)
                  request["Content-Type"] = "application/json"
                  request["Authorization"] = basicAuth
                  request.body = JSON.pretty_generate(id_linker: id_linker, cpf: cpf.gsub(/[^0-9]/, ''), card_id_partner: card_id, reason: reason, reason_description: reason_desc, fingerprint: id.to_s)
                  response = https.request(request)
                  begin
                    response = { status: response.code.to_i, content: JSON.parse(response.read_body)}
                  rescue
                    response = { status: response.code.to_i, content: {}}
                  end
                  response
            end



	end
end


