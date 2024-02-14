# Jenkins Pipeline for Microservice Deployment

This Jenkins pipeline automates the deployment process of a microservice, including building a Docker image, pushing it to AWS ECR, performing SonarQube analysis for both .NET and PHP, and finally deploying the microservice using Kubernetes.

## Prerequisites

- Jenkins installed and configured
- AWS ECR repository set up
- SonarQube server configured for the projects
- Kubernetes cluster configured and accessible

## Jenkins Pipeline Stages

### 1. Build Docker Image

This stage builds the Docker image for the microservice.

- **Agent:** Any
- **Environment Variables:**
  - `MICROSERVICE_NAME`
  - `IMAGE_REGISTRY`
  - `TAG`

### 2. Push to AWS ECR

This stage pushes the Docker image to AWS ECR.

- **Agent:** Any
- **Environment Variables:**
  - `AWS_REGION`
  - `AWS_ACCOUNT_ID`

### 3. SonarQube Analysis for .NET

This stage performs SonarQube analysis for a .NET Core project.

- **Agent:** Any
- **Environment Variables:**
  - `MICROSERVICE_NAME`
  - `SONARQUBE_URL`
  - `SONARQUBE_LOGIN`

### 4. SonarQube Analysis for PHP

This stage performs SonarQube analysis for a PHP project using Composer.

- **Agent:** Any
- **Environment Variables:**
  - `MICROSERVICE_NAME`
  - `SONARQUBE_URL`
  - `SONARQUBE_LOGIN`
  - `PHP_VERSION`

### 5. Deploy

This stage deploys the microservice to a Kubernetes cluster.

- **Agent:** Any
- **Environment Variables:**
  - `MICROSERVICE_NAME`
  - `REPLICAS`
  - `IMAGE_REGISTRY`
  - `TAG`
  - `CONTAINER_PORT`
  - `SERVICE_PORT`

### Post-build Action

- **Display SonarQube Results:**
  - Displays the SonarQube analysis results in the Jenkins console.

## How to Use

1. Configure the required environment variables in the Jenkins pipeline configuration.
2. Run the Jenkins pipeline.

---

## Setting Up Jenkins

1. Install Jenkins on your server or machine.
2. Configure Jenkins by following the official documentation: [Jenkins Installation Guide](https://www.jenkins.io/doc/book/installing/).
3. Install necessary plugins for Docker, AWS, and Kubernetes integration.

---

## Setting Up SonarQube for Code Analysis

1. Install and configure SonarQube on your server or use the SonarQube cloud service.
2. Follow the official SonarQube documentation for installation: [SonarQube Installation Guide](https://docs.sonarqube.org/latest/setup/get-started-2-minutes/).
3. Create a new project in SonarQube and generate a token for authentication.
4. Set up SonarQube for .NET by installing the SonarScanner for .NET: [SonarScanner for .NET Documentation](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-msbuild/).
5. Set up SonarQube for PHP by installing the SonarScanner for PHP: [SonarScanner for PHP Documentation](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-php/).
6. Configure your Jenkins pipeline with the SonarQube server URL and authentication token.

---

## Deployment File Explanation
Deployment Section
apiVersion: Specifies the Kubernetes API version for the resource.

kind: Defines the type of resource, in this case, a Deployment.

metadata: Contains metadata such as the name and labels for the Deployment.

spec: Describes the desired state for the Deployment, including the number of replicas and the pod template.

replicas: Specifies the desired number of replicas for the microservice.

selector: Defines how the Deployment identifies which pods to manage.

template: Defines the pod template, including labels and specifications for the containers.

containers: Contains information about the microservice container.

name: Specifies the name of the container.
image: Specifies the Docker image for the microservice.
ports: Specifies the container port to expose.
livenessProbe: Configures the liveness probe for the container.

readinessProbe: Configures the readiness probe for the container.

Service Section
kind: Defines the type of resource, in this case, a Service.

apiVersion: Specifies the Kubernetes API version for the resource.

metadata: Contains metadata such as the name for the Service.

spec: Describes the desired state for the Service.

selector: Specifies the pods that the Service should target.
ports: Specifies the ports for the Service, including the protocol, port, and target port.
This Kubernetes deployment file can be used as a reference for deploying microservices in a Kubernetes environment. Adjust the placeholders (e.g., <microservice-name>, <replicas>, etc.) with your specific values when creating your deployment files.
