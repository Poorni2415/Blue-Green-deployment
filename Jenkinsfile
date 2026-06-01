pipeline {
    agent any

    stages {

        stage('Check Docker') {
            steps {
                sh 'docker ps'
            }
        }

        stage('Build New Image') {
            steps {
                sh 'docker build -t bluegreen-app:test .'
            }
        }

        stage('Check Running App') {
            steps {
                sh 'curl http://host.docker.internal:8085'
            }
        }

    }
}