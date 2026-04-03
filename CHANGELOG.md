# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- [ ] Phase 5: Develop Python Lambda function for visitor count logic.
- [ ] Phase 6: Provision API Gateway and configure CORS.
- [ ] Phase 7: Automate backend deployment via GitHub Actions.

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