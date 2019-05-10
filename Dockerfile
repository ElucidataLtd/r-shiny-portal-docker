FROM rocker/tidyverse:3.5.3

# install other packages

RUN install2.r bit64 data.table DiagrammeR DT futile.logger future ggplot2 glue listviewer pool promises r2d3 rhandsontable rjson RPostgres shiny shinydashboard shinyjqui shinyjs testthat yaml XML

RUN Rscript -e "devtools::install_github('nik01010/dashboardthemes')"
RUN Rscript -e "devtools::install_github('timelyportfolio/reactR')"

