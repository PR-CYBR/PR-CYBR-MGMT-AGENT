// web/static/js/__tests__/status-page.test.js

import { fetchDiscussions } from '../discussion-board.js';
import '../status-page.js'; // Import the status-page.js to test its functionality

// Mock the fetch API
global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve([
      {
        title: 'Alpha Release: PR-CYBR-MGMT-AGENT v0.1.0-alpha',
        html_url: 'https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/discussions/2',
        user: { login: 'GIT_USER_NAME' }, // Use the variable here
        created_at: '2024-11-12T19:46:17Z'
      }
    ]),
  })
);

jest.mock('../discussion-board.js', () => ({
  fetchDiscussions: jest.fn(),
}));

describe('Status Page', () => {
  beforeEach(() => {
    // Clear all instances and calls to constructor and all methods:
    fetch.mockClear();
    fetchDiscussions.mockClear();
    document.body.innerHTML = `
      <ul id="discussion-list"></ul>
    `;
  });

  test('fetchDiscussions is called on DOMContentLoaded', () => {
    // Simulate DOMContentLoaded event
    document.dispatchEvent(new Event('DOMContentLoaded'));

    expect(fetchDiscussions).toHaveBeenCalledTimes(1);
  });

  test('fetchDiscussions populates the discussion list', async () => {
    fetchDiscussions.mockImplementationOnce(() => {
      const discussionListElement = document.getElementById('discussion-list');
      const listItem = document.createElement('li');
      listItem.innerHTML = `
        <a href="https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/discussions/2" target="_blank">Alpha Release: PR-CYBR-MGMT-AGENT v0.1.0-alpha</a>
        <br>
        <small>Started by: GIT_USER_NAME on ${new Date('2024-11-12T19:46:17Z').toLocaleString()}</small>
      `;
      discussionListElement.appendChild(listItem);
    });

    // Simulate DOMContentLoaded event
    document.dispatchEvent(new Event('DOMContentLoaded'));

    const discussionListElement = document.getElementById('discussion-list');
    expect(discussionListElement.children.length).toBe(1);
    expect(discussionListElement.children[0].innerHTML).toContain('Alpha Release: PR-CYBR-MGMT-AGENT v0.1.0-alpha');
  });

  test('displays error message when fetch fails', async () => {
    fetchDiscussions.mockImplementationOnce(() => {
      const discussionListElement = document.getElementById('discussion-list');
      discussionListElement.innerHTML = '<li>Error loading discussions.</li>';
    });

    // Simulate DOMContentLoaded event
    document.dispatchEvent(new Event('DOMContentLoaded'));

    const discussionListElement = document.getElementById('discussion-list');
    expect(discussionListElement.innerHTML).toBe('<li>Error loading discussions.</li>');
  });
});