# 🚀 AWS EC2 Auto Stop – Cost Optimization System

## 📌 Overview

This project is a **serverless cloud automation system** designed to optimize AWS costs by automatically identifying and stopping idle EC2 instances.

It leverages **event-driven architecture, Infrastructure as Code, and CI/CD** to create a fully automated and production-ready solution.

---

## 🎯 Problem Statement

In many cloud environments, EC2 instances are left running unnecessarily, leading to **significant cost wastage**.

This project solves that by:

* Detecting idle EC2 instances
* Automatically stopping them
* Ensuring critical workloads are not affected (via tagging)

---

## 🏗️ Architecture

### 🔁 Workflow

1. **Event Trigger**

   * Scheduled execution every hour

2. **Lambda Execution**

   * Scans EC2 instances using Boto3

3. **Filtering Logic**

   * Stops instances only if:

     * `AutoStop = true`
     * `State = 0`

4. **Action**

   * Stops eligible running EC2 instances

5. **Monitoring**

   * Logs and custom metrics stored

---

## ⚙️ Tech Stack

* AWS EC2
* AWS Lambda
* Amazon EventBridge
* Amazon CloudWatch
* IAM (Least Privilege)
* Terraform (Infrastructure as Code)
* GitHub Actions (CI/CD)
* Python (Boto3)

---

## 📂 Project Structure

```
aws-ec2-auto-stop/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│
├── lambda/
│   ├── auto_stop.py
│   ├── requirements.txt
│
├── .github/workflows/
│   └── deploy.yml
│
├── architecture/
│   └── diagram.png
│
├── README.md
└── deployment-steps.md
```

---

## 🚀 Features

* ✅ Automated EC2 cost optimization
* ✅ Tag-based resource control
* ✅ Fully serverless architecture
* ✅ Infrastructure as Code (Terraform)
* ✅ CI/CD deployment pipeline
* ✅ Monitoring with CloudWatch
* ✅ Secure IAM role configuration

---

## 🔄 CI/CD Pipeline

The project uses **GitHub Actions** to automate:

1. Lambda packaging (dependencies + code)
2. Terraform initialization & validation
3. Infrastructure deployment
4. Lambda function provisioning

---

## 💰 Cost Optimization Impact

* Automatically shuts down idle instances
* Prevents unnecessary compute usage
* Estimated **20–40% reduction in idle EC2 costs**

---

## 🧠 Key Learnings

* Implementing event-driven serverless systems
* Managing IAM roles and permissions securely
* Debugging real-world CI/CD pipeline issues
* Handling Terraform state and deployment conflicts
* Designing scalable and automated cloud workflows

---

## ⚠️ Challenges Faced

* Terraform not detecting configuration files due to repository structure
* IAM permission errors in CI/CD pipeline
* Lambda deployment failing due to incorrect artifact ordering
* Handling existing AWS resources causing conflicts

---

## 🔮 Future Enhancements

* 📩 Slack/Email alerts for stopped instances
* 📊 Cost analytics using AWS Cost Explorer API
* 🔄 Auto-start instances based on schedule
* 📈 Advanced monitoring dashboard

---

## 🏁 Conclusion

This project demonstrates a **real-world DevOps use case**, combining cloud automation, CI/CD, and cost optimization into a scalable and production-ready system.
