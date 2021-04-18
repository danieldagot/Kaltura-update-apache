pipeline {
    agent any
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
        stage('get letest git') {
         steps{
            sh "mkdir -p deployment;touch deployment/test"
            stash name: "deployment", includes: "deployment/**"
            
             checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/danieldagot/Kaltura-update-apache.git']]])
            sh "ls"
            
         }
        }
          stage('lunch ec2 instance') {
              step{
                  knife ec2 server create –I ami-456b493a -S /home/ubuntu/jenkins-aws-key.pem –f t2.small -x ubuntu –G sg-5d8b2c17 -s subnet-9d51ddc6 -Z us-east-1a
              }
        }
    }
}
