
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
   stage('Upload Cookbook to Chef Server, Converge Nodes') {
            steps {
             
                withCredentials([zip(credentialsId: 'chef-server-cred', variable: 'CHEFREPO')]) {
                    sh 'mkdir -p $CHEFREPO/chef-repo/cookbooks/apache'
                    sh 'sudo rm -rf $WORKSPACE/Berksfile.lock'
                    sh 'mv $WORKSPACE/* $CHEFREPO/chef-repo/cookbooks/apache'
                    // add trusted certs to remote repo 
                    sh"cp -r ~/chef-repo/.chef/trusted_certs $CHEFREPO/chef-repo/"
                     sh"cp -r ~/chef-repo/.chef/syntaxcache $CHEFREPO/chef-repo/"
                    sh "knife ssl fetch -c $CHEFREPO/chef-repo/.chef/config.rb "
                    //update cookbook
                    sh "knife cookbook upload apache --force -o $CHEFREPO/chef-repo/cookbooks -c $CHEFREPO/chef-repo/.chef/config.rb"
                    withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu', keyFileVariable: 'AGENT_SSHKEY', passphraseVariable: '', usernameVariable: '')]) {
                        
                        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsCredentialId', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                           script{
                               try {
                              env.instaseCount  =    sh(script: "knife search node -c $CHEFREPO/chef-repo/.chef/config.rb tags:us-east-1 || exit 0 ", returnStdout: true)
                               }catch (err) {
                                   echo err
                                   
                               }
                               echo  env.instaseCount
                            //    if(env.instaseCount == "0"){
                            //        echo "test is good"
                            //        //create and boostrap new ec2 instacse 
                            //    }
                            //    else {
                            //      //  echo env.instaseCount
                            //    }
                            
                           } 

                    }
                }

            }
        }
   }
            }
        }
