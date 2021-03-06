module M2yLkr

	class Login < Base

            def self.getCompany(cpf, ip = nil)
                  url = "#{baseUrl}#{COMPANIES_PATH}/#{cpf.gsub(/[^0-9]/, '')}"
                  req = HTTParty.get(url, headers: basicHeaders )
                  parse_response(req, url, {cpf: cpf}, "checkCpf")
            end

            def self.attemptLogin(cpf, cnpj, password, ip, id, key = nil)
      
                  url = "#{baseUrl}#{LOGIN_PATH}"
                  body = {"cpf":  cpf.gsub(/[^0-9]/, ''),"cnpj": cnpj.gsub(/[^0-9]/, ''), "password": password, "ip": ip, "fingerprint": id}
                  if key.present?
                        body["key"] = key
                  end
                  req = HTTParty.post(url, headers: basicHeaders, body: body.to_json)
                  body[:password] =  nil
                  parse_response(req, url, body.to_s, "login")
            end

            def self.createPassword(cpf, cnpj, password, ip, id)
                  url = "#{baseUrl}#{PASSWORD_PATH}"
                  req = HTTParty.post(url, headers: basicHeaders, body: {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, ''), "password": password, "ip": ip, "fingerprint": id})
                  parse_response(req, url, {"cpf": cpf, "cnpj": cnpj}.to_s, "Create Pass")
                  if req.code != 201
                        updatePassword(cpf, cnpj, password, ip, id)
                  else
                        response
                  end
            end

            def self.updatePassword(cpf, cnpj, password, ip, id)
                  url = "#{baseUrl}#{PASSWORD_PATH}"
                  req = HTTParty.put(url, headers: basicHeaders, body: {"cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, ''), "password": password, "ip": ip, "fingerprint": id.to_s })
                  parse_response(req, url, {"cpf": cpf, "cnpj": cnpj}.to_s, "Update Pass")
            end


      end
end


