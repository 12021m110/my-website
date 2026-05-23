pipeline {
    agent any

    environment {
        IMAGE_NAME = "venkyvenkat110/my-website"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

stage('Deploy to Kubernetes') {
    steps {
        withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://172.18.0.3:6443']) {
            sh 'kubectl apply -f my-app.yaml --validate=false'
            sh 'kubectl rollout restart deployment/my-app'
            sh 'kubectl rollout status deployment/my-app'
        }
    }
}

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Pipeline failed — check logs above.'
        }
    }
}