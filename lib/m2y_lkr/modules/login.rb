module M2yLkr

	class Login < Base

            def self.getLinkAccountStatus(idLinker)
                  url = "#{baseUrl}#{TRANSFERS_PATH}/#{idLinker}"
                  req = HTTParty.get(url, headers: basicHeaders)
                  { status: req.code, content: req.parsed_response}
            end

            def self.getCompany(cpf, ip = nil)
                  url = "#{baseUrl}#{COMPANIES_PATH}/#{cpf.gsub(/[^0-9]/, '')}"
                  req = HTTParty.get(url, headers: basicHeaders )
                  {status:  req.code, :content => req.parsed_response}
                  response
            end

            def self.attemptLogin(cpf, cnpj, password, ip, id, key = nil)
      
                  url = "#{baseUrl}#{LOGIN_PATH}"
                  body = {"cpf":  cpf.gsub(/[^0-9]/, ''),"cnpj": cnpj.gsub(/[^0-9]/, ''), "password": password, "ip": ip, "fingerprint": id}
                  if key.present?
                        body["key"] = key
                  end
                  req = HTTParty.post(url, headers: basicHeaders, body: body.to_json)
                  {status:  req.code, :content => req.parsed_response}
            end

            def self.createPassword(cpf, cnpj, password, ip, id)
                  url = "#{baseUrl}#{PASSWORD_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, ''), "password": password, "ip": ip, "fingerprint": id})
                  response = {status:  req.code, :content => req.parsed_response}
                  if req.code != 201
                        updatePassword(cpf, cnpj, password, ip, id)
                  else
                        response
                  end
            end

            def self.updatePassword(cpf, cnpj, password, ip, id)
                  url = "#{baseUrl}#{PASSWORD_PATH}"
                  req = HTTParty.put(url, headers: basicHeaders, body: {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, ''), "password": password, "ip": ip, "fingerprint": id.to_s })
                  {status:  req.code, :content => req.parsed_response}
            end


      end
end


