import { fetchDiscussions } from './discussion-board.js';

document.addEventListener('DOMContentLoaded', function() {
    console.log('Status page loaded. Ensure the server is running to fetch discussions.');

    // Fetch discussions on page load
    fetchDiscussions();

    // You can add any additional initialization logic here
});