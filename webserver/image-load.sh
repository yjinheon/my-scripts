for img in images/*; do
    docker load -i "$img"
done
