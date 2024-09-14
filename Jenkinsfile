pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker'  // DockerHub credentials ID
        IMAGE_NAME = 'foxe03/app'
        TAG = 'latest'
        ARGOCD_SERVER = 'https://your-argocd-server'
        ARGOCD_APP_NAME = 'app'
        ARGOCD_CREDENTIALS_ID = 'argocd-credentials'  // Argo CD credentials ID
        MANIFEST_REPO = 'https://github.com/Fox-R-fox/Jenkins-assignment.git' // Repository with Kubernetes manifests
        MANIFEST_REPO_DIR = 'your-repo'  // Directory name where the repo will be cloned
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository with the application code and Dockerfile
                git branch: 'main', url: 'https://github.com/Fox-R-fox/Jenkins-assignment.git'
            }
        }

        stage('Set Script Permissions') {
            steps {
                // Ensure the build_push.sh script is executable
                sh 'chmod +x scripts/build_push.sh'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "$DOCKER_CREDENTIALS_ID", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    // Run the build and push script
                    sh 'scripts/build_push.sh'
                }
            }
        }

        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    // Clone repository containing Kubernetes manifests
                    sh "git clone ${MANIFEST_REPO}"
                    dir("${MANIFEST_REPO_DIR}") {
                        // Update image tag in deployment.yaml
                        sh "sed -i 's|image: ${IMAGE_NAME}:.*|image: ${IMAGE_NAME}:${TAG}|' deployment.yaml"
                        // Commit and push changes
                        sh 'git config user.email "jenkins@example\.com"'
                        sh 'git config user.name "Jenkins"'
                        sh 'git add deployment.yaml'
                        sh 'git commit -m "Update Docker image tag"'
                        sh 'git push origin main'
                    }
                }
            }
        }

        stage('Sync with Argo CD') {
            steps {
                withCredentials([usernamePassword(credentialsId: "$ARGOCD_CREDENTIALS_ID", usernameVariable: 'ARGOCD_USERNAME', passwordVariable: 'ARGOCD_PASSWORD')]) {
                    script {
                        // Login to Argo CD
                        sh 'argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --insecure'

                        // Sync the Argo CD application
                        sh 'argocd app sync $ARGOCD_APP_NAME'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after build
        }
    }
}
