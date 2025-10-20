FROM ghcr.io/matcha-bookable/docker-tf2-server:latest
LABEL maintainer="avan"

ADD --chown=tf2:tf2 ./sourcemod.sh ./cleanup.sh ./plugins.sh ./tf.sh $SERVER/

RUN chmod +x $SERVER/sourcemod.sh \
	$SERVER/cleanup.sh \
    $SERVER/plugins.sh \
	$SERVER/tf.sh

RUN echo "=== Starting sourcemod.sh ===" && \
	$SERVER/sourcemod.sh && \
	echo "=== Starting cleanup.sh ===" && \
	$SERVER/cleanup.sh && \
	echo "=== Completed ==="

USER root
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME ["/external"]

EXPOSE 27015/udp 27015/tcp 27021/tcp 27020/udp

WORKDIR /home/$USER/hlserver

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["+sv_pure", "1", "+map", "cp_process_f12", "+servercfgfile", "server.cfg", "+maxplayers", "24", "-enablefakeip"]