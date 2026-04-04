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
├── CHANGELOG.md    
└── README.md
```

## 🚀 Development Roadmap

#### **🟢 COMPLETED**
- [x] **Phase 1:** Project Foundation (S3, CloudFront, Terraform Setup).
- [x] **Phase 2:** Frontend Infrastructure (OAC, S3, CloudFront).
- [x] **Phase 3:** Frontend Code & Basic CI/CD (HTML/CSS/JS + GitHub Actions).
- [x] **Phase 4:** Database Infrastructure (DynamoDB + Seeding).
- [x] **Phase 5:** Backend Logic (Python Lambda + API Gateway).
- [x] **Phase 6:** Frontend-Backend Integration.
- [x] **Phase 7:** Infrastructure Hardening.
- [x] **Phase 8:** Backend CI/CD & Testing.

#### **🟠 CURRENT FOCUS: DevOps Maturity & Polishing**
- [ ] **Phase 9: Final Polish**
    *   Custom Domain setup (Route 53 + ACM).
    *   Create a professional Architecture Diagram for the README.
    *   Finalize `CHANGELOG.md` for v2.0.0 (Full Release).

## 🛠️ How to Deploy

This project uses a **GitOps** workflow. Manual deployments from local machines are discouraged to ensure infrastructure consistency.

### 1. Prerequisites
* **AWS Account** with a configured IAM OIDC Provider.
* **GitHub Repository Secrets**:
    * `AWS_OIDC_ROLE_ARN`: The ARN of the IAM role for GitHub to assume.
    * `S3_BUCKET_NAME`: The name of the frontend assets bucket.
    * `CLOUDFRONT_DISTRIBUTION_ID`: For automated cache invalidations.

### 2. The Deployment Pipeline
Infrastructure and code changes are managed through a three-stage **Fail-Fast** pipeline:
1. **Linting:** Static analysis of Python (`flake8`, `black`) and Terraform (`tflint`).
2. **Testing:** Unit tests via `pytest` with 100% logic coverage using `moto` for AWS mocking.
3. **Deployment:** If tests pass, Terraform automatically initializes, plans, and applies changes to the AWS environment using OIDC secretless authentication.

### 3. Local Development (Optional)
If you must run the project locally for testing:
```bash
# Initialize Terraform with the Remote S3 Backend
cd terraform
terraform init

# Run Python Tests
cd ../backend
pip install -r requirements.txt
pytest
```