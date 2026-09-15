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
            when {
                changeset "Frontend/**"
            }
            steps {
                sh 'docker build -t yelb-ui:${IMAGE_TAG} ./Frontend'
            }
        }

        stage('Deploy Frontend') {
            when {
                changeset "Frontend/**"
            }
            steps {
                sh 'kubectl set image deployment/yelb-ui yelb-ui=yelb-ui:${IMAGE_TAG} -n yelb'
                sh 'kubectl rollout status deployment/yelb-ui -n yelb --timeout=60s'
            }
        }

        stage('Build Backend Image') {
            when {
                changeset "Backend/**"
            }
            steps {
                sh 'docker build -t yelb-appserver:${IMAGE_TAG} ./Backend'
            }
        }

        stage('Deploy Backend') {
            when {
                changeset "Backend/**"
            }
            steps {
                sh 'kubectl set image deployment/yelb-appserver yelb-appserver=yelb-appserver:${IMAGE_TAG} -n yelb'
                sh 'kubectl rollout status deployment/yelb-appserver -n yelb --timeout=60s'
            }
        }

        stage('Smoke Test') {
            steps {
                sh 'kubectl run curl-test-${BUILD_NUMBER} --image=curlimages/curl -n yelb --rm --restart=Never --attach -- curl -f http://yelb-ui:80/'
    }
}
    }
}