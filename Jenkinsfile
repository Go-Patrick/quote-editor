pipeline {
    agent any
    environment {
        APP_NAME="${JOB_NAME.substring(0, JOB_NAME.lastIndexOf('/'))}"
        SHORT_COMMIT="${GIT_COMMIT[0..7]}"
        ECR_URL = "932782693588.dkr.ecr.ap-southeast-1.amazonaws.com/quote-app"
        AWS_CREDENTIALS_ID = "patrick-demo-1"
        ENV_FILE_CREDENTIAL_ID = "quote-env"
        ECR_REPO_APP = "quote-app"
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
                    branch 'main'
                    branch 'feat/jenkins-implement'
                }
            }
            steps {
                withCredentials([file(credentialsId: "${env.ENV_FILE_CREDENTIAL_ID}", variable: 'ENV_FILE')]) {
                    script {
                        try{
                            sh 'cat $ENV_FILE > .env'
                            sh 'cd deploy && cat $ENV_FILE > .env'
                            sh "echo \"IMAGE_VERSION=${env.SHORT_COMMIT}\" > deploy/.env"
                            docker.withRegistry("https://" + "${env.ECR_URL}", 'ecr:ap-southeast-1:patrick-demo-1') {
                                def IMAGE_NAME="${env.ECR_URL}:${env.SHORT_COMMIT}"
                                def customImage = docker.build("$IMAGE_NAME", "-f Dockerfile .")
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
                    branch 'main'
                    branch 'feat/jenkins-implement'
                }
            }
            steps {
                script {
                    try{
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]){
                            sh '''
                            cd deploy
                            aws deploy push --application-name quote-editor --s3-location s3://quote-editor-deploy-bucket/deploy.zip
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
                    branch 'main'
                    branch 'feat/jenkins-implement'
                }
            }
            steps {
                script {
                    try{
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]){
                            sh '''
                            aws deploy create-deployment --application-name quote-editor \\
                            --deployment-config-name CodeDeployDefault.OneAtATime \\
                            --deployment-group-name quote-group \\
                            --s3-location bucket=quote-editor-deploy-bucket,bundleType=zip,key=deploy.zip
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