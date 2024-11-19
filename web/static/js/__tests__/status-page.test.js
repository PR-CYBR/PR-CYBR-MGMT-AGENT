// web/static/js/__tests__/status-page.test.js

import { fetchDiscussions } from '../discussion-board.js';
import '../status-page.js'; // Import the status-page.js to test its functionality

// Mock the fetch API
global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve([{ title: 'Discussion 1', html_url: 'http://example.com', user: { login: 'user1' }, created_at: '2023-11-19T19:46:17Z' }]),
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
        <a href="http://example.com" target="_blank">Discussion 1</a>
        <br>
        <small>Started by: user1 on ${new Date('2023-11-19T19:46:17Z').toLocaleString()}</small>
      `;
      discussionListElement.appendChild(listItem);
    });

    // Simulate DOMContentLoaded event
    document.dispatchEvent(new Event('DOMContentLoaded'));

    const discussionListElement = document.getElementById('discussion-list');
    expect(discussionListElement.children.length).toBe(1);
    expect(discussionListElement.children[0].innerHTML).toContain('Discussion 1');
  });

  test('displays error message when fetch fails', async () => {
    fetch.mockImplementationOnce(() => Promise.reject('API is down'));

    await fetchDiscussions();

    const discussionListElement = document.getElementById('discussion-list');
    expect(discussionListElement.innerHTML).toBe('<li>Error loading discussions.</li>');
  });
});