// web/static/js/__tests__/main.test.js

import '../main.js'; // Import the main.js to test its functionality

// Mock the fetch API
global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve({ status: 'success' }),
  })
);

describe('Main Script', () => {
  beforeEach(() => {
    // Clear all instances and calls to constructor and all methods:
    fetch.mockClear();
    document.body.innerHTML = `
      <div id="discussion-list"></div>
      <div id="project-board-list"></div>
      <button id="play-pause"></button>
      <button id="prev"></button>
      <button id="next"></button>
      <input id="volume" type="range" />
      <ul id="playlist">
        <li data-src="track1.mp3"></li>
        <li data-src="track2.mp3"></li>
      </ul>
    `;
  });

  test('executeFunction makes a POST request to the correct endpoint', async () => {
    const endpoint = 'test-endpoint';
    await executeFunction(endpoint);

    expect(fetch).toHaveBeenCalledTimes(1);
    expect(fetch).toHaveBeenCalledWith(`/api/${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
    });
  });

  test('applyTheme sets CSS variables correctly', () => {
    const theme = {
      'primary-color': '#4CAF50',
      'secondary-color': '#FFC107',
    };
    applyTheme(theme);

    const root = document.documentElement;
    expect(root.style.getPropertyValue('--primary-color')).toBe('#4CAF50');
    expect(root.style.getPropertyValue('--secondary-color')).toBe('#FFC107');
  });

  test('initializeMusicPlayer sets up event listeners', () => {
    initializeMusicPlayer();

    const playPauseButton = document.getElementById('play-pause');
    const prevButton = document.getElementById('prev');
    const nextButton = document.getElementById('next');
    const volumeSlider = document.getElementById('volume');

    expect(playPauseButton.onclick).toBeDefined();
    expect(prevButton.onclick).toBeDefined();
    expect(nextButton.onclick).toBeDefined();
    expect(volumeSlider.oninput).toBeDefined();
  });

  test('fetchDiscussions and fetchProjectBoard are called on DOMContentLoaded', () => {
    const fetchDiscussionsSpy = jest.spyOn(window, 'fetchDiscussions');
    const fetchProjectBoardSpy = jest.spyOn(window, 'fetchProjectBoard');

    document.dispatchEvent(new Event('DOMContentLoaded'));

    expect(fetchDiscussionsSpy).toHaveBeenCalled();
    expect(fetchProjectBoardSpy).toHaveBeenCalled();
  });
});