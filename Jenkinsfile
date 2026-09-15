pipeline {
    agent any
    environment {
        IMAGE_TAG = "${env.GIT_COMMIT}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Frontend Image') {
            steps {
                sh 'docker build -t yelb-ui:${IMAGE_TAG} ./Frontend'
            }
        }
        stage('Deploy') {
            steps {
                sh 'kubectl set image deployment/yelb-ui yelb-ui=yelb-ui:${IMAGE_TAG} -n yelb'
                sh 'kubectl rollout status deployment/yelb-ui -n yelb --timeout=60s'
            }
        }
        stage('Smoke Test') {
            steps {
                sh 'curl -f http://localhost:80'
            }
        }
    }
}

