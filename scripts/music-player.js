// Agent Dashboard Music Player

document.addEventListener("DOMContentLoaded", function() {
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
});