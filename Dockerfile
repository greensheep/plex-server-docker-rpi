#############################################
## Stage 1: Download / extract plex source ##
#############################################

FROM balenalib/armv7hf-debian:stretch AS src

ENV DEBIAN_FRONTEND="noninteractive" \
  PLEX_PATH=/opt/plex/Application

COPY VERSION .

RUN apt update \
  && apt install -y wget ca-certificates locales

# Download / extract Plex
RUN PLEX_VERSION=$(cat ./VERSION) \
  && wget --no-verbose -O /tmp/plex.tar https://downloads.plex.tv/plex-media-server-new/${PLEX_VERSION}/synology/PlexMediaServer-${PLEX_VERSION}-armv7hf.spk \
  && tar -xf /tmp/plex.tar -C /tmp \
  && mkdir -p $PLEX_PATH \
  && tar -xf /tmp/package.tgz -C $PLEX_PATH

# Move the Resources/start.sh script to the plex app root. This ensures correct
# env vars are set and the plex binary can be located
RUN mv $PLEX_PATH/Resources/start.sh $PLEX_PATH/

# Also add a line to start.sh script to remove any previous pid file found in
# the config dir. Plex wont start if this file is left over from a previous run
RUN sed -i '2i rm -rf /config/Library/Application\\ Support/Plex\\ Media\\ Server/plexmediaserver.pid' $PLEX_PATH/start.sh

# Setup locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
  && locale-gen

##########################
## Stage 2: Final image ##
##########################

FROM arm32v7/debian:stretch-slim

ENV PLEX_PATH=/opt/plex/Application

# Copy plex & locales from stage 1
COPY --from=src ${PLEX_PATH} ${PLEX_PATH}
COPY --from=src /usr/lib/locale /usr/lib/locale

# Setup volumes
#  - /config holds the server settings
#  - /data is where media should be mounted
VOLUME ["/config", "/data"]

# Plex server port
EXPOSE 32400

# Plex config environment vars
ENV HOME=/config

WORKDIR ${PLEX_PATH}
CMD ["sh", "start.sh"]
