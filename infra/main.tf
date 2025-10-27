terraform {
  required_version = ">= 1.5.0"
}

locals {
  orchestrator_identity = {
    agent_code  = "PR-CYBR-MGMT-AGENT"
    description = "Central orchestration and synchronization controller"
  }
}
