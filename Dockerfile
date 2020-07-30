FROM elucidataltd/tidyverse-plus

# Install portal-specific packages

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libgtk2.0-dev \
  libxt-dev \
  libv8-dev

  RUN install2.r --error \
    --deps TRUE \
    data.table \
    DT \
    htmltools \
    futile.logger \
    future \
    openxlsx \
    pool \
    promises \
    rjson \
    RPostgres \
    shiny \
    shinyBS \
    shinydashboard \
    shinyjqui \
    shinyjs \
    shinyWidgets \
    yaml \
    XML

RUN Rscript -e "devtools::install_github('ElucidataLtd/dashboardthemes')"

# # Install AzureAuth 1.2.4
RUN Rscript -e "devtools::install_github('Azure/AzureAuth', ref = '34c59d3407caf730cc58158ae7e76b422c3a8884')"

# Install saas (not available on MRAN at snapshot date)
RUN Rscript -e "remotes::install_github('rstudio/sass')"
CMD ["R"]
