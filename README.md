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
* **DNS & SSL:** AWS CloudFront Default Certificate (HTTPS) / *Route 53 + ACM (Planned Upgrade)*

**Backend Architecture:**
* **Compute:** AWS Lambda (Python 3.12)
* **API Routing:** Amazon API Gateway (HTTP API)
* **Database:** Amazon DynamoDB (NoSQL)

## 📂 Repository Structure (Monorepo)
```text
.
├── frontend/             # HTML, CSS, and Vanilla JavaScript
├── backend/              # Python application code (AWS Lambda)
├── terraform/            # Infrastructure as Code (.tf files)
├── .github/workflows/    # CI/CD automation (GitHub Actions)
└── README.md
```

## 🚀 Development Roadmap
- [x] Initialize project skeleton and document architecture.
- [x] Write Terraform code for secure S3 bucket and CloudFront distribution.
- [x] Build and deploy static HTML/CSS frontend.
- [x] Implement GitHub Actions for automated frontend S3 synchronization.
- [ ] Write Terraform code for DynamoDB table.
- [ ] Develop Python Lambda function to interact with database.
- [ ] Provision API Gateway and configure CORS.
- [ ] Connect frontend JavaScript to backend API.
- [ ] Implement GitHub Actions for automated Terraform deployment.
- [ ] Configure custom domain (Route 53) and HTTPS (ACM). *(Planned Upgrade)*

## 🛠️ How to Deploy (Local Development)
1. **Infrastructure:** Navigate to `/terraform`, run `terraform init` and `terraform apply`.
2. **Frontend:** Changes pushed to the `main` branch automatically sync to S3 via GitHub Actions.
3. **Backend:** Current logic is handled via Python 3.12 in the `/backend` directory.