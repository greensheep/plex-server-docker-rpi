#!/bin/bash

set -e

VERSION=$1

case $2 in
  arm64)
    TARGETARCH=arm64
    ;;
  arm)
    TARGETARCH=armhf
    ;;
  *)
    echo "Error: unknown target arch"
    exit 1
    ;;
esac

echo https://downloads.plex.tv/plex-media-server-new/${VERSION}/debian/plexmediaserver_${VERSION}_${TARGETARCH}.deb
