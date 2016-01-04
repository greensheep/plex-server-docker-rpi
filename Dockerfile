FROM resin/rpi-raspbian:jessie

# Dependencies
RUN apt-get update \
 && apt-get upgrade \
 && apt-get install locales apt-transport-https wget ca-certificates -y

# Setup locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
 && locale-gen

# Add package repo
RUN wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add - \
 && echo "deb https://dev2day.de/pms/ jessie main" | tee /etc/apt/sources.list.d/pms.list \
 && apt-get update

# Install Plex
RUN apt-get install plexmediaserver -y

# Setup volumes
VOLUME ["/config", "/data"]

# Plex env vars
ENV HOME=/config

# Plex server port
EXPOSE 32400

# Ensure any previous pid is removed
RUN sed -i '2i rm -rf /config/Library/Application\\ Support/Plex\\ Media\\ Server/plexmediaserver.pid' /usr/lib/plexmediaserver/start.sh

WORKDIR /usr/lib/plexmediaserver
CMD ["bash", "start.sh"]
