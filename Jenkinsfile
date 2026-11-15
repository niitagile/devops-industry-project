
pipeline {
    agent any

    options {
        // Prevent overlapping deployments on the same port
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('1. Checkout') {
            steps {
                // Download project files from GitHub
                checkout scm
            }
        }

        stage('2. Validate Application') {
            steps {
                // Ensure that the application exists
                bat 'if not exist app\\index.html exit /b 1'

                // Check expected application content
                bat 'findstr /C:"Welcome to Online Shopping" app\\index.html'

                echo 'Application validation passed.'
            }
        }

        stage('3. Docker Build') {
            steps {
                // Confirm Docker Engine is accessible
                bat 'docker info'

                // Tag the image with the Jenkins build number
                bat 'docker build -t devops-shop:%BUILD_NUMBER% .'
            }
        }

        stage('4. Deploy Application') {
            steps {
                // Remove the previous demo container if present
                bat(returnStatus: true,
                    script: 'docker rm -f devops-shop')

                // Deploy the newly built image
                bat '''
                    docker run -d --name devops-shop -p 127.0.0.1:8081:80 devops-shop:%BUILD_NUMBER%
                '''
            }
        }

        stage('5. Verify Deployment') {
            steps {
                // Ensure the website returns the expected content
                bat '''
                    curl.exe -fsS http://127.0.0.1:8081/ | findstr /C:"Welcome to Online Shopping"
                '''

                echo 'Deployment verification passed.'
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Review the failing stage.'
        }
    }
}
