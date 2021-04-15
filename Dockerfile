FROM debian:buster-slim AS src

ARG TARGETARCH

ENV DEBIAN_FRONTEND="noninteractive" \
  PLEX_PATH=/usr/lib/plexmediaserver \
  PLEX_USER_NAME=plex \
  PLEX_CONFIG_DIR=/config \
  PLEX_DATA_DIR=/data \
  PLEX_TRANSCODE_DIR=/transcode

RUN apt-get update \
  && apt-get install -y wget ca-certificates

COPY VERSION .
COPY scripts/plex-url.sh .

# Download / install Plex
RUN PLEX_VERSION=$(cat ./VERSION) \
 && PLEX_URL=$(./plex-url.sh $PLEX_VERSION $TARGETARCH) \
 && wget --no-verbose -O /tmp/plex.deb $PLEX_URL \
 && dpkg -i /tmp/plex.deb \
 && rm -f /tmp/plexmediaserver.deb

# Add user
RUN useradd -U -d $PLEX_CONFIG_DIR -s /bin/false $PLEX_USER_NAME \
 && usermod -G users $PLEX_USER_NAME

COPY scripts/entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
