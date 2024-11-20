// src/js/discussion-board.js

export function fetchDiscussions() {
    const discussionListElement = document.getElementById('discussion-list');

    const repoOwner = 'PR-CYBR'; // Replace with your GitHub organization or user
    const repoName = 'PR-CYBR-MGMT-AGENT'; // Replace with your repository name

    const apiUrl = `https://api.github.com/repos/${repoOwner}/${repoName}/discussions`;

    fetch(apiUrl, {
        headers: {
            'Accept': 'application/vnd.github.v3+json',
            'Authorization': 'token PR_CYBR_ACTIONS' 
        }
    })
    .then(response => response.json())
    .then(data => {
        if (Array.isArray(data)) {
            data.forEach(discussion => {
                const listItem = document.createElement('li');
                listItem.innerHTML = `
                    <a href="${discussion.html_url}" target="_blank">${discussion.title}</a>
                    <br>
                    <small>Started by: ${discussion.user.login} on ${new Date(discussion.created_at).toLocaleString()}</small>
                `;
                discussionListElement.appendChild(listItem);
            });
        } else {
            discussionListElement.innerHTML = '<li>No discussions found.</li>';
        }
    })
    .catch(error => {
        console.error('Error fetching discussions:', error);
        discussionListElement.innerHTML = '<li>Error loading discussions.</li>';
    });
}