FROM bioatlas/mirroreum:0.9.1

COPY retrosearch_0.6.tar.gz /tmp/retrosearch.tar.gz

RUN R CMD INSTALL /tmp/retrosearch.tar.gz

#RUN Rscript -e "install.packages('/tmp/retrosearch.tar.gz', repos=NULL)"

RUN cd /srv/shiny-server && rm -rf * && ln -s /usr/local/lib/R/site-library/retrosearch/shiny-apps/retrofinder/* /srv/shiny-server

CMD ["/usr/bin/shiny-server.sh"]
