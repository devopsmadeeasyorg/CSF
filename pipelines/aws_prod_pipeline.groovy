// import statements
// import groovy.json.JsonSlurperClassic




// Declare variables
deployRepo = "https://github.com/devopsmadeeasyorg/CSF.git"
deployReponame = "CSF"
deployDir = "${deployReponame}"

// Declarative Pipeline
pipeline {
    // To run job on any available agent
    agent any
    // Environment variables
    environment {
        AWS_ACCESS_KEY_ID = credentials('accesskey')
        AWS_SECRET_ACCESS_KEY = credentials('secretkey')
    }
    // Passing parameters 
    parameters {
        string(name: "CLUSTER_DATA", description: "Cluster Data JSON")
        string(name: "BRANCH_NAME", description: "Branch Name", defaultValue: "master")
        string(name: "TASKS", description: "Actions", defaultValue: "provision")
    }
    // Stages in execution
    stages{
        // Set up environment
        stage ("Set up environment"){
            steps {
                script {
                    gitClone()
                    sh """
                    echo ${params.CLUSTER_DATA} > ${deployDir}/cluster_data.json
                    cat ${deployDir}/cluster_data.json
                    """
                    // read json data and update build number
                   data = sh(script: " cat ${deployDir}/cluster_data.json", returnStdout: true)
                //    jsonData = new JsonSlurperClassic().parseText(data)
                   def jsonData = new groovy.json.JsonSlurper().parseText(data)
                   if(jsonData.containsKey('cloud_provider')){
                    currentBuild.displayName = jsonData['cloud_provider']
                   }
                   else {
                    cloud_provider = ""
                   }
                }
            }
        }
        // provision infrastructure
        stage("Execute tasks"){
            steps{
            script {
                sh """
                  export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                  export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                  cd ${deployDir} && python3 csf_gateway.py --cluster_data cluster_data.json --actions '${params.TASKS}'
                """
                
                }
                
            }
            }
        }
    }



// Groovy script

// Clone Git repo
def gitClone(){
    dir(deployReponame) {
        git branch: params.BRANCH_NAME, credentialsId: 'gitcred', url: deployRepo
    }
}

