from flask import Flask, jsonify, request
from flask_cors import CORS
import logging
import os
from agent_logic.core_functions import AgentCore

# Initialize Flask application
app = Flask(__name__)

# Enable CORS to allow cross-origin requests
CORS(app)

# Configure logging for the application
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize the AgentCore with an environment variable or default ID
agent_id = os.getenv("ASSISTANT_ID", "asst_xL366MqkNOQHXkMDC1UaQ3v5")
agent = AgentCore(agent_id=agent_id)

@app.route('/')
def index():
    """
    Root endpoint to verify the API is running.
    Returns a welcome message.
    """
    return jsonify({"message": "Welcome to the PR-CYBR-MGMT-AGENT API"})

@app.route('/api/strategic-planning', methods=['POST'])
def strategic_planning():
    """
    Endpoint to trigger strategic planning.
    Executes the strategic planning function of the agent.
    """
    try:
        agent.strategic_planning()
        return jsonify({"status": "Strategic planning executed"})
    except Exception as e:
        logger.error(f"Error in strategic planning: {e}")
        return jsonify({"error": "Failed to execute strategic planning"}), 500

@app.route('/api/coordination', methods=['POST'])
def coordination():
    """
    Endpoint to trigger coordination.
    Executes the coordination function of the agent.
    """
    try:
        agent.coordination()
        return jsonify({"status": "Coordination executed"})
    except Exception as e:
        logger.error(f"Error in coordination: {e}")
        return jsonify({"error": "Failed to execute coordination"}), 500

@app.route('/api/dashboard-chat', methods=['POST'])
def dashboard_chat():
    """
    Endpoint for real-time chat functionality.
    Processes user input and returns the agent's response.
    """
    try:
        user_input = request.json.get('message')
        response = agent.dashboard_chat(user_input)
        return jsonify({"response": response})
    except Exception as e:
        logger.error(f"Error in dashboard chat: {e}")
        return jsonify({"error": "Failed to process chat message"}), 500

@app.route('/api/monitoring', methods=['GET'])
def monitoring():
    """
    Endpoint to get monitoring data.
    Retrieves monitoring data from the agent.
    """
    try:
        agent.monitoring_and_reporting()
        return jsonify({"status": "Monitoring data retrieved"})
    except Exception as e:
        logger.error(f"Error in monitoring: {e}")
        return jsonify({"error": "Failed to retrieve monitoring data"}), 500

@app.route('/api/decision-support', methods=['POST'])
def decision_support():
    """
    Endpoint to trigger decision support.
    Executes the decision support function of the agent.
    """
    try:
        agent.decision_support()
        return jsonify({"status": "Decision support executed"})
    except Exception as e:
        logger.error(f"Error in decision support: {e}")
        return jsonify({"error": "Failed to execute decision support"}), 500

@app.route('/api/resource-allocation', methods=['POST'])
def resource_allocation():
    """
    Endpoint to optimize resource allocation.
    Executes the resource allocation function of the agent.
    """
    try:
        agent.resource_allocation()
        return jsonify({"status": "Resource allocation executed"})
    except Exception as e:
        logger.error(f"Error in resource allocation: {e}")
        return jsonify({"error": "Failed to execute resource allocation"}), 500

@app.route('/api/training-and-awareness', methods=['POST'])
def training_and_awareness():
    """
    Endpoint to develop and host training programs.
    Executes the training and awareness function of the agent.
    """
    try:
        agent.training_and_awareness()
        return jsonify({"status": "Training and awareness executed"})
    except Exception as e:
        logger.error(f"Error in training and awareness: {e}")
        return jsonify({"error": "Failed to execute training and awareness"}), 500

@app.route('/api/stakeholder-engagement', methods=['POST'])
def stakeholder_engagement():
    """
    Endpoint to manage stakeholder communication.
    Executes the stakeholder engagement function of the agent.
    """
    try:
        agent.stakeholder_engagement()
        return jsonify({"status": "Stakeholder engagement executed"})
    except Exception as e:
        logger.error(f"Error in stakeholder engagement: {e}")
        return jsonify({"error": "Failed to execute stakeholder engagement"}), 500

@app.route('/api/incident-management', methods=['POST'])
def incident_management():
    """
    Endpoint to coordinate incident management.
    Executes the incident management function of the agent.
    """
    try:
        agent.incident_management()
        return jsonify({"status": "Incident management executed"})
    except Exception as e:
        logger.error(f"Error in incident management: {e}")
        return jsonify({"error": "Failed to execute incident management"}), 500

@app.route('/api/community-feedback', methods=['POST'])
def community_feedback():
    """
    Endpoint to collect and analyze community feedback.
    Processes feedback provided by the user.
    """
    try:
        feedback = request.json.get('feedback')
        agent.community_feedback(feedback)
        return jsonify({"status": "Community feedback processed"})
    except Exception as e:
        logger.error(f"Error in community feedback: {e}")
        return jsonify({"error": "Failed to process community feedback"}), 500

@app.route('/api/theme-customization', methods=['POST'])
def theme_customization():
    """
    Endpoint to handle theme customization requests.
    Customizes the theme based on user input.
    """
    try:
        theme_description = request.json.get('theme_description')
        agent.customize_theme(theme_description)
        return jsonify({"status": "Theme customization initiated"})
    except Exception as e:
        logger.error(f"Error in theme customization: {e}")
        return jsonify({"error": "Failed to customize theme"}), 500

if __name__ == '__main__':
    # Run the Flask application
    # In production, use a WSGI server like Gunicorn
    app.run(host='0.0.0.0', port=5000)