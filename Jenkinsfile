pipeline {
    agent none

    stages {
        stage('Checkout') {
            agent any
            steps {
                checkout scm
            }
        }

        stage('Validate Schema') {
            agent {
                docker {
                    image 'ghcr.io/yannh/kubeconform:v0.6.6-alpine'
                    args '--entrypoint=/bin/sh'
    }
}
    steps {
        sh 'kubeconform $(find . -name "*.yml" -not -path "./docker-jenkins/*")'
    }
}

        stage('Lint') {
            agent {
                docker { image 'stackrox/kube-linter:v0.8.3' }
            }
            steps {
                sh 'kube-linter lint $(find . -name "*.yml" -not -path "./docker-jenkins/*")'
            }
        }
    }
}