// web/static/js/project-board.js

export function fetchProjectBoard() {
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