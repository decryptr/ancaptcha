FROM rocker/r-ver:4.0.3
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libssl-dev libxml2-dev libmagick++-dev make pandoc pandoc-citeproc && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest', download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("rlang",upgrade="never", version = "0.4.10")'
RUN Rscript -e 'remotes::install_version("magrittr",upgrade="never", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.1.1")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.6.0")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("googleCloudStorageR",upgrade="never", version = "0.6.0")'
RUN Rscript -e 'remotes::install_version("torch",upgrade="never", version = "0.2.1")'
RUN Rscript -e 'torch::install_torch()'
RUN Rscript -e 'remotes::install_version("shinyalert",upgrade="never", version = "2.0.0")'
RUN Rscript -e 'remotes::install_github("mlverse/torchvision")'
RUN Rscript -e 'remotes::install_github("decryptr/captcha@adcb53ce4c77b88dd928d36835ee39c8c636e4b6")'
RUN Rscript -e 'remotes::install_github("r-lib/usethis@734b5c2935a63781deb7d09de4ba24f625484418")'
RUN Rscript -e 'remotes::install_github("ThinkR-Open/golem@aaae5c8788802a7b4aef4df23691902a286dd964")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
CMD R -e "options('shiny.port'=$PORT,shiny.host='0.0.0.0');ancaptcha::run_app()"
