
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
        stage('Luch server') {
            steps {
                // sh "knife ec2 server create -I ami-456b493a -S /home/ubuntu/jenkins-aws-key.pem -f t2.small -x ubuntu -G sg-5d8b2c17 -s subnet-9d51ddc6 -Z us-east-1a"
                sh "knife ec2 server -r 'role[webserver-${params.AWS_DEFAULT_REGION}]' create --tags username= ${params.username} --groups=default   --region=${params.AWS_DEFAULT_REGION}  --image=ami-062ce30491f964ba1 --flavor=t2.small  -U ubuntu  --ssh-key=jenkins-aws-key -i=/home/ubuntu/jenkins-aws-key.pem --aws-tag Name=webserver"
                sh "knife bootstrap HOSTNAME --run-list 'role[webserver-${params.AWS_DEFAULT_REGION}]'"
            }    
        }
    }
}