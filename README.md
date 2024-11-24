<!--
Updates to make:
1. Update build workflow
2. 
-->

# PR-CYBR-MGMT-AGENT

## Overview

The `PR-CYBR-MGMT-AGENT` is the central coordinator within the PR-CYBR ecosystem, managing interactions, workflows, and resource allocation across other agents. It leverages GitHub Actions and provides scripts for local setup, cloud deployment, and building from source.

## Key Features

- **Workflow Management**: Automates task coordination across agents.
- **Resource Optimization**: Monitors agent performance for efficient operations.
- **Scalability**: Facilitates seamless integration of new agents into the ecosystem.

## Getting Started

### Prerequisites

- **Git**: For cloning the repository.
- **Docker**: Required for containerization and deployment.
- **Python 3.8+**: Necessary for running scripts locally.
- **Access to GitHub Actions**: For automated workflows.

### Local Setup

To set up the `PR-CYBR-MGMT-AGENT` locally on your machine:

1. **Clone the Repository**

```bash
git clone https://github.com/yourusername/PR-CYBR-MGMT-AGENT.git
cd PR-CYBR-MGMT-AGENT
```

2.	**Run Local Setup Script**

```bash
./scripts/local_setup.sh
```
_This script will install necessary dependencies and set up the local environment._

3. **Provision the Agent**

```bash
./scripts/provision_agent.sh
```
_This script configures the agent with default settings for local development._

### Build from Source

Alternatively, you can build the agent from source using the provided setup script:

1. **Clone the Repository** (if not already done)

2. **Install Dependencies**

```bash
pip install -r requirements.txt
```

3. **Run Setup Script**

```bash
python setup.py install
```
_This installs the agent as a Python package on your system._

### Cloud Deployment

To deploy the agent to a cloud environment:

1. **Configure Repository Secrets**

- Navigate to `Settings` > `Secrets and variables` > `Actions` in your GitHub repository.
- Add the required secrets:
   - `CLOUD_API_KEY`
   - `DOCKERHUB_USERNAME`
   - `DOCKERHUB_PASSWORD`
- Any other cloud-specific credentials.

2. **Deploy Using GitHub Actions**

- The deployment workflow is defined in `.github/workflows/docker-compose.yml`.
- Push changes to the `main` branch to trigger the deployment workflow automatically.

3. **Manual Deployment**

- Use the deployment script for manual deployment:

```bash
./scripts/deploy_agent.sh
```

- Ensure you have Docker and cloud CLI tools installed and configured on your machine.

## Integration

The `PR-CYBR-MGMT-AGENT` integrates with other PR-CYBR agents to provide centralized management and reporting. It communicates with agents like `PR-CYBR-SECURITY-AGENT` and `PR-CYBR-DATA-INTEGRATION-AGENT` to maintain system-wide efficiency.

## Usage

- **Trigger Workflows**

  - Workflows can be triggered manually or by events such as pushing code to the repository.
  - Use GitHub Actions or local scripts to manage and execute agent workflows.

- **Monitor Performance**

  - The agent provides monitoring features to keep track of resource usage and performance metrics.

## License

This project is licensed under the **MIT License**. See the [`LICENSE`](LICENSE) file for details.

---

For more information, refer to the [GitHub Actions Documentation](https://docs.github.com/en/actions) or contact the PR-CYBR team.
