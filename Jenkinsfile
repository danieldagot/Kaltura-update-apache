
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
        stage('Update server') {
             steps {
                sh "mv ${env.WORKSPACE}/recipes/default.rb ~/chef-repo/cookbooks/apache/recipes/default.rb" 
                sh "mv ${env.WORKSPACE}/roles/apache.rb ~/chef-repo/roles/apache.rb" 
                sh "knife upload /cookbooks"
            }
        }
        stage('Lunch ec2 server') {
            steps {
                withAWS(credentials: '9d3197bc-24e1-48c4-bba6-43213cfc5b13') {
                        // sh "knife ec2 server create -r 'role[webserver]'  --tags username= ${params.username} --groups=default   --region=${params.AWS_DEFAULT_REGION}  --image=ami-062ce30491f964ba1 --flavor=t2.small  -U ubuntu  --ssh-key=jenkins-aws-key -i=/home/ubuntu/jenkins-aws-key.pem --aws-tag Name=apache"
    // some block 
                      withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu', keyFileVariable: 'AGENT_SSHKEY', passphraseVariable: '', usernameVariable: '')]) {
                        sh "knife ssh 'role:webserver' -x ubuntu -i $AGENT_SSHKEY 'sudo chef-client' -c $CHEFREPO/chef-repo/.chef/knife.rb"      
                    }
                }

            }
        }
    }
}
