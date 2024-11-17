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
    initializeMusicPlayer();
});

// Function to initialize the music player
function initializeMusicPlayer() {
    const playPauseButton = document.getElementById("play-pause");
    const prevButton = document.getElementById("prev");
    const nextButton = document.getElementById("next");
    const volumeSlider = document.getElementById("volume");
    const playlistItems = document.querySelectorAll("#playlist li");

    let currentTrackIndex = 0;
    let isPlaying = false;
    const audio = new Audio();

    // Load the first track
    loadTrack(currentTrackIndex);

    playPauseButton.addEventListener("click", togglePlayPause);
    prevButton.addEventListener("click", playPreviousTrack);
    nextButton.addEventListener("click", playNextTrack);
    volumeSlider.addEventListener("input", changeVolume);

    function loadTrack(index) {
        const track = playlistItems[index];
        audio.src = track.getAttribute("data-src");
        audio.load();
    }

    function togglePlayPause() {
        if (isPlaying) {
            audio.pause();
            playPauseButton.textContent = "Play";
        } else {
            audio.play();
            playPauseButton.textContent = "Pause";
        }
        isPlaying = !isPlaying;
    }

    function playPreviousTrack() {
        currentTrackIndex = (currentTrackIndex - 1 + playlistItems.length) % playlistItems.length;
        loadTrack(currentTrackIndex);
        if (isPlaying) audio.play();
    }

    function playNextTrack() {
        currentTrackIndex = (currentTrackIndex + 1) % playlistItems.length;
        loadTrack(currentTrackIndex);
        if (isPlaying) audio.play();
    }

    function changeVolume() {
        audio.volume = volumeSlider.value;
    }

    // Automatically play the next track when the current one ends
    audio.addEventListener("ended", playNextTrack);
}

// Additional interactivity can be added here