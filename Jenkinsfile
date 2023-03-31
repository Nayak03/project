pipeline {
    agent any

    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-creds', url: 'https://github.com/Nayak03/project'
            }
        }
        stage('maven build package') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('tomcat deploy') {
            steps {
                sshagent(['tomcat-creds']) {
                    sh "scp -o StrictHostKeyChecking=no target/*.war ec2-user@172.31.83.74:/opt/tomcat9/webapps"
                    sh "ssh ec2-user@172.31.83.74 /opt/tomcat9/bin/shutdown.sh"
                    sh "ssh ec2-user@172.31.83.74 /opt/tomcat9/bin/startup.sh"
                    
                }
            }    
        }
        stage('docker build') {
            steps {
                sh "docker build -t adarshnayak/project:0.0.2 ."

                }
            }    
        stage('docker push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'HubPwd')]) {
                sh "docker login -u adarshnayak -p ${HubPwd}"
                sh "docker push adarshnayak/project:0.0.2"
                }
            }
        }    
        stage('docker Deploy') {
            steps {
                sshagent(['docker-host']) {
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@172.31.94.41 docker run -d -p 8080:8080 --name project adarshnayak/project:0.0.2" 
                }
            }
        }    
    }
}
