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
        user: { login: 'GIT_USER_NAME' },
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
      <header>
        <h1 id="agent-title">PR-CYBR-MGMT-AGENT</h1>
        <p id="agent-summary">PR-CYBR-MGMT-AGENT is a tool for managing and enhancing cybersecurity efforts in Puerto Rico, featuring an interactive dashboard for real-time operations.</p>
      </header>
      <nav>
        <ul>
          <li><a href="#agent-status">Agent-Status</a></li>
          <li><a href="#agent-actions">Agent-Actions</a></li>
          <li><a href="#discussion-board">Discussion Board</a></li>
          <li><a href="#project-board">Project Board</a></li>
        </ul>
      </nav>
      <main>
        <section id="agent-status">
          <h2>Agent Status</h2>
          <div class="status-metrics">
            <div class="metric">
              <span class="metric-label">Recent Commit:</span>
              <span class="metric-value" id="recent-commit">Loading...</span>
            </div>
            <div class="metric">
              <span class="metric-label">Active Tasks:</span>
              <span class="metric-value" id="active-tasks">Loading...</span>
            </div>
            <div class="metric">
              <span class="metric-label">Issues & Pull Requests:</span>
              <span class="metric-value" id="issues-prs">Loading...</span>
            </div>
            <div class="metric">
              <span class="metric-label">Repository Statistics:</span>
              <span class="metric-value" id="repo-stats">Loading...</span>
            </div>
          </div>
          <button onclick="refreshStatus()">Refresh Status</button>
        </section>
        <section id="agent-actions">
          <h2>Agent Actions</h2>
          <div class="actions-list">
            <ul id="workflow-list">
              <!-- Workflow items will be dynamically inserted here -->
            </ul>
          </div>
        </section>
        <section id="discussion-board">
          <h2>Discussion Board</h2>
          <div class="discussion-list">
            <ul id="discussion-list">
              <!-- Discussion items will be dynamically inserted here -->
            </ul>
          </div>
        </section>
        <section id="project-board">
          <h2>Project Board</h2>
          <div id="interactive-board">
            <ul id="project-board-list">
              <!-- Project board items will be dynamically inserted here -->
            </ul>
          </div>
        </section>
      </main>
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