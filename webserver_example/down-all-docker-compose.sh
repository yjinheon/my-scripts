#!/bin/bash

for dir in *-docker/; do
    if [ -d "$dir" ]; then
        echo "$dir down docker-compose"
	(
	    cd "$dir" || exit
            docker-compose down
	)
	echo "done : $dir"
    fi
done
