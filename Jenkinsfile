pipeline {
    agent any
    
    environment {
        REMOTE_SERVER = '44.204.185.121'
        REMOTE_USER = 'ubuntu'
    }
    stages {
        stage('SCM') {
            steps {
                script {
                    git 'https://github.com/Doortocloud/java-web-app-docker.git'
                }
            }
        }
        stage('Maven Build') {
            steps {
                script {
                    def mavenHome = tool name: "Maven", type: "maven"
                    sh "'${mavenHome}/bin/mvn' clean package"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t premcloud/jenkinsdockerapp:${BUILD_NUMBER} .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'DockerPass', variable: 'DockerPass')]) {
                        sh '''
                        docker login -u premcloud -p ${DockerPass}
                        docker push premcloud/jenkinsdockerapp:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
        stage('Deploy to Remote Server') {
            steps {
                script {
                    sshagent(['SSH_AGENT']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_SERVER}
                            docker pull premcloud/jenkinsdockerapp:${BUILD_NUMBER}
                            docker rm -f jenkinsdockerappcontainer || true
                            docker run -d --name jenkinsdockerappcontainer -p 9090:8080 premcloud/jenkinsdockerapp:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            sh 'docker system prune -af --volumes || true' 
        } 
    }     
}
