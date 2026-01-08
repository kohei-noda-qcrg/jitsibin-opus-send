#!/bin/bash

set -eu

WAVE=6
VOLUME=0.2
BITRATE=64000
HOST=127.0.0.1
PORT=5000

gst-launch-1.0 -v audiotestsrc is-live=true volume=$VOLUME wave=$WAVE \
    ! audioconvert \
    ! audioresample \
    ! opusenc bitrate=$BITRATE \
    ! rtpopuspay pt=96 \
    ! udpsink host=$HOST port=$PORT
