// web/static/js/status-page.js

import { fetchDiscussions } from './discussion-board.js';
import { fetchProjectBoard } from './project-board.js'; // Ensure this import is correct

document.addEventListener('DOMContentLoaded', function() {
    console.log('Status page loaded. Ensure the server is running to fetch discussions and project board.');

    // Fetch discussions and project board on page load
    fetchDiscussions();
    fetchProjectBoard();

    // Add event listener for project board search input
    const projectSearchInput = document.getElementById('project-search');
    projectSearchInput.addEventListener('input', function() {
        const keyword = projectSearchInput.value.toLowerCase();
        filterProjectBoard(keyword);
    });

    // You can add any additional initialization logic here
});

// Function to filter project board tasks based on keyword
function filterProjectBoard(keyword) {
    const projectBoardElement = document.getElementById('project-board-list');
    const tasks = projectBoardElement.getElementsByTagName('li');

    Array.from(tasks).forEach(task => {
        const text = task.textContent.toLowerCase();
        task.style.display = text.includes(keyword) ? '' : 'none';
    });
}