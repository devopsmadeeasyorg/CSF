// import statements
import groovy.json.JsonSlurperClassic

// Declare variables
deployRepo = "https://github.com/fullstack2025/CSF.git"
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
        base64File 'CLUSTER_DATA'
        string(name: "BRANCH_NAME", description: "Branch Name", defaultValue: "master")
        string(name: "TASKS", description: "Actions", defaultValue: "provision")
    }
    // Stages in execution
    stages{
        // Set up environment
        stage ("Set up environment"){
            steps {
                withFileParameter('CLUSTER_DATA'){
                script {
                   gitClone()
                   // read json data
                   data = sh(script: "cat $CLUSTER_DATA", returnStdout: true)
                   jsonData = new JsonSlurperClassic().parseText(data)
                   if(jsonData.containsKey('cloud_provider')){
                    currentBuild.displayName = jsonData['cloud_provider']
                   }
                   else {
                    cloud_provider = ""
                   }
                   cloud_provider = jsonData['cloud_provider']
                // The below commented line are to send notifications via Teams and Slack channel
                //    if(cloud_provider == "aws") {
                //     // slack channel id and teams webhook url
                //     channelID = ""
                //     webhookURL = "" 
                //    }
                //    else if(cloud_provider == "azure"){
                //     // slack channel id and teams webhook url
                //     channelID = ""
                //     webhookURL = "" 
                //    }
                //    else{
                //     // slack channel id and teams webhook url
                //     channelID = ""
                //     webhookURL = "" 
                //    }
                //    slackSend(color: "#00FF00", channel: channelID, message: "cluster provision/deprovision request received with \nJenkins job: ${env.BUILD_URL}")
                //    office365ConnectorSend color: "#00FF00", webhookUrl: webhookURL, message: "cluster provision/deprovision request received with \nJenkins job: ${env.BUILD_URL}"
                }
                }
            }
        }
        // keys rotation
        stage("Execute tasks"){
            steps{
            withFileParameter('CLUSTER_DATA'){
            script {
                sh """
                  cat ${CLUSTER_DATA}
                  export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                  export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                  cd ${deployDir} && python3 csf_gateway.py --cluster_data ${CLUSTER_DATA} --actions $TASKS
                """
                
                }
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

