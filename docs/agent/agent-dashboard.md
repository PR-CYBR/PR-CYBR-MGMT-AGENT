<!-- 
Key Objectives for this Document:
1. Outline the purpose and functionality of the Agent Dashboard.
2. Define the core components of the dashboard, including its UI/UX, integrations, and interactivity.
3. Provide a framework for deploying and maintaining the frontend dashboard effectively.
-->

# Overview of Agent Dashboard – Frontend

## Overview

The `Agent Dashboard` serves as an interactive platform for users to engage with various agents within the `PR-CYBR-[agent-name]-AGENT` container. It is designed to provide a user-friendly interface for communication, data visualization, and agent-specific operations.

---

## Key Components

<!-- 
Key Points to highlight about Key Components:
1. Highlight the major components of the dashboard, including chat interface, interactive map, and agent sidebar.
2. Detail their specific functionalities and how they contribute to the user experience.
3. Provide technical insights into implementation details, such as libraries or frameworks used.
-->

### Chat Interface
- **Functionality**:
  - Enables real-time communication with agents.
  - Provides dynamic responses based on the selected agent's capabilities.
- **Design**:
  - Integrated within the dashboard layout for seamless use.
  - Responsive for both desktop and mobile devices.

### Interactive Map
- **Technology**:
  - Built with Leaflet.js and MapBox API.
  - Styled based on user picked UI/UX theme during setup of Agent
- **Features**:
  - Displays geospatial data relevant to PR-CYBR operations. (map elements such as POI (Points-of-interest) relevant to Cybersecurity, threat intelligence, natural disasters, power outages, and other threats to public safty)
  - Includes search functionality and real-time updates for geographical insights.

### Agent Sidebar
- **Functionality**:
  - Lists available agents with an option to switch or interact.
  - Displays real-time agent statuses and activity logs.
- **Customization**:
  - Users can personalize the sidebar layout, rearranging agent lists or adding shortcuts.

---

## Deployment Strategy

<!-- 
Key Points to highlight for Deployment Strategy:
1. Provide clear deployment steps for the frontend dashboard.
2. Include containerized deployment instructions for Docker environments.
3. Ensure compatibility and scalability in deployment methods.
-->

### Containerized Deployment
1. Build the dashboard Docker image:
```bash
docker build -t pr-cybr-dashboard 
```
2. Run the container:
```bash
docker run -p 8080:80 pr-cybr-dashboard
```
3. Access the dashboard via http://localhost:8080

## User Experience (UI/UX)

<!-- 
Key Points for User Experience (UI/UX):
1. Dashboard should be responsive and seemless regardless of view from computer or mobile
2. The theme that the user picked during the installation / setup phase, should be the theme that is applied and used for the Agent's Dashboard UI/UX
3. There should be clear instructions and an option to change theme that the user can user / find , and apply at any time. (requires container restart)
-->

**Responsive Design**

	•	Desktop View: Features a dual-pane layout with the map on one side and chat on the other.
	•	Mobile View: Offers a collapsible menu for easy navigation and a pop-up chat interface.

**Accessibility Features**

	•	Keyboard navigation and ARIA roles for screen reader compatibility.
	•	Adjustable font sizes and high-contrast modes for visually impaired users.

---

## Advanced Features

<!-- 
Key Points for Advanced Features:
1. Music should be loaded and autoplayed as soon as the Dashboard is loaded
2. Ability to chat to discord text channel 
3. Ability to chat in slack text channel
4. TAK Mission Package Builder Page / Popup  (allows for export)
5. Threat Intel Feed: Page with RSS Feed
-->

**Notifications**

	•	Real-time alerts for agent activities and updates.
	•	Users can configure alert preferences for personalized notifications.

**Background Music**

	•	Synthwave playlist integrated with the dashboard for a unique ambient experience.
	•	Users can manage playback via a music player interface styled in a retro theme.

---

## Troubleshooting and Support

<!-- 
Key Points for Troubleshooting and Support:
1. Provide a list of common issues users might face and their solutions.
2. Include links to relevant support resources or documentation. (such as Agent specific links)
3. Ensure this section empowers users to resolve minor problems independently. (reference Wiki and Discussion Board)
-->

**Common Issues**

	•	Error: Dashboard not loading
	•	Solution: Check if the Docker container is running and accessible via the correct port.
	•	Map does not display data
	•	Solution: Verify API keys for MapBox and data feed integrations.

**Support Resources**

	•	Official Documentation: [Link to wiki or README]
	•	Community Forum: [Link to discussion board]

## Notes and References

<!-- 
Key Points for Notes and References:
1. Include links to related documentation or external libraries used. (agent specific)
2. Provide references for APIs and tools integrated into the dashboard.
3. Document best practices for extending or maintaining the dashboard. (mention steps to apply changes to docker container and re-deploy)
-->

•	APIs Used:
	•	OpenAI API for chat functionality.
	•	MapBox API for interactive mapping.
•	Frameworks:
	•	React.js for frontend components.
	•	Leaflet.js for geospatial visualization.