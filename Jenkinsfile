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
                        sh 'ls -la'
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    script {
                         dir('jenkins_nodejs_example') {
                            sh 'pwd'
                            sh 'docker build . -f dockerfile -t nodejs-app:latest'

                            withCredentials([usernamePassword(credentialsId: 'nexus-cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                                // sh "echo $PASSWORD | docker login  -u $USERNAME --password-stdin"
                                sh "docker login -u $USERNAME -p $PASSWORD 10.107.105.40:5000"
                            }
                            // Tag the image with Nexus registry information
                            sh "docker tag nodejs-app:latest 10.107.105.40:5000/repository/docker-repo/nodejs-app:latest"
                            
                            // Push the image to Nexus registry
                            sh "docker push 10.107.105.40:5000/repository/docker-repo/nodejs-app:latest"
                        }
                    }
                }
            }
        }
    }
}
