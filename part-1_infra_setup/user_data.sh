#!/bin/bash

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install Git
yum install -y git

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y java-11-openjdk jenkins
systemctl start jenkins
systemctl enable jenkins

# Pull and run sample app containers
docker pull sumanthgunti/sample-app:latest
docker run -d -p 80:80 --name prod-app sumanthgunti/sample-app:latest
docker run -d -p 8081:80 --name staging-app sumanthgunti/sample-app:latest

# Install Trivy for image scanning
rpm -ivh https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.49.1_Linux-64bit.rpm

# Create folders for monitoring configs
mkdir -p /opt/monitoring

# Run Prometheus
docker run -d --name=prometheus -p 9090:9090 \
  -v /opt/monitoring/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

# Run Node Exporter
docker run -d --name=node-exporter -p 9100:9100 prom/node-exporter

# Run Grafana
docker run -d --name=grafana -p 3000:3000 grafana/grafana

# Run Loki
docker run -d --name=loki -p 3100:3100 \
  -v /opt/monitoring/loki-config.yml:/etc/loki/loki.yml \
  grafana/loki

# Run Promtail
docker run -d --name=promtail \
  -v /var/log:/var/log \
  -v /opt/monitoring/promtail-config.yml:/etc/promtail/promtail.yml \
  grafana/promtail