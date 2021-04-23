
pipeline {
    agent { label "chef"}
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
        stage('Update server') {
             steps {
               // sh "mv ${env.WORKSPACE}/recipes/default.rb ~/chef-repo/cookbooks/apache/recipes/default.rb" 
              //  sh 'knife exec -E "nodes.find(:name => webserver\') { |node|   node.normal_attrs[:username]=\'test\' ; node.save; }"'
               // sh "knife upload /cookbooks  --force "
                 sh "knife ssh 'role:webserver' -x ubuntu -i -p 'Aa123456' 'sudo chef-client' "
            }
        }
            }
        }
