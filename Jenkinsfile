pipeline {
    agent any

    triggers {
        githubPush()
    }

    stages {

        stage('Clone') {
            steps {
                git branch: 'develop', 
                    url: 'https://github.com/FatihaKhassil/Covoiturage-devops.git'
            }
        }

        // 👉 IMPORTANT : UN SEUL BUILD QUI FAIT TOUT
        stage('Build + Tests + Coverage') {
            steps {
                script {
                    def mvnHome = tool name: 'Maven3', type: 'maven'
                    echo 'Build + Tests + JaCoCo...'
                    bat "\"${mvnHome}\\bin\\mvn\" clean verify site"
                }
            }
        }

        // 🔍 DEBUG : vérifier que Jenkins a bien généré JaCoCo
        stage('Check JaCoCo') {
            steps {
                bat "dir target\\site\\jacoco"
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONAR_TOKEN = credentials('sonar-token-id')
            }
            steps {
                script {
                    def mvnHome = tool name: 'Maven3', type: 'maven'
                    bat """
                    \"${mvnHome}\\bin\\mvn\" sonar:sonar ^
                    -Dsonar.projectKey=Covoiturage-devops ^
                    -Dsonar.projectName=\"Covoiturage DevOps\" ^
                    -Dsonar.host.url=http://localhost:9000 ^
                    -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml ^
                    -Dsonar.token=%SONAR_TOKEN%
                    """
                }
            }
        }

        stage('Package') {
            steps {
                script {
                    def mvnHome = tool name: 'Maven3', type: 'maven'
                    echo 'Création du WAR...'
                    bat "\"${mvnHome}\\bin\\mvn\" package -DskipTests"
                }
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
