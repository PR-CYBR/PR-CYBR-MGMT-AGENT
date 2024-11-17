// Function to update the theme based on user input
function updateTheme(themeSettings) {
    const root = document.documentElement;
    Object.keys(themeSettings).forEach(variable => {
        root.style.setProperty(`--${variable}`, themeSettings[variable]);
    });
    saveThemeSettings(themeSettings);
}

// Function to save theme settings to local storage
function saveThemeSettings(themeSettings) {
    localStorage.setItem('userTheme', JSON.stringify(themeSettings));
}

// Function to load theme settings from local storage
function loadThemeSettings() {
    const savedTheme = localStorage.getItem('userTheme');
    if (savedTheme) {
        const themeSettings = JSON.parse(savedTheme);
        updateTheme(themeSettings);
    }
}

// Function to reset theme to default
function resetTheme() {
    localStorage.removeItem('userTheme');
    location.reload(); // Reload the page to apply default styles
}

// Event listener for theme customization form submission
document.addEventListener('DOMContentLoaded', () => {
    const themeForm = document.getElementById('theme-form');
    if (themeForm) {
        themeForm.addEventListener('submit', (event) => {
            event.preventDefault();
            const formData = new FormData(themeForm);
            const themeSettings = {};
            formData.forEach((value, key) => {
                themeSettings[key] = value;
            });
            updateTheme(themeSettings);
        });
    }

    // Load saved theme settings on page load
    loadThemeSettings();
});

// Function to apply a default theme if no user theme is set
function applyDefaultTheme() {
    const defaultTheme = {
        'primary-color': '#4CAF50',
        'secondary-color': '#FFC107',
        'background-color': '#f0f0f0',
        'text-color': '#333',
        'header-footer-bg-color': '#4CAF50',
        'button-bg-color': '#4CAF50',
        'button-hover-bg-color': '#388E3C'
    };
    updateTheme(defaultTheme);
}

// Apply default theme if no theme is saved
if (!localStorage.getItem('userTheme')) {
    applyDefaultTheme();
}