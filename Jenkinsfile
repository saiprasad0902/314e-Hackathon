pipeline {
    environment {
        registry = "saiprasad0902/314e-hackathon"
        registryCredential = 'saiprasad0902'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Cloning our Git') {
            steps {
                git 'https://github.com/saiprasad0902/314e-Hackathon.git/'
            }
        }
        stage('Building our image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":1.0.0"
                }
            }
        }
        stage('Deploy our image') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Cleaning up') {
            steps {
                sh "docker rmi $registry:1.0.0"
            }
        }
    }
}