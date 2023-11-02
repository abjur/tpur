
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tpur

<!-- badges: start -->
<!-- badges: end -->

O objetivo do pacote é oferecer a pesquisadores que queiram se aventurar
nos dados do Judiciário brasileiro uma forma mais simples de acessar os
códigos de TPUs que precisam ser utilizados para utilizar APIs e
solicitar dados via Lei de Acesso à Informação (LAI). Em ambos os casos,
o Poder Público exige que os pesquisadores listem os dados processuais
por meio dos códigos das classes e assuntos, e não a sua descrição.

Existem 4 tipos de Tabelas Processuais Unificadas: classe, assunto,
movimento e documento. Atualmente, temos apenas as TPUs de classe e de
assunto.

## TPUs Disponíveis

| file           | dt_ini     | dt_fim     | release                                                                  |
|:---------------|:-----------|:-----------|:-------------------------------------------------------------------------|
| C_20230929.csv | 2023-09-29 | 2023-11-01 | <https://github.com/abjur/tpur/releases/download/classes/C_20230929.csv> |
| C_20230705.csv | 2023-07-05 | 2023-09-28 | <https://github.com/abjur/tpur/releases/download/classes/C_20230705.csv> |
| C_20230616.csv | 2023-06-16 | 2023-07-04 | <https://github.com/abjur/tpur/releases/download/classes/C_20230616.csv> |
| C_20230526.csv | 2023-05-26 | 2023-06-15 | <https://github.com/abjur/tpur/releases/download/classes/C_20230526.csv> |
| C_20230331.csv | 2023-03-31 | 2023-05-25 | <https://github.com/abjur/tpur/releases/download/classes/C_20230331.csv> |
| C_20230202.csv | 2023-02-02 | 2023-03-30 | <https://github.com/abjur/tpur/releases/download/classes/C_20230202.csv> |
| C_20221216.csv | 2022-12-16 | 2023-02-01 | <https://github.com/abjur/tpur/releases/download/classes/C_20221216.csv> |
| C_20221129.csv | 2022-11-29 | 2022-12-15 | <https://github.com/abjur/tpur/releases/download/classes/C_20221129.csv> |
| C_20220920.csv | 2022-09-20 | 2022-11-28 | <https://github.com/abjur/tpur/releases/download/classes/C_20220920.csv> |
| C_20220701.csv | 2022-07-01 | 2022-09-19 | <https://github.com/abjur/tpur/releases/download/classes/C_20220701.csv> |
| C_20220615.csv | 2022-06-15 | 2022-06-30 | <https://github.com/abjur/tpur/releases/download/classes/C_20220615.csv> |
| C_20220323.csv | 2022-03-23 | 2022-06-14 | <https://github.com/abjur/tpur/releases/download/classes/C_20220323.csv> |
| C_20211203.csv | 2021-12-03 | 2022-03-22 | <https://github.com/abjur/tpur/releases/download/classes/C_20211203.csv> |
| C_20211001.csv | 2021-10-01 | 2021-12-02 | <https://github.com/abjur/tpur/releases/download/classes/C_20211001.csv> |
| C_20210730.csv | 2021-07-30 | 2021-09-30 | <https://github.com/abjur/tpur/releases/download/classes/C_20210730.csv> |
| C_20210531.csv | 2021-05-31 | 2021-07-29 | <https://github.com/abjur/tpur/releases/download/classes/C_20210531.csv> |
| C_20210331.csv | 2021-03-31 | 2021-05-30 | <https://github.com/abjur/tpur/releases/download/classes/C_20210331.csv> |
| C_20210330.csv | 2021-03-30 | 2021-03-30 | <https://github.com/abjur/tpur/releases/download/classes/C_20210330.csv> |
| C_20210120.csv | 2021-01-20 | 2021-03-29 | <https://github.com/abjur/tpur/releases/download/classes/C_20210120.csv> |
| C_20201204.csv | 2020-12-04 | 2021-01-19 | <https://github.com/abjur/tpur/releases/download/classes/C_20201204.csv> |
| C_20201124.csv | 2020-11-24 | 2020-12-03 | <https://github.com/abjur/tpur/releases/download/classes/C_20201124.csv> |
| C_20200917.csv | 2020-09-17 | 2020-11-23 | <https://github.com/abjur/tpur/releases/download/classes/C_20200917.csv> |
| C_20200814.csv | 2020-08-14 | 2020-09-16 | <https://github.com/abjur/tpur/releases/download/classes/C_20200814.csv> |
| C_20200811.csv | 2020-08-11 | 2020-08-13 | <https://github.com/abjur/tpur/releases/download/classes/C_20200811.csv> |
| C_20200810.csv | 2020-08-10 | 2020-08-10 | <https://github.com/abjur/tpur/releases/download/classes/C_20200810.csv> |
| C_20200623.csv | 2020-06-23 | 2020-08-09 | <https://github.com/abjur/tpur/releases/download/classes/C_20200623.csv> |
| C_20200525.csv | 2020-05-25 | 2020-06-22 | <https://github.com/abjur/tpur/releases/download/classes/C_20200525.csv> |
| C_20200321.csv | 2020-03-21 | 2020-05-24 | <https://github.com/abjur/tpur/releases/download/classes/C_20200321.csv> |
| C_20200318.csv | 2020-03-18 | 2020-03-20 | <https://github.com/abjur/tpur/releases/download/classes/C_20200318.csv> |
| C_20190919.csv | 2019-09-19 | 2020-03-17 | <https://github.com/abjur/tpur/releases/download/classes/C_20190919.csv> |
| C_20190917.csv | 2019-09-17 | 2019-09-18 | <https://github.com/abjur/tpur/releases/download/classes/C_20190917.csv> |
| C_20190821.csv | 2019-08-21 | 2019-09-16 | <https://github.com/abjur/tpur/releases/download/classes/C_20190821.csv> |
| C_20190820.csv | 2019-08-20 | 2019-08-20 | <https://github.com/abjur/tpur/releases/download/classes/C_20190820.csv> |
| C_20190306.csv | 2019-03-06 | 2019-08-19 | <https://github.com/abjur/tpur/releases/download/classes/C_20190306.csv> |
| C_20190115.csv | 2019-01-15 | 2019-03-05 | <https://github.com/abjur/tpur/releases/download/classes/C_20190115.csv> |
| C_20181219.csv | 2018-12-19 | 2019-01-14 | <https://github.com/abjur/tpur/releases/download/classes/C_20181219.csv> |
| C_20180906.csv | 2018-09-06 | 2018-12-18 | <https://github.com/abjur/tpur/releases/download/classes/C_20180906.csv> |
| C_20180628.csv | 2018-06-28 | 2018-09-05 | <https://github.com/abjur/tpur/releases/download/classes/C_20180628.csv> |
| C_20180309.csv | 2018-03-09 | 2018-06-27 | <https://github.com/abjur/tpur/releases/download/classes/C_20180309.csv> |
| C_20171127.csv | 2017-11-27 | 2018-03-08 | <https://github.com/abjur/tpur/releases/download/classes/C_20171127.csv> |
| C_20170710.csv | 2017-07-10 | 2017-11-26 | <https://github.com/abjur/tpur/releases/download/classes/C_20170710.csv> |
| C_20160906.csv | 2016-09-06 | 2017-07-09 | <https://github.com/abjur/tpur/releases/download/classes/C_20160906.csv> |
| C_20160809.csv | 2016-08-09 | 2016-09-05 | <https://github.com/abjur/tpur/releases/download/classes/C_20160809.csv> |
| C_20160503.csv | 2016-05-03 | 2016-08-08 | <https://github.com/abjur/tpur/releases/download/classes/C_20160503.csv> |
| C_20160315.csv | 2016-03-15 | 2016-05-02 | <https://github.com/abjur/tpur/releases/download/classes/C_20160315.csv> |
| C_20160314.csv | 2016-03-14 | 2016-03-14 | <https://github.com/abjur/tpur/releases/download/classes/C_20160314.csv> |
| C_20150929.csv | 2015-09-29 | 2016-03-13 | <https://github.com/abjur/tpur/releases/download/classes/C_20150929.csv> |
| C_20150824.csv | 2015-08-24 | 2015-09-28 | <https://github.com/abjur/tpur/releases/download/classes/C_20150824.csv> |
| C_20141003.csv | 2014-10-03 | 2015-08-23 | <https://github.com/abjur/tpur/releases/download/classes/C_20141003.csv> |

TPUs de classes disponíveis

| file           | dt_ini     | dt_fim     | release                                                                   |
|:---------------|:-----------|:-----------|:--------------------------------------------------------------------------|
| A_20230929.csv | 2023-09-29 | 2023-11-01 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230929.csv> |
| A_20230705.csv | 2023-07-05 | 2023-09-28 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230705.csv> |
| A_20230616.csv | 2023-06-16 | 2023-07-04 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230616.csv> |
| A_20230526.csv | 2023-05-26 | 2023-06-15 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230526.csv> |
| A_20230331.csv | 2023-03-31 | 2023-05-25 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230331.csv> |
| A_20230202.csv | 2023-02-02 | 2023-03-30 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230202.csv> |
| A_20221216.csv | 2022-12-16 | 2023-02-01 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20221216.csv> |
| A_20221129.csv | 2022-11-29 | 2022-12-15 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20221129.csv> |
| A_20220920.csv | 2022-09-20 | 2022-11-28 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20220920.csv> |
| A_20220701.csv | 2022-07-01 | 2022-09-19 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20220701.csv> |
| A_20220615.csv | 2022-06-15 | 2022-06-30 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20220615.csv> |
| A_20220323.csv | 2022-03-23 | 2022-06-14 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20220323.csv> |
| A_20211203.csv | 2021-12-03 | 2022-03-22 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20211203.csv> |
| A_20211001.csv | 2021-10-01 | 2021-12-02 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20211001.csv> |
| A_20210730.csv | 2021-07-30 | 2021-09-30 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20210730.csv> |
| A_20210531.csv | 2021-05-31 | 2021-07-29 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20210531.csv> |
| A_20210331.csv | 2021-03-31 | 2021-05-30 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20210331.csv> |
| A_20210330.csv | 2021-03-30 | 2021-03-30 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20210330.csv> |
| A_20210120.csv | 2021-01-20 | 2021-03-29 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20210120.csv> |
| A_20201204.csv | 2020-12-04 | 2021-01-19 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20201204.csv> |
| A_20201124.csv | 2020-11-24 | 2020-12-03 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20201124.csv> |
| A_20200917.csv | 2020-09-17 | 2020-11-23 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200917.csv> |
| A_20200814.csv | 2020-08-14 | 2020-09-16 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200814.csv> |
| A_20200811.csv | 2020-08-11 | 2020-08-13 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200811.csv> |
| A_20200810.csv | 2020-08-10 | 2020-08-10 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200810.csv> |
| A_20200623.csv | 2020-06-23 | 2020-08-09 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200623.csv> |
| A_20200525.csv | 2020-05-25 | 2020-06-22 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200525.csv> |
| A_20200321.csv | 2020-03-21 | 2020-05-24 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200321.csv> |
| A_20200318.csv | 2020-03-18 | 2020-03-20 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20200318.csv> |
| A_20190919.csv | 2019-09-19 | 2020-03-17 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20190919.csv> |
| A_20190917.csv | 2019-09-17 | 2019-09-18 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20190917.csv> |
| A_20190821.csv | 2019-08-21 | 2019-09-16 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20190821.csv> |
| A_20190306.csv | 2019-03-06 | 2019-08-20 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20190306.csv> |
| A_20190115.csv | 2019-01-15 | 2019-03-05 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20190115.csv> |
| A_20181219.csv | 2018-12-19 | 2019-01-14 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20181219.csv> |
| A_20180906.csv | 2018-09-06 | 2018-12-18 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20180906.csv> |
| A_20180628.csv | 2018-06-28 | 2018-09-05 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20180628.csv> |
| A_20180309.csv | 2018-03-09 | 2018-06-27 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20180309.csv> |
| A_20171127.csv | 2017-11-27 | 2018-03-08 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20171127.csv> |
| A_20170710.csv | 2017-07-10 | 2017-11-26 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20170710.csv> |
| A_20160906.csv | 2016-09-06 | 2017-07-09 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20160906.csv> |
| A_20160809.csv | 2016-08-09 | 2016-09-05 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20160809.csv> |
| A_20160503.csv | 2016-05-03 | 2016-08-08 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20160503.csv> |
| A_20160315.csv | 2016-03-15 | 2016-05-02 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20160315.csv> |
| A_20160314.csv | 2016-03-14 | 2016-03-14 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20160314.csv> |
| A_20150929.csv | 2015-09-29 | 2016-03-13 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20150929.csv> |
| A_20150824.csv | 2015-08-24 | 2015-09-28 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20150824.csv> |
| A_20141003.csv | 2014-10-03 | 2015-08-23 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20141003.csv> |

TPUs de Assuntos disponíveis

## Installation

Você pode instalar a versão de desenvolvimento do pacote tpur no
[GitHub](https://github.com/) com:

``` r
# install.packages("devtools")
devtools::install_github("abjur/tpur")
```

## Baixando as TPUs

O pacote vem com uma base para cada tipo de TPU (uma para classes e
outra para assuntos). Você pode acessar essas bases com as seguintes
funções:

``` r
classes <- readr::read_csv("inst/extdata/classes.csv", show_col_types = FALSE)
assuntos <- readr::read_csv("inst/extdata/assuntos.csv", show_col_types = FALSE)
```

E se você quiser acessar essas mesmas tabelas em R, basta usar os
seguintes códigos:

``` r
classes <- tpur::classes
assuntos <- tpur::assuntos
```

Essas são exatamente as tabelas acima, apresentadas na Sessão de **TPUs
Disponíveis**. Para baixar a TPU, basta ler o csv de um dos links do
releases

``` r
link_csv <- readr::read_csv("inst/extdata/assuntos.csv", show_col_types = FALSE) |> 
  dplyr::filter(file == "A_20230331.csv") |> # seleciona a TPU desejada
  dplyr::pull(release) # extrai o link do releases

base <- readr::read_csv(link_csv) # lê o .csv do release e atribui a um objeto
```

## Utilizando o pacote

Além de disponibilizar as TPUs do CNJ, este pacote busca, também, criar
uma forma de fácil acesso a pesquisadores aos códigos das TPUs. Para
tanto, foram criadas duas funções de leitura.

- `tpur::tpu_assunto_read`
- `tpur::tpu_classe_read`

Ambas as funções possuem os mesmos parâmetros:

- `busca`: Palavra a ser pesquisada nas TPUs
- `ini`: Início do período que se pretende pesquisar. A data deve ser
  passada no formato “YYYY-MM-DD”
- `fim`: Fim do período que se pretende pesquisar. A data deve ser
  passada no formato “YYYY-MM-DD”

Os parâmetros `ini` e `fim`, por default, utilizam a data de hoje, por
meio da função `Sys.Date()`.

## Exemplo

Este é um exemplo básico de como a função de read dos assunto funciona.

``` r
tpur::tpu_assunto_read(busca = "desapropriação", ini = "2023-01-01", fim = "2023-02-01") |> 
  knitr::kable()
```

| id         | tpu_periodo_validade       | codigo | assunto                                                                     |
|:-----------|:---------------------------|-------:|:----------------------------------------------------------------------------|
| A_20221216 | de 16/12/2022 a 01/02/2023 |  10121 | Desapropriação                                                              |
| A_20221216 | de 16/12/2022 a 01/02/2023 |  10134 | Desapropriação de Imóvel Urbano                                             |
| A_20221216 | de 16/12/2022 a 01/02/2023 |  10125 | Desapropriação Indireta                                                     |
| A_20221216 | de 16/12/2022 a 01/02/2023 |  12031 | Desapropriação para Regularização de Comunidade Quilombola / Dec. 4887/2003 |
| A_20221216 | de 16/12/2022 a 01/02/2023 |  10123 | Desapropriação por Interesse Social Comum / L 4.132/1962                    |
| A_20221216 | de 16/12/2022 a 01/02/2023 |  10124 | Desapropriação por Interesse Social para Reforma Agrária                    |
| A_20221216 | de 16/12/2022 a 01/02/2023 |  10122 | Desapropriação por Utilidade Pública / DL 3.365/1941                        |
| A_20221216 | de 16/12/2022 a 01/02/2023 |  10886 | Nulidade do Decreto que autoriza a desapropriação                           |

Este outro exemplo traz o funcionamento da função de read das classes.
Aqui é possível ver também que é possível passar uma
[regex](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf)
como parâmetro.

``` r
tpur::tpu_classe_read("juri$", ini = "2023-01-01", fim = "2023-02-01") |> 
  knitr::kable()
```

| id         | tpu_periodo_validade       | codigo | classe                            |
|:-----------|:---------------------------|-------:|:----------------------------------|
| C_20221216 | de 16/12/2022 a 01/02/2023 |    282 | Ação Penal de Competência do Júri |
| C_20221216 | de 16/12/2022 a 01/02/2023 |    422 | Protesto por Novo Júri            |

## Futuros desenvolvimentos

- O pacote ainda não conseguiu extrair as TPUs de assuntos e classes
  anteriores a 20/09/2022.
- Ainda não foram construídas as funções para extrair as TPUs
  relacionadas a movimentos e documentos.

Outras sugestões para o desenvolvimento do pacote são bem vindas. Para
tanto, envie email para <ric.feliz@gmail.com>.
