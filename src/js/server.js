// src/js/server.js

const express = require('express');
const fetch = require('node-fetch');
require('dotenv').config(); // Load environment variables from a .env file

const app = express();
const PORT = process.env.PORT || 3000;

// Ensure you have a .env file with GITHUB_TOKEN=your_github_token
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;

if (!GITHUB_TOKEN) {
  console.error('Error: GITHUB_TOKEN is not set in the environment variables.');
  process.exit(1);
}

app.get('/api/discussions', async (req, res) => {
  const repoOwner = 'PR-CYBR'; // Replace with your GitHub organization or user
  const repoName = 'PR-CYBR-MGMT-AGENT'; // Replace with your repository name
  const apiUrl = `https://api.github.com/repos/${repoOwner}/${repoName}/discussions`;

  try {
    const response = await fetch(apiUrl, {
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': `token ${GITHUB_TOKEN}`
      }
    });

    if (!response.ok) {
      throw new Error(`GitHub API error: ${response.statusText}`);
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Error fetching discussions:', error);
    res.status(500).json({ error: 'Error fetching discussions' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});