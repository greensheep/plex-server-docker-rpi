# Plex Server for Raspberry Pi

A simple way to run a plex media server in Docker on the Raspberry Pi.

## What's included

- Plex media server
- Samba server

## Usage

Install [Hypriot OS](http://blog.hypriot.com/downloads) onto your SD card and boot up the Pi.  Identify the Pi on your network and SSH in with the following credentials: User: `pi` / password: `raspberry`

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

The pi (including the pi 2) isn't powerful enough for transcoding but if you have media that will direct play on your client it works great! I've only tested this on the pi 2.

## Development

To build the images yourself, use the `docker-compose.dev.yml` file:

    docker-compose -f docker-compose.yml -f docker-compose.dev.yml build
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
