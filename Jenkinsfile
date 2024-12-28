pipeline {
    agent any
    environment {
        REPO_NAME_GITHUB = "satishgonella2024/aws-3-tier-app" // For GitHub
        REPO_NAME_DOCKER_BACKEND = "satish2024/aws-3-tier-app-backend" // Docker Hub backend repo
        REPO_NAME_DOCKER_FRONTEND = "satish2024/aws-3-tier-app-frontend" // Docker Hub frontend repo
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: 'main', url: "git@github.com:${REPO_NAME_GITHUB}.git"
            }
        }
        stage('Build Backend Image') {
            steps {
                script {
                    echo "Building backend Docker image..."
                    docker.build("${env.REPO_NAME_DOCKER_BACKEND}", './backend')
                }
            }
        }
        stage('Build Frontend Image') {
            steps {
                script {
                    echo "Building frontend Docker image..."
                    docker.build("${env.REPO_NAME_DOCKER_FRONTEND}", './frontend')
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
                            docker tag ${REPO_NAME_DOCKER_BACKEND}:latest ${DOCKER_USERNAME}/${REPO_NAME_DOCKER_BACKEND}:latest
                            docker push ${DOCKER_USERNAME}/${REPO_NAME_DOCKER_BACKEND}:latest
                            
                            echo "Pushing frontend Docker image..."
                            docker tag ${REPO_NAME_DOCKER_FRONTEND}:latest ${DOCKER_USERNAME}/${REPO_NAME_DOCKER_FRONTEND}:latest
                            docker push ${DOCKER_USERNAME}/${REPO_NAME_DOCKER_FRONTEND}:latest
                            
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
