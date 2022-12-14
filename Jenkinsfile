pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID=460132273510
        AWS_DEFAULT_REGION="ap-south-1"
	CLUSTER_NAME="devcluster"
	SERVICE_NAME="nodejs-container-service"
	TASK_DEFINITION_NAME="first-run-task-definition"
	DESIRED_COUNT=1
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
		      
			docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) {
		        aws ecr get-login-password --region ap-south-1 | docker login --username AWS \
--password-stdin 460132273510.dkr.ecr.ap-south-1.amazonaws.com
                    	dockerImage.push()
                	}
         }
        }
      }
      
//     stage('Deploy') {
//      steps{
//             withAWS(credentials: registryCredential, region: "${AWS_DEFAULT_REGION}") {
//                 script {
// 			sh './script.sh'
//                 }
//             } 
        }
      }      
      
    }
}

