
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        choice(name:'username',choices:['1','us-east-2'],description:'')
    }
    stages {
           stage('Update Ubuntu') {
            steps {
                sh 'sudo apt-get update'
            }    
        }
           stage('Download Cookbook') {
            steps {
                    git branch: 'main', credentialsId: 'git-creds', url: 'https://github.com/danieldagot/apache-ciickebook.git'            }
        }
   stage('Upload Cookbook to Chef Server, Converge Nodes') {
            steps {
                withCredentials([zip(credentialsId: 'chef-server-cred', variable: 'CHEFREPO')]) {
                    sh 'mkdir -p $CHEFREPO/chef-repo/cookbooks/apache'
                   // sh "knife ssh 'role:webserver' -x ubuntu -i -p 'Aa123456' 'sudo chef-client' "
                    sh 'sudo rm -rf $WORKSPACE/Berksfile.lock'
                    // sh 'mv $WORKSPACE/* $CHEFREPO/chef-repo/cookbooks/apache'
                    sh"cp -r ~/chef-repo/.chef"
                    sh "knife cookbook upload apache --force -o $CHEFREPO/chef-repo/cookbooks -c $CHEFREPO/chef-repo/.chef/config.rb"
                    // sh "knife ssh 'role:webserver' -x ubuntu -i -p 'Aa123456' 'sudo chef-client' "
                    withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu', keyFileVariable: 'AGENT_SSHKEY', passphraseVariable: '', usernameVariable: '')]) {
                        sh "knife ssh 'role:webserver' -x ubuntu -i $AGENT_SSHKEY 'sudo chef-client' -c $CHEFREPO/chef-repo/.chef/config.rb"      
                    }
                }

            }
        }
            }
        }
