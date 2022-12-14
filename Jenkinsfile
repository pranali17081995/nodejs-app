pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID=460132273510
        AWS_DEFAULT_REGION="ap-south-1"
// 	CLUSTER_NAME="devcluster"
// 	SERVICE_NAME="nodejs-container-service"
// 	TASK_DEFINITION_NAME="first-run-task-definition"
// 	DESIRED_COUNT=1
        IMAGE_REPO_NAME="container-repo"
        IMAGE_TAG="${env.BUILD_ID}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
	registryCredential ="demo-admin-user"
    }
   
    stages {

    // Tests
    stage('Unit Tests') {
      steps{
        script {
          sh 'npm install'
	  //sh 'npm test -- --watchAll=false'
        }
      }
    }
    stage('Logging into AWS ECR') {
steps {
script {
sh 'aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com'
}

}
}

        
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {       
		  sh 'docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG'
                  sh 'docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}'
		      
// 			docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) 
//                     	dockerImage.push()
                	}
         }
        }
     
      
    stage('Deploy') {
     steps{
            
                script {
			sh 'kubectl apply -f deployment.yml'
                }
            
        }
      }      
       }
    
}

