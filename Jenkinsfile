pipeline {
    agent {
        kubernetes {
            yamlFile 'k8s_agent_pod_templates/kaniko-build-agent.yaml' 
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
