FROM zino1337/acevo-server:latest
USER root
RUN rm -rf /data && ln -s /home/container /data
RUN rm -rf /root && ln -s /home/container /root
USER 1000
