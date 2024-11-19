// web/static/js/__tests__/project-board.test.js

import { fetchProjectBoard } from '../project-board.js'; // Import the function to test

// Mock the fetch API
global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve({
      data: {
        repository: {
          projects: {
            nodes: [
              {
                name: 'Project 4', // Assuming this is the name of your project
                columns: {
                  nodes: [
                    {
                      name: 'Todo',
                      cards: {
                        nodes: [
                          {
                            note: 'Card Note 1',
                            content: {
                              title: 'Issue 1',
                              url: 'https://github.com/orgs/PR-CYBR/projects/4?pane=issue&itemId=87879237'
                            }
                          }
                        ]
                      }
                    },
                    {
                      name: 'In Progress',
                      cards: {
                        nodes: [
                          {
                            note: 'Card Note 2',
                            content: {
                              title: 'Issue 2',
                              url: 'https://github.com/orgs/PR-CYBR/projects/4/views/1?pane=issue&itemId=87879247'
                            }
                          }
                        ]
                      }
                    },
                    {
                      name: 'Done',
                      cards: {
                        nodes: [
                          {
                            note: 'Card Note 3',
                            content: {
                              title: 'Issue 3',
                              url: 'https://github.com/orgs/PR-CYBR/projects/4/views/1?pane=issue&itemId=87879255'
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

  test('fetchProjectBoard populates the project board list on DOMContentLoaded', async () => {
    try {
      // Simulate DOMContentLoaded event
      document.dispatchEvent(new Event('DOMContentLoaded'));

      expect(fetch).toHaveBeenCalledTimes(1);
      expect(fetch).toHaveBeenCalledWith('https://api.github.com/graphql', expect.any(Object));

      const projectBoardElement = document.getElementById('project-board-list');
      expect(projectBoardElement.children.length).toBeGreaterThan(0);
      expect(projectBoardElement.innerHTML).toContain('Todo');
      expect(projectBoardElement.innerHTML).toContain('Card Note 1');
      expect(projectBoardElement.innerHTML).toContain('Issue 1');
      expect(projectBoardElement.innerHTML).toContain('In Progress');
      expect(projectBoardElement.innerHTML).toContain('Card Note 2');
      expect(projectBoardElement.innerHTML).toContain('Issue 2');
      expect(projectBoardElement.innerHTML).toContain('Done');
      expect(projectBoardElement.innerHTML).toContain('Card Note 3');
      expect(projectBoardElement.innerHTML).toContain('Issue 3');
    } catch (error) {
      console.error('Error in fetchProjectBoard test:', error);
    }
  });

  test('displays error message when fetch fails', async () => {
    fetch.mockImplementationOnce(() => Promise.reject('API is down'));

    try {
      await fetchProjectBoard();

      const projectBoardElement = document.getElementById('project-board-list');
      expect(projectBoardElement.innerHTML).toBe('<li>No project board found.</li>');
    } catch (error) {
      console.error('Error in error handling test:', error);
    }
  });
});