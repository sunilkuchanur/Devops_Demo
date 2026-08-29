Jenkins – Automation, Reusability and Maintainability

Jenkins is an automation server used to automate CI/CD processes such as building, testing, and deploying applications.

A major advantage of Jenkins is that we can combine a Jenkinsfile with Shared Libraries to make pipelines automated, reusable, and maintainable.

Repository Structure

Jenkins Demo/
├── vars/
│   └── deployApplication.groovy
└── Jenkinsfile

Jenkinsfile

The Jenkinsfile defines the pipeline flow.

It contains the stages and controls the overall CI/CD process.

vars/deployApplication.groovy

The vars directory is used for Jenkins Shared Library global steps.

deployApplication.groovy contains reusable deployment logic that can be called from the Jenkinsfile.

1. Automation

Jenkins automates the CI/CD process so that developers do not need to manually perform every step.

A typical flow is:

Developer
    ↓
Git Push
    ↓
Jenkins Trigger
    ↓
Build
    ↓
Test
    ↓
Deploy

Instead of manually executing commands for every deployment, Jenkins executes the pipeline automatically.

Example Jenkinsfile

pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building application'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests'
            }
        }

        stage('Deploy') {
            steps {
                deployApplication()
            }
        }
    }
}

The pipeline automatically executes the defined stages.

2. Reusability

Jenkins Shared Libraries allow us to write common pipeline logic once and reuse it across multiple Jenkins pipelines.

Instead of writing the same deployment code in every Jenkinsfile, we can move the common logic into:

vars/deployApplication.groovy

deployApplication.groovy

def call() {
    echo 'Deploying application'
    // Deployment commands
}

The Jenkinsfile can then simply call:

deployApplication()

The same shared function can be reused by multiple applications.

                 Shared Library
                      │
             deployApplication()
                      │
          ┌───────────┼───────────┐
          ↓           ↓           ↓
     Application A  Application B  Application C
       Jenkinsfile    Jenkinsfile    Jenkinsfile

This avoids duplicating the same deployment logic in every pipeline.

3. Maintainability

Shared Libraries improve maintainability because common pipeline logic is maintained in one central location.

Without Shared Libraries:

Jenkinsfile A → Deployment Logic
Jenkinsfile B → Deployment Logic
Jenkinsfile C → Deployment Logic

If the deployment process changes, we may need to modify multiple Jenkinsfiles.

With Shared Libraries:

Jenkinsfile A ──┐
Jenkinsfile B ──┼──→ deployApplication.groovy
Jenkinsfile C ──┘

If the deployment logic needs to be changed, we can update the shared library instead of modifying every pipeline individually.

This reduces code duplication and makes the CI/CD implementation easier to maintain.

Complete Example

Jenkinsfile

pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building application'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests'
            }
        }

        stage('Deploy') {
            steps {
                deployApplication()
            }
        }
    }
}

vars/deployApplication.groovy

def call() {
    echo 'Starting application deployment'

    // Deployment logic goes here
    // Example:
    // sh 'kubectl apply -f deployment.yaml'

    echo 'Application deployment completed'
}

Automation + Reusability + Maintainability

                    Jenkins
                       │
                       ↓
                 Jenkinsfile
                       │
                       ↓
              Shared Library
                       │
                       ↓
          deployApplication.groovy
                       │
          ┌────────────┼────────────┐
          ↓            ↓            ↓
      Automation   Reusability  Maintainability
          │            │            │
          ↓            ↓            ↓
       CI/CD       Common logic    Centralized
       process      reused across    logic
                    pipelines

Why Use Shared Libraries?

Without Shared Library

Each Jenkinsfile may contain:

Build logic
Test logic
Deployment logic
Notification logic
Infrastructure logic

This can result in:

Duplicate code

Large Jenkinsfiles

Difficult maintenance

Changes required in multiple repositories

With Shared Library

Common functionality can be moved into reusable functions:

deployApplication()
buildApplication()
sendNotification()
runTests()

The Jenkinsfile then focuses mainly on the pipeline flow.

Key Benefits

Feature

Benefit

Automation

Automatically executes CI/CD tasks

Reusability

Common pipeline logic can be reused

Maintainability

Changes can be made centrally

Consistency

Multiple pipelines follow the same process

Less Duplication

Avoids copying the same code

Cleaner Jenkinsfile

Pipeline focuses on workflow rather than implementation details

Presentation Explanation

Jenkins provides automation by executing the CI/CD pipeline automatically through a Jenkinsfile. For reusability, we can use Jenkins Shared Libraries to move common functionality into reusable functions such as deployApplication(). In our example, the deployment logic is stored in vars/deployApplication.groovy, while the Jenkinsfile simply calls the reusable function. This also improves maintainability because if the deployment logic changes, we can update it in one central location instead of modifying multiple Jenkinsfiles.

Jenkinsfile vs Shared Library

Jenkinsfile
    ↓
Defines WHAT should happen
    ↓
Pipeline flow

Shared Library
    ↓
Defines HOW common tasks should happen
    ↓
Reusable implementation

For example:

stage('Deploy') {
    steps {
        deployApplication()
    }
}

The Jenkinsfile says:

"Deploy the application"

While:

vars/deployApplication.groovy

contains the actual reusable deployment implementation.

Final Summary

Jenkins Shared Libraries help us achieve three important goals:

Automation

Jenkins automatically executes the defined CI/CD pipeline.

Reusability

Common functions such as deployment can be written once and reused across multiple pipelines.

Maintainability

Common logic is centralized, reducing duplication and making future changes easier.

Jenkinsfile
     +
Shared Library
     ↓
Automation
     +
Reusability
     +
Maintainability
     ↓
Scalable CI/CD Pipeline
