pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker'  // DockerHub credentials ID
        IMAGE_NAME = 'foxe03/app1'
        TAG = 'latest'
        MANIFEST_REPO = 'https://github.com/Fox-R-fox/Jenkins-assignment.git' // Repository with Kubernetes manifests
        MANIFEST_REPO_DIR = 'Jenkins-assignment'  // Directory name where the repo will be cloned
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
                    withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')]) {
                        sh '''
                            git clone https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/Fox-R-fox/Jenkins-assignment.git Jenkins-assignment || exit 1
                            cd Jenkins-assignment
                            if [ ! -f deployment-service.yml ]; then
                                echo "File deployment-service.yml not found!"
                                exit 1
                            fi
                            sed -i 's|image: foxe03/app1:.*|image: foxe03/app1:latest|' deployment-service.yml
                            git config user.email "rohansherkar2207@gmail.com"
                            git config user.name "Fox-R-fox"
                            git add deployment-service.yml
                            if [ -n "$(git status --porcelain)" ]; then
                                git commit -m "Update Docker image tag"
                                git push origin main
                            else
                                echo "No changes to commit"
                            fi
                        '''
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
