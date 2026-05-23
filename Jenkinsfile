pipeline {
    agent any

    environment {
        IMAGE_NAME = "venkyvenkat110/my-website"
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
                    if (env.BRANCH_NAME == 'main') {
                        docker.build("${IMAGE_NAME}:latest")
                    } else {
                        docker.build("${IMAGE_NAME}:${env.BRANCH_NAME}")
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        if (env.BRANCH_NAME == 'main') {
                            docker.image("${IMAGE_NAME}:latest").push()
                        } else {
                            docker.image("${IMAGE_NAME}:${env.BRANCH_NAME}").push()
                        }
                    }
                }
            }
        }

        stage('Deploy to Dev') {
            when { branch 'dev' }
            steps {
                withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://172.18.0.3:6443']) {
                    sh 'kubectl apply -f deploy-dev.yaml --validate=false'
                    sh 'kubectl rollout restart deployment/my-app -n dev'
                    sh 'kubectl rollout status deployment/my-app -n dev'
                }
            }
        }

        stage('Deploy to Staging') {
            when { branch 'staging' }
            steps {
                withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://172.18.0.3:6443']) {
                    sh 'kubectl apply -f deploy-staging.yaml --validate=false'
                    sh 'kubectl rollout restart deployment/my-app -n staging'
                    sh 'kubectl rollout status deployment/my-app -n staging'
                }
            }
        }

        stage('Deploy to Production') {
            when { branch 'main' }
            steps {
                withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://172.18.0.4:6443']) {
                    sh 'kubectl apply -f deploy-prod.yaml --validate=false'
                    sh 'kubectl rollout restart deployment/my-app -n prod'
                    sh 'kubectl rollout status deployment/my-app -n prod'
                }
            }
        }
    }

    post {
        success { echo 'Deployment successful!' }
        failure { echo 'Pipeline failed - check logs above.' }
    }
}