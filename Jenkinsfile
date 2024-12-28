pipeline {
    agent any
    environment {
        REPO_NAME = "satishgonella2024/aws-3-tier-app"
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: 'main', url: 'git@github.com:satishgonella2024/aws-3-tier-app-terraform-observability.git'
            }
        }
        stage('Build Backend Image') {
            steps {
                script {
                    echo "Building backend Docker image..."
                    docker.build("${env.REPO_NAME}-backend", './backend')
                }
            }
        }
        stage('Build Frontend Image') {
            steps {
                script {
                    echo "Building frontend Docker image..."
                    docker.build("${env.REPO_NAME}-frontend", './frontend')
                }
            }
        }
        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-credentials', 
                    passwordVariable: 'DOCKER_PASSWORD', 
                    usernameVariable: 'DOCKER_USERNAME'
                )]) {
                    script {
                        echo "Logging into Docker Hub..."
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            echo "Pushing backend Docker image..."
                            docker tag ${REPO_NAME}-backend:latest ${DOCKER_USERNAME}/${REPO_NAME}-backend:latest
                            docker push ${DOCKER_USERNAME}/${REPO_NAME}-backend:latest
                            
                            echo "Pushing frontend Docker image..."
                            docker tag ${REPO_NAME}-frontend:latest ${DOCKER_USERNAME}/${REPO_NAME}-frontend:latest
                            docker push ${DOCKER_USERNAME}/${REPO_NAME}-frontend:latest
                            
                            docker logout
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up Docker images...'
            sh 'docker image prune -f || true'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
