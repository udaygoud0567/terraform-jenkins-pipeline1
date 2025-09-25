pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')     // Jenkins credentials
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key') // Jenkins credentials
        AWS_DEFAULT_REGION    = "us-east-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/udaygoud0567/terraform-jenkins-pipeline1.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Apply?"
                sh 'terraform apply -input=false -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            echo "Pipeline finished!"
        }
    }
}
