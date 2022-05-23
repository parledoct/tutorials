#!/bin/bash

# Use buildkit to build images in parallel where possible
export DOCKER_BUILDKIT=1

# Build base image
docker build --target tutorials-base \
    --tag parledoct/tutorials:base .

# Build downstream images
IMAGES="audio-conversion voice-activity-detection speaker-diarisation"

for IMAGE in $IMAGES;
do
    docker build --target $IMAGE --cache-from=parledoct/tutorials:base --tag parledoct/tutorials:$IMAGE .
done

for IMAGE in $IMAGES;
do
    docker push parledoct/tutorials:$IMAGE
done
