pipeline {
    parameters{
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        string(name:'username',description:'')
    }
    stages {
        stage('get letest git') {
         steps{
            sh "mkdir -p deployment;touch deployment/test"
            stash name: "deployment", includes: "deployment/**"

            checkout(
                    [$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    doGenerateSubmoduleConfigurations: false, 
                    extensions: [[$class: 'RelativeTargetDirectory', 
                    relativeTargetDir: 'deployment']], 
                    submoduleCfg: [], 
                    userRemoteConfigs: [[credentialsId: 'secret', url: 'https://github.com/danieldagot/Kaltura-update-apache.git']]]) 

            unstash deployment
            sh "ls deployment"
            # it prints fetched repo AND existing before files 
        }

        }
    }
}