#!/bin/bash

set -eu

SERVER=${SERVER:-meet.jit.si}
ROOM=${ROOM:-jitsibin-opus-send}
DIRECT=${DIRECT:-false}
## DIRECT
WAVE=${WAVE:-6}
VOLUME=${VOLUME:-0.2}
## INDIRECT
PORT=${PORT:-5000}
LATENCY=${LATENCY:-150}

if ${DIRECT}; then
    gst-launch-1.0 jitsibin name=room server=$SERVER room=$ROOM audiotestsrc is-live=true volume=$VOLUME wave=$WAVE \
        ! audioconvert \
        ! opusenc \
        ! room.audio_sink
else
    gst-launch-1.0 jitsibin name=room server=$SERVER room=$ROOM udpsrc port=$PORT caps="application/x-rtp,media=audio,encoding-name=OPUS,payload=96" \
        ! rtpjitterbuffer latency=$LATENCY drop-on-latency=true \
        ! rtpopusdepay \
        ! room.audio_sink
fi
