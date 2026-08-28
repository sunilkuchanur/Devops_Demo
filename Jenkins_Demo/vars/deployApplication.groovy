def call(String environment) {

    stage("Build - ${environment}") {
        echo "Building application for ${environment}"
    }

    stage("Test - ${environment}") {
        echo "Running tests for ${environment}"
    }

    stage("Deploy - ${environment}") {
        echo "Deploying application to ${environment}"
    }
}