// web/static/js/main.js

// Import necessary modules
import { fetchDiscussions } from './discussion-board.js';
import './status-page.js';
import './project-board.js';

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
    fetchDiscussions(); // Fetch discussions on page load
    fetchProjectBoard(); // Fetch project board on page load
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

// Function to fetch project board from the server
function fetchProjectBoard() {
    const projectBoardElement = document.getElementById('project-board-list');

    const repoOwner = 'PR-CYBR'; // Replace with your GitHub organization or user
    const repoName = 'PR-CYBR-MGMT-AGENT'; // Replace with your repository name

    const query = `
    {
      repository(owner: "${repoOwner}", name: "${repoName}") {
        projects(first: 1) {
          nodes {
            name
            columns(first: 10) {
              nodes {
                name
                cards(first: 10) {
                  nodes {
                    note
                    content {
                      ... on Issue {
                        title
                        url
                      }
                      ... on PullRequest {
                        title
                        url
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    `;

    fetch('https://api.github.com/graphql', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer YOUR_GITHUB_TOKEN` // Replace with your GitHub token
        },
        body: JSON.stringify({ query })
    })
    .then(response => response.json())
    .then(data => {
        if (data.data && data.data.repository.projects.nodes.length > 0) {
            const project = data.data.repository.projects.nodes[0];
            project.columns.nodes.forEach(column => {
                const columnItem = document.createElement('li');
                columnItem.innerHTML = `<strong>${column.name}</strong>`;
                projectBoardElement.appendChild(columnItem);

                column.cards.nodes.forEach(card => {
                    const cardItem = document.createElement('li');
                    const content = card.content ? `<a href="${card.content.url}" target="_blank">${card.content.title}</a>` : card.note;
                    cardItem.innerHTML = `&nbsp;&nbsp;&nbsp;${content}`;
                    projectBoardElement.appendChild(cardItem);
                });
            });
        } else {
            projectBoardElement.innerHTML = '<li>No project board found.</li>';
        }
    })
    .catch(error => {
        console.error('Error fetching project board:', error);
        projectBoardElement.innerHTML = '<li>Error loading project board.</li>';
    });
}

// Additional interactivity can be added here