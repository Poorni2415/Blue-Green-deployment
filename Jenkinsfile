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

stage('Health Check Current App') {
    steps {
        sh '''
        curl  http://host.docker.internal:8085/health
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

        script {

    def active = sh(
        script: "curl -s http://host.docker.internal:8085",
        returnStdout: true
    ).trim()

    if (active.contains("Blue")) {

        env.TARGET_ENV = "green"
        env.TARGET_PORT = "8083"

    } else {

        env.TARGET_ENV = "blue"
        env.TARGET_PORT = "8082"
    }

    echo "Deploying to ${env.TARGET_ENV}"
}
    }
}


stage('Deploy') {

    steps {

        sh '''
        docker stop ${TARGET_ENV} || true
        docker rm ${TARGET_ENV} || true

        docker run -d \
          --name ${TARGET_ENV} \
          -p ${TARGET_PORT}:3000 \
          bluegreen-app:test
        '''
    }
}

stage('Health Check Target Environment') {

    steps {

        sh '''
        sleep 10
        curl --fail http://host.docker.internal:${TARGET_PORT}/health
        '''
    }
}


stage('Switch Traffic') {

    steps {

        script {

            if (env.TARGET_ENV == "green") {

                sh '''
                docker exec nginx sh -c "
                sed -i 's/server blue:3000;/server green:3000;/' /etc/nginx/nginx.conf
                nginx -s reload
                "
                '''
            } else {

                sh '''
                docker exec nginx sh -c "
                sed -i 's/server green:3000;/server blue:3000;/' /etc/nginx/nginx.conf
                nginx -s reload
                "
                '''
            }
        }
    }
}

stage('Cleanup') {
    steps {
        sh 'docker rm -f test-deploy || true'
    }
}


stage('Cleanup Old Environment') {

    steps {

        script {

            if (env.TARGET_ENV == "green") {

                sh '''
                docker stop blue || true
                docker rm blue || true
                '''

            } else {

                sh '''
                docker stop green || true
                docker rm green || true
                '''
            }
        }
    }
}


    }
}