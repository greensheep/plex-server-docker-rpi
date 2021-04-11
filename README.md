[![Build Status](https://travis-ci.org/greensheep/plex-server-docker-rpi.svg?branch=master)](https://travis-ci.org/greensheep/plex-server-docker-rpi)

Docker images: https://hub.docker.com/r/greensheep/plex-server-docker-rpi/tags

# Plex Server for Raspberry Pi

A simple way to run a plex media server in Docker on the Raspberry Pi.

**NOTE: The Pi 1 is NOT supported.**

## Usage

Install docker on your raspberry pi. There are numerous ways to do this but the easiest is to run:

```sh
curl -sSL https://get.docker.com | sh
```

_Source: https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi_

Next, you'll need to create three local folders for the plex config, data and transcode volumes (I have all of these on an external HDD because they get very large). For example:

```sh
mkdir -p ~/media/plex/{config,data,transcode}
```

Using the above folders, run the following to start plex:

```sh
docker run \
  -d \
  --rm \
  --name plex \
  --net host \
  --restart always \
  --volume $(echo $HOME)/media/plex/config:/config \
  --volume $(echo $HOME)/media/plex/data:/data \
  --volume $(echo $HOME)/media/plex/transcode:/transcode \
  greensheep/plex-server-docker-rpi:latest
```

After around 30 seconds, the Plex web admin should be available at `http://{ip address of Pi}:32400/web`.

## NFS Shares

If you have permission issues using NFS shares as the mounted volumes, set the `SET_PLEX_UID` and `SET_PLEX_GID` environment variables to the user/group id of the owner of those directories.

### To find the uid/gid:

```
# show user/group owner of a directory
ls -n ~/media/plex/config

# outputs something like this:
# drwxr-xr-x 20 1001  1001  4096 Apr  9 19:00 config
#               ^ uid ^ gid
```

### Updated `docker run`:

```sh
docker run \
  -d \
  --rm \
  --name plex \
  --net host \
  --restart always \
  -e SET_PLEX_UID=1001 \
  -e SET_PLEX_GID=1001 \
  --volume $(echo $HOME)/media/plex/config:/config \
  --volume $(echo $HOME)/media/plex/data:/data \
  --volume $(echo $HOME)/media/plex/transcode:/transcode \
  greensheep/plex-server-docker-rpi:latest
```

## Updating

Plex cannot be updated via the web ui. Run the following to download and run a new version:

```sh
docker pull greensheep/plex-server-docker-rpi:latest
docker stop plex
docker rm -f plex
# `docker run ...` command from above!
```

## Transcoding

The Pi isn't powerful enough for transcoding but if you have media that will direct play on your client it works great! I've tested this on the Pi 2 (Hypriot) and 3 (Arch) and 4 (ubuntu).

Be sure to set the "Transcoder temporary directory" setting to `/transcode` in the Plex -> Transcoder settings UI.

## Development

To build the images yourself clone this repository and run the following:

```sh
sudo docker build -t plex-dev:latest .
```
