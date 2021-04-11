FROM debian:buster-slim AS src

ENV DEBIAN_FRONTEND="noninteractive" \
  PLEX_PATH=/usr/lib/plexmediaserver \
  PLEX_USER_NAME=plex \
  PLEX_CONFIG_DIR=/config \
  PLEX_DATA_DIR=/data \
  PLEX_TRANSCODE_DIR=/transcode

COPY VERSION .

RUN apt-get update \
  && apt-get install -y wget ca-certificates

# Download / install Plex
RUN PLEX_VERSION=$(cat ./VERSION) \
 && wget --no-verbose -O /tmp/plex.deb https://downloads.plex.tv/plex-media-server-new/${PLEX_VERSION}/debian/plexmediaserver_${PLEX_VERSION}_arm64.deb \
 && dpkg -i /tmp/plex.deb \
 && rm -f /tmp/plexmediaserver.deb

# Add user
RUN useradd -U -d $PLEX_CONFIG_DIR -s /bin/false $PLEX_USER_NAME \
 && usermod -G users $PLEX_USER_NAME

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
