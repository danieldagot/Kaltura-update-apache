pipeline{
    agent any
    parameters{
        choice(name:'ENVTYPE',choices:['Nginx','NodeJS'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')
        choice(name:'AWS_DEFAULT_REGION',choices:['us-east-1','us-east-2'],description:'Type of Environment to launch like Nginx, tomcat etc. This will be used for bootstrapping')

    }
    environment{
        env="production"
    }
    
    stages{
        stage('Deploy Infra and Launch Instance'){
            
            when{
                environment name: 'env', value: 'production'
            }
          
            environment{
                AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
                AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
                AWS_DEFAULT_REGION="${params.AWS_DEFAULT_REGION}"
            }
            steps{
                  withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsCredentialId', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                      
                script {
                    env.AWS_ACCESS_KEY_ID = $AWS_ACCESS_KEY_ID
                    env.AWS_SECRET_ACCESS_KEY = $AWS_SECRET_ACCESS_KEY 
                    env.STACKID = sh(label:'',script:"aws cloudformation create-stack --stack-name myteststack3 --template-body file://deploy_ec2_network_v1.json --parameters ParameterKey=KeyP,ParameterValue=kaltura-ec2-keys ParameterKey=InstanceType,ParameterValue=t2.micro --query StackId",returnStdout: true).trim()
                    env.STACKSTATUS=sh(label:'',script:"aws cloudformation describe-stacks --stack-name ${env.STACKID} --query Stacks[0].StackStatus",returnStdout: true).trim()
                        while("${env.STACKSTATUS}"=='"CREATE_IN_PROGRESS"'){
                            sleep(20)
                            env.STACKSTATUS=sh(label:'',script:"aws cloudformation describe-stacks --stack-name ${env.STACKID} --query Stacks[0].StackStatus",returnStdout: true).trim()
                        }
                        env.INSTIP=sh(label:'',script:"aws cloudformation describe-stacks --stack-name ${env.STACKID} --query Stacks[0].Outputs[2].OutputValue",returnStdout: true).trim()
                    }
                
            }
            }
            
        }
        stage('Bootstrap'){
            steps{
                
                sh "mkdir ${env.WORKSPACE}/supporting_files/devopsprojectchef/.chef"
                sh "aws s3 cp s3://kaltura-ec2-keys ${env.WORKSPACE}/supporting_files/devopsprojectchef/.chef --recursive"
                script{
                    env.ENVTYPE = "Nginx"
                    if("${env.ENVTYPE}"=='Nginx'){
                        sh (label: '', script: "cd ${env.WORKSPACE}/supporting_files/devopsprojectchef;knife role from file roles/nginxserver.json;cd cookbooks/prepare_env;berks install;berks upload")
                        sh (label: '', script: "cd ${env.WORKSPACE}/supporting_files/devopsprojectchef;knife bootstrap ${env.INSTIP} --ssh-user ubuntu --sudo --yes --ssh-identity-file '${env.WORKSPACE}/supporting_files/devopsprojectchef/.chef/${env.EC2KEY}.pem' --node-name MyNode1 --run-list 'role[nginxserver]' ")
                    }
                }
            }
        }
        stage('Record Instance IP/DNS'){
            steps{
                sh "echo ${env.INSTIP}>InstanceDNS.txt"
                archiveArtifacts 'InstanceDNS.txt'
            }
        }
    }
    post{
        success{
            cleanWs disableDeferredWipeout: true, deleteDirs: true
        }
        failure{
            sh "aws cloudformation delete-stack --stack-name ${env.STACKID}"
            cleanWs disableDeferredWipeout: true, deleteDirs: true
        }
    }
}
