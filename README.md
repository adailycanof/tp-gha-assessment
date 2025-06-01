# TP GitHub Actions Assessment

A simple Flask "Hello World" application demonstrating CI/CD pipeline implementation with GitHub Actions, Docker, and AWS ECS deployment.

## 🚀 Features

- **Simple Flask Application**: Returns "Hello, World" response
- **Automated CI/CD Pipeline**: GitHub Actions workflow for testing and deployment
- **Containerized Deployment**: Docker-based application packaging
- **AWS ECS Integration**: Automated deployment to Amazon ECS
- **Quality Assurance**: Automated testing with pytest and code linting with flake8

## 📋 Prerequisites

- Python 3.9+
- Docker
- AWS CLI configured (for deployment)
- GitHub repository with required secrets configured

## 🛠️ Local Development

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/tp-gha-assessment.git
   cd tp-gha-assessment
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -e .
   pip install pytest pytest-cov flake8  # Development dependencies
   ```

### Running the Application

**Method 1: Direct Flask run**
```bash
export FLASK_APP=hello
export FLASK_ENV=development
flask run
```

**Method 2: Using Docker**
```bash
docker build -t flask-tp-app .
docker run -p 5000:5000 flask-tp-app
```

The application will be available at `http://localhost:5000`

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=hello

# Run linting
flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
```

## 🔄 CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci-cd.yml`) includes:

### Test Stage
- **Python Setup**: Configures Python 3.9 environment
- **Dependency Installation**: Installs application and test dependencies
- **Code Linting**: Runs flake8 for code quality checks
- **Unit Testing**: Executes pytest test suite

### Deploy Stage (main branch only)
- **AWS Configuration**: Sets up AWS credentials and region
- **ECR Login**: Authenticates with Amazon Elastic Container Registry
- **Docker Build & Push**: Builds container image and pushes to ECR
- **ECS Deployment**: Updates ECS service with new image

### Triggers
- **Pull Requests**: Runs tests only
- **Push to main**: Runs tests and deploys if successful
- **Manual**: Can be triggered via workflow_dispatch

## ⚙️ Configuration

### Environment Variables
- `AWS_REGION`: eu-west-2
- `ECR_REPOSITORY`: flask-tp-app
- `ECS_SERVICE`: tp-assessment-sh-dev-service
- `ECS_CLUSTER`: tp-assessment-sh-dev-cluster

### Required GitHub Secrets
- `AWS_ACCESS_KEY_ID`: AWS access key for deployment
- `AWS_SECRET_ACCESS_KEY`: AWS secret key for deployment

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub Repo   │───▶│  GitHub Actions │───▶│   AWS ECS      │
│                 │    │                 │    │                 │
│  - Source Code  │    │  - Build & Test │    │  - Container    │
│  - Dockerfile   │    │  - Docker Build │    │  - Load Balancer│
│  - CI/CD Config │    │  - ECR Push     │    │  - Auto Scaling │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📁 Project Structure

```
tp-gha-assessment/
├── .github/workflows/ci-cd.yml  # GitHub Actions workflow
├── hello/                       # Flask application package
│   └── __init__.py              # Application factory and routes
├── Dockerfile                   # Container configuration
├── setup.py                     # Python package configuration
├── conftest.py                  # Pytest configuration
├── test_hello.py               # Unit tests
└── README.md                   # This file
```

## 🚦 API Endpoints

| Method | Endpoint | Description | Response |
|--------|----------|-------------|----------|
| GET    | `/`      | Hello World | `Hello, World` |

## 🧪 Testing

The test suite includes:
- **Unit tests** for application routes
- **Integration tests** using Flask test client
- **Code coverage** reporting
- **Linting** for code quality

Test files follow the pattern `test_*.py` and use pytest fixtures for application setup.

## 🐳 Docker

The application is containerized using a multi-stage Docker build:
- **Base**: Python 3.9 slim image
- **Dependencies**: Installed via setup.py
- **Application**: Copied and configured
- **Runtime**: Flask development server on port 5000

## ☁️ AWS Deployment

### ECS Configuration
- **Cluster**: tp-assessment-sh-dev-cluster
- **Service**: tp-assessment-sh-dev-service
- **Image**: Stored in ECR repository `flask-tp-app`
- **Deployment**: Rolling updates with zero downtime

### Security
- IAM roles and policies for ECS task execution
- VPC configuration for network isolation
- Security groups for traffic control

## 🔧 Development Workflow

1. **Feature Development**
   - Create feature branch from main
   - Develop and test locally
   - Run tests: `pytest`
   - Check code quality: `flake8`

2. **Pull Request**
   - Create PR to main branch
   - Automated tests run via GitHub Actions
   - Code review and approval

3. **Deployment**
   - Merge to main branch
   - Automated deployment to AWS ECS
   - Monitor application health

## 📊 Monitoring & Logs

- **ECS CloudWatch Logs**: Application and container logs
- **ECS Metrics**: CPU, memory, and network utilization
- **Load Balancer Health Checks**: Application availability monitoring

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🆘 Troubleshooting

### Common Issues

**Local Development**
- Ensure Python 3.9+ is installed
- Activate virtual environment before running commands
- Check that port 5000 is not in use

**CI/CD Pipeline**
- Verify GitHub secrets are correctly configured
- Check AWS credentials have necessary permissions
- Ensure ECS cluster and service names match configuration

**Docker Issues**
- Clear Docker cache: `docker system prune`
- Rebuild without cache: `docker build --no-cache`
- Check Dockerfile syntax and layer caching
