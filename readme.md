# DevOps Assignment Octabyte: CI/CD, Monitoring, and Infrastructure Setup

## Overview

This project demonstrates a complete DevOps pipeline that includes:

* Infrastructure provisioning using Terraform
* CI/CD implementation with Jenkins
* Application deployment using Docker
* Monitoring and logging using Prometheus, Grafana, Loki, and Promtail

---

## Part 1: Infrastructure as Code (Terraform)

### Resources Created

* VPC with CIDR `10.0.0.0/16`
* Public and Private Subnets
* Internet Gateway and Route Tables
* Security Groups allowing HTTP, HTTPS, SSH
* EC2 instance with user\_data script

## Part 2: CI/CD with Jenkins

### Features

* Jenkins installed via system package in user\_data
* Pipeline triggered on GitHub push to `develop` branch
* Stages:

  * Checkout code
  * Run sample test cases
  * Run Trivy security scan
  * Build and push Docker image to Docker Hub
  * Deploy to staging (port 8081)
  * Manual approval step for production deployment
  * Deploy to production (port 80)

### Credentials Required

* Docker Hub credentials stored in Jenkins credentials as `dockerhub-creds`

---

## Part 3: Monitoring & Logging

### Tools

* **Prometheus**: Collects metrics from Node Exporter and Docker containers
* **Grafana**: Dashboards for visualizing metrics and logs
* **Loki**: Log aggregation
* **Promtail**: Forwards logs to Loki
* **Node Exporter**: Exposes system metrics

### Security Considerations

* Used security groups to limit access (currently open for demo)
* Jenkins credentials stored securely
* Trivy used to scan for vulnerabilities

### Cost Optimization

* Used `t2.micro` instance under AWS free tier
* Only one EC2 instance used for Jenkins + monitoring stack
* Only essential ports opened to reduce potential misuse

### Secret Management

* Jenkins credentials managed using Jenkins credential store

### Backup Strategy

* Backup plan: EBS volume snapshot (manual or scheduled)
* Jenkins job configurations can be backed up by copying `/var/lib/jenkins`

---

## Problems Faced & How I Resolved Them

### 1. Jenkins Setup Confusion

**Problem:** Initially Jenkins was planned in Docker but later found managing volumes and Docker-in-Docker complex.
**Resolution:** Installed Jenkins as a system service for better stability.

### 2. Port Conflicts

**Problem:** Multiple services (Grafana, App, Prometheus) running on same EC2 caused port conflicts.
**Resolution:** Manually configured Docker ports and EC2 security group to isolate them.

### 3. Promtail Not Forwarding Logs

**Problem:** Logs not visible in Grafana.
**Resolution:** Fixed `promtail.yml` to scrape correct log paths. Verified container logs manually.

### 5. Grafana Dashboard Blank

**Problem:** No data displayed after Grafana setup.
**Resolution:** Added Prometheus as data source manually. Confirmed scrape targets were active in Prometheus.


