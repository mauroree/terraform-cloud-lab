#!/bin/bash

apt-get update -y

apt-get install -y docker.io

systemctl start docker
systemctl enable docker

usermod -aG docker ubuntu

docker pull mrxjr/formulario-web:latest

docker rm -f formulario || true

docker run -d \
  -p 80:80 \
  --name formulario \
  mrxjr/formulario-web:latest

