------------trunk

Skip to main content
Electron homepage
Electron
Docs
API
Examples
Fiddle
Blog
Community
Releases
English
GitHub

Get Started
Introduction
Quick Start
Advanced Installation Instructions
Tutorial
Processes in Electron
Best Practices
Examples

Development
Distribution
Testing And Debugging
References
Contributing
Get StartedIntroduction
What is Electron?
Electron is a framework for building desktop applications using JavaScript, HTML, and CSS. By embedding Chromium and Node.js into its binary, Electron allows you to maintain one JavaScript codebase and create cross-platform apps that work on Windows, macOS, and Linux — no native development experience required.

Getting started
We recommend you to start with the tutorial, which guides you through the process of developing an Electron app and distributing it to users. The examples and API documentation are also good places to browse around and discover new things.

Running examples with Electron Fiddle
Electron Fiddle is a sandbox app written with Electron and supported by Electron's maintainers. We highly recommend installing it as a learning tool to experiment with Electron's APIs or to prototype features during development.

Fiddle also integrates nicely with our documentation. When browsing through examples in our tutorials, you'll frequently see an "Open in Electron Fiddle" button underneath a code block. If you have Fiddle installed, this button will open a fiddle.electronjs.org link that will automatically load the example into Fiddle, no copy-pasting required.

DOCS/FIDDLES/QUICK-START (20.0.1)
main.js
preload.js
index.html
const { app, BrowserWindow } = require('electron')
const path = require('path')

function createWindow () {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  })

  win.loadFile('index.html')
}

app.whenReady().then(() => {
  createWindow()

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow()
    }
  })
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})


What is in the docs?
All the official documentation is available from the sidebar. These are the different categories and what you can expect on each one:

Tutorial: An end-to-end guide on how to create and publish your first Electron application.
Processes in Electron: In-depth reference on Electron processes and how to work with them.
Best Practices: Important checklists to keep in mind when developing an Electron app.
Examples: Quick references to add features to your Electron app.
Development: Miscellaneous development guides.
Distribution: Learn how to distribute your app to end users.
Testing and debugging: How to debug JavaScript, write tests, and other tools used to create quality Electron applications.
References: Useful links to better understand how the Electron project works and is organized.
Contributing: Compiling Electron and making contributions can be daunting. We try to make it easier in this section.
Getting help
Are you getting stuck anywhere? Here are a few links to places to look:

If you need help with developing your app, our community Discord server is a great place to get advice from other Electron app developers.
If you suspect you're running into a bug with the electron package, please check the GitHub issue tracker to see if any existing issues match your problem. If not, feel free to fill out our bug report template and submit a new issue.
Edit this page
Next
Quick Start
Getting started
Running examples with Electron Fiddle
What is in the docs?
Getting help
Docs
Getting Started
API Reference
Checklists
Performance
Security
Community
Governance
Discord
Twitter
Stack Overflow
More
GitHub
Open Collective
OpenJS Foundation Logo
Copyright © 2021 OpenJS Foundation and Electron contributors.
title: Setting permissions for GitHub Apps
intro: '{% data reusables.shortdesc.permissions_github_apps %}'
redirect_from:
  - /apps/building-integrations/setting-up-and-registering-github-apps/about-permissions-for-github-apps
  - /apps/building-github-apps/permissions-for-github-apps
  - /apps/building-github-apps/setting-permissions-for-github-apps
  - /developers/apps/setting-permissions-for-github-apps
versions:
  fpt: '*'
  ghes: '*'
  ghae: '*'
  ghec: '*'
topics:
  - GitHub Apps
shortTitle: Set permissions
---
GitHub Apps don't have any permissions by default. When you create a GitHub App, you can select the permissions it needs to access end user data. Permissions can also be added and removed. For more information, see "[Editing a GitHub App's permissions](/apps/managing-github-apps/editing-a-github-app-s-permissions/)."
