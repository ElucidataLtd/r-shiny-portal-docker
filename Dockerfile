#FROM rocker/r-ver:latest
FROM rocker/tidyverse

#install other packages
RUN Rscript -e "install.packages(c('shinydashboard', 'shiny','dashboardthemes'))"


RUN Rscript -e "install.packages(c('purrr', 'stringr', 'devtools', 'futile.logger', 'DT', 'data.table', 'magrittr','httr', 'testthat','bit64'))"
RUN Rscript -e "install.packages(c('jsonlite','XML', 'rjson', 'DiagrammeR', 'listviewer', 'glue', 'shinyjqui', 'rhandsontable', 'lubridate'))"
RUN Rscript -e "install.packages(c('shinyjs'))"

RUN Rscript -e "devtools::install_github('nik01010/dashboardthemes')"
RUN Rscript -e "devtools::install_github('timelyportfolio/reactR')"

RUN install2.r stringr RPostgres r2d3 ggplot2 pool yaml