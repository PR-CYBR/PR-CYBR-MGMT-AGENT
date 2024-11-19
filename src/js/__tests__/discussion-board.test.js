// web/static/js/__tests__/discussion-board.test.js

import { fetchDiscussions } from '../discussion-board.js';

// Mock the fetch API
global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve([
      {
        title: 'Discussion 2',
        html_url: 'https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/discussions/2',
        user: { login: 'PR-CYBR' },
        created_at: '2023-11-19T19:46:17Z'
      }
    ]),
  })
);

describe('Discussion Board', () => {
  beforeEach(() => {
    // Clear all instances and calls to constructor and all methods:
    fetch.mockClear();
    document.body.innerHTML = `
      <ul id="discussion-list"></ul>
    `;
  });

  test('fetchDiscussions populates the discussion list with specific post', async () => {
    try {
      await fetchDiscussions();

      expect(fetch).toHaveBeenCalledTimes(1);
      expect(fetch).toHaveBeenCalledWith('https://api.github.com/repos/PR-CYBR/PR-CYBR-MGMT-AGENT/discussions', expect.any(Object));

      const discussionListElement = document.getElementById('discussion-list');
      expect(discussionListElement.children.length).toBe(1);

      const listItem = discussionListElement.children[0];
      expect(listItem.innerHTML).toContain('Discussion 1');
      expect(listItem.innerHTML).toContain('user1');
      expect(listItem.innerHTML).toContain('https://github.com/PR-CYBR/PR-CYBR-MGMT-AGENT/discussions/2');
    } catch (error) {
      console.error('Error in fetchDiscussions test:', error);
    }
  });

  test('displays error message when fetch fails', async () => {
    fetch.mockImplementationOnce(() => Promise.reject('API is down'));

    try {
      await fetchDiscussions();

      const discussionListElement = document.getElementById('discussion-list');
      expect(discussionListElement.innerHTML).toBe('<li>Error loading discussions.</li>');
    } catch (error) {
      console.error('Error in error handling test:', error);
    }
  });
});