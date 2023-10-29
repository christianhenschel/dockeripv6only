#!/bin/sh
for dir in ./*/
do
    dir=${dir%*/}
    cd "${dir##*/}"
    docker compose pull
    docker compose up -d
    cd ..
done