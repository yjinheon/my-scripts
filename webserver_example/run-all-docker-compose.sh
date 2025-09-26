#!/bin/bash

for dir in *-docker/; do
    if [ -d "$dir" ]; then
        echo "$dir run docker-compose"
	(
	    cd "$dir" || exit
            docker-compose up -d
	)
	echo "done : $dir"
    fi
done
