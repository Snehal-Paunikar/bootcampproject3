pipeline {
  agent any

  environment {
    // Azure Service Principal credentials stored in Jenkins
    ARM_CLIENT_ID       = credentials('terraform-client-id')
    ARM_CLIENT_SECRET   = credentials('terraform-client-secret')
    ARM_SUBSCRIPTION_ID = credentials('terraform-subscription-id')
    ARM_TENANT_ID       = credentials('terraform-tenant-id')  // ✅ FIXED typo
  }

stages {

    stage('Select Backend File') {
      steps {
        script {
          if (env.BRANCH_NAME == 'staging') {
            bat 'copy backend-staging.tf backend.tf'
          } else if (env.BRANCH_NAME == 'production') {
            bat 'copy backend-production.tf backend.tf'
          } else {
            error("Unsupported branch: ${env.BRANCH_NAME}")
          }
        }
      }
    }

  stages {
    stage('Prepare Backend') {
      steps {
        script {
          def backendFile = "backend-${env.BRANCH_NAME}.tf"
          if (!fileExists(backendFile)) {
            error "Missing backend file: ${backendFile}"
          }
          // Delete any existing backend.tf and copy the branch-specific backend file
          bat 'if exist backend.tf del backend.tf'
          bat "copy ${backendFile} backend.tf"
        }
      }
    }

    stage('Terraform Init') {
      steps {
        // Reinitialize terraform with the new backend.tf file
        bat 'terraform init -reconfigure'
      }
    }

    stage('Terraform Validate') {
      steps {
        bat 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      steps {
        script {
          def tfvarsFile = "${env.BRANCH_NAME}.tfvars"
          if (!fileExists(tfvarsFile)) {
            error "Missing file: ${tfvarsFile}"
          }
          bat "terraform plan -var-file=${tfvarsFile}"
        }
      }
    }

    stage('Terraform Apply') {
      when {
        anyOf {
          branch 'staging'
          branch 'production'
        }
      }
      steps {
        input message: "Deploy to ${env.BRANCH_NAME.toUpperCase()} environment?"
        script {
          def tfvarsFile = "${env.BRANCH_NAME}.tfvars"
          if (!fileExists(tfvarsFile)) {
            error "Missing file: ${tfvarsFile}"
          }
          bat "terraform apply -auto-approve -var-file=${tfvarsFile}"
        }
      }
    }
  } // 👈 this was missing
}     // 👈 this closes the `pipeline {}` block
