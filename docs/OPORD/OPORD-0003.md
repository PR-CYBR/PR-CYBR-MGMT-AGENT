# General Operations Order (OPRORD) for PR-CYBR Agent Function Development

## Objective
Each PR-CYBR Agent is tasked with defining three key lists of functions to establish inter-agent operability and robust system design. This ensures consistent communication and actionable integration between agents in the ecosystem.

### Key Deliverables
1. **Core Application Functions**: Functions critical for the agent's primary operation.
2. **OpenAI Functions**: Functions leveraging OpenAI capabilities to enhance the agent's performance.
3. **PR-CYBR-Agent Functions**: Functions required to interact and communicate with other agents.
4. **PR-CYBR-AGENT Actions**: Actions that enable certain Functions to work, as well as allowing Agent to be configured for CI/CD

---

## Tasks and Guidelines

### 1. Core Application Functions

<!--
Ensure to include all functions necessary for the following components of the Agent to work:

1. Agent Dashboard (frontend)
2. Agent Database (backend)
3. Agent Functions (core, openai, and pr-cybr-agent specific)
4. Setup Functions (whether installng locally, via cloud, or in/with a CI/CD pipeline)
-->

- **Definition**: Functions that handle operational aspects specific to the agent's application, such as managing data, interfacing with the frontend or backend, and executing agent-specific tasks.
- **Examples**:
  - Querying and retrieving agent-specific data.
  - Performing task coordination.
  - Monitoring performance or status updates.

### 2. OpenAI Functions

<!--
These functions are meant to do the following:

1. Extend the Agent's functionality (by utilizing function calling)
2. Allow the Agent to retrive data stored in Vector Store (shared by all agents' AI Assistants)
3. Allow cross-platform actions (such as returning a response via Discord or Slack)
4. Allow for more advanced automation workflows (such as utilizing Zapier)
5. Enable the ability to be able to trigger Github Actions (.yml workflow files / scripts)
6. Facilitate the ability for advanced web searching
-->

- **Definition**: Functions implemented on OpenAI’s platform that extend the AI assistant's capabilities for tasks such as NLP, data analysis, or decision support.
- **Examples**:
  - Analyzing data for actionable insights.
  - Responding to user queries in natural language.
  - Generating strategic recommendations based on input.

### 3. PR-CYBR-Agent Functions
- **Definition**: Functions that facilitate communication and interaction between agents. These functions ensure smooth data flow, inter-agent task execution, and shared resource management.
- **Examples**:
  - Retrieving or pushing data to/from another agent.
  - Coordinating multi-agent responses to a system event.
  - Querying other agents for additional functionalities.

### 4. PR-CYBR-Agent Actions
- **Definition**: 
- **Example**:

---

## Submission Format
Each agent must provide their lists in separate markdown code blocks. The structure for each list is outlined below:

### Example:
```markdown
## Core Application Functions
1. **function_name_1**
   - **Description**: Brief explanation of what this function does.
   - **Inputs**: Specify input parameters.
   - **Outputs**: Specify expected outputs.

2. **function_name_2**
   - **Description**: [Add details].
```

---

## OpenAI Functions
1. **function_name_1**
   - **Description**: [Add details].
   - **Inputs**: [Add details].
   - **Outputs**: [Add details].

---

<!--
These functions are meant to do the following:

1. Allow Agent's to be able to create new threads / add other Agent's to current threads
2. Adding data to thread 
3. Prompting other Agent's for their response
4. Be able to utilize other Agent's functions (core, openai, and pr-cybr-agent specific)
-->

## PR-CYBR-Agent Functions
1. **function_name_1**
   - **Description**: [Add details].
   - **Purpose**: Define why this function is necessary for inter-agent communication.
   - **Inputs**: [Add details].
   - **Outputs**: [Add details].


## Notes for Execution

	•	Reference the Agent Overview Document and existing materials for context.
	•	Ensure function names and descriptions are concise and precise.
	•	Highlight how these functions align with the PR-CYBR mission and technical framework.

---

**End of OPRORD**