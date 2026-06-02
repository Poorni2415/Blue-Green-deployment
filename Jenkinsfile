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

        stage('Deploy Test Container') {
    steps {
        sh '''
        docker rm -f test-deploy || true
        docker run -d --name test-deploy -p 8086:3000 bluegreen-app:test
        '''
    }
}

stage('Health Check') {
    steps {
        sh '''
        curl http://host.docker.internal:8085/health
        '''
    }
}

stage('Detect Active Environment') {
    steps {
        script {

            def active = sh(
                script: "curl -s http://host.docker.internal:8085",
                returnStdout: true
            ).trim()

            echo "Current App: ${active}"

        }
    }
}

    }
}