#!/bin/bash

# Colors
RD='\033[0;31m'
GR='\033[0;32m'
YL='\033[0;33m'
BL='\033[0;34m'
NC='\033[0m'

echo -e "${BL}INFO:${NC} Running MySql with version: ${GR}$INPUT_VERSION${NC}"
docker run \
  --platform linux/amd64 \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD="$INPUT_ROOT_PASSWORD" \
  -e MYSQL_USER="$INPUT_USER" \
  -e MYSQL_PASSWORD="$INPUT_PASSWORD" \
  -e MYSQL_DATABASE="$INPUT_DB_NAME" \
  -d mysql:"$INPUT_VERSION"