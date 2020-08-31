module M2yLkr

    module Extract 
        

        def self.parseDesc(desc, flag, name, idTipoAjuste, p2ps, bankTransfers, payments, status, raw, cards)
            
            if cards.nil?
                cards = []
            end
            physical_cards = cards.select{|x| x["flagVirtual"] == 0}
            virtual_cards = cards.select{|x| x["flagVirtual"] == 1}

            if status == 20
                desc = "Estorno #{desc}"
            elsif desc.include?("Transferencia entre contas") || desc.include?("Transf. entre Contas") || desc.include?("Transf entre Contas") || desc.include?("Contas-Favorecido") #|| desc.include?("Transf entre Contas")
                p2p = p2ps.select {|x| x["idAdjustment"].to_i == idTipoAjuste.to_i || x["idAdjustmentDestination"].to_i == idTipoAjuste.to_i || x["idAdjustmentDestination"].to_i == idTipoAjuste.to_i}.first
                if !p2p.nil? && (desc.include?("saida") || desc.include?("(-)") || flag == 0)
                    name = p2p["destinationAccountName"]
                    store = p2p["store"]
                    prefix = store.blank? ? "Transferência" : "Pagamento"
                    desc = "#{prefix} para #{name}"
                elsif !p2p.nil? && (desc.include?("entrada") || desc.include?("(+)") || flag == 1)
                    name = p2p["originalAccountName"]
                    desc = "Transferência de #{name}"
                else
                    desc = "Transferência Linker"
                end
            elsif desc.include?("Transferencia bancaria") || desc.include?("Transf. Bancária") || desc.include?("Transf Bancaria")
                transf = bankTransfers.select {|x| x["idAdjustment"].to_i == idTipoAjuste.to_i || x["idAdjustmentDestination"].to_i == idTipoAjuste.to_i || x["idAdjustmentDestination"].to_i == idTipoAjuste.to_i}.first
                if !transf.nil? && (desc.include?("debito") || desc.include?("(-)"))
                    name = transf["name"]
                    prefix = "Transferência Bancária"
                    desc = "#{prefix} para #{name}"
                elsif desc.include?("Tarifa")
                    desc = "Transferência Bancária: Tarifa"
                else
                    desc = "Transferência Bancária"
                end
            elsif desc.include?("Pagamento de Contas")
                if !idTipoAjuste.nil?
                    payment = payments.select {|x| x["idAdjustment"].to_i == idTipoAjuste.to_i}.first
                    if !payment.nil?
                        assignor = payment["assignor"].present? ? payment["assignor"] : payment["interest"]
                        if payment["billPaymentType"].to_i == 1 #NPC
                            desc = assignor.present? ? "Pagamento de conta para #{assignor}" : "Pagamento de conta"
                        elsif payment["billPaymentType"].to_i == 2 #Normal
                            case payment["paymentType"].to_i
                            when 0 #Conta concessionaria
                                prefix = "de conta "
                            when 1 #ficha de compensacao
                                prefix = "de conta "
                            when 2 #Indefinido
                                prefix = "de conta "
                            when 3 #DARF
                                prefix = "de DARF "
                            when 4 #DARJ
                                prefix = "de DARJ "
                            when 5 #GARE
                                prefix = "de GARE "
                            when 6 #FGTS
                                prefix = "de FGTS "
                            when 7 #GPS
                                prefix = "de GPS "
                            else
                                prefix = "de conta "
                            end

                            desc = assignor.present? ? "Pagamento #{prefix}para #{assignor}" : "Pagamento #{prefix}"
                        else
                            desc = assignor.present? ? "Pagamento de conta para #{assignor}" : "Pagamento de conta"
                        end
                    end
                else
                    desc = "Pagamento de Contas"
                end

            elsif desc.include?("pagamento") || desc.include?("Pagamento Efetuado")
                desc = "Recebimento de boleto"
            elsif desc.include?("Recarga Celular")
                desc = "Recarga de Celular"
            elsif desc.include?("SPTrans")
                desc = "Recarga SPTrans"   
            elsif desc.include?("Saque Nacional")
                desc = "Saque"
            elsif desc.include?("Taxa de Saque")
                desc = "Taxa de Saque"
            elsif desc.include?("IOF")
                desc = desc
            elsif !name.blank?
                if flag
                    # desc = "Cartão Virtual - " + name
                    
                    is_physical = physical_cards.find{ |h| h["numeroCartao"] == raw["cartaoMascarado"] } 
                    is_physical = is_physical.present? && !is_physical.first.nil?
                    if is_physical
                        desc = "Cartão Físico - " + name
                    else
                        desc = "Cartão Virtual - " + name
                    end
                else
                    desc = "Estorno - " + name
                end
            end
            desc
        end

        def self.parseValue(value, flag)
            val = 0
            if value.nil?
                val = value
            elsif flag == 1
                val = value
            else
                val = -value
            end
            # ActionController::Base.helpers.number_to_currency(val, unit: "", separator: ",", delimiter: "")
            val
        end

        def self.parseValueTimeline(value, flag)
            val = 0
            if value.nil?
                val = value
            elsif !flag.downcase.include?("saida")
                val = value
            else
                val = -value
            end
            # ActionController::Base.helpers.number_to_currency(val, unit: "", separator: ",", delimiter: "")
            val
        end

       def self.parse_csv(rows)
        rows = [["Data", "Hora", "Evento", "Valor"]] + rows
        head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
        csv_str = CSV.generate(csv = head) do |csv|
          rows.each do |row|
                csv << row
          end
        end
      end

       def self.parse_xls(rows)
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Extrato") do |sheet|
          sheet.add_row ["Data", "Hora", "Evento", "Valor"]
          rows.each do |row|
            sheet.add_row row
            end
        end
        p
       end

       def self.parse_pdf(rows)
        pdf_rows = [["Data", "Hora", "Evento", "Valor"]] + rows
        pdf = InvoicePdf.new(pdf_rows)
       end



       def self.parse_ofx(rows, date_start, date_end, account, branch)
            string = "
                    FXHEADER:100
                    DATA:OFXSGML
                    VERSION:102
                    SECURITY:NONE
                    ENCODING:USASCII
                    CHARSET:1252
                    COMPRESSION:NONE
                    OLDFILEUID:NONE
                    NEWFILEUID:NONE
                    <OFX>
                        <SIGNONMSGSRSV1>
                            <SONRS>
                                <STATUS>
                                    <CODE>0</CODE>
                                    <SEVERITY>INFO</SEVERITY>
                                </STATUS>
                                <DTSERVER>#{Time.now.strftime("%Y%m%d%H%M%S")}</DTSERVER>
                                <LANGUAGE>POR</LANGUAGE>
                                <FI>
                                    <ORG>Banco Votorantim S/A</ORG>
                                    <FID>655</FID>
                                </FI>
                            </SONRS>
                        </SIGNONMSGSRSV1>
                        <BANKMSGSRSV1>
                        <STMTTRNRS>
                            <TRNUID>1001</TRNUID>
                            <STATUS>
                                <CODE>0</CODE>
                                <SEVERITY>INFO</SEVERITY>
                            </STATUS>
                            <STMTRS>
                                <CURDEF>BRL</CURDEF>
                                <BANKACCTFROM>
                                    <BANKID>655</BANKID>
                                    <BRANCHID>#{branch}</BRANCHID>
                                    <ACCTID>#{account}</ACCTID>
                                    <ACCTTYPE>CHECKING</ACCTTYPE>
                                </BANKACCTFROM>
                            <BANKTRANLIST>
                            <DTSTART>#{date_start.strftime("%Y%m%d")}</DTSTART>
                            <DTEND>#{date_end.strftime("%Y%m%d")}</DTEND>
                            "

            rows.each_with_index do |row, index|
                if row[2].nil?
                    next
                end
                string += "<STMTTRN>
                                <TRNTYPE>#{row[3] > 0 ? 'CREDIT' : 'DEBIT'}</TRNTYPE>
                                <DTPOSTED>#{row[0].to_time.strftime("%Y%m%d%H%M%S")}</DTPOSTED>
                                <FITID>#{row[0].to_time.strftime("%Y%m%d%H%M%S")}</FITID>
                                <TRNAMT>#{row[3]}</TRNAMT>
                                <MEMO>#{row[2]}</MEMO>
                                <CHECKNUM>#{index + 70}</CHECKNUM>
                                <REFNUM>#{index + 70}</REFNUM>
                            </STMTTRN>"
            end

            string += "  </BANKTRANLIST>
                        </STMTRS>
                      </STMTTRNRS>
                     </BANKMSGSRSV1>
                    </OFX>"         
            string
          end

    end

    class InvoicePdf < Prawn::Document
        def initialize(rows)
            super(top_margin: 70)
            table rows
        end
    end


end
