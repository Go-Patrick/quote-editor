pipeline {
    agent any
    environment {
        APP_NAME="${JOB_NAME.substring(0, JOB_NAME.lastIndexOf('/'))}"
        SHORT_COMMIT="${GIT_COMMIT[0..7]}"
        ECR_URL = "932782693588.dkr.ecr.ap-southeast-1.amazonaws.com/quote-app"
        AWS_CREDENTIALS_ID = "patrick-demo-1"
        ENV_FILE_CREDENTIAL_ID = "quote-env"
        ECR_REPO_APP = "quote-app-default"
    }

    stages {
        stage('Clone repository') {
            steps {
                script{
                    checkout scm
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh "echo $APP_NAME"
            }
        }
        stage('Build Docker image') {
             when {
                anyOf {
                    branch 'main';
                    branch 'dev'
                }
            }
            steps {
                withCredentials([file(credentialsId: "${env.ENV_FILE_CREDENTIAL_ID}", variable: 'ENV_FILE')]) {
                    script {
                        try{
                            sh 'cat $ENV_FILE > .env'
                            sh 'cd deploy && cat $ENV_FILE > .env'
                            sh "echo \"\nIMAGE_VERSION=${env.SHORT_COMMIT}\" >> deploy/.env"
                            docker.withRegistry("https://" + "${env.ECR_URL}-default", 'ecr:ap-southeast-1:patrick-demo-1') {
                                def IMAGE_NAME="${env.ECR_URL}-default:${env.SHORT_COMMIT}"
                                def customImage = docker.build("$IMAGE_NAME", "--build-arg RAILS_ENV=production -f Dockerfile.prod .")
                                customImage.push()
                            }
                        } catch (Exception e) {
                            echo "Caught exception: ${e}"
                            currentBuild.result = 'FAILURE'
                        }
                    }
                }
            }
        }
        stage('Upload new deploy file') {
             when {
                anyOf {
                    branch 'main';
                    branch 'dev'
                }
            }
            steps {
                script {
                    try{
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]){
                            sh 'chmod +x deploy/scripts/deploy.sh'
                            sh '''
                            cd deploy
                            aws deploy push --application-name quote-editor-default --s3-location s3://quote-editor-deploy-bucket-default/deploy.zip
                            '''
                        }
                    } catch (Exception e) {
                        echo "Caught exception: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
        stage('Deploy new application') {
             when {
                anyOf {
                    branch 'main';
                    branch 'dev'
                }
            }
            steps {
                script {
                    try{
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]){
                            sh '''
                            aws deploy create-deployment --application-name quote-editor-default \\
                            --deployment-config-name CodeDeployDefault.OneAtATime \\
                            --deployment-group-name quote-group-default \\
                            --s3-location bucket=quote-editor-deploy-bucket-default,bundleType=zip,key=deploy.zip
                            '''
                        }
                    } catch (Exception e) {
                        echo "Caught exception: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
        stage('Cleanup') {
            steps {
                echo 'Cleaning..'
                echo 'Running docker rmi..'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}