module M2yLkr

	class Addresses < Base


      def self.getAddresses(cpf, cnpj)
            url = "#{baseUrl}/#{ACCOUNTS_PATH}/#{ADDRESSES_PATH}?cpf=#{cpf}&cnpj=#{cnpj}"
            req = HTTParty.get(url, headers: basicHeaders)
            parse_response(req, url, {"cpf": cpf, "cnpj": cnpj}.to_s, "Get Addresses")
      end

      def self.sendingAddress(cpf, cnpj, selected)
          url = "#{baseUrl}/#{ACCOUNTS_PATH}/#{ADDRESSES_PATH}"
          body = { "cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, ''), "selected": selected }
          req = HTTParty.post(url, headers: basicHeaders, body: body)
          parse_response(req, url, body.to_s, "Sending selected Address to Linker")
      end
	end
end


