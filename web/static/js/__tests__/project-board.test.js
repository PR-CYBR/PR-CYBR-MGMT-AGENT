// web/static/js/__tests__/project-board.test.js

import '../project-board.js'; // Import the project-board.js to test its functionality

// Mock the fetch API
global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve({
      data: {
        repository: {
          projects: {
            nodes: [
              {
                name: 'Project 1',
                columns: {
                  nodes: [
                    {
                      name: 'To Do',
                      cards: {
                        nodes: [
                          {
                            note: 'Card Note 1',
                            content: {
                              title: 'Issue 1',
                              url: 'http://example.com/issue1'
                            }
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      }
    }),
  })
);

describe('Project Board', () => {
  beforeEach(() => {
    // Clear all instances and calls to constructor and all methods:
    fetch.mockClear();
    document.body.innerHTML = `
      <ul id="project-board-list"></ul>
    `;
  });

  test('fetchProjectBoard is called on DOMContentLoaded', async () => {
    // Simulate DOMContentLoaded event
    document.dispatchEvent(new Event('DOMContentLoaded'));

    expect(fetch).toHaveBeenCalledTimes(1);
    expect(fetch).toHaveBeenCalledWith('https://api.github.com/graphql', expect.any(Object));

    const projectBoardElement = document.getElementById('project-board-list');
    expect(projectBoardElement.children.length).toBeGreaterThan(0);
    expect(projectBoardElement.innerHTML).toContain('To Do');
    expect(projectBoardElement.innerHTML).toContain('Card Note 1');
    expect(projectBoardElement.innerHTML).toContain('Issue 1');
  });

  test('displays error message when fetch fails', async () => {
    fetch.mockImplementationOnce(() => Promise.reject('API is down'));

    await fetchProjectBoard();

    const projectBoardElement = document.getElementById('project-board-list');
    expect(projectBoardElement.innerHTML).toBe('<li>No project board found.</li>');
  });
});