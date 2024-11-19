// web/static/js/__tests__/status-page.test.js

import { fetchDiscussions } from '../discussion-board.js';
import { fetchProjectBoard } from '../project-board.js'; // Import the function to mock
import '../status-page.js'; // Import the status-page.js to test its functionality

jest.mock('../discussion-board.js', () => ({
  fetchDiscussions: jest.fn(),
}));

jest.mock('../project-board.js', () => ({
  fetchProjectBoard: jest.fn(),
}));

describe('Status Page', () => {
  beforeEach(() => {
    fetch.mockClear();
    fetchDiscussions.mockClear();
    fetchProjectBoard.mockClear(); // Clear mock calls
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
    document.dispatchEvent(new Event('DOMContentLoaded'));
    expect(fetchDiscussions).toHaveBeenCalledTimes(1);
    expect(fetchProjectBoard).toHaveBeenCalledTimes(1); // Check if fetchProjectBoard is called
  });

  // Other tests...
});