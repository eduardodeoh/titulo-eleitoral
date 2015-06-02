require_relative 'constantes'

module TituloEleitoral
  class NumeroInscricao
    attr_reader :numero, :numero_original, :dv1, :dv2

    #http://www.tse.jus.br/legislacao/codigo-eleitoral/normas-editadas-pelo-tse/resolucao-nb0-21.538-de-14-de-outubro-de-2003-brasilia-2013-df
    #http://www.exceldoseujeito.com.br/2008/12/19/validar-cpf-cnpj-e-titulo-de-eleitor-parte-ii/
    #http://cdn.tse.jus.br/saae/util/scriptsGerais.js
    #http://ef3cinco.com/2011/09/07/como-validar-titulo-de-eleitor-usando-java-netbeans/

    def initialize(numero)
      @numero_original = divide_em_array(numero)
      @numero = normaliza_quantidade_digitos(numero_original)
      @dv1 = primeiro_digito_verificador
      @dv2 = segundo_digito_verificador
    end

    def valido?
      return false if (numero.size > NUMERO_DIGITOS) || (codigo_uf.nil?)
      digitos_verificadores == digitos_verificadores_calculados
    end

    def codigo_uf
      digitos_uf if uf_valida?
    end

    def sigla_uf
      UFS[digitos_uf] if uf_valida?
    end

    def random
      num = (1..8).map { rand(10).to_s }.join
      uf = UFS.keys.sample

      @numero = "#{num}#{uf}00".split('') # para setar a UF

      @dv1 = calcula_digito_verificador(num.split('').map(&:to_i), MULTIPLICADORES_DV1)
      @dv2 = calcula_digito_verificador("#{uf}#{@dv1}".split('').map(&:to_i), MULTIPLICADORES_DV2)

      @numero = "#{num}#{uf}#{@dv1}#{@dv2}"

      @numero
    end

    private
      def primeiro_digito_verificador
        #Somar a multiplicação dos 8 primeiros digitos, respectivamente, por [2,3,4,5,6,7,8,9] e após calcular módulo 11 desta soma
        digitos = numero.take(8).map(&:to_i)
        calcula_digito_verificador(digitos, MULTIPLICADORES_DV1)
      end

      def segundo_digito_verificador
        #Somar a multiplicação dos digitos 9, 10 e DV1, respectivamente, por [7,8,9] e após calcular módulo 11 desta soma
        digitos = numero[8,2].map(&:to_i) << dv1
        calcula_digito_verificador(digitos, MULTIPLICADORES_DV2)
      end

      def calcula_digito_verificador(digitos, multiplicadores)
        soma_multiplicacao = digitos.zip(multiplicadores).inject(0) { |resultado,(digito, multiplicador)| resultado + (digito * multiplicador) }
        resto_divisao = soma_multiplicacao % MODULO
        verifica_resto(resto_divisao)
      end

      def divide_em_array(numero)
        case
          when numero.is_a?(String) && !numero.empty?
            somente_numeros(numero).split('')
          when numero.is_a?(Fixnum)
            numero.to_s.split('')
          else
            []
        end
      end

      def normaliza_quantidade_digitos(numero)
        (numero.join.size >= NUMERO_DIGITOS) ? numero : numero.join.rjust(NUMERO_DIGITOS, "0").split('')
      end

      def digitos_uf
        numero[8,2].join
      end

      def digitos_verificadores
        numero[10,2].join
      end

      def uf_valida?
        uf = digitos_uf.to_i
        uf >= 1 && uf <=28
      end

      def digitos_verificadores_calculados
        dv1.to_s + dv2.to_s
      end

      def verifica_resto(resto_divisao)
        if resto_divisao == 10
          0
        else
          if (resto_divisao == 0) && ((sigla_uf == 'SP') || (sigla_uf == 'MG'))
            1
          else
            resto_divisao
          end
        end
      end

      def somente_numeros(valor)
        valor.gsub(/\D/, '')
      end
  end
end