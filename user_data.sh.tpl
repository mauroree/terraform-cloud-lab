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
mkdir -p /var/log/backend

docker run -d \
  --name backend-api \
  --network app-network \
  -e AWS_REGION=us-east-2 \
  -e DYNAMODB_TABLE=users \
  mrxjr/backend-api:latest \
  >> /var/log/backend/backend.log 2>&1

# Frontend
docker run -d \
  --name frontend-nginx \
  --network app-network \
  -p 80:80 \
  mrxjr/frontend-nginx:latest

# Instalar CloudWatch Agent
curl -o /tmp/amazon-cloudwatch-agent.deb \
  https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

dpkg -i /tmp/amazon-cloudwatch-agent.deb

cat << 'EOF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/cloud-init.log",
            "log_group_name": "/ec2/cloud-init-${environment}",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/ec2/syslog-${environment}",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          },
          {
           "file_path": "/var/log/backend/backend.log",
           "log_group_name": "/ec2/app-${environment}",
           "log_stream_name": "{instance_id}",
           "timezone": "UTC"
          }
        ]
      }
    }
  }
}
EOF

# Iniciar CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s
