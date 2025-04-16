# SimpleTimeService
This project was built as part of the DevOps Challenge to demonstrate DevOps skills using Infrastructure as Code (Terraform), containerization (Docker), cloud (AWS), and CI/CD (GitHub Actions).

## 🧠 Project Overview

This repository contains:
- A **minimal Python Flask app** that returns a JSON response with the current timestamp and visitor IP.
- A **Dockerfile** that builds the application and runs it as a non-root user.

## 📁 Repository Structure

```aiignore
├── app/
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
└── README.md
└── .gitignore
```

## 🚀 Application Details

- **Endpoint**: `/`
- **Response format**:
```json
{"timestamp": "2025-04-14T10:22:33.123Z","ip": "203.0.113.1"}
```

🏠Running the App Locally
```bash
cd app/
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python main.py
```

You should now see output like:
```aiignore
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```
Visit http://localhost:5000 in your browser to test it!

🐳Running on Docker
```bash
docker build -t simple-time-service .
docker run -p 5000:5000 simple-time-service
```
Visit http://localhost:5000 in your browser to test it!

## 🐳 Pushing Docker image to DockerHub

```bash
docker login
docker tag simple-time-service:latest dhruvusername/simpletimeservice:latest
docker push dhruvbundheliya/simpletimeservice:latest
```
## 📦 Terraform Infrastructure

This repository provisions infrastructure for a minimalist Flask app called SimpleTimeService using Terraform with remote state management. It follows a clear modular structure and supports multiple environments (e.g., dev, stage, prod) via .tfvars.

```aiignore
terraform/
├── vpc/                   # VPC creation (public/private subnets, NAT, etc.)
│   ├── tfvars/
│   │   └── dev.tfvars     # Dev environment-specific input values
│   ├── main.tf            # Module config for VPC
│   ├── outputs.tf
│   ├── provider.tf
│   └── variables.tf
├── loadbalancer/          # Application Load Balancer & Security Groups
│   ├── tfvars/
│   │   └── dev.tfvars
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── variables.tf
├── ecs/                   # ECS Cluster, Task Definition, Service
│   ├── tfvars/
│   │   └── dev.tfvars
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── variables.tf
├── simpletimeservice.hcl  # CLI config for remote backend initialization
```

## ☁️ Remote Backend Configuration

Your state is stored in Amazon S3 and locked in DynamoDB using the .hcl file

✅ simpletimeservice.hcl
```aiignore
bucket = ""
region = ""
dynamodb_table = ""
```

Make sure you provide the Bucket and Region values.

## 🚀 Deployment Flow (in order)

### 🧱 1. Deploy VPC

```aiignore
cd terraform/vpc
terraform init -backend-config=../../simpletimeservice.hcl
terraform plan -var-file=tfvars/dev.tfvars
terraform apply -var-file=tfvars/dev.tfvars
```

### 🌐 2. Deploy Load Balancer (reads VPC remote state)

Update main.tf in loadbalancer/ to read remote state:

```aiignore
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = ""
    key    = ""
    region = ""
  }
}
```
Then deploy:
```aiignore
cd terraform/loadbalancer
terraform init -backend-config=../../simpletimeservice.hcl
terraform plan -var-file=tfvars/dev.tfvars
terraform apply -var-file=tfvars/dev.tfvars
```

### ⚙️ 3. Deploy ECS Cluster, Service & Task Definition

Update main.tf in ecs/ to reference both:

```aiignore
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket               = ""
    key                  = "vpc/vpc.tfstate"
    region               = ""
  }
}

data "terraform_remote_state" "aws_security_group" {
  backend = "s3"
  config = {
    bucket               = ""
    key                  = "alb/alb.tfstate"
    region               = ""
  }
}
```
Then deploy:
```aiignore
cd terraform/ecs
terraform init -backend-config=../../simpletimeservice.hcl
terraform plan -var-file=tfvars/dev.tfvars
terraform apply -var-file=tfvars/dev.tfvars
```

### 🎯 Environment Support

Each module reads variables from tfvars/dev.tfvars. To support multiple environments, simply duplicate and rename the .tfvars files:

```aiignore
terraform/vpc/tfvars/stage.tfvars
terraform/loadbalancer/tfvars/prod.tfvars
terraform/ecs/tfvars/stage.tfvars
```