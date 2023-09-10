cd /opt/images
tar -cC 'artipie' . | docker load

cat <<EOF > /opt/deploy/docker-compose.yaml
version: "3.3"
services:
  artipie:
    image: artipie/artipie:latest
    container_name: artipie
    restart: unless-stopped
    environment:
      - ARTIPIE_USER_NAME=artipie
      - ARTIPIE_USER_PASS=artipie
    networks:
      - artipie-net
    ports:
      - "8081:8080"
      - "8086:8086"
  front:
    image: artipie/front:latest
    container_name: front
    restart: unless-stopped
    networks:
      - artipie-net
    environment:
      - ARTIPIE_REST=http://artipie:8086
    ports:
      - "8080:8080"

networks:
  artipie-net:
    driver: bridge
EOF