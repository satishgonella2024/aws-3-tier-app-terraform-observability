pipeline {
    agent any
    environment {
        REPO_NAME_GITHUB = "satishgonella2024/aws-3-tier-app-terraform-observability"
        REPO_NAME_DOCKER_BACKEND = "satish2024/aws-3-tier-app-backend"
        REPO_NAME_DOCKER_FRONTEND = "satish2024/aws-3-tier-app-frontend"
    }
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Checking out code from GitHub..."
                    git branch: 'main', url: "git@github.com:${REPO_NAME_GITHUB}.git"
                }
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
        stage('Test Backend') {
            steps {
                script {
                    echo "Testing backend..."
                    sh '''
                        docker build -t backend-test ./backend
                        docker run --rm backend-test pytest
                    '''
                }
            }
        }
        stage('Test Frontend') {
            steps {
                script {
                    echo "Testing frontend..."
                    sh '''
                        docker build -t frontend-test ./frontend
                        docker run --rm frontend-test npm test -- --watchAll=false
                    '''
                }
            }
        }
        stage('Push Docker Images') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        passwordVariable: 'DOCKER_PASSWORD',
                        usernameVariable: 'DOCKER_USERNAME'
                    )]) {
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
            script {
                sh 'docker image prune -f || true'
            }
        }
        success {
            script {
                echo 'Pipeline completed successfully!'
            }
        }
        failure {
            script {
                echo 'Pipeline failed!'
            }
        }
    }
}
