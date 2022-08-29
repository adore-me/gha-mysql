#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

echo -e "${BL}Info:${NC} Running MySql with version: ${GR}$INPUT_VERSION${NC}"
docker run \
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
docker run \
  --platform linux/amd64 \
  --network=bridge \
  mysql:"$INPUT_VERSION" \
  "sh" "-c" "for i in seq 1 10; do mysqladmin ping -u root -p$INPUT_ROOT_PASSWORD -h$containerIp --connect_timeout 2 && s=0 && break || s=$? && sleep 5; done; (exit $s)"

echo "${BL}Info:${NC} Set MySql container ip to: $containerIp"
echo "::set-output name=container-ip::$containerIp"