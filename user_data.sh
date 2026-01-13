#!/bin/bash

# Atualiza sistema
apt-get update -y

# Instala Docker
apt-get install -y docker.io

# Sobe Docker
systemctl start docker
systemctl enable docker

# Cria rede Docker
docker network create app-network

# Backend
docker run -d \
  --name backend-api \
  --network app-network \
  mrxjr/backend-api:latest

# Frontend
docker run -d \
  --name frontend-nginx \
  --network app-network \
  -p 80:80 \
  mrxjr/frontend-nginx:latest
