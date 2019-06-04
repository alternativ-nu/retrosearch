FROM bioatlas/mirroreum:0.9.1

RUN install2.r --error \
	rdrop2

COPY retrosearch.tar.gz /tmp/retrosearch.tar.gz

RUN R CMD INSTALL /tmp/retrosearch.tar.gz

#RUN Rscript -e "install.packages('/tmp/retrosearch.tar.gz', repos=NULL)"

RUN cd /srv/shiny-server && rm -rf * && ln -s /usr/local/lib/R/site-library/retrosearch/shiny-apps/retrofinder/* /srv/shiny-server

RUN mkdir -p /home/shiny/.config/retrosearch && chown -R shiny.shiny /home/shiny/.config/retrosearch

VOLUME /home/shiny/.config/retrosearch

CMD ["/usr/bin/shiny-server.sh"]
