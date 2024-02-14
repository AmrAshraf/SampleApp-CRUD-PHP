pipeline {
    agent any
    
    environment {
        MICROSERVICE_NAME = 'your_microservice_name'
        REPLICAS = 'your_replicas'
        IMAGE_REGISTRY = 'your_image_registry'
        TAG = 'your_tag'
        CONTAINER_PORT = 'your_container_port'
        SERVICE_PORT = 'your_service_port'
        AWS_REGION = 'your_aws_region'
        AWS_ACCOUNT_ID = 'your_aws_account_id'

        SONARQUBE_URL = 'http://your-sonarqube-server:9000'  // Update with your SonarQube server URL
        SONARQUBE_LOGIN = 'your-sonarqube-login-token'  // Generate a token in SonarQube and replace with the token

    }
    
    stages {
        stage('SonarQube Analysis for C# Core') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh "dotnet sonarscanner begin /k:${MICROSERVICE_NAME} /d:sonar.host.url=${SONARQUBE_URL} /d:sonar.login=${SONARQUBE_LOGIN}"
                        sh "dotnet build"
                        sh "dotnet sonarscanner end /d:sonar.login=${SONARQUBE_LOGIN}"
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_REGISTRY}/${MICROSERVICE_NAME}:${TAG} ."
                }
            }
        }
        
        stage('Push to AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', credentialsId: 'your_aws_credentials_id']]) {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                        sh "docker push ${IMAGE_REGISTRY}/${MICROSERVICE_NAME}:${TAG}"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh '''
                        sed -i "s|<microservice-name>|${MICROSERVICE_NAME}|g" deploy.yaml
                        sed -i "s|<replicas>|${REPLICAS}|g" deploy.yaml
                        sed -i "s|<image-registry>|${IMAGE_REGISTRY}|g" deploy.yaml
                        sed -i "s|<tag>|${TAG}|g" deploy.yaml
                        sed -i "s|<container-port>|${CONTAINER_PORT}|g" deploy.yaml
                        sed -i "s|<service-port>|${SERVICE_PORT}|g" deploy.yaml
                    '''
                    sh 'kubectl apply -f deploy.yaml'
                }
            }
        }
      post {
        always {
            // Display SonarQube results in Jenkins
            script {
                withSonarQubeEnv('SonarQube') {
                    def scannerHome = tool 'SonarQube';
                    def env = readProperties file:"${scannerHome}/conf/sonar-scanner.properties"
                    def reportDir = env['sonar.report.export.path']
                    
                    echo "SonarQube report is available at: ${reportDir}/sonar-report-task.txt"
                }
            }
        }
    }
}
