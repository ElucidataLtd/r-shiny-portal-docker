FROM rocker/tidyverse:3.5.3

# install other packages

RUN install2.r bit64 data.table DiagrammeR DT futile.logger future ggplot2 glue listviewer plotly pool promises r2d3 rhandsontable rjson RPostgres shiny shinyBS shinydashboard shinyjqui shinyjs shinyWidgets testthat yaml XML

RUN Rscript -e "devtools::install_github('ElucidataLtd/dashboardthemes')"
RUN Rscript -e "devtools::install_github('timelyportfolio/reactR')"
RUN Rscript -e "devtools::install_github('ElucidataLtd/udpprobe')"

# Install AzureAuth 1.2.4
RUN Rscript -e "devtools::install_github('Azure/AzureAuth', ref = '34c59d3407caf730cc58158ae7e76b422c3a8884')"
