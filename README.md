# TituloEleitoral

Esta gem permite validar o número de inscrição presente no título eleitoral, de acordo com o artigo 12 da resolução número 21.538 do TSE, de 14/10/2003.

## Installation

Adicione essa linha no arquivo Gemfile da sua aplicação:

    gem 'titulo-eleitoral'

E etão execute:

    $ bundle

Ou instale você mesmo:

    $ gem install titulo-eleitoral

## Uso

A utilização é bem simples:

```ruby
# Para verificar se o número de inscrição é válido:
TituloEleitoral.valido?('324542010232')

# Para verificar a UF do número de inscrição:
TituloEleitoral.uf('324542010232')

# Para retorna uma instância da classe TituloEleitoral::NumeroInscricao:
TituloEleitoral.numero_inscricao('324542010232')
```

## Contribuindo

1. Faça um Fork
2. Crie um branch para a nova funcionalidade (`git checkout -b minha-nova-funcionalidade`)
3. Faça o commit de suas alterações  (`git commit -am 'Adicionada nova funcionalidade'`)
4. Faça um push da sua nova funconalidade (`git push origin minha-nova-funcionalidade`)
5. Submeta uma nova Pull Request