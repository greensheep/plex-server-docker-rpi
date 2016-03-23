# Plex Server for Raspberry Pi

A simple way to run a plex media server in Docker on the Raspberry Pi 2 or 3.

NOTE: The Pi 1 is NOT supported.

## What's included

- Plex media server
- Samba server

## Usage

The easiest way to get started is to install [Hypriot OS](http://blog.hypriot.com/downloads) onto your SD card because it comes with docker & docker-compose pre-installed. It's also possible to use the [ARM version of Arch Linux](https://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2) but you'll need to install and configure these packages yourself.

Assuming Hypriot OS, boot up the Pi, identify it on your network and SSH in with the following credentials: User: `pi` / password: `raspberry`

Next, clone this repo and bring the services up using docker-compose:

    git clone https://github.com/greensheep/plex-server-docker-rpi.git
    cd plex-server-docker-rpi
    docker-compose up -d

Open the Plex web admin at `http://{ip address of Pi}:32400/web` to configure your server.

A samba share called `plex-data` is also made available. It's currently unsecured so if you don't want to use it just start the plex service:

    docker-compose up -d plex

Otherwise, connect as a guest to: `smb://{ip address of Pi}/plex-data`.

## Media

The plex server container uses docker volumes for the config and library directories. These are mapped to `/home/pi/plex/{config,data}`.

If you want to store your library on an external USB hard drive, mount your device into the `/home/pi/plex/data` directory.  For example:

    mount /dev/sda1 /home/pi/plex/data

If you already started your server, run:

    docker restart plex samba-server

## Transcoding

The Pi isn't powerful enough for transcoding but if you have media that will direct play on your client it works great! I've tested this on the Pi 2 (Hypriot) and 3 (Arch).

## Playback failures

If you experience problems with media that should direct play/stream to your client, and you mounted an external drive to `/home/pi/plex/data`, try setting the "Transcoder temporary directory" to a path on the mounted `/data` volume. For example, do:

    mkdir /home/pi/plex/data/transcoder

Then add `/data/transcoder` to `Settings -> Server -> Transcoder -> Transcoder temporary directory` in the Plex admin.
    
Why? Most of the time your SD card will be realtively small 16/32Gb and can quickly run out of space. According to [this forum post](https://forums.plex.tv/discussion/206281/there-was-a-problem-playing-this-item), the lack of available space can cause transcoder problems.

## Development

To build the images yourself, use the `docker-compose.dev.yml` file:

    docker-compose -f docker-compose.yml -f docker-compose.dev.yml build
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
