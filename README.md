# 🚀 Automated Kubernetes Deployment: Hello World Web Application

## 📘 Project Overview

This project shows how to **automatically deploy a simple web application** to a Kubernetes cluster using modern DevOps practices.

**Key points:**

- Infrastructure is created automatically using **Terraform**.
- Application is packaged in **Docker containers** and scanned for security issues.
- Kubernetes deployment is managed with **Helm charts**.
- **Jenkins pipeline** automates the build, push, and deployment process.
- **Prometheus and Grafana** are installed for monitoring and metrics.
- Application is publicly accessible using **Ingress** and Grafana using **Load Balancer**.
- Everything is automated, so any change pushed to GitHub triggers a new build and deployment.

---

## 🧰 Tools & Technologies

| Purpose                | Tools / Services                             |
|------------------------|---------------------------------------------|
| Infrastructure         | Terraform                                   |
| CI/CD                  | Jenkins                                     |
| Containers             | Docker                                      |
| Kubernetes             | Amazon EKS                                  |
| Deployment Management  | Helm                                        |
| Monitoring             | Prometheus, Grafana                         |
| Cloud                  | AWS (EKS, ECR, EC2, IAM, VPC, ALB)         |
| Security               | Docker image scanning (Trivy)               |
| Version Control        | GitHub                                      |

---

## ⚙️ Infrastructure

**Terraform** creates all AWS resources, including:

- Network (VPC, subnets, gateways)  
- Security groups and IAM roles  
- EKS cluster with worker nodes  
- EC2 instance for Jenkins  

---

## 🐳 Docker & Security

- The application is packaged into a **Docker container**.  
- Docker images are **scanned for vulnerabilities** before deployment.  
- Images are stored in **AWS ECR** and used by Kubernetes to run the application.

---

## ☸️ Kubernetes Deployment with Helm

- **Helm charts** are used to manage Kubernetes deployments.  
- Helm charts include:  
  - Deployments and replicas  
  - Services for internal and external access  
  - Ingress for public access  
- Kubernetes is configured so pods always pull the **latest image**.

---

## 🔄 CI/CD Pipeline

The **Jenkins pipeline** is fully automated and runs on every change to the main branch.  

**Pipeline steps:**

- Pull code from GitHub  
- Build Docker image and scan for vulnerabilities  
- Push image to ECR  
- Update Helm chart with new image  
- Deploy application to EKS using Helm  
- Deploy Prometheus and Grafana for monitoring  
- Verify that the application is running  

This ensures a **reliable, repeatable, and secure deployment process**.

---

## 📊 Monitoring

- **Prometheus** collects metrics from Kubernetes and the application.  
- **Grafana** displays dashboards for real-time monitoring.  
- Monitoring stack is available externally through **AWS Load Balancer**.

---

## 🔒 Security & Best Practices

- Docker images are scanned before deployment.  
- Helm charts make deployments **repeatable and easy to manage**.  
- **imagePullPolicy** ensures pods always use the latest Docker image.  
- Kubernetes best practices are followed for **scalability, observability, and security**.

---

## 📌 Submission

- **GitHub Repository:** [https://github.com/mdshaik-aws/HRGFSA_Task-KSA](https://github.com/mdshaik-aws/HRGFSA_Task-KSA)
