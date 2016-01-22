# Docker Samba Server

A super simple way to setup a samba share with Docker.

To use:

    docker build -t samba-server .
    docker run -d \
      --net="host" \
      --name samba-server \
      -v /some/host/dir:/path/to/share \
      -v /another/host/dir:/path/to/share-2 \
      samba-server:latest \
      {share-name}:{/path/to/share} {share-name-2}:{/path/to/share-2}

The server is unsecured so PRs welcome if you want this :)
