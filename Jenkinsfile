/* groovylint-disable CompileStatic, GStringExpressionWithinString */
pipeline {
    environment {
        registry = '280661052493.dkr.ecr.us-east-1.amazonaws.com'
        registryCredential = 'AWS_JENKINS_CREDENTIAL'
    }
    agent any
    stages {
        stage('Repo Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/sujithshajee/Assignment-DevOps-C7-Course-Project-nodeapp.git'
            }
        }
        stage('Build image') {
            steps {
                script {
                    app_build_number = docker.build(registry + "/app:$BUILD_NUMBER")
                    app_latest = docker.build(registry + '/app:latest')
                }
            }
        }
        stage('Push image') {
            steps {
                script {
                    /* groovylint-disable-next-line NestedBlockDepth */
                    docker.withRegistry('https://' + registry +'/app', 'ecr:us-east-1:' + registryCredential) {
                        app_build_number.push()
                        app_latest.push()
                    }
                }
            }
        }
        stage('Deploy image') {
            steps {
                sshagent(credentials: ['ssh-credentials-id']) {
                    sh 'ssh -o StrictHostKeyChecking=no -l ubuntu appserver sudo su && docker stop appserver || true && docker rm appserver || true && docker system prune -af || true && docker run -p 8080:8081 --name app-server -d ' + registry + '/app:latest'
                }
            }
        }
    }
}