
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
| C_20230331.csv | 2023-03-31 | 2023-06-13 | <https://github.com/abjur/tpur/releases/download/classes/C_20230331.csv> |
| C_20230202.csv | 2023-02-02 | 2023-03-30 | <https://github.com/abjur/tpur/releases/download/classes/C_20230202.csv> |
| C_20221216.csv | 2022-12-16 | 2023-02-01 | <https://github.com/abjur/tpur/releases/download/classes/C_20221216.csv> |
| C_20221129.csv | 2022-11-29 | 2022-12-15 | <https://github.com/abjur/tpur/releases/download/classes/C_20221129.csv> |
| C_20220920.csv | 2022-09-20 | 2022-11-28 | <https://github.com/abjur/tpur/releases/download/classes/C_20220920.csv> |

TPUs de classes disponíveis

| file           | dt_ini     | dt_fim     | release                                                                   |
|:---------------|:-----------|:-----------|:--------------------------------------------------------------------------|
| A_20230331.csv | 2023-03-31 | 2023-06-13 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230331.csv> |
| A_20230202.csv | 2023-02-02 | 2023-03-30 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20230202.csv> |
| A_20221216.csv | 2022-12-16 | 2023-02-01 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20221216.csv> |
| A_20221129.csv | 2022-11-29 | 2022-12-15 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20221129.csv> |
| A_20220920.csv | 2022-09-20 | 2022-11-28 | <https://github.com/abjur/tpur/releases/download/assuntos/A_20220920.csv> |

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

-   `tpur::tpu_assunto_read`
-   `tpur::tpu_classe_read`

Ambas as funções possuem os mesmos parâmetros:

-   `busca`: Palavra a ser pesquisada nas TPUs
-   `ini`: Início do período que se pretende pesquisar. A data deve ser
    passada no formato “YYYY-MM-DD”
-   `fim`: Fim do período que se pretende pesquisar. A data deve ser
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

-   O pacote ainda não conseguiu extrair as TPUs de assuntos e classes
    anteriores a 20/09/2022.
-   Ainda não foram construídas as funções para extrair as TPUs
    relacionadas a movimentos e documentos.

Outras sugestões para o desenvolvimento do pacote são bem vindas. Para
tanto, envie email para <ric.feliz@gmail.com>.
