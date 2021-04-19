
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
        stage('Update Ubuntu') {
            steps {
                sh "knife ec2 server create –I ami-456b493a -S /home/ubuntu/jenkins-aws-key.pem –f t2.small -x ubuntu –G sg-5d8b2c17 -s subnet-9d51ddc6 -Z us-east-1a"

            }    
        }
    }
}