pipeline {
    
    agent {
      node{
          label 'CI'
      }
    }
    
    stages { 
        stage('Clone Repo') {
            steps {
                git 'https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps49/_git/rs-cart'
            }
        }
        stage('NPM Install') {
            steps {
              sh label: '', script: ''' npm install
                        echo bye'''
            }
        }
    }
    
}
