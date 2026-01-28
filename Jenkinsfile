pipeline {
    agent any

    tools {
        maven 'Maven-3.6'
        jdk 'JDK-11'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Clonage du projet...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Compilation...'
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
