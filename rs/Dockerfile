FROM mongo:4.4
COPY replica-set.sh /replica-set.sh
USER root
RUN chown mongodb:mongodb /replica-set.sh
RUN chmod +x /replica-set.sh

USER mongodb
CMD ["/bin/bash", "/replica-set.sh"]