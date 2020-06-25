FROM alpine:3.12.0
ENV MRAN_REPO_DATE=2020-06-01
ENV MRAN=https://mran.microsoft.com/snapshot/$MRAN_REPO_DATE \
    TERM=xterm

###### ------- Alpine Packages ----------- #####

# Baseline packages for R and building R/Rcpp packages
ENV BASELINE_PKGS="cmake gcc g++ git R R-doc R-dev autoconf tzdata gnu-libiconv"
RUN apk update \
  && apk --no-cache add $BASELINE_PKGS

# R package httpuv is very particular about the version of automake it needs to
# compile. The easiest way to get the required version is from this repo of the 
# previous alpine release:
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories
RUN apk update
RUN apk add automake==1.16.1-r0

# Extra apk packages that are probably useful to service R packages
ENV RVER_PKGS="bash-completion ca-certificates file gfortran ghostscript-fonts libbz2 libcurl icu-libs libjpeg-turbo openblas-dev pango pcre-dev libpng readline tiff xz-libs unzip zip zlib"
ENV TIDYVERSE_PKGS="libxml2-dev cairo cairo-dev sqlite-dev mariadb-dev mariadb-client postgresql-dev libssh2 unixodbc-dev libsasl"

RUN apk add $RVER_PKGS
RUN apk add $TIDYVERSE_PKGS

###### ----------- R Packages --------------- #####

## Set configured CRAN mirror
RUN echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/lib/R/etc/Rprofile.site

# Tidyverse

#RUN R -e 'install.packages(c("tidyverse", "dplyr", "devtools", "formatR", "remotes", "selectr", "caTools"))'
#RUN R -e 'install.packages(c("Rcpp", "BH", "rlang", "magrittr", "R6", "promises"))'
#RUN R -e 'install.packages(c("httpuv", "shiny"))'


# Install dev version of readxl, which contains a fix for compiling on alpine,
# see https://github.com/tidyverse/readxl/pull/570. The version selected is
# post-1.3.1.
# Install some basic packages that we need for installing readxl
RUN R -e 'install.packages(c("Rcpp", "BH", "progress", "devtools", "magrittr"))'
# Install readxl
RUN Rscript -e "devtools::install_github('tidyverse/readxl', ref = '3815961a849fa85e6a8a9938b32ad116c682737d')"

RUN R -e 'install.packages(c("tidyverse"))'
RUN R -e 'install.packages(c("formatR", "caTools"))'

# Basic Shiny packages
RUN R -e 'install.packages(c("shiny"))'

# Packages for MI Portal
RUN Rscript -e "devtools::install_github('ElucidataLtd/dashboardthemes')"
RUN R -e 'install.packages(c("AzureAuth", "data.table", "DT", "futile.logger", "future", "ggplot2", "glue", "openxlsx", "pool", "promises", "rjson", "RPostgres", "shinyBS", "shinydashboard", "shinyjqui", "shinyjs", "shinyWidgets", "testthat", "yaml", "XML"))'
