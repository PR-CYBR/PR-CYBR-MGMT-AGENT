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