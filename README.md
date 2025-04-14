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

🐳 Running the App Locally
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

Running on Docker
```bash
docker build -t simple-time-service .
docker run -p 5000:5000 simple-time-service
```
Visit http://localhost:5000 in your browser to test it!
