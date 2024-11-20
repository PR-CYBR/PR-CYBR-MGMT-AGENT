// scripts/check-deployment.js

const fetch = require('node-fetch');

async function checkDeployment() {
  const url = 'https://your-deployed-site-url.com'; // Replace with your deployed site URL

  try {
    const response = await fetch(url);
    const text = await response.text();

    if (text.includes('<title>Your App Title</title>')) {
      console.log('Application code is successfully rendered.');
    } else if (text.includes('README')) {
      console.log('README.md is being displayed.');
    } else {
      console.log('Unexpected content is being displayed.');
    }
  } catch (error) {
    console.error('Error checking deployment:', error);
  }
}

checkDeployment();