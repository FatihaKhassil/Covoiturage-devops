pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {

        stage('Clone') {
            steps {
                git branch: 'develop', url: 'https://github.com/FatihaKhassil/Covoiturage-devops.git'
            }
        }

        stage('Build') {
            steps {
                 bat 'mvn clean compile'
            }
        }

        stage('Tests') {
            steps {
                echo 'Tests unitaires...'
                bat 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Création du WAR...'
                bat 'mvn package -DskipTests'
            }
            post {
                success {
                    archiveArtifacts '**/target/*.war'
                }
            }
        }
    }

    post {
        success {
            echo 'PIPELINE RÉUSSI ✅'
        }

        failure {
            echo 'PIPELINE ÉCHOUÉ ❌'
        }
    }
}
