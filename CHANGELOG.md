# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- [ ] Phase 7: Automate backend deployment via GitHub Actions.
- [ ] Phase 8: Backend CI/CD & Testing.
- [ ] Phase 9: Final Polish.

## [1.5.0] - 2026-04-04
### Added
- **OIDC Identity Federation:** Provisioned IAM OIDC Provider and Role for GitHub Actions to enable secretless AWS authentication.
- **Remote Terraform Backend:** S3 bucket for encrypted state storage and DynamoDB for state locking to prevent concurrent deployment conflicts.
- **API Throttling:** Implemented Rate Limiting (10 RPS) on API Gateway to prevent cost abuse and DDoS vectors.
- **Enhanced Outputs:** Refactored `outputs.tf` with technical descriptions for Frontend, Backend, and Security resources.

### Changed
- **CI/CD Security:** Migrated GitHub Actions from long-lived IAM Access Keys to temporary, short-lived OIDC tokens.
- **Infrastructure Source of Truth:** Successfully migrated `terraform.tfstate` from local storage to the AWS S3 remote backend.
- **Variable Injection:** Centralized GitHub repository naming and AWS regions within `variables.tf`.

### Security
- Eliminated long-lived credentials in GitHub Secrets to reduce the attack surface.
- Enabled S3 Bucket Versioning on the state bucket for point-in-time infrastructure recovery.

## [1.4.0] - 2026-04-04
### Added
- Python Lambda function for atomic visitor increments in DynamoDB.
- API Gateway (HTTP API) with CORS and Rate Limiting.
- Integrated frontend JavaScript with live backend API endpoint.

### Fixed
- Resolved CORS issues between S3-hosted frontend and API Gateway.

## [1.3.0] - 2026-04-03
### Added
- Python Lambda function (`app.py`) featuring an atomic counter for DynamoDB.
- Infrastructure as Code for Lambda execution (IAM Roles, Policies, and Function).
- Provisioned Amazon API Gateway (HTTP API) with CORS configuration.
- Lambda-to-API Gateway integration and execution permissions.
- Terraform output for API Gateway Invoke URL.

### Changed
- Refactored `main.tf` to include Backend and API Gateway infrastructure.

## [1.2.0] - 2026-04-03
### Added
- Provisioned DynamoDB table `VisitorCount` using Terraform with `PAY_PER_REQUEST` billing.
- Implemented database seeding using `aws_dynamodb_table_item` to initialize the `visitors` record at count `0`.
- Added `dynamodb_table_name` variable to `variables.tf` and output to `outputs.tf` for backend integration.

## [1.1.0] - 2026-04-03
### Added
- Created `frontend/` directory with semantic HTML, CSS styling, and basic JavaScript.
- Implemented GitHub Actions workflow (`frontend.yml`) for continuous deployment to AWS S3.
- Added CloudFront cache invalidation step to GitHub Actions to ensure immediate propagation of edge location updates.

### Changed
- Modularized Terraform structure by splitting configuration into `main.tf`, `variables.tf`, and `outputs.tf`.
- Replaced hardcoded S3 bucket names and region strings with Terraform variables.

### Fixed
- Resolved Node.js 20 deprecation warnings in the GitHub Actions runner by enabling the Node 24 opt-in environment flag.
- Fixed `.gitignore` spelling typo that was preventing files from being ignored.
- Purged untracked local cache files (`.terraform/` and `.tfstate`) from the Git tree.

## [1.0.0] - 2026-04-02
### Added
- Initialized local project repository on secondary drive and linked to remote GitHub repository.
- Configured AWS CLI with an IAM Administrator user to ensure least-privilege root account safety.
- Created infrastructure codebase using Terraform to provision a private S3 bucket and a CloudFront distribution with Origin Access Control (OAC) for secure asset delivery.