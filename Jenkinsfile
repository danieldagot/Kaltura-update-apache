
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string defaultValue: 'daniel-dagot', description: '', name: 'username', trim: true
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
          stage('Install Ruby and Test Kitchen') {
            steps {
                sh 'sudo apt-get install -y rubygems ruby-dev'
                // sh 'chef gem install kitchen-docker'
                sh 'chef gem install knife-count'
                 sh "knife client delete --delete-validators ip-172-31-71-132.ec2.internal"
                sh'sudo apt-get install gcc g++ make autoconf -y'
                
            }
        }
   stage('Upload Cookbook to Chef Server, Converge Nodes') {
            steps {
             
                withCredentials([zip(credentialsId: 'chef-server-cred', variable: 'CHEFREPO')]) {
                    sh 'mkdir -p $CHEFREPO/chef-repo/cookbooks/apache'
                    sh 'sudo rm -rf $WORKSPACE/Berksfile.lock'
                    sh 'mv $WORKSPACE/* $CHEFREPO/chef-repo/cookbooks/apache'
                    // add trusted certs to remote repo 
                    sh "knife ssl fetch -c $CHEFREPO/chef-repo/.chef/config.rb "
                    sh "cat $CHEFREPO/chef-repo/.chef/config.rb"
                    sh"cp -r ~/chef-repo/.chef/trusted_certs $CHEFREPO/chef-repo/"
                     sh"cp -r ~/chef-repo/.chef/syntaxcache $CHEFREPO/chef-repo/"
                    sh "knife ssl fetch -c $CHEFREPO/chef-repo/.chef/config.rb "

                    //update cookbook
                    sh "knife cookbook upload apache --force -o $CHEFREPO/chef-repo/cookbooks -c $CHEFREPO/chef-repo/.chef/config.rb"
                    withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu', keyFileVariable: 'AGENT_SSHKEY', passphraseVariable: '', usernameVariable: '')]) {
                        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsCredentialId', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        script{
                                  env.countInstenses= sh (returnStdout: true, script:"knife count -c $CHEFREPO/chef-repo/.chef/config.rb tags:$AWS_DEFAULT_REGION").trim()
                                
                        
                                  if("$env.countInstenses" == '0')
                                {
                                    echo "ok 0 "
                                   
                                    sh " knife ec2 server create -c $CHEFREPO/chef-repo/.chef/config.rb --groups=default   --aws-secret-access-key=$AWS_SECRET_ACCESS_KEY --aws-access-key-id=$AWS_ACCESS_KEY_ID --region=us-east-1  --image=ami-013f17f36f8b1fefb --flavor=t2.micro  --ssh-user ubuntu  --ssh-key=jenkins-aws-key -i=$AGENT_SSHKEY --aws-tag Name='webserver node'  -r 'role[apache]' "
                                    // sh "knife bootstrap  -c $CHEFREPO/chef-repo/.chef/config.rb 18.206.192.87 --sudo -x ubuntu -i $AGENT_SSHKEY -N webservertest -y  "
                                }
                                 
                        }
                           
                    }
                }

            }
        }
   }
            }
        }
