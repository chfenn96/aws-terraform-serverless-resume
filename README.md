# AWS Serverless Cloud Resume (Infrastructure as Code)

[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)](https://www.python.org/)
[![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)

## 📌 Project Overview
This repository contains my implementation of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/). It is a full-stack, serverless web application hosted on AWS. 

To demonstrate modern DevOps and Cloud Engineering practices, **100% of the cloud infrastructure is provisioned using Terraform** and deployments are fully automated via **GitHub Actions**.

## 🏗️ Architecture Design
*(Note: A formal architectural diagram will be added here upon project completion).*

**Frontend Architecture:**
* **Storage:** AWS S3 (Static Website Hosting)
* **CDN & Security:** AWS CloudFront with Origin Access Control (OAC)
* **DNS & SSL:** AWS Route 53 and AWS Certificate Manager (ACM)

**Backend Architecture:**
* **Compute:** AWS Lambda (Python 3.x)
* **API Routing:** Amazon API Gateway (HTTP API)
* **Database:** Amazon DynamoDB (NoSQL)

## 📂 Repository Structure (Monorepo)
This project follows a monorepo structure to keep the full system architecture in a single, easily navigable location.

```text
.
├── frontend/             # HTML, CSS, and Vanilla JavaScript
├── backend/              # Python application code for AWS Lambda
├── infrastructure/       # Terraform files (.tf) for all AWS resources
├── .github/workflows/    # CI/CD automation pipelines
└── README.md
```

## 🚀 Development Roadmap
- [x] Initialize project skeleton and document architecture.
- [ ] Write Terraform code for secure S3 bucket and CloudFront distribution.
- [ ] Configure custom domain (Route 53) and HTTPS (ACM).
- [ ] Build and deploy static HTML/CSS frontend.
- [ ] Write Terraform code for DynamoDB table.
- [ ] Develop Python Lambda function to interact with database.
- [ ] Provision API Gateway and configure CORS.
- [ ] Connect frontend JavaScript to backend API.
- [ ] Implement GitHub Actions for automated Terraform deployment.
- [ ] Implement GitHub Actions for automated frontend S3 synchronization.

## 🛠️ How to Deploy (Local Development)
*Deployment instructions and infrastructure variables will be documented here once the CI/CD pipeline is finalized.*