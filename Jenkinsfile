
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
        stage('Update server') {
             steps {
                    withCredentials([sshUserPrivateKey(credentialsId: 'master1', keyFileVariable: 'AGENT_SSHKEY', passphraseVariable: '', usernameVariable: '')]) {
                 
                        sh 'cd  ~/chef-repo ; knife exec -E "nodes.find(:name => \'webserver\') { |node|   node.normal_attrs[:username]=\'test123\' ; node.save; }"'
                    }
               // sh "mv ${env.WORKSPACE}/recipes/default.rb ~/chef-repo/cookbooks/apache/recipes/default.rb" 
               // sh "cd  ~/chef-repo"
            //    sh 'cd  ~/chef-repo ; knife exec -E "nodes.find(:name => \'webserver\') { |node|   node.normal_attrs[:username]=\'test123\' ; node.save; }"'
              //  sh "knife upload /cookbooks  --force "
            }
        }
            }
        }
