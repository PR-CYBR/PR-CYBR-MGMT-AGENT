// Function to execute a specific agent function via API call
function executeFunction(endpoint) {
    fetch(`/api/${endpoint}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        // Display the status message from the server
        alert(data.status);
    })
    .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while executing the function.');
    });
}

// Function to apply a theme dynamically
function applyTheme(theme) {
    const root = document.documentElement;
    Object.keys(theme).forEach(variable => {
        root.style.setProperty(`--${variable}`, theme[variable]);
    });
}

// Example of applying a theme
const userTheme = {
    'primary-color': '#4CAF50',
    'secondary-color': '#FFC107',
    'background-color': '#f0f0f0',
    'text-color': '#333',
    'header-footer-bg-color': '#4CAF50',
    'button-bg-color': '#4CAF50',
    'button-hover-bg-color': '#388E3C'
};

// Apply the user's theme on page load
document.addEventListener('DOMContentLoaded', () => {
    applyTheme(userTheme);
});

// Additional interactivity can be added here