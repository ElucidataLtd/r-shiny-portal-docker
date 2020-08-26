FROM ubuntu:20.04
RUN apt update \
  && apt upgrade -y \
  && apt install -y apt-utils

# Set locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set MRAN snapshot date. 2019-04-26 is the date associated with r-ver 3.5.3.
ENV BUILD_DATE=2019-04-26
ENV R_VERSION=3.5.3 \
  CRAN=https://cran.rstudio.com \
  LC_ALL=en_US.UTF-8 \
  LANG=en_US.UTF-8 \
  TERM=xterm

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London
RUN apt install -y tzdata

RUN apt update \
  && apt install -y --no-install-recommends \
  bash-completion \
  ca-certificates \
  file \
  fonts-texgyre \
  g++ \
  gfortran \
  gsfonts \
  libblas-dev \
  libbz2-1.0 \
  libcurl4 \
  libopenblas-dev \
  libpangocairo-1.0-0 \
  libpcre3 \
  libpng16-16 \
  libreadline8 \
  libtiff5 \
  liblzma5 \
  locales \
  make \
  unzip \
  zip \
  zlib1g \
  && BUILDDEPS="curl \
  default-jdk \
  libbz2-dev \
  libcairo2-dev \
  libcurl4-openssl-dev \
  libpango1.0-dev \
  libjpeg-dev \
  libicu-dev \
  libpcre3-dev \
  libpng-dev \
  libreadline-dev \
  libtiff5-dev \
  liblzma-dev \
  libx11-dev \
  libxt-dev \
  perl \
  tcl8.6-dev \
  tk8.6-dev \
  x11proto-core-dev \
  xauth \
  xfonts-base \
  xvfb \
  zlib1g-dev" \
  && apt install -y --no-install-recommends $BUILDDEPS \
  && cd tmp/ \
  ## Download source code
  && curl -O https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz \
  ## Extract source code
  && tar -xf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION} \
  ## Set compiler flags
  && R_PAPERSIZE=letter \
  R_BATCHSAVE="--no-save --no-restore" \
  R_BROWSER=xdg-open \
  PAGER=/usr/bin/pager \
  PERL=/usr/bin/perl \
  R_UNZIPCMD=/usr/bin/unzip \
  R_ZIPCMD=/usr/bin/zip \
  R_PRINTCMD=/usr/bin/lpr \
  LIBnn=lib \
  AWK=/usr/bin/awk \
  CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
  CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
  ## Configure options
  ./configure --enable-R-shlib \
  --enable-memory-profiling \
  --with-readline \
  --with-blas \
  --with-tcltk \
  --disable-nls \
  --with-recommended-packages \
  ## Build and install
  && make \
  && make install \
  ## Add a library directory (for user-installed packages)
  && mkdir -p /usr/local/lib/R/site-library \
  && chown root:staff /usr/local/lib/R/site-library \
  && chmod g+ws /usr/local/lib/R/site-library \
  ## Fix library path
  && sed -i '/^R_LIBS_USER=.*$/d' /usr/local/lib/R/etc/Renviron \
  && echo "R_LIBS_USER=\${R_LIBS_USER-'/usr/local/lib/R/site-library'}" >> /usr/local/lib/R/etc/Renviron \
  && echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron \
  ## Set configured CRAN mirror
  && if [ -z "$BUILD_DATE" ]; then MRAN=$CRAN; \
  else MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE}; fi \
  && echo MRAN=$MRAN >> /etc/environment \
  && echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
  ## Use littler installation scripts
  && Rscript -e "install.packages(c('littler', 'docopt'), repo = '$CRAN')" \
  && ln -s /usr/local/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
  && ln -s /usr/local/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
  && ln -s /usr/local/lib/R/site-library/littler/bin/r /usr/local/bin/r \
  ## Clean up from R source install
  && cd / \
  && rm -rf /tmp/* \
  && apt remove --purge -y $BUILDDEPS \
  && apt autoremove -y \
  && apt autoclean -y \
  && rm -rf /var/lib/apt/lists/*


# ###################### Portal additions #############################################################
# OS packages are split into package build dependencies and package dependencies.
# The package *build deps* only need to be present during the R package compilation. They
# have significant additional dependencies (e.g. python) which can be removed after the
# R package has been compiled. The *package deps* however, need to remain on the system
# to be used by the R packages at runtime.

ENV PKG_DEPS="libapparmor1 \
  binutils-multiarch \
  libssl1.1 \
  libxml2 \
  libcairo2 \
  libsqlite0 \
  libmariadb3 \
  libpq5 \
  libssh2-1 \
  unixodbc \
  libsasl2-2 \
  libnode64 \
  libxt6"

ENV PKG_BUILD_DEPS="libclang-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libcairo2-dev \
  libsqlite0-dev \
  libmariadbd-dev \
  libmariadbclient-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev \
  libnode-dev \
  libxt-dev"


RUN apt update \
  && apt install -y --no-install-recommends $PKG_DEPS\
  && apt install -y --no-install-recommends $PKG_BUILD_DEPS \
  && install2.r --error \
  --deps TRUE \
  tidyverse \
  glue \
  testthat \
  devtools \
  formatR \
  remotes \
  selectr \
  # portal-specific  
  data.table \
  DT \
  htmltools \
  futile.logger \
  future \
  openxlsx \
  pool \
  promises \
  r2d3 \
  rjson \
  RPostgres \
  shiny \
  shinydashboard \
  shinyjqui \
  shinyjs \
  shinyWidgets \
  yaml \
  XML \
  && apt remove --purge -y $PKG_BUILD_DEPS \
  && apt autoremove -y \
  && apt autoclean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/downloaded_packages/*

# Install AzureAuth 1.2.4
RUN Rscript -e "devtools::install_github('Azure/AzureAuth', ref = '34c59d3407caf730cc58158ae7e76b422c3a8884')"

CMD ["R"]