
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
      stage("Env Variables") {
        environment {
            AWS_ACCESS_KEY_ID = "AKIAYX4FGXDNACL6OWZY" // overrides pipeline level NAME env variable
            AWS_SECRET_ACCESS_KEY = "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" // overrides the default BUILD_NUMBER
        }
        stage('Update server') {
             steps {
                sh "mv ${env.WORKSPACE}/recipes/default.rb ~/chef-repo/cookbooks/apache/recipes/default.rb" 
                sh "mv ${env.WORKSPACE}/roles/apache.rb ~/chef-repo/roles/apache.rb" 
                sh "knife upload /cookbooks"
            }
        }
        stage('Lunch ec2 server') {
            steps {
                sh "knife ec2 server create -r 'role[webserver]'  --aws-access-key-id 'AKIAYX4FGXDNACL6OWZY' ----aws-secret-access-key "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"  --tags username= ${params.username} --groups=default   --region=${params.AWS_DEFAULT_REGION}  --image=ami-062ce30491f964ba1 --flavor=t2.small  -U ubuntu  --ssh-key=jenkins-aws-key -i=/home/ubuntu/jenkins-aws-key.pem --aws-tag Name=apache"
            }
        }
    }
    post {
    always {
       mail to: 'bcl@nclasters.org',
          subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
          body: "${env.BUILD_URL} has result ${currentBuild.result}"
    }
  }
}
