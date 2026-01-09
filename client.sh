#!/bin/bash

set -eu

WAVE=${WAVE:-6}
VOLUME=${VOLUME:-0.2}
BITRATE=${BITRATE:-64000}
HOST=${HOST:-127.0.0.1}
PORT=${PORT:-5000}
DEVICE=${DEVICE:-}

if [ "${DEVICE:-}" == "" ]; then
    gst-launch-1.0 -v audiotestsrc is-live=true volume=$VOLUME wave=$WAVE \
        ! audioconvert \
        ! audioresample \
        ! opusenc bitrate=$BITRATE \
        ! rtpopuspay pt=96 \
        ! udpsink host=$HOST port=$PORT
else
    gst-launch-1.0 -v pulsesrc device="$DEVICE" \
        ! audioconvert \
        ! audioresample \
        ! opusenc bitrate=$BITRATE \
        ! rtpopuspay pt=96 \
        ! udpsink host=$HOST port=$PORT
fi
