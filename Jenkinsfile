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
            agent any
            steps {
                sh '''
                    HOST_WORKSPACE="/var/lib/docker/volumes/docker-jenkins_jenkins_home/_data/workspace/local-test"
                    docker run --rm -v "$HOST_WORKSPACE:/work" -w /work \
                        ghcr.io/yannh/kubeconform:v0.6.6-alpine \
                        $(find /work -name "*.yml" -not -path "/work/docker-jenkins/*")
                '''
            }
        }

        stage('Lint') {
            agent any
            steps {
                sh '''
                    HOST_WORKSPACE="/var/lib/docker/volumes/docker-jenkins_jenkins_home/_data/workspace/local-test"
                    docker run --rm -v "$HOST_WORKSPACE:/work" -w /work \
                        stackrox/kube-linter:v0.8.3 \
                        lint $(find /work -name "*.yml" -not -path "/work/docker-jenkins/*")
                '''
            }
        }
    }
}