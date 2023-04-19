#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

echo -e "${BL}Info:${NC} Running MySql with version: ${GR}$INPUT_VERSION${NC}"
docker run \
  -d \
  --platform linux/amd64 \
  --network=bridge \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD="$INPUT_ROOT_PASSWORD" \
  -e MYSQL_USER="$INPUT_USER" \
  -e MYSQL_PASSWORD="$INPUT_PASSWORD" \
  -e MYSQL_DATABASE="$INPUT_DB_NAME" \
  -d mysql:"$INPUT_VERSION"

containerIp=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql)

echo -e "${BL}Info:${NC} Wait for MySql to be up and receiving requests..."
docker exec mysql bash -c "for i in seq 1 10; do mysqladmin ping -u root -p$INPUT_ROOT_PASSWORD -h$containerIp --connect_timeout 2 && s=0 && break || s=$? && sleep 5; done; (exit $s)"
MYSQL_LIVENESS_EXIT_CODE=$?

if [ "$MYSQL_LIVENESS_EXIT_CODE" != "0" ]; then
  echo "::error::MySql liveness failed with exit code: $MYSQL_LIVENESS_EXIT_CODE"
  exit $MYSQL_LIVENESS_EXIT_CODE
fi

echo -e "${BL}Info:${NC} Set MySql container ip to: $containerIp"
echo "container-ip=$containerIp" >> "$GITHUB_OUTPUT"
