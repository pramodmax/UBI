node {
   def mvnHome
   stage('Pre-req-display') { 
      sh """
      echo "Running this on Openshift Platform" 
      echo "Expecting you to have test1 project in OCP" 
      echo "Jenkins Service-account should have privilages to do change on test1 project" 
      """
      
   }
   stage('checkout') { 
      git 'https://github.com/pramodmax/ubi_utils.git'
      
   }
   
   stage('Start container build'){
        sh """
                
                oc project test1
                echo "Creating BuildConfig/IS."
        		oc new-build --name=fuse-base-image --binary=true --strategy=docker --to-docker=true -n test1
                tar -cvf a.tar jolokia/ run-java/ s2i/ Dockerfile
                oc start-build fuse-base-image -n test1 --from-archive=a.tar --follow
                
           """


    }
   
}
