# Plex Server for Raspberry Pi

A simple way to run a plex media server in Docker on the Raspberry Pi.

**NOTE: The Pi 1 is NOT supported.**

## Usage

Install docker on your raspberry pi. There are numerous ways to do this but the easiest is to run:

    curl -sSL https://get.docker.com | sh

_Source: https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi_

Next, you'll need to create two local folders for the plex config and data volumes (I have both of these on an external HDD because they get very large). For example:

    mkdir -p ~/media/plex/{config,data}

Using the above folders, run the following to start plex:

    docker run \
      -d \
      --name plex \
      --net host \
      -p 32400:32400 \
      --restart always \
      --volume $(echo $HOME)/media/plex/config:/config \
      --volume $(echo $HOME)/media/plex/data:/data \
      greensheep/plex-server-docker-rpi:latest

After around 30 seconds, the Plex web admin should be available at `http://{ip address of Pi}:32400/web`.

## Updating

Plex cannot be updated via the web ui. Run the following to download and run a new version:

    docker pull greensheep/plex-server-docker-rpi:latest
    docker stop plex
    docker rm -f plex
    # `docker run ...` command from above!

## Transcoding

The Pi isn't powerful enough for transcoding but if you have media that will direct play on your client it works great! I've tested this on the Pi 2 (Hypriot) and 3 (Arch).

## Playback failures

If you experience problems with media that should direct play/stream to your client, and you mounted an external drive for your media, try setting the "Transcoder temporary directory" to a path on the mounted `/data` volume. For example, do:

    mkdir {PATH TO DATA DIR}/transcode

Then add `/data/transcode` to `Settings -> Server -> Transcoder -> Transcoder temporary directory` in the Plex admin.

Why? Most of the time your SD card will be realtively small (16/32/64Gb, etc) and can quickly run out of space. According to [this forum post](https://forums.plex.tv/discussion/206281/there-was-a-problem-playing-this-item), the lack of available space can cause transcoder problems.

## Development

To build the images yourself, use the `docker-compose.yml` file:

    docker-compose build
    docker-compose up
