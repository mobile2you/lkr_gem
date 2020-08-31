module M2yLkr

	class Registration < Base

            def self.sendDocuments(cnpj, cpf, type, document, pep, revenue)
                  url = "#{baseUrl}#{DOCUMENT_PATH}"
                  body = {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, '')}
                  log_body = body
                  content = 'image/jpeg'
                  case type
                  when 'rg_front'
                    body['identity_card_front'] = document
                  when 'rg_back'
                    body['identity_card_verse'] = document
                  when 'cnh_front'
                    body['driver_license_front'] = document
                  when 'cnh_back'
                    body['driver_license_verse'] = document
                  when 'selfie'
                    body['selfie'] = document
                    body['pep'] = pep
                    body['revenue'] = revenue
                  when 'signature_card'
                    body['signature_card'] = document
                  when 'document'
                    body['document'] = document
                    content = 'application/pdf'
                  end

                  req = HTTParty.post(url,
                          headers: basicHeaders,
                          body: body)
                  parse_response(req, url, log_body.to_s, "Envio de documento: #{type}")
            end

            def self.sendPerEmail (cpf, cnpj)
                  url = "#{baseUrl}#{DOCUMENT_PATH}#{MAIL_PATH}"
                  body = {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, '')}.to_s
                  req = HTTParty.post(url, headers: basicHeaders, body: body )
                  parse_response(req, url, body.to_s, "Send Company Doc per Email")
            end

      end
end


