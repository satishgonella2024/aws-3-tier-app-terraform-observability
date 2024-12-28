pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = "docker-hub-credentials"
        REPO_NAME = "satishgonella2024/aws-3-tier-app"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'git@github.com:satishgonella2024/aws-3-tier-app-terraform-observability.git'
            }
        }
        stage('Build Backend Image') {
            steps {
                script {
                    docker.build("${env.REPO_NAME}-backend", './backend')
                }
            }
        }
        stage('Build Frontend Image') {
            steps {
                script {
                    docker.build("${env.REPO_NAME}-frontend", './frontend')
                }
            }
        }
        stage('Test Credentials') {
            steps {
                script {
                    echo "Using credentials ID: ${DOCKERHUB_CREDENTIALS}"
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKERHUB_CREDENTIALS') {
                        docker.image("${env.REPO_NAME}-backend").push('latest')
                        docker.image("${env.REPO_NAME}-frontend").push('latest')
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up Docker images...'
            sh 'docker image prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
