This project is a serverless cloud automation system designed to optimize AWS costs by automatically identifying and stopping idle EC2 instances.

It leverages event-driven architecture, Infrastructure as Code, and CI/CD to create a fully automated and production-ready solution.


Problem Statement

In many cloud environments, EC2 instances are left running unnecessarily, leading to significant cost wastage.

This project solves that by:

* Detecting idle EC2 instances
* Automatically stopping them
* Ensuring critical workloads are not affected (via tagging)


CI/CD Pipeline

The project uses GitHub Actions to automate:

1. Lambda packaging (dependencies + code)
2. Terraform initialization & validation
3. Infrastructure deployment
4. Lambda function provisioning


This project demonstrates a real-world DevOps use case, combining cloud automation, CI/CD, and cost optimization into a scalable and production-ready system.
