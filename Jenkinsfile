pipeline {
    agent {
        kubernetes {
            label 'jenkins-slave'
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: docker
                image: docker:19.03
                command:
                - cat
                tty: true
                volumeMounts:
                - name: docker-sock
                  mountPath: /var/run/docker.sock
              volumes:
              - name: docker-sock
                hostPath:
                  path: /var/run/docker.sock
            """
        }
    }
    stages {
        stage('Clone Repository') {
            steps {
                container('jnlp') {
                    script {
                        sh 'git clone -b k8s_task https://github.com/mahmoud254/jenkins_nodejs_example.git'
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                        sh 'docker build -t my-docker-image ./jenkins_nodejs_example'
                    }
                }
            }
        }
    }
}
