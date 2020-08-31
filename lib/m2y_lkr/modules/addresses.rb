module M2yLkr

	class Addresses < Base


      def self.getAddresses(cpf, cnpj)
            url = "#{baseUrl}/#{ACCOUNTS_PATH}/#{ADDRESSES_PATH}?cpf=#{cpf}&cnpj=#{cnpj}"
            req = HTTParty.get(url, headers: basicHeaders)
            {:status => req.code, :content => req.parsed_response}
      end

      def self.sendingAddress(cpf, cnpj, selected)
          url = "#{baseUrl}/#{ACCOUNTS_PATH}/#{ADDRESSES_PATH}"
          req = HTTParty.post(url, headers: basicHeaders, body: { "cpf": cpf.gsub(/[^0-9]/, ''), "cnpj": cnpj.gsub(/[^0-9]/, ''), "selected": selected })
          { status: req.code, content: req.parsed_response}
      end
	end
end


