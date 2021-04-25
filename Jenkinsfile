pipeline {
  agent {
    label 'chef'
  }
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
        git(branch: 'main', credentialsId: 'git-creds', url: 'https://github.com/danieldagot/apache-ciickebook.git')
      }
    }

    stage('Install Ruby and Test Kitchen') {
      steps {
        sh 'sudo apt-get install -y rubygems ruby-dev'
        sh 'chef gem install knife-count'
        sh 'sudo apt-get install gcc g++ make autoconf -y'
      }
    }

    stage('Upload Cookbook to Chef Server, Converge Nodes') {
      steps {
        withCredentials(bindings: [zip(credentialsId: 'chef-server-cred', variable: 'CHEFREPO')]) {
          sh 'mkdir -p $CHEFREPO/chef-repo/cookbooks/apache'
          sh 'sudo rm -rf $WORKSPACE/Berksfile.lock'
          sh 'mv $WORKSPACE/* $CHEFREPO/chef-repo/cookbooks/apache'
          sh "knife ssl fetch -c $CHEFREPO/chef-repo/.chef/config.rb "
          sh "cat $CHEFREPO/chef-repo/.chef/config.rb"
          sh "cp -r ~/chef-repo/.chef/trusted_certs $CHEFREPO/chef-repo/"
          sh "cp -r ~/chef-repo/.chef/syntaxcache $CHEFREPO/chef-repo/"
          sh "knife ssl fetch -c $CHEFREPO/chef-repo/.chef/config.rb "
          sh "knife cookbook upload apache --force -o $CHEFREPO/chef-repo/cookbooks -c $CHEFREPO/chef-repo/.chef/config.rb"
          withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'ubuntu', keyFileVariable: 'AGENT_SSHKEY', passphraseVariable: '', usernameVariable: '')]) {
            withCredentials(bindings: [aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsCredentialId', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
              env.name = "$AWS_DEFAULT_REGION-webserver"
              script {
                
                env.countInstenses= sh (returnStdout: true, script:"""knife count -c $CHEFREPO/chef-repo/.chef/config.rb name:$env.name""").trim()
                env.amiID = 'ami-013f17f36f8b1fefb'
                
                if ($params.AWS_DEFAULT_REGION == 'us-east-2'){
                    env.amiID = 'ami-01e7ca2ef94a0ae86'
                    
                }
                if("$env.countInstenses" == '0')
                {
                  sh "knife ec2 server create -c $CHEFREPO/chef-repo/.chef/config.rb --groups=default   --aws-secret-access-key=$AWS_SECRET_ACCESS_KEY --aws-access-key-id=$AWS_ACCESS_KEY_ID --region=us-east-1   --ssh-identity-file $AGENT_SSHKEY --image=ami-013f17f36f8b1fefb --flavor=t2.micro -N '' --ssh-user ubuntu  --ssh-key jenkins-aws-key --aws-tag Name='webserver node'  -y --sudo  "
                  sh "knife node run_list add $env.IName 'recipe[apache::default]' -c $CHEFREPO/chef-repo/.chef/config.rb "
                }
                sh """knife exec -c $CHEFREPO/chef-repo/.chef/config.rb -E "nodes.find(:name => $env.IName) { |node|   node.normal_attrs[:username]=\'${params.username}\' ; node.save; }" """  
                sh "knife ssh 'name:''' -x ubuntu -i $AGENT_SSHKEY 'sudo chef-client' -c $CHEFREPO/chef-repo/.chef/config.rb"    
              }

            }

          }

        }

      }
    }

  }
}