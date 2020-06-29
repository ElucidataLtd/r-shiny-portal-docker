FROM alpine:3.12.0
ENV MRAN_REPO_DATE=2020-06-01
ENV MRAN=https://mran.microsoft.com/snapshot/$MRAN_REPO_DATE \
 LC_ALL=en_US.UTF-8 \
 LANG=en_US.UTF-8 \
 TERM=xterm

# Set default timezone
ENV TZ UTC 

###### ------- Alpine Packages ----------- #####

# Baseline packages for R and building R/Rcpp packages
ENV BASELINE_PKGS="cmake gcc R R-doc R-dev g++ git autoconf tzdata gnu-libiconv"
RUN apk update \
  && apk --no-cache add $BASELINE_PKGS

# R package httpuv is very particular about the version of automake it needs to
# compile. The easiest way to get the required version is from this repo of the 
# previous alpine release:
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories
RUN apk update
RUN apk add automake==1.16.1-r0

# Extra apk packages that are probably useful to service R packages
ENV RVER_PKGS="bash-completion ca-certificates file gfortran ghostscript-fonts libbz2 libcurl icu-libs libjpeg-turbo libjpeg-turbo-dev openblas-dev pango pcre-dev libpng libpng-dev readline tiff tiff-dev xz-libs unzip zip zlib coreutils"
ENV TIDYVERSE_PKGS="libxml2-dev cairo cairo-dev sqlite-dev mariadb-dev mariadb-client postgresql-dev libssh2 libssh2-dev libgit2 libgit2-dev unixodbc-dev libsasl"

RUN apk --no-cache add $RVER_PKGS
RUN apk --no-cache add $TIDYVERSE_PKGS

###### ----------- R Packages --------------- #####

# The default iconv renders an incomplete and in a format not compatible with R list
# gnu-iconv is the compatible one with R, hence it is used for replacement and its list given to R
RUN cp /usr/bin/gnu-iconv /usr/bin/iconv
RUN /usr/bin/iconv -l > /usr/lib/R/library/utils/iconvlist

## Set compiler flags
RUN CFLAGS="-g -O2 -fstack-protector-strong -D_DEFAULT_SOURCE -D__USE_MISC" 
RUN CXXFLAGS="-g -O2 -fstack-protector-strong -D_FORTIFY_SOURCE=2 -D__MUSL__" 

## Announce library path
RUN echo "R_LIBS_SITE=\${R_LIBS_SITE-'/usr/local/lib/R/site-library:/usr/lib/R/library'}" >> /usr/lib/R/etc/Renviron

## Set configured CRAN mirror
RUN echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/lib/R/etc/Rprofile.site

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
#RUN R -e 'install.packages(c("shiny"))'
# Need Shiny 1.5 and htmltools 0.5 so that ragg can be used to render figures
RUN R -e 'devtools::install_github("rstudio/htmltools@v0.5.0")'
RUN R -e 'devtools::install_github("rstudio/shiny@v1.5.0")'
RUN R -e 'install.packages(c("ragg"))'

# Packages for MI Portal
RUN Rscript -e "devtools::install_github('ElucidataLtd/dashboardthemes')"
RUN R -e 'install.packages(c("AzureAuth", "data.table", "DT", "futile.logger", "future", "glue", "openxlsx", "pool", "promises", "rjson", "RPostgres", "sass", "shinyBS", "shinydashboard", "shinyjqui", "shinyjs", "shinyWidgets", "testthat", "yaml", "XML"))'
