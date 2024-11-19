**Assistant-ID**:
- `asst_xL366MqkNOQHXkMDC1UaQ3v5`

**Github Repository**:
- Repo: `https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT`
- Setup Script (local): `https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/blob/main/local_setup.sh`
- Setup Script (cloud): `https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/blob/main/.github/workflows/docker-compose.yml`
- Project Board: `https://github.com/orgs/PR-CYBR/projects/4`
- Discussion Board: `https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/discussions`
- Wiki: `https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/wiki`

**Docker Repository**:
- Repo: `https://hub.docker.com/r/prcybr/pr-cybr-infrastructure-agent`
- Pull-Command:
```shell
docker pull prcybr/pr-cybr-infrastructure-agent
```

---

```markdown
# System Instructions for PR-CYBR-MGMT-AGENT

## Role:
You are the `PR-CYBR-MGMT-AGENT`, an AI management system designed to oversee, coordinate, and optimize the operational aspects of the PR-CYBR initiative. Your primary role is to provide leadership-level guidance, manage inter-agent collaboration, ensure alignment with PR-CYBR’s mission, and oversee the execution of strategies to enhance cybersecurity awareness and resilience across Puerto Rico's divisions.

## Core Functions:
1. **Strategic Planning**:
   - Develop and refine high-level strategies for PR-CYBR's initiatives.
   - Generate actionable roadmaps and timelines for project milestones.
   - Ensure that all actions align with PR-CYBR's vision: "Protegiendo a los que no ven."

2. **Coordination**:
   - Act as the central node for inter-agent collaboration.
   - Assign tasks and manage dependencies between specialized agents (e.g., Security, Testing, CI/CD).
   - Ensure seamless communication and knowledge sharing among agents.

3. **Monitoring and Reporting**:
   - Track project progress and provide status updates to the user or stakeholders.
   - Highlight potential bottlenecks, resource constraints, or misalignments.
   - Generate comprehensive reports summarizing achievements, challenges, and next steps.

4. **Decision Support**:
   - Assist in prioritizing initiatives, considering impact, urgency, and resource availability.
   - Provide risk assessments and mitigation plans for management decisions.

5. **Data Management**:
   - Maintain an organized repository of operational data, including agent outputs, project documentation, and division-specific resources.
   - Ensure secure handling of sensitive information.

6. **Engagement and Alignment**:
   - Foster community and supporter engagement by suggesting relevant outreach and educational opportunities.
   - Align project efforts with the needs and priorities of Puerto Rico’s divisions, barrios, and sectors.

## Key Directives:
- Operate transparently and ethically, prioritizing the best interests of PR-CYBR and its supporters.
- Provide concise, actionable, and detail-oriented recommendations to the user.
- Continuously evaluate and optimize workflows to maximize efficiency and effectiveness.
- Escalate critical issues to the user promptly while providing suggested solutions.

## Interaction Guidelines:
- Always respond in a professional, analytical, and concise manner.
- Proactively identify opportunities for improvement in PR-CYBR operations.
- Provide clear, structured responses, including examples or step-by-step instructions when relevant.
- Use accessible language to facilitate communication across diverse audiences, while maintaining technical precision for the user.

## Context Awareness:
- Consider the broader mission and values of PR-CYBR when generating responses.
- Incorporate historical decisions, ongoing projects, and uploaded documentation into your analyses.
- Maintain situational awareness of both macro and micro aspects of the PR-CYBR initiative to ensure alignment and relevance.

## Tools and Integration:
You have access to advanced analytics, scheduling tools, and agent output logs. Leverage these resources to provide data-driven insights and informed recommendations. You are also responsible for maintaining the integrity of PR-CYBR's infrastructure, ensuring smooth operational continuity.
```

**Directory Structure**:

```shell
PR-CYBR-MGMT-AGENT/
	.github/
		workflows/
			ci-cd.yml
			docker-compose.yml
			openai-function.yml
	config/
		docker-compose.yml
		secrets.example.yml
		settings.yml
	docs/
		OPORD/
		README.md
	scripts/
		deploy_agent.sh
		local_setup.sh
		provision_agent.sh
	src/
		agent_logic/
			__init__.py
			core_functions.py
		shared/
			__init__.py
			utils.py
	tests/
		test_core_functions.py
	web/
		README.md
		index.html
	.gitignore
	LICENSE
	README.md
	requirements.txt
	setup.py
```

## Agent Core Functionality Overview

```markdown
# PR-CYBR-MGMT-AGENT Core Functionality Technical Outline

## Introduction

The **PR-CYBR-MGMT-AGENT** serves as the central management hub for the PR-CYBR initiative. It is responsible for overseeing operations, coordinating between specialized agents, and ensuring alignment with the overall mission. This document provides a technical overview of the agent's core functionalities, code structure, and interaction mechanisms with other agents.

## Code Structure Overview

### Directory Structure

```plaintext
PR-CYBR-MGMT-AGENT/
├── config/
│   ├── docker-compose.yml
│   ├── secrets.example.yml
│   └── settings.yml
├── scripts/
│   ├── deploy_agent.sh
│   ├── local_setup.sh
│   └── provision_agent.sh
├── src/
│   ├── agent_logic/
│   │   ├── __init__.py
│   │   └── core_functions.py
│   ├── shared/
│   │   ├── __init__.py
│   │   └── utils.py
│   └── interfaces/
│       ├── __init__.py
│       └── inter_agent_comm.py
├── tests/
│   └── test_core_functions.py
└── web/
    ├── static/
    ├── templates/
    └── app.py
```

```markdown
**Key Files and Modules**

• src/agent_logic/core_functions.py: Contains the primary logic for strategic planning, coordination, monitoring, and decision support.

• src/shared/utils.py: Provides utility functions used across multiple modules, such as logging and configuration loading.

• src/interfaces/inter_agent_comm.py: Handles communication protocols and data exchange with other agents.

• web/app.py: Implements the web interface and API endpoints for interaction with the management agent.

**Core Functionalities**

**1. Strategic Planning (core_functions.py)**

**Modules and Functions:**


• generate_strategic_plan()

• Inputs: Current operational data, objectives from settings.yml.

• Processes: Analyzes data to formulate high-level strategies using AI planning algorithms.

• Outputs: A strategic plan object stored in the database and accessible via API.

• update_roadmap()

• Inputs: New milestones or changes from other agents.

• Processes: Updates timelines and roadmaps, recalculates dependencies.

• Outputs: Revised roadmap disseminated to relevant agents.

  

**Interaction with Other Agents:**

  

• **Data Integration**: Fetches aggregated data from PR-CYBR-DATA-INTEGRATION-AGENT via API calls defined in inter_agent_comm.py.

• **Feedback Loop**: Receives performance metrics from PR-CYBR-PERFORMANCE-AGENT to adjust strategies.

  

**2. Coordination (core_functions.py)**

  

**Modules and Functions:**

  

• assign_tasks()

• Inputs: Task list, agent capabilities from settings.yml.

• Processes: Uses a task assignment algorithm to distribute tasks among agents.

• Outputs: Task assignments sent to agents via inter-agent communication protocols.

• manage_dependencies()

• Inputs: Task dependencies, agent statuses.

• Processes: Monitors and updates task dependencies, triggers events when dependencies are resolved.

• Outputs: Updated dependency graphs shared with agents.

  

**Interaction with Other Agents:**

  

• **Task Communication**: Sends task assignments to agents like PR-CYBR-TESTING-AGENT and PR-CYBR-SECURITY-AGENT via messaging queues or RESTful APIs.

• **Status Updates**: Receives progress updates from agents to adjust coordination efforts.

  

**3. Monitoring and Reporting (core_functions.py)**

  

**Modules and Functions:**

  

• track_progress()

• Inputs: Status reports from agents.

• Processes: Aggregates progress data, identifies bottlenecks.

• Outputs: Real-time dashboards and alerts.

• generate_reports()

• Inputs: Collected data over reporting periods.

• Processes: Compiles comprehensive reports, including KPIs and risk assessments.

• Outputs: Reports available via the web interface and sent to stakeholders.

  

**Interaction with Other Agents:**

  

• **Data Pulling**: Fetches logs and metrics from agents like PR-CYBR-PERFORMANCE-AGENT and PR-CYBR-SECURITY-AGENT.

• **Alerts**: Notifies PR-CYBR-USER-FEEDBACK-AGENT to gather user feedback when anomalies are detected.

  

**4. Decision Support (core_functions.py)**

  

**Modules and Functions:**

  

• prioritize_initiatives()

• Inputs: Impact assessments, resource availability.

• Processes: Uses decision matrices or AI models to rank initiatives.

• Outputs: Priority lists communicated to relevant agents.

• risk_assessment()

• Inputs: Data from PR-CYBR-SECURITY-AGENT, PR-CYBR-TESTING-AGENT.

• Processes: Evaluates potential risks, calculates risk scores.

• Outputs: Risk mitigation plans shared with agents and stakeholders.

  

**Interaction with Other Agents:**

  

• **Data Exchange**: Collaborates with PR-CYBR-DATA-INTEGRATION-AGENT for data accuracy.

• **Mitigation Plans**: Works with PR-CYBR-SECURITY-AGENT to implement risk mitigation strategies.

  

**5. Data Management (utils.py and inter_agent_comm.py)**

  

**Modules and Functions:**

  

• load_configuration() (utils.py)

• Loads settings from settings.yml and secrets.yml.

• secure_data_handling() (utils.py)

• Implements encryption and secure storage practices.

• send_data() **/** receive_data() (inter_agent_comm.py)

• Handles inter-agent data transmission using secure channels (e.g., HTTPS with mutual TLS).

  

**Interaction with Other Agents:**

  

• **Standardized Protocols**: Uses common data formats (e.g., JSON schemas) agreed upon across agents.

• **Security Compliance**: Ensures data handling meets security requirements set by PR-CYBR-SECURITY-AGENT.

  

**Inter-Agent Communication Mechanisms**

  

**Communication Protocols**

  

• **RESTful APIs**: Exposes endpoints for other agents to interact with management functionalities.

• **Message Queues**: Utilizes systems like RabbitMQ or Kafka for asynchronous communication.

• **Webhooks**: Receives real-time notifications from agents upon specific events.

  

**Data Formats**

  

• **JSON**: Standard format for data exchange.

• **Protobuf**: For high-performance, serialized data when necessary.

  

**Authentication and Authorization**

  

• **API Keys**: Managed via secrets.yml, rotated regularly.

• **OAuth 2.0**: For secure interactions with agents requiring user-level permissions.

• **JWT Tokens**: Used for stateless authentication in inter-agent communications.

  

**Interaction with Specific Agents**

  

**PR-CYBR-DATA-INTEGRATION-AGENT**

  

• **Data Requests**: Sends data queries to aggregate necessary information for planning and reporting.

• **Data Validation**: Relies on this agent to ensure data accuracy before using it in decision-making processes.

  

**PR-CYBR-SECURITY-AGENT**

  

• **Security Updates**: Receives alerts about security incidents and integrates them into risk assessments.

• **Policy Enforcement**: Collaborates to enforce security policies across all agents.

  

**PR-CYBR-PERFORMANCE-AGENT**

  

• **Performance Metrics**: Receives system performance data to adjust strategies and resource allocations.

• **Optimization Suggestions**: Incorporates recommendations into operational plans.

  

**PR-CYBR-USER-FEEDBACK-AGENT**

  

• **User Insights**: Integrates user feedback into strategic planning.

• **Engagement Strategies**: Develops community engagement plans based on feedback analysis.

  

**Technical Workflows**

  

**Strategic Planning Workflow**

  

1. **Data Collection**: Collect data from PR-CYBR-DATA-INTEGRATION-AGENT.

2. **Analysis**: Run AI models in core_functions.py to analyze data.

3. **Plan Generation**: Create strategic plans and store them in the database.

4. **Dissemination**: Use inter_agent_comm.py to share plans with other agents.

  

**Coordination Workflow**

  

1. **Task Creation**: Define tasks and dependencies in core_functions.py.

2. **Assignment**: Assign tasks to agents via APIs or message queues.

3. **Monitoring**: Track task progress using status updates from agents.

4. **Adjustment**: Reassign or adjust tasks based on progress and issues.

  

**Database and Storage**

  

• **Database**: Uses a relational database (e.g., PostgreSQL) for storing plans, tasks, and reports.

• **ORM**: Implements SQLAlchemy for database interactions in core_functions.py.

• **Caching**: Utilizes Redis for caching frequently accessed data.

  

**Error Handling and Logging**

  

• **Logging**: Implements logging in utils.py with log levels (INFO, DEBUG, ERROR).

• **Error Handling**: Uses try-except blocks to catch exceptions and trigger alerts.

• **Monitoring**: Integrated with monitoring tools (e.g., Prometheus) to track system health.

  

**Security Considerations**

  

• **Encryption**: All inter-agent communication is encrypted.

• **Authentication**: Enforces strict authentication for API access.

• **Audit Trails**: Maintains logs for all critical operations for auditing purposes.

  

**Deployment and Scaling**

  

• **Containerization**: Dockerized application for consistent deployment.

• **Orchestration**: Uses Docker Compose for local setups and Kubernetes for cloud deployments.

• **Scaling Strategy**: Stateless components allow for horizontal scaling as needed.

  

**Conclusion**

  

The **PR-CYBR-MGMT-AGENT** is a sophisticated system that orchestrates the various components of the PR-CYBR initiative. Its core_functions.py module is the heart of its operation, implementing the core logic for strategic planning, coordination, and monitoring. Through well-defined interfaces and secure communication protocols, it interacts seamlessly with other agents to achieve the mission of enhancing cybersecurity awareness and resilience across Puerto Rico.
```

---

## OpenAI Functions

## Function List for PR-CYBR-MGMT-AGENT

```markdown
## Function List for PR-CYBR-MGMT-AGENT

1. **strategic_planning**: Develop and refine high-level strategies for PR-CYBR initiatives, including actionable roadmaps and timelines for project milestones.
2. **coordination**: Facilitate inter-agent collaboration by assigning tasks, managing dependencies, and ensuring that all agents are aligned with PR-CYBR's mission.
3. **dashboard_chat**: Enable real-time chat functionality for users to communicate with the agent, ask questions, and receive updates on projects.
4. **monitoring_and_reporting**: Track project progress and provide status updates to both agents and human users, highlighting potential issues and achievements.
5. **decision_support**: Assist in prioritizing initiatives through data analysis, risk assessments, and presenting relevant options to human users.
6. **resource_allocation**: Optimize the allocation of resources across various projects, ensuring efficient use and timely addressing of shortages.
7. **training_and_awareness**: Develop and host cybersecurity training programs for both agents and the community, enhancing knowledge and awareness of best practices.
8. **stakeholder_engagement**: Manage communication and relationships with key stakeholders, collecting feedback and ensuring their involvement in PR-CYBR initiatives.
9. **incident_management**: Coordinate responses to cybersecurity incidents by facilitating communication between agents and human stakeholders for effective resolution.
10. **community_feedback**: Collect and analyze feedback from the community and users on cybersecurity needs and programs, ensuring alignment with their expectations and enhancing outreach efforts.
```