pipeline{
    agent any
	
    stages{
        stage('Git Checkout'){
            steps{
                git credentialsId: 'github', url: 'https://github.com/Moni3099/vault-dev'
                
            }
        }				
        stage('Terraform Path') { 
            steps {
			   script{
					def tfHome = tool name: 'terraform', type: 'terraform'
					env.PATH = "${tfHome}:${env.PATH}"
					sh 'terraform --version'
			   }
			    
            }
         }
		stage('Terraform initialize'){
		    steps{
				sh 'terraform init'
			}
		}
		stage('Terraform plan'){
		    steps{
				sh 'terraform plan'
			}
		}
		stage('Terraform Apply'){
		    steps{
				sh 'terraform apply -auto-approve'
			}
		}
		stage('Terraform Destroy'){
		    steps{
				sh 'terraform destroy -auto-approve'
			}
		}
    }   
}
