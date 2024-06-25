pipeline {
    agent {
        kubernetes {
            label 'jenkins-slave'
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: kaniko
                image: gcr.io/kaniko-project/executor:debug
                command:
                - cat
                tty: true
                volumeMounts:
                - name: kaniko-secret
                  mountPath: /kaniko/.docker
              volumes:
              - name: kaniko-secret
                secret:
                  secretName: kaniko-secret
                  items:
                  - key: config.json
                    path: config.json
            """
        }
    }
    stages {
        stage('Clone Repository') {
            steps {
                container('jnlp') {
                    script {
                        sh 'git clone -b k8s_task https://github.com/mahmoud254/jenkins_nodejs_example.git'
                        sh 'ls -la'
                    }
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                container('kaniko') {
                    script {
                        dir('jenkins_nodejs_example') {
                            sh 'pwd'
                            sh '''
                                /kaniko/executor --dockerfile=dockerfile --context=. --destination=nexus-service.tools.svc:5000/repository/docker-repo/nodejs-app:latest --insecure
                            '''
                        }
                    }
                }
            }
        }
    }
}
