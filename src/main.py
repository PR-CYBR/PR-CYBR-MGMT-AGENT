from agent_logic.core_functions import AgentCore
from shared.utils import setup_logging, validate_environment_variables
import os
import sys

def main():
    # Set up logging
    setup_logging()

    # Define required environment variables
    required_vars = ["ASSISTANT_ID"]

    # Validate environment variables
    try:
        validate_environment_variables(required_vars)
    except EnvironmentError as e:
        print(f"Error: {e}")
        sys.exit(1)  # Exit the program with an error code

    # Retrieve the Assistant ID from environment variables
    agent_id = os.getenv("ASSISTANT_ID")
    print(f"Initializing PR-CYBR-MGMT-AGENT with ID: {agent_id}")

    # Create an instance of the AgentCore
    agent = AgentCore(agent_id=agent_id)

    # Run the agent's main functionality
    agent.run()

if __name__ == "__main__":
    main()