module M2yLkr

	class Registration < Base

            def self.sendDocuments(cnpj, cpf, type, document, pep, revenue)
                  url = "#{baseUrl}#{DOCUMENT_PATH}"
                  body = {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, '')}
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
                  { :status => req.code, :content => req.parsed_response }
            end

            def self.sendPerEmail (cpf, cnpj)
                  url = "#{baseUrl}#{DOCUMENT_PATH}#{MAIL_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, '')} )
                  {:status => req.code, :content => req.parsed_response}
            end

      end
end


