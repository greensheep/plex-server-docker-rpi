FROM resin/rpi-raspbian:jessie

RUN apt-get update \
 && apt-get upgrade

# Install samba
RUN apt-get install -y samba

# Add config/start script
COPY samba-start /usr/local/bin/samba-start

# Samba ports
EXPOSE 139/tcp 445/tcp 137/udp 138/udp

# Set the entrypoint so we can just pass a list of dirs to share
ENTRYPOINT ["/usr/local/bin/samba-start"]
