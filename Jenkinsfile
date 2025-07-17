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
    stage('Terraform Init') {
      steps {
        bat 'terraform init'
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
