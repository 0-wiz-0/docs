# GraphQL

The files in this directory are kept in sync with their counterparts on `github/github`
by [automation](../script/graphql/README.md). These files **should not** be edited by humans.

Dotcom source files:
```
config/schema.docs.graphql
config/graphql_previews.yml
graphql_upcoming_changes.yml
```

Enterprise source files:
```
enterprise-VERSION-release/config/schema.docs-enterprise.graphql
enterprise-VERSION-release/config/graphql_previews.enterprise.yml
enterprise-VERSION-release/config/graphql_upcoming_changes.public-enterprise.yml
```
Skip to content
Search or jump to…
Pull requests
Issues
Codespaces
Marketplace
Explore
 
@zakwarlord7 
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.

Pull request creation failed. Validation failed: Body is too long (maximum is 65536 characters)  
github
/
docs
Public
Code
Issues
93
Pull requests
165
Discussions
Actions
Projects
3
Security
Insights
Open a pull request
Create a new pull request by comparing changes across two branches. If you need to, you can also .
     
Checking mergeability… Don’t worry, you can still create the pull request.
@zakwarlord7
Readme.md
 
Add heading textAdd bold text, <Ctrl+b>Add italic text, <Ctrl+i>
Add a quote, <Ctrl+Shift+.>Add code, <Ctrl+e>Add a link, <Ctrl+k>
Add a bulleted list, <Ctrl+Shift+8>Add a numbered list, <Ctrl+Shift+7>Add a task list, <Ctrl+Shift+l>
Directly mention a user or team
Reference an issue, pull request, or discussion
Add saved reply
<!--
Thank you for contributing to this project! You must fill out the information below before we can review this pull request. By explaining why you're making a change (or linking to an issue) and what changes you've made, we can triage your pull request to the best possible team for review.
-->

### Why:

Closes [issue link]

<!-- If there's an existing issue for your change, please link to it in the brackets above.
If there's _not_ an existing issue, please open one first to make it more likely that this update will be accepted: https://github.com/github/docs/issues/new/choose. -->

### What's being changed (if available, include any code snippets, screenshots, or gifs):

<!-- Let us know what you are changing. Share anything that could provide the most context.
If you made changes to the `content` directory, a table will populate in a comment below with links to the preview and current production articles. -->

### Check off the following:

- [ ] I have reviewed my changes in staging (look for the "Automatically generated comment" and click the links in the "Preview" column to view your latest changes).
- [ ] For content changes, I have completed the [self-review checklist](https://github.com/github/docs/blob/main/contributing/self-review.md#self-review).

No file chosen
Attach files by dragging & dropping, selecting or pasting them.
Styling with Markdown is supported
Allow edits and access to secrets by maintainers
Remember, contributions to this repository should follow its contributing guidelines, security policy, and code of conduct.
Helpful resources
Contributing
Code of conduct
Security policy
GitHub Community Guidelines
 5 commits
 3,751 files changed
 48 contributors
Commits on Jul 30, 2022
Create npc

@zakwarlord7
zakwarlord7 committed on Jul 30
 
Create ci

@zakwarlord7
zakwarlord7 committed on Jul 30
  
BITORE

@zakwarlord7
zakwarlord7 committed on Jul 30
  
Commits on Sep 2, 2022
bitore.sig (#78) 

@zakwarlord7
@docubot
@Octomerger
@anleac
@sophietheking
48 people committed on Sep 2
  
Commits on Sep 17, 2022
README.md

@zakwarlord7
zakwarlord7 committed on Sep 17
  
Showing 3,751 changed files with 338,206 additions and 187,430 deletions.
The diff you're trying to view is too large. We only load the first 3000 changed files.
  14  
.github/CODEOWNERS
This CODEOWNERS file contains errors …
@@ -16,12 +16,11 @@ package-lock.json @github/docs-engineering
package.json @github/docs-engineering

# Localization
/.github/actions-scripts/create-translation-batch-pr.js @github/docs-localization
/.github/workflows/create-translation-batch-pr.yml @github/docs-localization
/.github/workflows/crowdin.yml @github/docs-localization
/crowdin*.yml @github/docs-engineering @github/docs-localization
/translations/ @github/docs-engineering @github/docs-localization @Octomerger
/translations/log/ @github/docs-localization @Octomerger
/.github/actions-scripts/create-translation-batch-pr.js @github/docs-engineering
/.github/workflows/create-translation-batch-pr.yml @github/docs-engineering
/.github/workflows/crowdin.yml @github/docs-engineering
/crowdin*.yml @github/docs-engineering
/translations/ @Octomerger

# Site Policy
/content/site-policy/ @github/site-policy-admins
@@ -32,3 +31,6 @@ package.json @github/docs-engineering
/contributing/content-model.md @github/docs-content-strategy
/contributing/content-style-guide.md @github/docs-content-strategy
/contributing/content-templates.md @github/docs-content-strategy

# Requires review of #actions-oidc-integration, docs-engineering/issues/1506
content/actions/deployment/security-hardening-your-deployments/** @github/oidc
  1  
.github/ISSUE_TEMPLATE/config.yml
@@ -3,3 +3,4 @@ contact_links:
  - name: GitHub Support
    url: https://support.github.com/contact
    about: Contact Support if you're having trouble with your GitHub account.
zachry t wood
  7  
.github/actions-scripts/check-for-enterprise-issues-by-label.js
@@ -3,17 +3,20 @@
import { getOctokit } from '@actions/github'
import { setOutput } from '@actions/core'

const ENTERPRISE_DEPRECATION_LABEL = 'enterprise deprecation'
const ENTERPRISE_RELEASE_LABEL = 'GHES release tech steps'

async function run() {
  const token = process.env.GITHUB_TOKEN
  const octokit = getOctokit(token)
  const queryDeprecation = encodeURIComponent('is:open repo:github/docs-engineering is:issue')
  const queryRelease = encodeURIComponent('is:open repo:github/docs-content is:issue')

  const deprecationIssues = await octokit.request(
    `GET /search/issues?q=${queryDeprecation}+label:"enterprise%20deprecation"`
    `GET /search/issues?q=${queryDeprecation}+label:"${encodeURI(ENTERPRISE_DEPRECATION_LABEL)}"`
  )
  const releaseIssues = await octokit.request(
    `GET /search/issues?q=${queryRelease}+label:"enterprise%20release"`
    `GET /search/issues?q=${queryRelease}+label:"${encodeURI(ENTERPRISE_RELEASE_LABEL)}"`
  )
  const isDeprecationIssue = deprecationIssues.data.items.length === 0 ? 'false' : 'true'
  const isReleaseIssue = releaseIssues.data.items.length === 0 ? 'false' : 'true'
  254  
.github/actions-scripts/content-changes-table-comment.js
@@ -1,13 +1,14 @@
#!/usr/bin/env node

import * as github from '@actions/github'
import { setOutput } from '@actions/core'
import core from '@actions/core'

import { getContents } from '../../script/helpers/git-utils.js'
import parse from '../../lib/read-frontmatter.js'
import getApplicableVersions from '../../lib/get-applicable-versions.js'
import nonEnterpriseDefaultVersion from '../../lib/non-enterprise-default-version.js'
import { allVersionShortnames } from '../../lib/all-versions.js'
import { waitUntilUrlIsHealthy } from './lib/wait-until-url-is-healthy.js'

const { GITHUB_TOKEN, APP_URL } = process.env
const context = github.context
@@ -26,135 +27,144 @@ if (!APP_URL) {
const MAX_COMMENT_SIZE = 125000

const PROD_URL = 'https://docs.github.com'
const octokit = github.getOctokit(GITHUB_TOKEN)

// get the list of file changes from the PR
const response = await octokit.rest.repos.compareCommitsWithBasehead({
  owner: context.repo.owner,
  repo: context.payload.repository.name,
  basehead: `${context.payload.pull_request.base.sha}...${context.payload.pull_request.head.sha}`,
})

const { files } = response.data

let markdownTable =
  '| **Source** | **Preview** | **Production** | **What Changed** |\n|:----------- |:----------- |:----------- |:----------- |\n'

const pathPrefix = 'content/'
const articleFiles = files.filter(
  ({ filename }) => filename.startsWith(pathPrefix) && !filename.endsWith('/index.md')
)

const lines = await Promise.all(
  articleFiles.map(async (file) => {
    const sourceUrl = file.blob_url
    const fileName = file.filename.slice(pathPrefix.length)
    const fileUrl = fileName.slice(0, fileName.lastIndexOf('.'))

    // get the file contents and decode them
    // this script is called from the main branch, so we need the API call to get the contents from the branch, instead
    const fileContents = await getContents(
      context.repo.owner,
      context.payload.repository.name,
      // Can't get its content if it no longer exists.
      // Meaning, you'd get a 404 on the `getContents()` utility function.
      // So, to be able to get necessary meta data about what it *was*,
      // if it was removed, fall back to the 'base'.
      file.status === 'removed'
        ? context.payload.pull_request.base.sha
        : context.payload.pull_request.head.sha,
      file.filename
    )

    // parse the frontmatter
    const { data } = parse(fileContents)

    let contentCell = ''
    let previewCell = ''
    let prodCell = ''

    if (file.status === 'added') contentCell = 'New file: '
    else if (file.status === 'removed') contentCell = 'Removed: '
    contentCell += `[\`${fileName}\`](${sourceUrl})`

    try {
      // the try/catch is needed because getApplicableVersions() returns either [] or throws an error when it can't parse the versions frontmatter
      // try/catch can be removed if docs-engineering#1821 is resolved
      // i.e. for feature based versioning, like ghae: 'issue-6337'
      const fileVersions = getApplicableVersions(data.versions)

      for (const plan in allVersionShortnames) {
        // plan is the shortName (i.e., fpt)
        // allVersionShortNames[plan] is the planName (i.e., free-pro-team)

        // walk by the plan names since we generate links differently for most plans
        const versions = fileVersions.filter((fileVersion) =>
          fileVersion.includes(allVersionShortnames[plan])
        )

        if (versions.length === 1) {
          // for fpt, ghec, and ghae
run()

          if (versions.toString() === nonEnterpriseDefaultVersion) {
            // omit version from fpt url
async function run() {
  const isHealthy = await waitUntilUrlIsHealthy(new URL('/healthz', APP_URL).toString())
  if (!isHealthy) {
    return core.setFailed(`Timeout waiting for preview environment: ${APP_URL}`)
  }

            previewCell += `[${plan}](${APP_URL}/${fileUrl})<br>`
            prodCell += `[${plan}](${PROD_URL}/${fileUrl})<br>`
          } else {
            // for non-versioned releases (ghae, ghec) use full url
  const octokit = github.getOctokit(GITHUB_TOKEN)
  // get the list of file changes from the PR
  const response = await octokit.rest.repos.compareCommitsWithBasehead({
    owner: context.repo.owner,
    repo: context.payload.repository.name,
    basehead: `${context.payload.pull_request.base.sha}...${context.payload.pull_request.head.sha}`,
  })

  const { files } = response.data

  let markdownTable =
    '| **Source** | **Preview** | **Production** | **What Changed** |\n|:----------- |:----------- |:----------- |:----------- |\n'

  const pathPrefix = 'content/'
  const articleFiles = files.filter(
    ({ filename }) => filename.startsWith(pathPrefix) && !filename.endsWith('/index.md')
  )

  const lines = await Promise.all(
    articleFiles.map(async (file) => {
      const sourceUrl = file.blob_url
      const fileName = file.filename.slice(pathPrefix.length)
      const fileUrl = fileName.slice(0, fileName.lastIndexOf('.'))

      // get the file contents and decode them
      // this script is called from the main branch, so we need the API call to get the contents from the branch, instead
      const fileContents = await getContents(
        context.repo.owner,
        context.payload.repository.name,
        // Can't get its content if it no longer exists.
        // Meaning, you'd get a 404 on the `getContents()` utility function.
        // So, to be able to get necessary meta data about what it *was*,
        // if it was removed, fall back to the 'base'.
        file.status === 'removed'
          ? context.payload.pull_request.base.sha
          : context.payload.pull_request.head.sha,
        file.filename
      )

            previewCell += `[${plan}](${APP_URL}/${versions}/${fileUrl})<br>`
            prodCell += `[${plan}](${PROD_URL}/${versions}/${fileUrl})<br>`
      // parse the frontmatter
      const { data } = parse(fileContents)

      let contentCell = ''
      let previewCell = ''
      let prodCell = ''

      if (file.status === 'added') contentCell = 'New file: '
      else if (file.status === 'removed') contentCell = 'Removed: '
      contentCell += `[\`${fileName}\`](${sourceUrl})`

      try {
        // the try/catch is needed because getApplicableVersions() returns either [] or throws an error when it can't parse the versions frontmatter
        // try/catch can be removed if docs-engineering#1821 is resolved
        // i.e. for feature based versioning, like ghae: 'issue-6337'
        const fileVersions = getApplicableVersions(data.versions)

        for (const plan in allVersionShortnames) {
          // plan is the shortName (i.e., fpt)
          // allVersionShortNames[plan] is the planName (i.e., free-pro-team)

          // walk by the plan names since we generate links differently for most plans
          const versions = fileVersions.filter((fileVersion) =>
            fileVersion.includes(allVersionShortnames[plan])
          )

          if (versions.length === 1) {
            // for fpt, ghec, and ghae

            if (versions.toString() === nonEnterpriseDefaultVersion) {
              // omit version from fpt url

              previewCell += `[${plan}](${APP_URL}/${fileUrl})<br>`
              prodCell += `[${plan}](${PROD_URL}/${fileUrl})<br>`
            } else {
              // for non-versioned releases (ghae, ghec) use full url

              previewCell += `[${plan}](${APP_URL}/${versions}/${fileUrl})<br>`
              prodCell += `[${plan}](${PROD_URL}/${versions}/${fileUrl})<br>`
            }
          } else if (versions.length) {
            // for ghes releases, link each version

            previewCell += `${plan}@ `
            prodCell += `${plan}@ `

            versions.forEach((version) => {
              previewCell += `[${version.split('@')[1]}](${APP_URL}/${version}/${fileUrl}) `
              prodCell += `[${version.split('@')[1]}](${PROD_URL}/${version}/${fileUrl}) `
            })
            previewCell += '<br>'
            prodCell += '<br>'
          }
        } else if (versions.length) {
          // for ghes releases, link each version

          previewCell += `${plan}@ `
          prodCell += `${plan}@ `

          versions.forEach((version) => {
            previewCell += `[${version.split('@')[1]}](${APP_URL}/${version}/${fileUrl}) `
            prodCell += `[${version.split('@')[1]}](${PROD_URL}/${version}/${fileUrl}) `
          })
          previewCell += '<br>'
          prodCell += '<br>'
        }
      } catch (e) {
        console.error(
          `Version information for ${file.filename} couldn't be determined from its frontmatter.`
        )
      }
      let note = ''
      if (file.status === 'removed') {
        note = 'removed'
        // If the file was removed, the `previewCell` no longer makes sense
        // since it was based on looking at the base sha.
        previewCell = 'n/a'
      }
    } catch (e) {
      console.error(
        `Version information for ${file.filename} couldn't be determined from its frontmatter.`
      )
    }
    let note = ''
    if (file.status === 'removed') {
      note = 'removed'
      // If the file was removed, the `previewCell` no longer makes sense
      // since it was based on looking at the base sha.
      previewCell = 'n/a'
    }

    return `| ${contentCell} | ${previewCell} | ${prodCell} | ${note} |`
  })
)

// this section limits the size of the comment
const cappedLines = []
let underMax = true

lines.reduce((previous, current, index, array) => {
  if (underMax) {
    if (previous + current.length > MAX_COMMENT_SIZE) {
      underMax = false
      cappedLines.push('**Note** There are more changes in this PR than we can show.')
      return previous
    }
      return `| ${contentCell} | ${previewCell} | ${prodCell} | ${note} |`
    })
  )

    cappedLines.push(array[index])
    return previous + current.length
  }
  return previous
}, markdownTable.length)
  // this section limits the size of the comment
  const cappedLines = []
  let underMax = true

markdownTable += cappedLines.join('\n')
  lines.reduce((previous, current, index, array) => {
    if (underMax) {
      if (previous + current.length > MAX_COMMENT_SIZE) {
        underMax = false
        cappedLines.push('**Note** There are more changes in this PR than we can show.')
        return previous
      }

setOutput('changesTable', markdownTable)
      cappedLines.push(array[index])
      return previous + current.length
    }
    return previous
  }, markdownTable.length)

  markdownTable += cappedLines.join('\n')

  core.setOutput('changesTable', markdownTable)
}
  4  
.github/actions-scripts/create-enterprise-issue.js
@@ -87,8 +87,8 @@ async function run() {
  )
  const issueLabels =
    milestone === 'release'
      ? ['enterprise release']
      : ['enterprise deprecation', 'priority-4', 'batch', 'time sensitive']
      ? ['GHES release tech steps']
      : ['enterprise deprecation', 'priority-1', 'batch', 'time sensitive']
  const issueTitle = `[${nextMilestoneDate}] Enterprise Server ${versionNumber} ${milestone} (technical steps)`

  const issueBody = `GHES ${versionNumber} ${milestone} occurs on ${nextMilestoneDate}.
  99  
.github/actions-scripts/enterprise-server-issue-templates/deprecation-issue.md
@@ -1,60 +1,87 @@
## Overview

The day after a GHES version's [deprecation date](https://github.com/github/docs-internal/tree/main/lib/enterprise-dates.json), a banner on the docs will say: `This version was deprecated on <date>.` This is all users need to know. However, we don't want to update those docs anymore or link to them in the nav.  Follow the steps in this issue to **archive** the docs.
The day after a GHES version's [deprecation date](https://github.com/github/docs-internal/tree/main/lib/enterprise-dates.json), a banner on the docs will say: `This version was deprecated on <date>.` This is all users need to know. However, we don't want to update those docs anymore or link to them in the nav. Follow the steps in this issue to **archive** the docs.

**Note**: Do each step below in a separate PR. Only move on to the next step when the previous PR has been merged.

The following large repositories are used throughout this checklist, it may be useful to clone them before you begin:

- `github/help-docs-archived-enterprise-versions`
- `github/github`
- `github/docs-internal`

Additionally, you may want to download:

- [Azure Storage Explorer](https://aka.ms/portalfx/downloadstorageexplorer)

## Step 0: Remove deprecated version numbers from docs-content issue forms

**Note**: This step can be performed independently of all other steps, and can be done several days before or along with the other steps. 
**Note**: This step can be performed independently of all other steps, and can be done several days before or along with the other steps.

- [ ] In the `docs-content` repo, remove the deprecated GHES version number from the "Specific GHES version(s)" section in the following files (in the `.github/ISSUE_TEMPLATE/` directory): [`release-tier-1-or-2-tracking.yml`](https://github.com/github/docs-content/blob/main/.github/ISSUE_TEMPLATE/release-tier-1-or-2-tracking.yml) and [`release-tier-3-or-tier-4.yml`](https://github.com/github/docs-content/blob/main/.github/ISSUE_TEMPLATE/release-tier-3-or-tier-4.yml).
- [ ] When the PR is approved, merge it in. This can be merged independently from all other steps. 
- [ ] When the PR is approved, merge it in. This can be merged independently from all other steps.

## Step 1: Scrape the docs and archive the files

- [ ] In your checkout of the [repo with archived GHES content](https://github.com/github/help-docs-archived-enterprise-versions), create a new branch: `git checkout -b deprecate-<version>`
- [ ] In your `docs-internal` checkout, download the static files for the oldest supported version into your archival checkout:
    The archive script depends on an optional dependency so install optional dependencies first:
    ```
    $ npm ci --include-optional
    ```
    Then run the archive script:
    ```
    $ script/enterprise-server-deprecations/archive-version.js -p <path-to-archive-repo-checkout>
    ```
    If your checkouts live in the same directory, this command would be:
    ```
    $ script/enterprise-server-deprecations/archive-version.js -p ../help-docs-archived-enterprise-versions
    ```
    **Note:** You can pass the `--dry-run` flag to scrape only the first 10 pages plus their redirects for testing purposes.

      The archive script depends on an optional dependency so install optional dependencies first:
  ```
  $ npm i --include-optional
  ```
  Ensure your build is up to date:
  ```
  $ npm run build
  ```
  Then run the archive script:
  ```
  $ script/enterprise-server-deprecations/archive-version.js -p <path-to-archive-repo-checkout>
  ```
  If your checkouts live in the same directory, this command would be:
  ```
  $ script/enterprise-server-deprecations/archive-version.js -p ../help-docs-archived-enterprise-versions
  ```
  **Note:** You can pass the `--dry-run` flag to scrape only the first 10 pages plus their redirects for testing purposes. **If you use the dry run command, be sure to run the full script without `--dry-run` before you commit the changes.**

## Step 2: Upload the assets directory to Azure storage

- [ ] Log in to the Azure portal from Okta. Navigate to the [githubdocs Azure Storage Blob resource](https://portal.azure.com/#@githubazure.onmicrosoft.com/resource/subscriptions/fa6134a7-f27e-4972-8e9f-0cedffa328f1/resourceGroups/docs-production/providers/Microsoft.Storage/storageAccounts/githubdocs/overview).
- [ ] Click the "Open in Explorer" button to the right of search box.If you haven't already, click the download link to download "Microsoft Azure Storage Explorer." To login to the app, click the plug icon in the left sidebar and click the option to "add an azure account." When you login, you'll need a yubikey to authenticate through Okta.
- [ ] From the Microsoft Azure Storage Explorer app, select the `githubdocs` storage account resource and navigate to the `github-images` blob container. 
- [ ] Click "Upload" and select "Upload folder." Click the "Selected folder" input to navigate to the `help-docs-archived-enterprise-versions` repository and select the `assets` directory for the version you just generated. In the "Destination folder" input, add the version number. For example, `/enterprise/2.22/`.
- [ ] Click the "Open in Explorer" button to the right of search box. If you haven't already, click the download link to download "Microsoft Azure Storage Explorer." To login to the app, click the plug icon in the left sidebar and click the option to "add an azure account." When you login, you'll need a yubikey to authenticate through Okta.
- [ ] From the Microsoft Azure Storage Explorer app, select the `githubdocs` storage account resource and navigate to the `github-images` blob container.
- [ ] Click "Upload" and select "Upload folder." Click the "Selected folder" input to navigate to the `help-docs-archived-enterprise-versions` repository and select the `assets` directory for the version you just generated. In the "Destination directory" input, add the version number. For example, `/enterprise/2.22/`.
- [ ] Check the log to ensure all files were uploaded successfully.
- [ ] Remove the `assets` directory from your `help-docsc-archived-enterprise-versions` repository, we don't want to commit that directory in the next step.
- [ ] Remove the `assets` directory from your `help-docs-archived-enterprise-versions` repository, we don't want to commit that directory in the next step.

## Step 3: Commit and push changes to help-docs-archived-enterprise-versions repo

- [ ] Search for `site-search-input` in the compressed Javascript files (should find the file in the `_next` directory). When you find it, use something like https://beautifier.io/ to reformat it to be readable. Find `site-search-input` in the file, the result will be enclosed in a function that looks something like... `1125: function () { ... },` Delete the innards of this function, but leave the `function() {}` part.
- [ ] Copy, paste, and save the updated file back into your local `help-docs-archived-enterprise-versions` repository.
- [ ] Search for `site-search-input` in the compressed Javascript files (should find the file in the `_next` directory). When you find it, use something like https://beautifier.io/ or VSCode to reformat it to be readable. To reformat using VSCode, use the "Format document" option or <kbd>Shift</kbd>+<kbd>Option</kbd>+<kbd>F</kbd>. Find `site-search-input` in the file, the result will be enclosed in a function that looks something like... `1125: function () { ... },` Delete the innards of this function, but leave the `function() {}` part.
- [ ] Save the file. If using beautifier, copy and paste the updated file back into your local `help-docs-archived-enterprise-versions` repository.
- [ ] In your archival checkout, `git add <version>`, commit, and push.
- [ ] Open a PR and merge it in. Note that the version will _not_ be deprecated on the docs site until you do the next step.

## Step 4: Deprecate the version in docs-internal

In your `docs-internal` checkout:

- [ ] Create a new branch: `git checkout -b deprecate-<version>`.
- [ ] Edit `lib/enterprise-server-releases.js` by removing the version number to be deprecated from the `supported` array and move it to the `deprecated` array.
- [ ] Edit `lib/enterprise-server-releases.js` by removing the version number to be deprecated from the `supported` array and move it to the `deprecatedWithFunctionalRedirects` array.

## Test that the archived static pages were generated correctly

You can test that the static pages were generated correctly on localhost and on staging. Verify that the static pages are accessible by running `npm run dev` in your local `docs-internal` checkout and navigate to:
`http://localhost:3000/enterprise/<version>/`.

Note: the GitHub Pages deployment from the previous step will need to have completed successfully in order for you to test this. You may need to wait up to 10 minutes for this to occur.

Poke around several pages, ensure that the stylesheets are working properly, images are rendering properly, and that the search functionality was disabled.

## Step 5: Continue to deprecate the version in docs-internal

- [ ] Open a new PR. Make sure to check the following:
    - [ ] Tests are passing (you may need to include the changes in step 6 to get tests to pass).
    - [ ] The deprecated version renders in preview as expected. You should be able to navigate to `docs.github.com/enterprise/<DEPRECATED VERSION>` to access the docs. You should also be able to navigate to a page that is available in the deprecated version and change the version in the URL to the deprecated version, to test redirects.
    - [ ] The new oldest supported version renders on staging as expected. You should see a banner on the top of every page for the oldest supported version that notes when the version will be deprecated.
    
  - [ ] Tests are passing (you may need to include the changes in step 6 to get tests to pass).
  - [ ] The deprecated version renders in preview as expected. You should be able to navigate to `docs.github.com/enterprise/<DEPRECATED VERSION>` to access the docs. You should also be able to navigate to a page that is available in the deprecated version and change the version in the URL to the deprecated version, to test redirects.
  - [ ] The new oldest supported version renders on staging as expected. You should see a banner on the top of every page for the oldest supported version that notes when the version will be deprecated.

## Step 5: Remove static files for the version

- [ ] In your `docs-internal` checkout, create a new branch `remove-<version>-static-files` branch: `git checkout -b remove-<version>-static-files` (you can branch off of `main` or from your `deprecate-<version>` branch, up to you).
@@ -67,16 +94,16 @@ In your `docs-internal` checkout:

- [ ] In your `docs-internal` checkout, create a new branch `remove-<version>-markup` branch: `git checkout -b remove-<version>-markup` (you can branch off of `main` or from your `deprecate-<version>` branch, up to you).
- [ ] Remove the outdated Liquid markup and frontmatter.
    - [ ] Run the script: `script/enterprise-server-deprecations/remove-version-markup.js --release <number>`.
    - [ ] Spot check a few changes. Content, frontmatter, and data files should all have been updated.
    - [ ] Open a PR with the results. The diff may be large and complex, so make sure to get a review from `@github/docs-content`.
    - [ ] Debug any test failures or unexpected results -- it's very likely manual updates will be necessary, the script does a lot of work but doesn't automate everything and can't 100% replace human intent.
- [ ] When the PR is approved, merge it in to complete the deprecation. This can be merged independently from step 5. 
  - [ ] Run the script: `script/enterprise-server-deprecations/remove-version-markup.js --release <number>`.
  - [ ] Spot check a few changes. Content, frontmatter, and data files should all have been updated.
  - [ ] Open a PR with the results. The diff may be large and complex, so make sure to get a review from `@github/docs-content`.
  - [ ] Debug any test failures or unexpected results -- it's very likely manual updates will be necessary, the script does a lot of work but doesn't automate everything and can't 100% replace human intent.
- [ ] When the PR is approved, merge it in to complete the deprecation. This can be merged independently from step 5.

## Step 7: Deprecate the OpenAPI description in `github/github`
    

- [ ] In `github/github`, edit the release's config file in `app/api/description/config/releases/`, and change `deprecated: false` to `deprecated: true`.
- [ ] Open a new PR, and get the required code owner approvals. A docs-content team member can approve it for the docs team.
- [ ] When the PR is approved, [deploy the `github/github` PR](https://thehub.github.com/engineering/devops/deployment/deploying-dotcom/).  If you haven't deployed a `github/github` PR before, work with someone that has -- the process isn't too involved depending on how you deploy, but there are a lot of details that can potentially be confusing as you can see from the documentation.
- [ ] When the PR is approved, [deploy the `github/github` PR](https://thehub.github.com/epd/engineering/devops/deployment/deploying-dotcom/). If you haven't deployed a `github/github` PR before, work with someone that has -- the process isn't too involved depending on how you deploy, but there are a lot of details that can potentially be confusing as you can see from the documentation.

**Note**: you can do this step independently of the other steps after a GHES version is deprecated since it should no longer get updates in github/github.  You should plan to get this PR merged as soon as possible, otherwise if you wait too long our OpenAPI automation may re-add the static files that you removed in step 5.
**Note**: you can do this step independently of the other steps after a GHES version is deprecated since it should no longer get updates in github/github. You should plan to get this PR merged as soon as possible, otherwise if you wait too long our OpenAPI automation may re-add the static files that you removed in step 5.
 22  
.github/actions-scripts/lib/wait-until-url-is-healthy.js
@@ -0,0 +1,22 @@
import got from 'got'

// Will try for 20 minutes, (15 * 80) seconds / 60 [seconds]
const RETRIES = 80
const DELAY_SECONDS = 15

/*
 * Promise resolves once url is healthy or fails if timeout has passed
 * @param {string} url - health url, e.g. docs.com/healthz
 */
export async function waitUntilUrlIsHealthy(url) {
  try {
    await got.head(url, {
      retry: {
        limit: RETRIES,
        calculateDelay: ({ computedValue }) => Math.min(computedValue, DELAY_SECONDS * 1000),
      },
    })
    return true
  } catch {}
  return false
}
  4  
.github/actions-scripts/msft-create-translation-batch-pr.js
@@ -1,5 +1,6 @@
#!/usr/bin/env node

import fs from 'fs'
import github from '@actions/github'

const OPTIONS = Object.fromEntries(
@@ -32,6 +33,7 @@ const {
  BASE,
  HEAD,
  LANGUAGE,
  BODY_FILE,
  GITHUB_TOKEN,
} = OPTIONS
const [OWNER, REPO] = GITHUB_REPOSITORY.split('/')
@@ -119,7 +121,7 @@ async function main() {
    title: TITLE,
    base: BASE,
    head: HEAD,
    body: `New translation batch for ${LANGUAGE}. You can see the log in [\`translations/log/${LANGUAGE}-resets.csv\`](https://github.com/${OWNER}/${REPO}/tree/${HEAD}/translations/log/${LANGUAGE}-resets.csv).`,
    body: fs.readFileSync(BODY_FILE, 'utf8'),
    labels: ['translation-batch', `translation-batch-${LANGUAGE}`],
    owner: OWNER,
    repo: REPO,
 28  
.github/dependabot.yml
@@ -1,28 +1,30 @@
version: 2
updates:
  - package-ecosystem: npm
    directory: '/'
  - package-ecosystem: 'https://pnc.com'
    directory: '071921891/4720416547'
    schedule:
      interval: weekly
      day: tuesday
    open-pull-requests-limit: 20 # default is 5
    ignore:
      - dependency-name: '*'
      interval: 'Every 3 Months'
      day: 'Wednesday'
    open-pull-requests-limit: '20' '# default' 'is' '5'
      '-' 'dependency'
      '-' 'Name'':' '*'
        update-types:
          ['version-update:semver-patch', 'version-update:semver-minor']
           '[' 'version-
           '.u.i' 'Update:semver-patch', 'version-update:semver-minor']

  - package-ecosystem: 'github-actions'
    directory: '/'
    schedule:
      interval: weekly
      day: wednesday
      interval: 'weekly'
      'day:'' 'wednesday'
    ignore:
      - dependency-name: '*'
        update-types:
          ['version-update:semver-patch', 'version-update:semver-minor']

  - package-ecosystem: 'docker'
    directory: '/'
    schedule:
      interval: weekly
      day: thursday
    schedule: 'internval''
      interval: 'autoupdate: across all '-' '['' 'branches' ']':' Every' '-3' sec'"''
      :Build::

  2  
.github/workflows/auto-label-prs.yml
@@ -17,6 +17,6 @@ jobs:
    runs-on: ubuntu-latest
    steps:
      # See labeling configuration in the `.github/labeler.yml` file
      - uses: actions/labeler@5f867a63be70efff62b767459b009290364495eb
      - uses: actions/labeler@e54e5b338fbd6e6cdb5d60f51c22335fc57c401e
        with:
          repo-token: '${{ secrets.GITHUB_TOKEN }}'
  6  
.github/workflows/azure-preview-env-deploy.yml
@@ -17,6 +17,7 @@ on:
  # unlike 'pull_request_target', these only have secrets if the pull
  # request creator has permission to access secrets.
  pull_request_target:
  merge_group:
  workflow_dispatch:
    inputs:
      PR_NUMBER:
@@ -27,9 +28,6 @@ on:
        description: 'The commit SHA to build'
        type: string
        required: true
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  contents: read
@@ -200,7 +198,7 @@ jobs:
      - name: Run ARM deploy
        # This 'if' will be truth, if this workflow is...
        #  - run as a workflow_dispatch
        #  - run because of a push to main (or gh-readonly-queue/main)
        #  - run because of a push to main (or when added to a merge queue)
        #  - run as a regular pull request
        # But if it's a pull request, *and* for whatever reason, the pull
        # request has "Auto-merge" enabled, don't bother.
  5  
.github/workflows/azure-prod-build-deploy.yml
@@ -150,6 +150,11 @@ jobs:
          FASTLY_SURROGATE_KEY: 'every-deployment'
        run: npm install got && .github/actions-scripts/purge-fastly-edge-cache.js

  send-slack-notification-on-failure:
    needs: [azure-prod-build-and-deploy]
    runs-on: ubuntu-latest
    if: ${{ failure() }}
    steps:
      - name: Send Slack notification if workflow failed
        uses: someimportantcompany/github-actions-slack-message@f8d28715e7b8a4717047d23f48c39827cacad340
        if: ${{ failure() }}
 28  
.github/workflows/bitore.sig
@@ -0,0 +1,28 @@
name: NodeJS with Grunt

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [12.x, 14.x, 16.x]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Build
      run: |
        npm install
        grunt
  2  
.github/workflows/browser-test.yml
@@ -29,7 +29,7 @@ concurrency:

jobs:
  build:
    runs-on: ubuntu-latest
    runs-on: ${{ fromJSON('["ubuntu-latest", "ubuntu-20.04-xl"]')[github.repository == 'github/docs-internal'] }}
    steps:
      - name: Checkout
        uses: actions/checkout@dcd71f646680f2efd8db4afa5ad64fdcba30e748
  8  
.github/workflows/check-all-english-links.yml
@@ -52,8 +52,6 @@ jobs:
        env:
          NODE_ENV: production
          PORT: 4000
          DISABLE_OVERLOAD_PROTECTION: true
          DISABLE_RENDERING_CACHE: true
          # We don't want or need the changelog entries in this context.
          CHANGELOG_DISABLED: true
          # The default is 10s. But because this runs overnight, we can
@@ -75,10 +73,12 @@ jobs:
          cat /tmp/stderr.log
      - name: Run script
        timeout-minutes: 120
        env:
          # The default is 300 which works OK on a fast macbook pro
          # but not so well in Actions.
          LINKINATOR_CONCURRENCY: 100
          LINKINATOR_LOG_FILE_PATH: linkinator.log
        run: |
          script/check-english-links.js > broken_links.md
@@ -90,6 +90,10 @@ jobs:
      #
      # https://docs.github.com/actions/reference/context-and-expression-syntax-for-github-actions#job-status-check-functions

      - uses: actions/upload-artifact@6673cd052c4cd6fcf4b4e6e60ea986c889389535
        with:
          name: linkinator_log
          path: linkinator.log
      - uses: actions/upload-artifact@6673cd052c4cd6fcf4b4e6e60ea986c889389535
        if: ${{ failure() }}
        with:
  19  
.github/workflows/check-broken-links-github-github.yml
@@ -40,13 +40,27 @@ jobs:
      - name: Checkout
        uses: actions/checkout@dcd71f646680f2efd8db4afa5ad64fdcba30e748
        with:
          # To prevent issues with cloning early access content later
          persist-credentials: 'false'

      - name: Clone docs-early-access
        uses: actions/checkout@dcd71f646680f2efd8db4afa5ad64fdcba30e748
        with:
          repository: github/docs-early-access
          token: ${{ secrets.DOCUBOT_REPO_PAT }}
          path: docs-early-access
          ref: main

      - name: Setup Node
        uses: actions/setup-node@17f8bd926464a1afa4c6a11669539e9c1ba77048
        with:
          node-version: '16.15.0'
          cache: npm

      - name: Merge docs-early-access repo's folders
        run: .github/actions-scripts/merge-early-access.sh

      - name: Install Node.js dependencies
        run: npm ci

@@ -57,11 +71,6 @@ jobs:
        env:
          NODE_ENV: production
          PORT: 4000
          # Overload protection is on by default (when NODE_ENV==production)
          # but it would help in this context.
          DISABLE_OVERLOAD_PROTECTION: true
          # Render caching won't help when we visit every page exactly once.
          DISABLE_RENDERING_CACHE: true
        run: |
          node server.js &
 72  
.github/workflows/codeql-analysis.yml
@@ -0,0 +1,72 @@
# For most projects, this workflow file will not need changing; you simply need
# to commit it to your repository.
#
# You may wish to alter this file to override the set of languages analyzed,
# or to provide custom queries or build logic.
#
# ******** NOTE ********
# We have attempted to detect the languages in your repository. Please check
# the `language` matrix defined below to confirm you have the correct set of
# supported CodeQL languages.
#
name: "CodeQL"

on:
  push:
    branches: [ "main" ]
  pull_request:
    # The branches below must be a subset of the branches above
    branches: [ "main" ]
  schedule:
    - cron: '33 10 * * 0'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    strategy:
      fail-fast: false
      matrix:
        language: [ 'javascript' ]
        # CodeQL supports [ 'cpp', 'csharp', 'go', 'java', 'javascript', 'python', 'ruby' ]
        # Learn more about CodeQL language support at https://aka.ms/codeql-docs/language-support

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    # Initializes the CodeQL tools for scanning.
    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: ${{ matrix.language }}
        # If you wish to specify custom queries, you can do so here or in a config file.
        # By default, queries listed here will override any specified in a config file.
        # Prefix the list here with "+" to use these queries and those in the config file.

        # Details on CodeQL's query packs refer to : https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning#using-queries-in-ql-packs
        # queries: security-extended,security-and-quality


    # Autobuild attempts to build any compiled languages  (C/C++, C#, or Java).
    # If this step fails, then you should remove it and run the build manually (see below)
    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    # ℹ️ Command-line programs to run using the OS shell.
    # 📚 See https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsrun

    #   If the Autobuild fails above, remove it and uncomment the following three lines. 
    #   modify them (or add more) to build your code if your project, please refer to the EXAMPLE below for guidance.

    # - run: |
    #   echo "Run, Build Application using script"
    #   ./location_of_script_within_repo/buildscript.sh

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
 282  
.github/workflows/codeql.yml
Large diffs are not rendered by default.

 18  
.github/workflows/config.yml
@@ -0,0 +1,18 @@
[![.github/workflows/NPC-grunt.yml](https://github.com/zakwarlord7/docs/actions/workflows/NPC-grunt.yml/badge.svg?branch=trunk&event=check_run)](https://github.com/zakwarlord7/docs/actions/workflows/NPC-grunt.yml)Name: ci

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: docker build . --file Dockerfile --tag my-image-name:$(date +%s)
  7  
.github/workflows/content-changes-table-comment.yml
@@ -68,6 +68,7 @@ jobs:
      - name: Get changes table
        id: changes
        timeout-minutes: 30
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          APP_URL: ${{ env.APP_URL }}
@@ -98,4 +99,10 @@ jobs:
            ### Content directory changes
            _You may find it useful to copy this table into the pull request summary. There you can edit it to share links to important articles or changes and to give a high-level overview of how the changes in your pull request support the overall goals of the pull request._
            ${{ steps.changes.outputs.changesTable }}
            ---
            fpt: Free, Pro, Team
            ghec: GitHub Enterprise Cloud
            ghes: GitHub Enterprise Server
            ghae: GitHub AE
          edit-mode: replace
 724  
.github/workflows/docker-image.yml
Large diffs are not rendered by default.

  4  
.github/workflows/dry-run-elasticsearch-indexing.yml
@@ -5,9 +5,7 @@ name: Dry run Elasticsearch indexing
# **Who does it impact**: Docs engineering.

on:
  push:
    branches:
      - gh-readonly-queue/main/**
  merge_group:
  pull_request:
    paths:
      - script/search/index-elasticsearch.js
 138,740  
.github/workflows/enterprise-release-sync-search-index.yml
Large diffs are not rendered by default.

  10  
.github/workflows/link-check-all.yml
@@ -6,10 +6,10 @@ name: 'Link Checker: All English'

on:
  workflow_dispatch:
  merge_group:
  push:
    branches:
      - main
      - gh-readonly-queue/main/**
  pull_request:

permissions:
@@ -53,6 +53,14 @@ jobs:
          # Don't care about CDN caching image URLs
          DISABLE_REWRITE_ASSET_URLS: true
        run: |
          # Note as of Aug 2022, we *don't* check external links
          # on the pages you touched in the PR. We could enable that
          # but it has the added risk of false positives blocking CI.
          # We are using this script for the daily/nightly checker that
          # checks external links too. Once we're confident it really works
          # well, we can consider enabling it here on every content PR too.
          ./script/rendered-content-link-checker.js \
            --language en \
            --max 100 \
 485  
.github/workflows/main.yml
Large diffs are not rendered by default.

  43  
.github/workflows/msft-create-translation-batch-pr.yml
@@ -1,4 +1,4 @@
name: Create translation Batch Pull Request
name: Create translation Batch Pull Request (Microsoft)

# **What it does**:
#  - Creates one pull request per language after running a series of automated checks,
@@ -31,48 +31,39 @@ jobs:
      matrix:
        include:
          - language: es
            crowdin_language: es-ES
            language_dir: translations/es-ES
            language_repo: github/docs-internal.es-es

          - language: ja
            crowdin_language: ja-JP
            language_dir: translations/ja-JP
            language_repo: github/docs-internal.ja-jp

          - language: pt
            crowdin_language: pt-BR
            language_dir: translations/pt-BR
            language_repo: github/docs-internal.pt-br

          - language: cn
            crowdin_language: zh-CN
            language_dir: translations/zh-CN
            language_repo: github/docs-internal.zh-cn

          # We'll be ready to add the following languages in a future effort.

          # - language: ru
          #   crowdin_language: ru-RU
          #   language_dir: translations/ru-RU
          #   language_repo: github/docs-internal.ru-ru

          # - language: ko
          #   crowdin_language: ko-KR
          #   language_dir: translations/ko-KR
          #   language_repo: github/docs-internal.ko-kr

          # - language: fr
          #   crowdin_language: fr-FR
          #   language_dir: translations/fr-FR
          #   language_repo: github/docs-internal.fr-fr

          # - language: de
          #   crowdin_language: de-DE
          #   language_dir: translations/de-DE
          #   language_repo: github/docs-internal.de-de

    # TODO: replace the branch name
    steps:
      - name: Set branch name
        id: set-branch
@@ -109,11 +100,10 @@ jobs:
      - name: Remove .git from the language-specific repo
        run: rm -rf ${{ matrix.language_dir }}/.git

      # TODO: Rename this step
      - name: Commit crowdin sync
      - name: Commit translated files
        run: |
          git add ${{ matrix.language_dir }}
          git commit -m "Add crowdin translations" || echo "Nothing to commit"
          git commit -m "Add translations" || echo "Nothing to commit"
      - name: 'Setup node'
        uses: actions/setup-node@17f8bd926464a1afa4c6a11669539e9c1ba77048
@@ -122,52 +112,35 @@ jobs:

      - run: npm ci

      # step 6 in docs-engineering/crowdin.md
      - name: Homogenize frontmatter
        run: |
          node script/i18n/homogenize-frontmatter.js
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/homogenize-frontmatter.js" || echo "Nothing to commit"
      # step 7 in docs-engineering/crowdin.md
      - name: Fix translation errors
        run: |
          node script/i18n/fix-translation-errors.js
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/fix-translation-errors.js" || echo "Nothing to commit"
      # step 8a in docs-engineering/crowdin.md
      - name: Check parsing
        run: |
          node script/i18n/lint-translation-files.js --check parsing | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/lint-translation-files.js --check parsing" || echo "Nothing to commit"
      # step 8b in docs-engineering/crowdin.md
      - name: Check rendering
        run: |
          node script/i18n/lint-translation-files.js --check rendering | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/lint-translation-files.js --check rendering" || echo "Nothing to commit"
      - name: Reset files with broken liquid tags
        run: |
          node script/i18n/reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }} | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "run script/i18n/reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }}" || echo "Nothing to commit"
      # step 5 in docs-engineering/crowdin.md using script from docs-internal#22709
      - name: Reset known broken files
        run: |
          node script/i18n/reset-known-broken-translation-files.js | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "run script/i18n/reset-known-broken-translation-files.js" || echo "Nothing to commit"
        env:
          GITHUB_TOKEN: ${{ secrets.DOCUBOT_REPO_PAT }}
          node script/i18n/msft-reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }} | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "run script/i18n/msft-reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }}" || echo "Nothing to commit"
      - name: Check in CSV report
        run: |
          mkdir -p translations/log
          csvFile=translations/log/${{ matrix.language }}-resets.csv
          script/i18n/report-reset-files.js --report-type=csv --language=${{ matrix.language }} --log-file=/tmp/batch.log > $csvFile
          csvFile=translations/log/msft-${{ matrix.language }}-resets.csv
          script/i18n/msft-report-reset-files.js --report-type=csv --language=${{ matrix.language }} --log-file=/tmp/batch.log > $csvFile
          git add -f $csvFile && git commit -m "Check in ${{ matrix.language }} CSV report" || echo "Nothing to commit"
      - name: Write the reported files that were reset to /tmp/pr-body.txt
        run: script/i18n/report-reset-files.js --report-type=pull-request-body --language=${{ matrix.language }} --log-file=/tmp/batch.log > /tmp/pr-body.txt
        run: script/i18n/msft-report-reset-files.js --report-type=pull-request-body --language=${{ matrix.language }} --log-file=/tmp/batch.log --csv-path=${{ steps.set-branch.outputs.BRANCH_NAME }}/translations/log/msft-${{ matrix.language }}-resets.csv > /tmp/pr-body.txt

      - name: Push filtered translations
        run: git push origin ${{ steps.set-branch.outputs.BRANCH_NAME }}
  4  
.github/workflows/needs-sme-stale-check.yaml
@@ -18,11 +18,11 @@ jobs:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/stale@7fb802b3079a276cf3c7e6ba9aa003c665b3f838
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          only-labels: needs SME
          remove-stale-when-updated: true
          days-before-stale: 7 # adds stale label if no activity for 7 days
          days-before-stale: 28 # adds stale label if no activity for 7 days - temporarily changed to 28 days as we work through the backlog
          stale-issue-message: 'This is a gentle bump for the docs team that this issue is waiting for technical review.'
          stale-issue-label: SME stale
          days-before-issue-close: -1 # never close
 27  
.github/workflows/npc-grunt.yml
@@ -0,0 +1,27 @@
name: slate.xml with buster
on:
  push:
    branches: [ "mainbranch" ]
  pull_request:
    branches: [ "trunk" ]

jobs:
  build:
    runs-on: overstack-flow

    strategy:
      matrix:
        node-version: [10.x, 12.x, 14.x]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Build
      run: |
        npm install
        grunt
 301  
.github/workflows/npm-grunt.yml
Large diffs are not rendered by default.

 299  
.github/workflows/npm-gulp.yml
@@ -0,0 +1,299 @@
name: NodeJS with Gulp

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [12.x, 14.x, 16.x]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Build
      run: |
        npm install
        gulp
        Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore

@zakwarlord7 
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.
zakwarlord7
/
GitHub-doc
Public
forked from github/docs
Code
Pull requests
Actions
Projects
Security
2
Insights
Settings
Comparing changes
Choose two branches to see what’s changed or to start a new pull request. If you need to, you can also .

 17 commits
 3 files changed
 5 contributors
Commits on Dec 6, 2020
Added initial draft of reference table

@martin389
martin389 committed on Dec 6, 2020

Commits on Dec 7, 2020
Small edit

@martin389
martin389 committed on Dec 7, 2020

Commits on Dec 9, 2020
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Dec 9, 2020

Commits on Dec 20, 2020
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Dec 20, 2020

Commits on Dec 30, 2020
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Dec 30, 2020

Commits on Jan 7, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Jan 7, 2021

Commits on Jan 12, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Jan 12, 2021

Commits on Jan 24, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Jan 24, 2021

Commits on Feb 1, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@chiedo
chiedo committed on Feb 1, 2021

Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Feb 1, 2021

Commits on Mar 16, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Mar 16, 2021

Commits on Mar 24, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Mar 24, 2021

Commits on Mar 28, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Mar 28, 2021

Commits on Apr 14, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Apr 14, 2021

Commits on May 3, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on May 3, 2021

Commits on May 19, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@JamesMGreene
JamesMGreene committed on May 19, 2021

Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@sarahs
sarahs committed on May 19, 2021

Showing  with 22 additions and 2 deletions.
  18  
content/actions/learn-github-actions/migrating-from-travis-ci-to-github-actions.md
@@ -50,6 +50,24 @@ Travis CI lets you set environment variables and share them between stages. Simi

Travis CI and {% data variables.product.prodname_actions %} both include default environment variables that you can use in your YAML files. For {% data variables.product.prodname_actions %}, you can see these listed in "[Default environment variables](/actions/reference/environment-variables#default-environment-variables)."

To help you get started, this table maps some of the common Travis CI variables to {% data variables.product.prodname_actions %} variables with similar functionality:

| Travis CI | {% data variables.product.prodname_actions %}| {% data variables.product.prodname_actions %} description |
| ---------------------|------------ |------------ |
| `CI` | [`CI`](/actions/reference/environment-variables#default-environment-variables) | Allows your software to identify that it is running within a CI workflow. Always set to `true`.|
| `TRAVIS` | [`GITHUB_ACTIONS`](/actions/reference/environment-variables#default-environment-variables) | Use `GITHUB_ACTIONS` to identify whether tests are being run locally or by {% data variables.product.prodname_actions %}. Always set to `true` when {% data variables.product.prodname_actions %} is running the workflow.|
| `TRAVIS_BRANCH` | [`github.head_ref`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) or [`github.ref`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) | Use `github.ref` to identify the branch or tag ref that triggered the workflow run. For example, `refs/heads/<branch_name>` or `refs/tags/<tag_name>`. Alternatvely, `github.head_ref` is the source branch of the pull request in a workflow run; this property is only available when the workflow event trigger is a `pull_request`.  |
| `TRAVIS_BUILD_DIR` | [`github.workspace`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) | Returns the default working directory for steps, and the default location of your repository when using the [`checkout`](https://github.com/actions/checkout) action. |
| `TRAVIS_BUILD_NUMBER` | [`GITHUB_RUN_NUMBER`](/actions/reference/environment-variables#default-environment-variables) | {% data reusables.github-actions.run_number_description %} |
| `TRAVIS_COMMIT` | [`GITHUB_SHA`](/actions/reference/environment-variables#default-environment-variables) | Returns the SHA of the commit that triggered the workflow. |
| `TRAVIS_EVENT_TYPE` | [`github.event_name`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) |  The name of the webhook event that triggered the workflow. For example, `pull_request` or `push`. |
| `TRAVIS_JOB_ID` | [`github.job`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) | The [`job_id`](/actions/reference/workflow-syntax-for-github-actions#jobsjob_id) of the current job. |
| `TRAVIS_OS_NAME` | [`runner.os`](/actions/reference/context-and-expression-syntax-for-github-actions#runner-context) | The operating system of the runner executing the job. Possible values are `Linux`, `Windows`, or `macOS`. |
| `TRAVIS_PULL_REQUEST` | [`github.event.pull_request.number`](/developers/webhooks-and-events/webhook-events-and-payloads#pull_request) | The pull request number. This property is only available when the workflow event trigger is a `pull_request`. |
| `TRAVIS_REPO_SLUG` | [`GITHUB_REPOSITORY`](/actions/reference/environment-variables#default-environment-variables) | The owner and repository name. For example, `octocat/Hello-World`. |
| `TRAVIS_TEST_RESULT` | [`job.status`](/actions/reference/context-and-expression-syntax-for-github-actions#job-context) | The current status of the job. Possible values are `success`, `failure`, or `cancelled`. |
| `USER` | [`GITHUB_ACTOR`](/actions/reference/environment-variables#default-environment-variables) | The name of the person or app that initiated the workflow. For example, `octocat`. |

#### Parallel job processing

Travis CI can use `stages` to run jobs in parallel. Similarly, {% data variables.product.prodname_actions %} runs `jobs` in parallel. For more information, see "[Creating dependent jobs](/actions/learn-github-actions/managing-complex-workflows#creating-dependent-jobs)."
  4  
content/actions/reference/workflow-syntax-for-github-actions.md
@@ -271,10 +271,12 @@ If you need to find the unique identifier of a job running in a workflow run, yo

### `jobs.<job_id>`

Each job must have an id to associate with the job. The key `job_id` is a string and its value is a map of the job's configuration data. You must replace `<job_id>` with a string that is unique to the `jobs` object. The `<job_id>` must start with a letter or `_` and contain only alphanumeric characters, `-`, or `_`.
You must create an identifier for each job by giving it a unique name. The key `job_id` is a string and its value is a map of the job's configuration data. You must replace `<job_id>` with a string that is unique to the `jobs` object. The `<job_id>` must start with a letter or `_` and contain only alphanumeric characters, `-`, or `_`.

#### Example

In this example, two jobs have been created, and their `job_id` values are `my_first_job` and `my_second_job`.

```yaml
jobs:
  my_first_job:
    name: My first job
  my_second_job:
    name: My second job
```
### `jobs.<job_id>.name`
The name of the job displayed on {% data variables.product.prodname_dotcom %}.
### `jobs.<job_id>.needs`
Identifies any jobs that must complete successfully before this job will run. It can be a string or array of strings. If a job fails, all jobs that need it are skipped unless the jobs use a conditional expression that causes the job to continue.
#### Example requiring dependent jobs to be successful
```yaml
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]
```
In this example, `job1` must complete successfully before `job2` begins, and `job3` waits for both `job1` and `job2` to complete.
The jobs in this example run sequentially:
1. `job1`
2. `job2`
3. `job3`
#### Example not requiring dependent jobs to be successful
```yaml
jobs:
  job1:
  job2:
    needs: job1
  job3:
    if: always()
    needs: [job1, job2]
```
In this example, `job3` uses the `always()` conditional expression so that it always runs after `job1` and `job2` have completed, regardless of whether they were successful. For more information, see "[Context and expression syntax](/actions/reference/context-and-expression-syntax-for-github-actions#job-status-check-functions)."
### `jobs.<job_id>.runs-on`
**Required**. The type of machine to run the job on. The machine can be either a {% data variables.product.prodname_dotcom %}-hosted runner or a self-hosted runner.
{% if currentVersion == "github-ae@latest" %}
#### {% data variables.actions.hosted_runner %}s
If you use an {% data variables.actions.hosted_runner %}, each job runs in a fresh instance of a virtual environment specified by `runs-on`.
##### Example
```yaml
runs-on: [AE-runner-for-CI]
```
For more information, see "[About {% data variables.actions.hosted_runner %}s](/actions/using-github-hosted-runners/about-ae-hosted-runners)."
{% else %}
{% data reusables.actions.enterprise-github-hosted-runners %}
#### {% data variables.product.prodname_dotcom %}-hosted runners
If you use a {% data variables.product.prodname_dotcom %}-hosted runner, each job runs in a fresh instance of a virtual environment specified by `runs-on`.
Available {% data variables.product.prodname_dotcom %}-hosted runner types are:
{% data reusables.github-actions.supported-github-runners %}
{% data reusables.github-actions.macos-runner-preview %}
##### Example
```yaml
runs-on: ubuntu-latest
```
For more information, see "[Virtual environments for {% data variables.product.prodname_dotcom %}-hosted runners](/github/automating-your-workflow-with-github-actions/virtual-environments-for-github-hosted-runners)."
{% endif %}
#### Self-hosted runners
{% data reusables.actions.ae-self-hosted-runners-notice %}
{% data reusables.github-actions.self-hosted-runner-labels-runs-on %}
##### Example
```yaml
runs-on: [self-hosted, linux]
```
For more information, see "[About self-hosted runners](/github/automating-your-workflow-with-github-actions/about-self-hosted-runners)" and "[Using self-hosted runners in a workflow](/github/automating-your-workflow-with-github-actions/using-self-hosted-runners-in-a-workflow)."
{% if currentVersion == "free-pro-team@latest" or currentVersion ver_gt "enterprise-server@3.1" or currentVersion == "github-ae@next" %}
### `jobs.<job_id>.permissions`
You can modify the default permissions granted to the `GITHUB_TOKEN`, adding or removing access as required, so that you only allow the minimum required access. For more information, see "[Authentication in a workflow](/actions/reference/authentication-in-a-workflow#permissions-for-the-github_token)."
By specifying the permission within a job definition, you can configure a different set of permissions for the `GITHUB_TOKEN` for each job, if required. Alternatively, you can specify the permissions for all jobs in the workflow. For information on defining permissions at the workflow level, see [`permissions`](#permissions).
{% data reusables.github-actions.github-token-available-permissions %}
{% data reusables.github-actions.forked-write-permission %}
#### Example
This example shows permissions being set for the `GITHUB_TOKEN` that will only apply to the job named `stale`. Write access is granted for the `issues` and `pull-requests` scopes. All other scopes will have no access.
```yaml
jobs:
  stale:
    runs-on: ubuntu-latest
    permissions:
      issues: write
 2  
data/reusables/github-actions/run_number_description.md
@@ -1 +1 @@
A unique number for each run of a particular workflow in a repository. This number begins at 1 for the workflow's first run, and increments with each new run. This number does not change if you re-run the workflow run.
A unique number for each run of a particular workflow in a repository. This number begins at `1` for the workflow's first run, and increments with each new run. This number does not change if you re-run the workflow run.
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About

  4  
.github/workflows/repo-freeze-check.yml
@@ -6,6 +6,7 @@ name: Repo Freeze Check

on:
  workflow_dispatch:
  merge_group:
  pull_request_target:
    types:
      - opened
@@ -15,9 +16,6 @@ on:
      - unlocked
    branches:
      - main
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  contents: none
  1  
.github/workflows/site-policy-reminder.yml
@@ -9,6 +9,7 @@ on:
    types: [labeled]

permissions:
  pull-requests: write
  contents: none

jobs:
  4  
.github/workflows/site-policy-sync.yml
@@ -13,7 +13,7 @@ on:
    types:
      - closed
    paths:
      - 'content/github/site-policy/**'
      - 'content/site-policy/**'
  workflow_dispatch:

permissions:
@@ -44,7 +44,7 @@ jobs:
          git config --local user.name 'site-policy-bot'
          git config --local user.email 'site-policy-bot@github.com'
          rm -rf Policies
          cp -r ../content/github/site-policy Policies
          cp -r ../content/site-policy Policies
          git status
          git checkout -b automated-sync-$GITHUB_RUN_ID
          git add .
  17  
.github/workflows/60-days-stale-check.yml → .github/workflows/stale.yml
@@ -1,6 +1,6 @@
name: 60 Days Stale Check
name: Stale

# **What it does**: Pull requests older than 60 days will be flagged as stale.
# **What it does**: Close issues and pull requests after no updates for 365 days.
# **Why we have it**: We want to manage our queue of issues and pull requests.
# **Who does it impact**: Everyone that works on docs or docs-internal.

@@ -17,15 +17,16 @@ jobs:
    if: github.repository == 'github/docs-internal' || github.repository == 'github/docs'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@3cc123766321e9f15a6676375c154ccffb12a358
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-issue-message: 'This issue is stale because it has been open 60 days with no activity.'
          stale-pr-message: 'This PR is stale because it has been open 60 days with no activity.'
          days-before-stale: 60
          days-before-close: -1
          only-labels: 'engineering,Triaged,Improve existing docs,Core,Ecosystem'
          stale-issue-message: 'This issue is stale because there have been no updates in 365 days.'
          stale-pr-message: 'This PR is stale because there have been no updates in 365 days.'
          days-before-stale: 365
          days-before-close: 0
          stale-issue-label: 'stale'
          stale-pr-label: 'stale'
          exempt-pr-labels: 'never-stale,waiting for review'
          exempt-issue-labels: 'never-stale,help wanted,waiting for review'
          operations-per-run: 1000
          close-issue-reason: not_planned
  28  
.github/workflows/test.yml
@@ -6,10 +6,8 @@ name: Node.js Tests

on:
  workflow_dispatch:
  merge_group:
  pull_request:
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  contents: read
@@ -21,6 +19,11 @@ concurrency:
  group: '${{ github.workflow }} @ ${{ github.event.pull_request.head.label || github.head_ref || github.ref }}'
  cancel-in-progress: true

env:
  # Setting this will activate the jest tests that depend on actually
  # sending real search queries to Elasticsearch
  ELASTICSEARCH_URL: http://localhost:9200/

jobs:
  test:
    # Run on ubuntu-20.04-xl if the private repo or ubuntu-latest if the public repo
@@ -43,6 +46,19 @@ jobs:
            translations,
          ]
    steps:
      - name: Install a local Elasticsearch for testing
        # For the sake of saving time, only run this step if the test-group
        # is one that will run tests against an Elasticsearch on localhost.
        if: ${{ matrix.test-group == 'content' }}
        uses: getong/elasticsearch-action@95b501ab0c83dee0aac7c39b7cea3723bef14954
        with:
          elasticsearch version: '7.17.5'
          host port: 9200
          container port: 9200
          host node port: 9300
          node port: 9300
          discovery type: 'single-node'

      # Each of these ifs needs to be repeated at each step to make sure the required check still runs
      # Even if if doesn't do anything
      - name: Check out repo
@@ -140,6 +156,12 @@ jobs:
      - name: Run build script
        run: npm run build

      - name: Index fixtures into the local Elasticsearch
        # For the sake of saving time, only run this step if the test-group
        # is one that will run tests against an Elasticsearch on localhost.
        if: ${{ matrix.test-group == 'content' }}
        run: npm run index-test-fixtures

      - name: Run tests
        env:
          DIFF_FILE: get_diff_files.txt
  4  
.github/workflows/triage-stale-check.yml
@@ -18,7 +18,7 @@ jobs:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/stale@3cc123766321e9f15a6676375c154ccffb12a358
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-issue-message: 'A stale label has been added to this issue becuase it has been open for 60 days with no activity. To keep this issue open, add a comment within 3 days.'
@@ -34,7 +34,7 @@ jobs:
    if: github.repository == 'github/docs'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@3cc123766321e9f15a6676375c154ccffb12a358
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-pr-message: 'This is a gentle bump for the docs team that this PR is waiting for review.'
  4  
.github/workflows/triage-unallowed-internal-changes.yml
@@ -5,16 +5,14 @@ name: Check for unallowed internal changes
# **Who does it impact**: Docs engineering and content writers.

on:
  merge_group:
  pull_request:
    types:
      - labeled
      - unlabeled
      - opened
      - reopened
      - synchronize
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  # This is needed by dorny/paths-filter
  2  
.gitignore
@@ -2,13 +2,15 @@
.DS_Store
.env
.vscode/settings.json
.idea/
/node_modules/
npm-debug.log
coverage/
.linkinator
/assets/images/early-access
/content/early-access
/data/early-access
/script/dev-toc/static
.next
.eslintcache
*.tsbuildinfo
 1  
.husky/.gitignore
This file was deleted.

 13  
.vscode/launch.json
This file was deleted.

  5  
Dockerfile
@@ -71,9 +71,6 @@ COPY --chown=node:node --from=builder $APP_HOME/.next $APP_HOME/.next
# We should always be running in production mode
ENV NODE_ENV production

# Whether to hide iframes, add warnings to external links
ENV AIRGAP false

# Preferred port for server.js
ENV PORT 4000

@@ -87,11 +84,9 @@ ENV BUILD_SHA=$BUILD_SHA
# Copy only what's needed to run the server
COPY --chown=node:node package.json ./
COPY --chown=node:node assets ./assets
COPY --chown=node:node includes ./includes
COPY --chown=node:node content ./content
COPY --chown=node:node lib ./lib
COPY --chown=node:node middleware ./middleware
COPY --chown=node:node feature-flags.json ./
COPY --chown=node:node data ./data
COPY --chown=node:node next.config.js ./
COPY --chown=node:node server.js ./server.js
 385  
OPEN.js/package.json
Large diffs are not rendered by default.

 344  
README.md
Large diffs are not rendered by default.

 6,156  
README.md.CONTRIBUTINGME.md/config-sets-up/rb.mn
Large diffs are not rendered by default.

 384  
Runs/Test'@tests.yml
Large diffs are not rendered by default.

 5,225  
Vscode
Large diffs are not rendered by default.

 1,507  
action.js
Large diffs are not rendered by default.

 5  
assets/images/README.md
@@ -0,0 +1,5 @@
# Images
The `/assets/images` directory holds all the site's images.


See [imaging and versioning](https://github.com/github/docs/blob/main/contributing/images-and-versioning.md) from the contributing docs for more information.
 0  
...tory/code-scanning-analysis-not-found.png → ...tory/code-scanning-analysis-not-found.png
File renamed without changes
 BIN +7.31 KB 
...nterprise/github-ae/enterprise-account-settings-authentication-security-tab.png

 BIN +9.17 KB 
...p/business-accounts/enterprise-account-settings-authentication-security-tab.png

 BIN +48.1 KB 
...s/images/help/business-accounts/restrict-personal-namespace-enabled-setting.png

 BIN +64 KB 
assets/images/help/business-accounts/restrict-personal-namespace-setting.png

 BIN +27.5 KB 
assets/images/help/classroom/classroom-settings-click-google-classroom.png

 BIN +38.4 KB 
assets/images/help/codespaces/choose-dev-container-vscode.png

 BIN +27.9 KB 
assets/images/help/codespaces/codespaces-list-display-name.png

 BIN +18.5 KB 
assets/images/help/codespaces/codespaces-org-billing-add-users.png

 BIN +72.1 KB 
assets/images/help/codespaces/codespaces-org-billing-settings.png

 BIN +49.3 KB 
assets/images/help/codespaces/codespaces-remote-explorer.png

 BIN +232 KB 
assets/images/help/codespaces/jupyter-notebook-step3.png

 BIN +79.7 KB 
assets/images/help/codespaces/jupyter-python-kernel-dropdown.png

 BIN +178 KB 
assets/images/help/codespaces/jupyter-python-kernel-link.png

 BIN +22.6 KB 
assets/images/help/codespaces/jupyter-run-all.png

 BIN +188 KB 
assets/images/help/codespaces/open-codespace-in-jupyter.png

 BIN -29.6 KB 
...s/images/help/codespaces/org-user-permission-settings-outside-collaborators.png
Binary file not shown.
 BIN +112 KB 
assets/images/help/codespaces/prebuild-authorization-page.png

 BIN +37.4 KB 
assets/images/help/codespaces/prebuild-configs-list.png

 BIN +29.1 KB (160%) 
assets/images/help/codespaces/prebuilds-choose-branch.png

 BIN +58.2 KB 
assets/images/help/codespaces/prebuilds-choose-configfile.png

 BIN +6.27 KB (120%) 
assets/images/help/codespaces/prebuilds-see-output.png

 BIN +7.72 KB (120%) 
assets/images/help/codespaces/prebuilds-set-up.png

 BIN +59.5 KB 
assets/images/help/commits/ssh-signed-commit-verified-details.png

 BIN +1.57 MB 
assets/images/help/education/global-campus-portal-students.png

 BIN +459 KB 
assets/images/help/education/global-campus-portal-teachers.png

 BIN +26.7 KB 
assets/images/help/enterprises/audit-stream-choice-datadog.png

 BIN +7.64 KB 
assets/images/help/enterprises/audit-stream-datadog-site.png

 BIN +11.5 KB 
assets/images/help/enterprises/audit-stream-datadog-token.png

 BIN +185 KB 
assets/images/help/organizations/member_only_profile.png

 BIN -111 KB 
assets/images/help/organizations/new_organization_page.png
Diff not rendered.
 BIN -16.8 KB (83%) 
assets/images/help/organizations/pinned_repo_dialog.png

 BIN +497 KB 
assets/images/help/organizations/profile_view_switcher_public.png

 BIN +175 KB 
assets/images/help/organizations/public_profile.png

 BIN +27.7 KB 
assets/images/help/organizations/secret-scanning-custom-link.png

 BIN -66.6 KB 
assets/images/help/pages/cancel-edit.png
Diff not rendered.
 BIN -9.9 KB 
assets/images/help/pages/choose-a-theme.png
Diff not rendered.
 BIN -176 KB 
assets/images/help/pages/select-theme.png
Diff not rendered.
 BIN +8.85 KB (160%) 
assets/images/help/pull_requests/merge-queue-options.png

 BIN +133 KB 
assets/images/help/repository/allow-merge-commits-no-dropdown.png

 BIN +166 KB 
assets/images/help/repository/allow-merge-commits.png

 BIN +230 KB 
assets/images/help/repository/allow-rebase-merging-no-dropdown.png

 BIN +261 KB 
assets/images/help/repository/allow-rebase-merging.png

 BIN +203 KB 
assets/images/help/repository/allow-squash-merging-no-dropdown.png

 BIN +234 KB 
assets/images/help/repository/allow-squash-merging.png

 BIN -99.5 KB 
assets/images/help/repository/code-scanning-alert-drop-down-reason.png
Diff not rendered.
 BIN +109 KB 
assets/images/help/repository/code-scanning-alert-dropdown-reason.png

 BIN +209 KB 
assets/images/help/repository/default-commit-message-dropdown.png

 BIN +192 KB 
assets/images/help/repository/default-squash-message-dropdown.png

 BIN +56.2 KB 
assets/images/help/repository/dependabot-alerts-dismissal-comment.png

 BIN +19 KB 
assets/images/help/repository/do-not-allow-bypassing-the-above-settings.png

 BIN -17.2 KB 
assets/images/help/repository/publish-github-action-to-markeplace-button.png
Diff not rendered.
 BIN +105 KB 
assets/images/help/repository/publish-github-action-to-marketplace-button.png

 BIN -3.35 KB (77%) 
assets/images/help/repository/repository-name-change.png

 BIN +17.1 KB 
assets/images/help/repository/secret-scanning-dry-run-custom-pattern-all-repos.png

 BIN +19.7 KB 
...ges/help/repository/secret-scanning-dry-run-custom-pattern-select-repo-only.png

 BIN +23.5 KB 
.../help/repository/secret-scanning-dry-run-custom-pattern-select-repos-option.png

 BIN -8.98 KB (66%) 
...mages/help/repository/secret-scanning-push-protection-web-ui-commit-allowed.png

 BIN +35.8 KB 
...tory/secret-scanning-push-protection-web-ui-commit-blocked-banner-with-link.png

 BIN +65.7 KB 
assets/images/help/repository/secret-scanning-push-protection-with-custom-link.png

 BIN +18.2 KB 
assets/images/help/repository/sync-fork-dropdown.png

 BIN +48.8 KB 
assets/images/help/repository/update-branch-button.png

 BIN +9.68 KB 
assets/images/help/security/check-ip-address.png

 BIN +19.4 KB (140%) 
assets/images/help/settings/codespaces-access-and-security-radio-buttons.png

 BIN +60.8 KB 
assets/images/help/settings/cookie-settings-accept-or-reject.png

 BIN +6.29 KB 
assets/images/help/settings/cookie-settings-manage.png

 BIN +67.5 KB 
assets/images/help/settings/cookie-settings-save.png

 BIN +3.7 KB (240%) 
assets/images/help/settings/ssh-add-key.png

 BIN +27.6 KB 
assets/images/help/settings/ssh-add-ssh-key-with-auth.png

 BIN +46.4 KB 
assets/images/help/settings/ssh-key-paste-with-type.png

 BIN -14.1 KB 
assets/images/help/settings/sudo_mode_popup.png
Diff not rendered.
 BIN +10 KB 
assets/images/help/settings/sudo_mode_prompt_2fa_code.png

 BIN +15.3 KB 
assets/images/help/settings/sudo_mode_prompt_github_mobile.png

 BIN +9.78 KB 
assets/images/help/settings/sudo_mode_prompt_github_mobile_prompt.png

 BIN +16.3 KB 
assets/images/help/settings/sudo_mode_prompt_password.png

 BIN +12.4 KB 
assets/images/help/settings/sudo_mode_prompt_security_key.png

 BIN +16.6 KB 
assets/images/help/settings/sudo_mode_prompt_totp_sms.png

 BIN +47.6 KB 
assets/images/hosted-runner-mgmt.png

 BIN +132 KB 
assets/images/hosted-runner.png

 89  
components/BasicSearch.tsx
@@ -0,0 +1,89 @@
import { useState, useRef } from 'react'
import { useRouter } from 'next/router'
import cx from 'classnames'

import { useTranslation } from 'components/hooks/useTranslation'
import { DEFAULT_VERSION, useVersion } from 'components/hooks/useVersion'
import { useQuery } from 'components/hooks/useQuery'

import styles from './Search.module.scss'

type Props = {
  isHeaderSearch?: true
  variant?: 'compact' | 'expanded'
  iconSize: number
}

export function BasicSearch({ isHeaderSearch = true, variant = 'compact', iconSize = 24 }: Props) {
  const router = useRouter()
  const { query, debug } = useQuery()
  const [localQuery, setLocalQuery] = useState(query)
  const inputRef = useRef<HTMLInputElement>(null)
  const { t } = useTranslation('search')
  const { currentVersion } = useVersion()

  function redirectSearch() {
    let asPath = `/${router.locale}`
    if (currentVersion !== DEFAULT_VERSION) {
      asPath += `/${currentVersion}`
    }
    asPath += '/search'
    const params = new URLSearchParams({ query: localQuery })
    if (debug) {
      params.set('debug', '1')
    }
    asPath += `?${params}`
    router.push(asPath)
  }

  return (
    <div data-testid="search">
      <div className="position-relative z-2">
        <form
          role="search"
          className="width-full d-flex"
          noValidate
          onSubmit={(event) => {
            event.preventDefault()
            redirectSearch()
          }}
        >
          <label className="text-normal width-full">
            <span
              className="visually-hidden"
              aria-label={t`label`}
              aria-describedby={t`description`}
            >{t`placeholder`}</span>
            <input
              data-testid="site-search-input"
              ref={inputRef}
              className={cx(
                styles.searchInput,
                iconSize === 24 && styles.searchIconBackground24,
                iconSize === 24 && 'form-control px-6 f4',
                iconSize === 16 && styles.searchIconBackground16,
                iconSize === 16 && 'form-control px-5 f4',
                variant === 'compact' && 'py-2',
                variant === 'expanded' && 'py-3',
                isHeaderSearch && styles.searchInputHeader,
                !isHeaderSearch && 'width-full'
              )}
              type="search"
              placeholder={t`placeholder`}
              autoComplete={localQuery ? 'on' : 'off'}
              autoCorrect="off"
              autoCapitalize="off"
              spellCheck="false"
              maxLength={512}
              onChange={(e) => setLocalQuery(e.target.value)}
              value={localQuery}
              aria-label={t`label`}
              aria-describedby={t`description`}
            />
          </label>
          <button className="d-none" type="submit" title="Submit the search query." hidden />
        </form>
      </div>
    </div>
  )
}
 31  
components/ClientSideHighlight.tsx
@@ -0,0 +1,31 @@
import { useState, useEffect } from 'react'
import dynamic from 'next/dynamic'
import { useRouter } from 'next/router'

const ClientSideHighlightJS = dynamic(() => import('./ClientSideHighlightJS'), {
  ssr: false,
})

export function ClientSideHighlight() {
  const { asPath } = useRouter()
  // If the page contains `[data-highlight]` blocks, these pages need
  // syntax highlighting. But not every page needs i  t, so it's conditionally
  // lazy-loaded on the client.
  const [load, setLoad] = useState(false)
  useEffect(() => {
    // It doesn't need to use querySelector because all we care about is if
    // there is greater than zero of these in the DOM.
    // Note! This "core selector", which determines whether to bother
    // or not, needs to match what's used inside ClientSideHighlightJS.tsx
    if (!load && document.querySelector('[data-highlight]')) {
      setLoad(true)
    }

    // Important to depend on the current path because the first page you
    // load, before any client-side navigation, might not need it, but the
    // consecutive one does.
  }, [asPath])

  if (load) return <ClientSideHighlightJS />
  return null
}
 0  
components/article/ClientSideHighlightJS.tsx → components/ClientSideHighlightJS.tsx
File renamed without changes.
 0  
.../article/ClientsideRedirectExceptions.tsx → components/ClientSideRedirectExceptions.tsx
File renamed without changes.
 43  
components/ClientSideRedirects.tsx
@@ -0,0 +1,43 @@
import { useState, useEffect } from 'react'
import dynamic from 'next/dynamic'
import { useRouter } from 'next/router'

const ClientSideRedirectExceptions = dynamic(
  () => import('components/ClientSideRedirectExceptions'),
  {
    ssr: false,
  }
)

export function ClientSideRedirects() {
  const { asPath } = useRouter()
  // We have some one-off redirects for rest api docs
  // currently those are limited to the repos page, but
  // that will grow soon as we restructure the rest api docs.
  // This is a workaround to updating the hardcoded links
  // directly in the REST API code in a separate repo, which
  // requires many file changes and teams to sign off.
  // While the organization is turbulent, we can do this.
  // Once it's more settled, we can refactor the rest api code
  // to leverage the OpenAPI urls rather than hardcoded urls.
  // The code below determines if we should bother loading this redirecting
  // component at all.
  // The reason this isn't done at the server-level is because there you
  // can't possibly access the URL hash. That's only known in client-side
  // code.
  const [load, setLoad] = useState(false)
  useEffect(() => {
    const { hash } = window.location

    // Today, Jan 2022, it's known explicitly what the pathname.
    // In the future there might be more.
    // Hopefully, we can some day delete all of this and no longer
    // be dependent on the URL hash to do the redirect.
    if (hash && asPath.startsWith('/rest')) {
      setLoad(true)
    }
  }, [])

  if (load) return <ClientSideRedirectExceptions />
  return null
}
  12  
components/Link.tsx
@@ -1,12 +1,10 @@
import NextLink from 'next/link'
import { ComponentProps } from 'react'
import { useMainContext } from 'components/context/MainContext'

const { NODE_ENV } = process.env

type Props = { locale?: string; disableClientTransition?: boolean } & ComponentProps<'a'>
export function Link(props: Props) {
  const { airGap } = useMainContext()
  const { href, locale, disableClientTransition = false, ...restProps } = props

  if (!href && NODE_ENV !== 'production') {
@@ -15,16 +13,6 @@ export function Link(props: Props) {

  const isExternal = href?.startsWith('http') || href?.startsWith('//')

  // In airgap mode, add a tooltip to external links warning they may not work.
  if (airGap && isExternal) {
    if (restProps.className) {
      restProps.className += ' tooltipped'
    } else {
      restProps.className = 'tooltipped'
    }
    restProps['aria-label'] = 'This link may not work in this environment.'
  }

  if (disableClientTransition) {
    return (
      /* eslint-disable-next-line jsx-a11y/anchor-has-content */
 3  
components/README.md
@@ -1,6 +1,3 @@
# Components

⚠️ This area is a work-in-progress.

This is the main source for our React components. They can be rendered by the server or the client via [Next.js](https://nextjs.org). The starting point for any component usage is the `pages/` directory, which uses a file-system routing paradigm to match paths to pages that then render these components.

  18  
components/Search.tsx
@@ -6,16 +6,25 @@ import { Flash, Label, ActionList, ActionMenu } from '@primer/react'
import { ItemInput } from '@primer/react/lib/deprecated/ActionList/List'
import { InfoIcon } from '@primer/octicons-react'

import { useLanguages } from 'components/context/LanguagesContext'
import { useTranslation } from 'components/hooks/useTranslation'
import { sendEvent, EventType } from 'components/lib/events'
import { useMainContext } from './context/MainContext'
import { DEFAULT_VERSION, useVersion } from 'components/hooks/useVersion'
import { useQuery } from 'components/hooks/useQuery'
import { Link } from 'components/Link'
import { useLanguages } from './context/LanguagesContext'

import styles from './Search.module.scss'

// This is a temporary thing purely for the engineers of this project.
// When we are content that the new Elasticsearch-based middleware can
// wrap searches that match the old JSON format, but based on Elasticsearch
// behind the scene, we can change this component to always use
// /api/search/legacy. Then, when time allows we can change this component
// to use the new JSON format (/api/search/v1) and change the code to
// use that instead.
const USE_LEGACY_SEARCH = JSON.parse(process.env.NEXT_PUBLIC_USE_LEGACY_SEARCH || 'false')

type SearchResult = {
  url: string
  breadcrumbs: string
@@ -32,6 +41,7 @@ type Props = {
  iconSize: number
  children?: (props: { SearchInput: ReactNode; SearchResults: ReactNode }) => ReactNode
}

export function Search({
  isHeaderSearch = false,
  isMobileSearch = false,
@@ -52,10 +62,12 @@ export function Search({
  const { searchVersions, nonEnterpriseDefaultVersion } = useMainContext()
  // fall back to the non-enterprise default version (FPT currently) on the homepage, 404 page, etc.
  const version = searchVersions[currentVersion] || searchVersions[nonEnterpriseDefaultVersion]
  const language = (Object.keys(languages).includes(router.locale || '') && router.locale) || 'en'
  const language = languages
    ? (Object.keys(languages).includes(router.locale || '') && router.locale) || 'en'
    : 'en'

  const fetchURL = query
    ? `/search?${new URLSearchParams({
    ? `/${USE_LEGACY_SEARCH ? 'api/search/legacy' : 'search'}?${new URLSearchParams({
        language,
        version,
        query,
  27  
components/article/ArticlePage.tsx
@@ -1,6 +1,4 @@
import { useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import dynamic from 'next/dynamic'

import { ZapIcon, InfoIcon, ShieldLockIcon } from '@primer/octicons-react'
import { Callout } from 'components/ui/Callout'
@@ -17,8 +15,7 @@ import { ArticleGridLayout } from './ArticleGridLayout'
import { PlatformPicker } from 'components/article/PlatformPicker'
import { ToolPicker } from 'components/article/ToolPicker'
import { MiniTocs } from 'components/ui/MiniTocs'

const ClientSideHighlightJS = dynamic(() => import('./ClientSideHighlightJS'), { ssr: false })
import { ClientSideHighlight } from 'components/ClientSideHighlight'

// Mapping of a "normal" article to it's interactive counterpart
const interactiveAlternatives: Record<string, { href: string }> = {
@@ -58,29 +55,9 @@ export const ArticlePage = () => {
  const { t } = useTranslation('pages')
  const currentPath = asPath.split('?')[0]

  // If the page contains `[data-highlight]` blocks, these pages need
  // syntax highlighting. But not every page needs it, so it's conditionally
  // lazy-loaded on the client.
  const [lazyLoadHighlightJS, setLazyLoadHighlightJS] = useState(false)
  useEffect(() => {
    // It doesn't need to use querySelector because all we care about is if
    // there is greater than zero of these in the DOM.
    // Note! This "core selector", which determines whether to bother
    // or not, needs to match what's used inside ClientSideHighlightJS.tsx
    if (document.querySelector('[data-highlight]')) {
      setLazyLoadHighlightJS(true)
    }

    // Important to depend on the current path because the first page you
    // load, before any client-side navigation, might not need it, but the
    // consecutive one does.
  }, [asPath])

  return (
    <DefaultLayout>
      {/* Doesn't matter *where* this is included because it will
      never render anything. It always just return null. */}
      {lazyLoadHighlightJS && <ClientSideHighlightJS />}
      <ClientSideHighlight />

      <div className="container-xl px-3 px-md-6 my-4">
        <ArticleGridLayout
 30  
components/article/AutomatedPage.tsx
@@ -1,48 +1,22 @@
import { useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import dynamic from 'next/dynamic'

import { DefaultLayout } from 'components/DefaultLayout'
import { ArticleTitle } from 'components/article/ArticleTitle'
import { MarkdownContent } from 'components/ui/MarkdownContent'
import { Lead } from 'components/ui/Lead'
import { ArticleGridLayout } from './ArticleGridLayout'
import { MiniTocs } from 'components/ui/MiniTocs'
import { useAutomatedPageContext } from 'components/context/AutomatedPageContext'

const ClientSideHighlightJS = dynamic(() => import('./ClientSideHighlightJS'), { ssr: false })
import { ClientSideHighlight } from 'components/ClientSideHighlight'

type Props = {
  children: React.ReactNode
}

export const AutomatedPage = ({ children }: Props) => {
  const { asPath } = useRouter()
  const { title, intro, renderedPage, miniTocItems } = useAutomatedPageContext()

  // If the page contains `[data-highlight]` blocks, these pages need
  // syntax highlighting. But not every page needs it, so it's conditionally
  // lazy-loaded on the client.
  const [lazyLoadHighlightJS, setLazyLoadHighlightJS] = useState(false)
  useEffect(() => {
    // It doesn't need to use querySelector because all we care about is if
    // there is greater than zero of these in the DOM.
    // Note! This "core selector", which determines whether to bother
    // or not, needs to match what's used inside ClientSideHighlightJS.tsx
    if (document.querySelector('[data-highlight]')) {
      setLazyLoadHighlightJS(true)
    }

    // Important to depend on the current path because the first page you
    // load, before any client-side navigation, might not need it, but the
    // consecutive one does.
  }, [asPath])

  return (
    <DefaultLayout>
      {/* Doesn't matter *where* this is included because it will
      never render anything. It always just return null. */}
      {lazyLoadHighlightJS && <ClientSideHighlightJS />}
      <ClientSideHighlight />

      <div className="container-xl px-3 px-md-6 my-4">
        <ArticleGridLayout
 12  
components/article/LinkIconHeading.tsx
@@ -0,0 +1,12 @@
import { LinkIcon } from '@primer/octicons-react'

type Props = {
  slug: string
}
export const LinkIconHeading = ({ slug }: Props) => {
  return (
    <a className="doctocat-link" href={`#${slug}`}>
      <LinkIcon className="octicon-link" size="small" verticalAlign="middle" />
    </a>
  )
}
  2  
components/article/PlatformPicker.tsx
@@ -5,7 +5,7 @@ import { sendEvent, EventType } from 'components/lib/events'
import { useRouter } from 'next/router'

import { useArticleContext } from 'components/context/ArticleContext'
import parseUserAgent from 'components/lib/user-agent'
import { parseUserAgent } from 'components/lib/user-agent'

const platforms = [
  { id: 'mac', label: 'Mac' },
 19  
components/context/DotComAuthenticatedContext.tsx
This file was deleted.

  2  
components/context/LanguagesContext.tsx
@@ -5,12 +5,10 @@ type LanguageItem = {
  nativeName?: string
  code: string
  hreflang: string
  wip?: boolean
}

export type LanguagesContextT = {
  languages: Record<string, LanguageItem>
  userLanguage: string
}

export const LanguagesContext = createContext<LanguagesContextT | null>(null)
  10  
components/context/MainContext.tsx
@@ -87,7 +87,6 @@ export type MainContextT = {
  isHomepageVersion: boolean
  isFPT: boolean
  data: DataT
  airGap?: boolean
  error: string
  currentCategory?: string
  relativePath?: string
@@ -127,6 +126,14 @@ export type MainContextT = {
}

export const getMainContext = (req: any, res: any): MainContextT => {
  // Our current translation process adds 'ms.*' frontmatter properties to files
  // it translates including when data/ui.yml is translated. We don't use these
  // properties and their syntax (e.g. 'ms.openlocfilehash',
  // 'ms.sourcegitcommit', etc.) causes problems so just delete them.
  if (req.context.site.data.ui.ms) {
    delete req.context.site.data.ui.ms
  }

  return {
    breadcrumbs: req.context.breadcrumbs || {},
    activeProducts: req.context.activeProducts,
@@ -147,7 +154,6 @@ export const getMainContext = (req: any, res: any): MainContextT => {
        release_candidate: req.context.site.data.variables.release_candidate,
      },
    },
    airGap: req.context.AIRGAP || false,
    currentCategory: req.context.currentCategory || '',
    currentPathWithoutLanguage: req.context.currentPathWithoutLanguage,
    relativePath: req.context.page?.relativePath,
  3  
components/context/PlaygroundContext.tsx
@@ -59,7 +59,8 @@ export const PlaygroundContextProvider = (props: { children: React.ReactNode })
  const router = useRouter()
  const [activeSectionIndex, setActiveSectionIndex] = useState(0)
  const [scrollToSection, setScrollToSection] = useState<number>()
  const path = router.asPath.split('?')[0]
  const path = router.asPath.split('?')[0].split('#')[0]

  const relevantArticles = articles.filter(({ slug }) => slug === path)

  const { langId } = router.query
  4  
components/context/ProductLandingContext.tsx
@@ -134,6 +134,10 @@ export const getProductLandingContextFromRequest = (req: any): ProductLandingCon
      .filter(([key]) => {
        return key === 'guides' || key === 'popular' || key === 'videos'
      })
      // This is currently only used to filter out videos with a blank title
      // indicating that the video is not available for the currently selected
      // version
      .filter(([, links]: any) => links.every((link: FeaturedLink) => link.title))
      .map(([key, links]: any) => {
        return {
          label:
 56  
components/graphql/BreakingChanges.tsx
@@ -0,0 +1,56 @@
import React from 'react'
import GithubSlugger from 'github-slugger'
import cx from 'classnames'

import { LinkIconHeading } from 'components/article/LinkIconHeading'
import { BreakingChangesT } from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  schema: BreakingChangesT
}
const slugger = new GithubSlugger()

export function BreakingChanges({ schema }: Props) {
  const changes = Object.keys(schema).map((date) => {
    const items = schema[date]
    const heading = `Changes scheduled for  ${date}`
    const slug = slugger.slug(heading)

    return (
      <div className={cx(styles.markdownBody, styles.automatedPages)} key={date}>
        <h2 id={slug}>
          <LinkIconHeading slug={slug} />
          {heading}
        </h2>
        {items.map((item) => {
          const criticalityStyles =
            item.criticality === 'breaking'
              ? 'color-border-danger color-bg-danger'
              : 'color-border-accent-emphasis color-bg-accent'
          const criticality = item.criticality === 'breaking' ? 'Breaking' : 'Dangerous'

          return (
            <ul key={item.location}>
              <li>
                <span className={cx(criticalityStyles, 'border rounded-1 m-1 p-1')}>
                  {criticality}
                </span>{' '}
                A change will be made to <code>{item.location}</code>.
                <p>
                  <b>Description: </b>
                  <span dangerouslySetInnerHTML={{ __html: item.description }} />
                </p>
                <p>
                  <b>Reason: </b> <span dangerouslySetInnerHTML={{ __html: item.reason }} />
                </p>
              </li>
            </ul>
          )
        })}
      </div>
    )
  })

  return <div>{changes}</div>
}
 67  
components/graphql/Changelog.tsx
@@ -0,0 +1,67 @@
import React from 'react'
import GithubSlugger from 'github-slugger'
import cx from 'classnames'

import { LinkIconHeading } from 'components/article/LinkIconHeading'
import { ChangelogItemT } from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  changelogItems: ChangelogItemT[]
}

export function Changelog({ changelogItems }: Props) {
  const changes = changelogItems.map((item) => {
    const heading = `Schema changes for ${item.date}`
    const slugger = new GithubSlugger()
    const slug = slugger.slug(heading)

    return (
      <div className={cx(styles.markdownBody, styles.automatedPages)} key={item.date}>
        <h2 id={slug}>
          <LinkIconHeading slug={slug} />
          {heading}
        </h2>
        {item.schemaChanges &&
          item.schemaChanges.map((change, index) => (
            <React.Fragment key={`${item.date}-schema-changes-${index}`}>
              <p>{change.title}</p>
              <ul>
                {change.changes.map((change) => (
                  <li key={`${item.date}-${change}`}>
                    <span dangerouslySetInnerHTML={{ __html: change }} />
                  </li>
                ))}
              </ul>
            </React.Fragment>
          ))}
        {item.previewChanges &&
          item.previewChanges.map((change, index) => (
            <React.Fragment key={`${item.date}-preview-changes-${index}`}>
              <p>{change.title}</p>
              <ul>
                {change.changes.map((change) => (
                  <li key={`${item.date}-${change}`}>
                    <span dangerouslySetInnerHTML={{ __html: change }} />
                  </li>
                ))}
              </ul>
            </React.Fragment>
          ))}
        {item.upcomingChanges &&
          item.upcomingChanges.map((change, index) => (
            <React.Fragment key={`${item.date}-upcoming-changes-${index}`}>
              <p>{change.title}</p>
              {change.changes.map((change) => (
                <li key={`${item.date}-${change}`}>
                  <span dangerouslySetInnerHTML={{ __html: change }} />
                </li>
              ))}
            </React.Fragment>
          ))}
      </div>
    )
  })

  return <div>{changes}</div>
}
 31  
components/graphql/Enum.tsx
@@ -0,0 +1,31 @@
import React from 'react'

import { useTranslation } from 'components/hooks/useTranslation'
import { GraphqlItem } from './GraphqlItem'
import type { EnumT } from './types'

type Props = {
  item: EnumT
}

export function Enum({ item }: Props) {
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.values')

  return (
    <GraphqlItem item={item} heading={heading}>
      {item.values.map((value) => (
        <React.Fragment key={`${value.name}-${value.description}`}>
          <p>
            <strong>{value.name}</strong>
          </p>
          <div
            dangerouslySetInnerHTML={{
              __html: value.description,
            }}
          />
        </React.Fragment>
      ))}
    </GraphqlItem>
  )
}
 43  
components/graphql/GraphqlItem.tsx
@@ -0,0 +1,43 @@
import { LinkIconHeading } from 'components/article/LinkIconHeading'
import type { GraphqlT } from './types'
import { Notice } from './Notice'

type Props = {
  item: GraphqlT
  heading?: string
  headingLevel?: number
  children?: React.ReactNode
}

export function GraphqlItem({ item, heading, children, headingLevel = 2 }: Props) {
  const lowerCaseName = item.name.toLowerCase()
  return (
    <div>
      {headingLevel === 2 && (
        <h2 id={lowerCaseName}>
          <LinkIconHeading slug={lowerCaseName} />
          {item.name}
        </h2>
      )}
      {headingLevel === 3 && (
        <h3 id={lowerCaseName}>
          <LinkIconHeading slug={lowerCaseName} />
          {item.name}
        </h3>
      )}
      <p
        dangerouslySetInnerHTML={{
          __html: item.description,
        }}
      />
      <div>
        {item.preview && <Notice item={item} variant="preview" />}
        {item.isDeprecated && <Notice item={item} variant="deprecation" />}
      </div>
      <div>
        {heading && <h4>{heading}</h4>}
        {children}
      </div>
    </div>
  )
}
 85  
components/graphql/GraphqlPage.tsx
@@ -0,0 +1,85 @@
import React from 'react'
import cx from 'classnames'

import { Enum } from 'components/graphql/Enum'
import { InputObject } from 'components/graphql/InputObject'
import { Interface } from 'components/graphql/Interface'
import { Scalar } from 'components/graphql/Scalar'
import { Mutation } from 'components/graphql/Mutation'
import { Object } from 'components/graphql/Object'
import { Query } from 'components/graphql/Query'
import { Union } from 'components/graphql/Union'
import type {
  EnumT,
  InputObjectT,
  InterfaceT,
  MutationT,
  ObjectT,
  QueryT,
  ScalarT,
  UnionT,
} from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  schema: Object
  pageName: string
  objects?: ObjectT[]
}

export const GraphqlPage = ({ schema, pageName, objects }: Props) => {
  const graphqlItems: JSX.Element[] = [] // In the case of the H2s for Queries

  // The queries page has two heading sections (connections and fields)
  // So we need to add the heading component and the children under it
  // for each section.
  if (pageName === 'queries') {
    graphqlItems.push(
      ...(schema as QueryT[]).map((item) => <Query item={item} key={item.id + item.name} />)
    )
  } else if (pageName === 'enums') {
    graphqlItems.push(
      ...(schema as EnumT[]).map((item) => {
        return <Enum key={item.id} item={item} />
      })
    )
  } else if (pageName === 'inputObjects') {
    graphqlItems.push(
      ...(schema as InputObjectT[]).map((item) => {
        return <InputObject key={item.id} item={item} />
      })
    )
  } else if (pageName === 'interfaces' && objects) {
    graphqlItems.push(
      ...(schema as InterfaceT[]).map((item) => {
        return <Interface key={item.id} item={item} objects={objects} />
      })
    )
  } else if (pageName === 'mutations') {
    graphqlItems.push(
      ...(schema as MutationT[]).map((item) => {
        return <Mutation key={item.id} item={item} />
      })
    )
  } else if (pageName === 'objects') {
    graphqlItems.push(
      ...(schema as ObjectT[]).map((item) => {
        return <Object key={item.id} item={item} />
      })
    )
  } else if (pageName === 'scalars') {
    graphqlItems.push(
      ...(schema as ScalarT[]).map((item) => {
        return <Scalar key={item.id} item={item} />
      })
    )
  } else if (pageName === 'unions') {
    graphqlItems.push(
      ...(schema as UnionT[]).map((item) => {
        return <Union key={item.id} item={item} />
      })
    )
  }

  return <div className={cx(styles.automatedPages, styles.markdownBody)}>{graphqlItems}</div>
}
 18  
components/graphql/InputObject.tsx
@@ -0,0 +1,18 @@
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { InputObjectT } from './types'

type Props = {
  item: InputObjectT
}

export function InputObject({ item }: Props) {
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.input_fields')
  return (
    <GraphqlItem item={item} heading={heading}>
      <Table fields={item.inputFields} />
    </GraphqlItem>
  )
}
 47  
components/graphql/Interface.tsx
@@ -0,0 +1,47 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { ObjectT, InterfaceT } from './types'

type Props = {
  item: InterfaceT
  objects: ObjectT[]
}

export function Interface({ item, objects }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.implemented_by')
  const heading2 = t('graphql.reference.fields')

  const implementedBy = objects.filter(
    (object) =>
      object.implements &&
      object.implements.some((implementsItem) => implementsItem.name === item.name)
  )

  return (
    <GraphqlItem item={item} heading={heading}>
      <ul>
        {implementedBy.map((object) => (
          <li key={`${item.id}-${item.name}-${object.href}-${object.name}`}>
            <code>
              <Link href={object.href} locale={locale}>
                {object.name}
              </Link>
            </code>
          </li>
        ))}
      </ul>
      {item.fields && (
        <>
          <h4>{heading2}</h4>
          <Table fields={item.fields} />
        </>
      )}
    </GraphqlItem>
  )
}
 45  
components/graphql/Mutation.tsx
@@ -0,0 +1,45 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Notice } from './Notice'
import { useTranslation } from 'components/hooks/useTranslation'
import { Table } from './Table'
import type { MutationT } from './types'
import React from 'react'

type Props = {
  item: MutationT
}

export function Mutation({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.input_fields')
  const heading2 = t('graphql.reference.return_fields')

  return (
    <GraphqlItem item={item} heading={heading}>
      {item.inputFields.map((input) => (
        <React.Fragment key={input.id}>
          <ul>
            <li>
              <code>{input.name}</code> (
              <code>
                <Link href={input.href} locale={locale}>
                  {input.type}
                </Link>
              </code>
              )
            </li>
          </ul>

          {input.preview && <Notice item={input} variant="preview" />}
          {input.isDeprecated && <Notice item={input} variant="deprecation" />}
          <h4>{heading2}</h4>
          <Table fields={item.returnFields} />
        </React.Fragment>
      ))}
    </GraphqlItem>
  )
}
 51  
components/graphql/Notice.tsx
@@ -0,0 +1,51 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { useTranslation } from 'components/hooks/useTranslation'
import type { GraphqlT } from './types'

type Props = {
  item: GraphqlT
  variant: 'preview' | 'deprecation'
}

export function Notice({ item, variant = 'preview' }: Props) {
  const { locale } = useRouter()

  const { t } = useTranslation('products')
  const previewTitle =
    variant === 'preview'
      ? t('rest.reference.preview_notice')
      : t('graphql.reference.deprecation_notice')
  const noticeStyle =
    variant === 'preview'
      ? 'note color-border-accent-emphasis color-bg-accent'
      : 'warning color-border-danger color-bg-danger'
  return (
    <div className={`${noticeStyle} extended-markdown border rounded-1 my-3 p-3 f5`}>
      <p>
        <b>{previewTitle}</b>
      </p>
      {variant === 'preview' && item.preview ? (
        <p>
          <code>{item.name}</code> is available under the{' '}
          <Link href={item.preview.href} locale={locale}>
            {item.preview.title}
          </Link>
          . {t('graphql.reference.preview_period')}
        </p>
      ) : item.deprecationReason ? (
        <div>
          <p>
            <code>{item.name}</code> is deprecated.
          </p>
          <div
            dangerouslySetInnerHTML={{
              __html: item.deprecationReason,
            }}
          />
        </div>
      ) : null}
    </div>
  )
}
 46  
components/graphql/Object.tsx
@@ -0,0 +1,46 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { ObjectT, ImplementsT } from './types'

type Props = {
  item: ObjectT
}

export function Object({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading1 = t('graphql.reference.implements')
  const heading2 = t('graphql.reference.fields')

  return (
    <GraphqlItem item={item}>
      {item.implements && (
        <>
          <h3>{heading1}</h3>
          <ul>
            {item.implements.map((implement: ImplementsT) => (
              <li key={`${implement.id}-${implement.href}-${implement.name}`}>
                <code>
                  <Link href={implement.href} locale={locale}>
                    {implement.name}
                  </Link>
                </code>
              </li>
            ))}
          </ul>
        </>
      )}

      {item.fields && (
        <>
          <h3>{heading2}</h3>
          <Table fields={item.fields} />
        </>
      )}
    </GraphqlItem>
  )
}
 56  
components/graphql/Previews.tsx
@@ -0,0 +1,56 @@
import React from 'react'
import GithubSlugger from 'github-slugger'
import cx from 'classnames'

import { LinkIconHeading } from 'components/article/LinkIconHeading'
import { useTranslation } from 'components/hooks/useTranslation'
import { PreviewT } from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  schema: PreviewT[]
}

export function Previews({ schema }: Props) {
  const previews = schema.map((item) => {
    const slugger = new GithubSlugger()
    const slug = slugger.slug(item.title)
    const { t } = useTranslation('products')

    return (
      <div className={cx(styles.markdownBody, styles.automatedPages)} key={slug}>
        <h2 id={slug}>
          <LinkIconHeading slug={slug} />
          {item.title}
        </h2>
        <p>{item.description}</p>
        <p>{t('graphql.overview.preview_header')}</p>
        <pre>
          <code>{item.accept_header}</code>
        </pre>
        <p>{t('graphql.overview.preview_schema_members')}:</p>
        <ul>
          {item.toggled_on.map((change) => (
            <li key={change + slug}>
              <code>{change}</code>
            </li>
          ))}
        </ul>
        {item.announcement && (
          <p>
            <b>{t('graphql.overview.announced')}: </b>
            <a href={item.announcement.url}>{item.announcement.date}</a>
          </p>
        )}
        {item.updates && (
          <p>
            <b>{t('graphql.overview.updates')}: </b>
            <a href={item.updates.url}>{item.updates.date}</a>
          </p>
        )}
      </div>
    )
  })

  return <div>{previews}</div>
}
 38  
components/graphql/Query.tsx
@@ -0,0 +1,38 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { QueryT } from './types'

type Props = {
  item: QueryT
}

export function Query({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')

  return (
    <GraphqlItem item={item} headingLevel={3}>
      <div>
        <p>
          <b>{t('graphql.reference.type')}: </b>
          <Link href={item.href} locale={locale}>
            {item.type}
          </Link>
        </p>
      </div>

      <div>
        {item.args.length > 0 && (
          <>
            <h4>{t('graphql.reference.arguments')}</h4>
            <Table fields={item.args} />
          </>
        )}
      </div>
    </GraphqlItem>
  )
}
 10  
components/graphql/Scalar.tsx
@@ -0,0 +1,10 @@
import { GraphqlItem } from './GraphqlItem'
import { ScalarT } from './types'

type Props = {
  item: ScalarT
}

export function Scalar({ item }: Props) {
  return <GraphqlItem item={item} />
}
 100  
components/graphql/Table.tsx
@@ -0,0 +1,100 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { Notice } from './Notice'
import { useTranslation } from 'components/hooks/useTranslation'
import { FieldT } from './types'

type Props = {
  fields: FieldT[]
}

export function Table({ fields }: Props) {
  const { locale } = useRouter()

  const { t } = useTranslation('products')
  const tableName = t('graphql.reference.name')
  const tableDescription = t('graphql.reference.description')

  return (
    <table className="fields width-full">
      <thead>
        <tr>
          <th>{tableName}</th>
          <th>{tableDescription}</th>
        </tr>
      </thead>
      <tbody>
        {fields.map((field) => (
          <tr key={field.name}>
            <td>
              <p>
                <code>{field.name}</code> (
                <code>
                  <Link href={field.href} locale={locale}>
                    {field.type}
                  </Link>
                </code>
                )
              </p>
            </td>
            <td>
              {field.description ? (
                <span
                  dangerouslySetInnerHTML={{
                    __html: field.description,
                  }}
                />
              ) : (
                'N/A'
              )}
              {field.defaultValue !== undefined && (
                <p>
                  The default value is <code>{field.defaultValue.toString()}</code>.
                </p>
              )}
              {field.preview && <Notice item={field} variant="preview" />}
              {field.isDeprecated && <Notice item={field} variant="deprecation" />}

              {field.arguments && (
                <div className="border rounded-1 mt-3 mb-3 p-3 color-bg-subtle f5">
                  <h4 className="pt-0 mt-0">{t('graphql.reference.arguments')}</h4>
                  {field.arguments.map((argument, index) => (
                    <ul
                      key={`${index}-${argument.type.name}-${argument.type.href}`}
                      className="list-style-none pl-0"
                    >
                      <li className="border-top mt-2">
                        <p className="mt-2">
                          <code>{argument.name}</code> (
                          <code>
                            <Link href={argument.type.href} locale={locale}>
                              {argument.type.name}
                            </Link>
                          </code>
                          )
                        </p>
                        {
                          <span
                            dangerouslySetInnerHTML={{
                              __html: argument.description,
                            }}
                          />
                        }
                        {argument.defaultValue !== undefined && (
                          <p>
                            The default value is <code>{argument.defaultValue.toString()}</code>.
                          </p>
                        )}
                      </li>
                    </ul>
                  ))}
                </div>
              )}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
 30  
components/graphql/Union.tsx
@@ -0,0 +1,30 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { useTranslation } from 'components/hooks/useTranslation'
import type { UnionT } from './types'

type Props = {
  item: UnionT
}

export function Union({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.possible_types')

  return (
    <GraphqlItem item={item} heading={heading}>
      <ul>
        {item.possibleTypes.map((type) => (
          <li key={type.id}>
            <Link href={type.href} locale={locale}>
              {type.name}
            </Link>
          </li>
        ))}
      </ul>
    </GraphqlItem>
  )
}
 135  
components/graphql/types.tsx
@@ -0,0 +1,135 @@
export type PreviewT = {
  title: string
  description: string
  toggled_by: string
  toggled_on: []
  owning_teams: []
  accept_header: string
  href: string
  announcement: {
    date: string
    url: string
  }
  updates: {
    date: string
    url: string
  }
}

export type UpcomingChangesT = {
  location: string
  description: string
  reason: string
  date: string
  criticality: 'breaking' | 'dangerous'
  owner: string
}

export type GraphqlT = {
  name: string
  kind: string
  id: string
  href: string
  description: string
  type?: string
  size?: number
  isDeprecated?: boolean
  deprecationReason?: string
  preview?: PreviewT
  defaultValue?: boolean
}

export type ImplementsT = {
  name: string
  id: string
  href: string
}

export type ArgumentT = {
  name: string
  description: string
  defaultValue?: string | boolean
  type: {
    name: string
    id: string
    kind: string
    href: string
  }
}

export type FieldT = GraphqlT & {
  arguments?: ArgumentT[]
}

export type QueryT = GraphqlT & {
  args: GraphqlT[]
}

export type MutationT = GraphqlT & {
  inputFields: FieldT[]
  returnFields: FieldT[]
}

export type ObjectT = GraphqlT & {
  fields: FieldT[]
  implements?: ImplementsT[]
}

export type InterfaceT = GraphqlT & {
  fields: FieldT[]
}

export type EnumValuesT = {
  name: string
  description: string
}

export type EnumT = GraphqlT & {
  values: EnumValuesT[]
}

export type UnionT = GraphqlT & {
  possibleTypes: ImplementsT[]
}

export type InputFieldsT = GraphqlT & {
  type: string
}

export type InputObjectT = GraphqlT & {
  inputFields: FieldT[]
}

export type ScalarT = GraphqlT & {
  kind?: string
}

export type AllVersionsT = {
  [versions: string]: {
    miscVersionName: string
  }
}

type ChangeT = {
  title: string
  changes: string[]
}

export type ChangelogItemT = {
  date: string
  schemaChanges: ChangeT[]
  previewChanges: ChangeT[]
  upcomingChanges: ChangeT[]
}

export type BreakingChangeT = {
  location: string
  description: string
  reason: string
  date: string
  criticality: string
}

export type BreakingChangesT = {
  [date: string]: BreakingChangeT[]
}
 23  
components/hooks/useHasAccount.ts
@@ -0,0 +1,23 @@
import { useState, useEffect } from 'react'
import Cookies from 'js-cookie'

// Measure if the user has a github.com account and signed in during this session.
// The github.com sends the color_mode cookie every request when you sign in,
// but does not delete the color_mode cookie on sign out.
// You do not need to change your color mode settings to get this cookie,
// this applies to every user regardless of if they changed this setting.
// To test this, try a private browser tab.
// We are using the color_mode cookie because it is not HttpOnly.
// For users that haven't changed their session cookies recently,
// we also can check for the browser-set `preferred_color_mode` cookie.
export function useHasAccount() {
  const [hasAccount, setHasAccount] = useState<boolean | null>(null)

  useEffect(() => {
    const cookieValue = Cookies.get('color_mode')
    const altCookieValue = Cookies.get('preferred_color_mode')
    setHasAccount(Boolean(cookieValue || altCookieValue))
  }, [])

  return { hasAccount }
}
 16  
components/hooks/usePage.ts
@@ -0,0 +1,16 @@
import { useRouter } from 'next/router'

type Info = {
  page: number
}
export const usePage = (): Info => {
  const router = useRouter()
  const page = parseInt(
    router.query.page && Array.isArray(router.query.page)
      ? router.query.page[0]
      : router.query.page || ''
  )
  return {
    page: !isNaN(page) && page >= 1 ? page : 1,
  }
}
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
AboutSkip to content
Search or jump to…
Pull requests
Issues
Codespaces
Marketplace
Explore
 
@zakwarlord7 
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.
zakwarlord7
/
User-bin-env-Bash
Private
generated from zakwarlord7/peter-evans-create-pull-request
Code
Issues
Pull requests
Actions
Projects
Security
Insights
Settings
Comparing changes
Choose two branches to see what’s changed or to start a new pull request. If you need to, you can also .
  
 4 commits
 4 files changed
 1 contributor
Commits on Nov 21, 2022
Create README.md

@zakwarlord7
zakwarlord7 committed 2 hours ago
  
Create npm-grunt.yml

@zakwarlord7
zakwarlord7 committed 42 minutes ago
  
Update slash-command-dispatch.yml (#1)

@zakwarlord7
zakwarlord7 committed 34 minutes ago
  
Automates

@zakwarlord7
zakwarlord7 committed 4 minutes ago
  
Showing  with 9,970 additions and 2 deletions.
 2,119  
.github/workflows/npm-grunt.yml
@@ -0,0 +1,2119 @@
name: NodeJS with Grunt

on:
  push:
    branches: [ "master" ]
  pull_request:
    branches: [ "master" ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [14.x, 16.x, 18.x]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Build
      run: |
        npm install
        grunt
From fe6bd12338a89220c1f4af7310121894652b4342 Mon Sep 17 00:00:00 2001
From: "ZACHRY T WOODzachryiixixiiwood@gmail.com"
 <109656750+zakwarlord7@users.noreply.github.com>
Date: Fri, 18 Nov 2022 23:35:41 -0600
Subject: [PATCH 1/2] Revert "Revert "Update RakI.u (#1)" (#2)" (#3)

This reverts commit 21a7b70e4b4aea5e588362f75618306acc3e4ffe.
---
 RakI.u | 65 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/RakI.u b/RakI.u
index 2d5fcaa..1276ad0 100644
--- a/RakI.u
+++ b/RakI.u
@@ -1,17 +1,55 @@
-#3GLOW4
-BEGIN
-#TYPE
-#SCRIPTS
-#SCR?IPT
-#:Build::RUN RUNS ENV
+**#3GLOW4 :
+BEGIN4 :
+#TYPE :
+#SCRIPTS :
+#SCR?IPT :
+#:Build::RUN RUNS ENV :Runs #Test :tests'@ci'@#Test'@CI'' ':'':
 ENV :!#/User/bin/sdh/imp.yml'@bitore.sig'@Demlsr/Smber.yml'' 
 $mk.dir=: src.dir/index.md/.dist'@WIZARD/db/instsll/indtsller'@sun.java.org/py-Flask.eslint/rendeerer/slate.yml'ERaku.i :
 '#Clerks/chalk.yml-with :grunt.xml/Gulp.xml'@Trunk :'
 Package-on :Python.JS'@MAsterbranch :'
 bundle-with :rake.i'@master :'
 -with :bp/-dylan/th.boop/-quipp/ranger/helpers'@pom.YML ::Runs-on :sRust/Cake.io :'
-FANG
-#:Build::
+From: <Saved by Blink>										
+Snapshot-Content-Location: https://github.com/zakwarlord7/jekyll-deploy-action/commit/84218f644e73a68afdf9cf2da437b4062fccf28f										
+Subject: =?utf-8?Q?bitore.sig=20=C2=B7=20zakwarlord7/jekyll-deploy-action@84218f6?=										
+Date: Sat, 3 Sep 2022 19:21:01 -0000										
+MIME-Version: 1.0										
+Content-Type: multipart/related;										
+ype="text/html";									
+oundary="----MultipartBoundary--wjliXQErN1i5NgVkHr2WB1jdr56S5qoNszw7DpylZJ----"									
+-----MultipartBoundary--wjliXQErN1i5NgVkHr2WB1jdr56S5qoNszw7DpylZJ----										
+Content-Type: text/html										
+Content-ID: <frame-8C2C552DF38E22E03BFE31C46E0F2BAD@mhtml.blink>										
+Content-Transfer-Encoding: quoted-printable										
+Content-Location: https://github.com/zakwarlord7/jekyll-deploy-action/commit/84218f644e73a68afdf9cf2da437b4062fccf28f										
+										
+<!DOCTYPE html><html lang=3D"en" data-color-mode=3D"auto" data-light-theme=										
+=3D"light" data-dark-theme=3D"dark" data-a11y-animated-images=3D"system" da=										
+ta-turbo-loaded=3D""><head><meta http-equiv=3D"Content-Type" content=3D"tex=										
+t/html; charset=3DUTF-8"><link rel=3D"stylesheet" type=3D"text/css" href=3D=										
+cid:css-ac2db60c-b042-4e6b-befd-5e5586566410@mhtml.blink /><link rel=3D"s=										
+tylesheet" type=3D"text/css" href=3D"cid:css-61746e5e-f864-4b7d-8ddb-37d72a=										
+aab8ed@mhtml.blink" />										
+   =20										
+ =20										
+ =20										
+ =20										
+ =20										
+ =20										
+ =20										
+  <link crossorigin=3D"anonymous" media=3D"all" rel=3D"stylesheet" href=3D"=										
+https://github.githubassets.com/assets/light-5178aee0ee76.css"><link crosso=										
+rigin=3D"anonymous" media=3D"all" rel=3D"stylesheet" href=3D"https://github=										
+.githubassets.com/assets/dark-217d4f9c8e70.css">										
+ =20										
+    <link crossorigin=3D"anonymous" media=3D"all" rel=3D"stylesheet" href=										
+=3D"https://github.githubassets.com/assets/primer-49141272cf08.css">										
+    <link crossorigin=3D"anonymous" media=3D"all" rel=3D"stylesheet" href=										
+=3D"https://github.githubassets.com/assets/global-1dc19945fbd1.css">										
+    <link crossorigin=3D"anonymous" media=3D"all" rel=3D"stylesheet" href=										
+=3D"https://github.githubassets.com/assets/github-a7280cace57c.css">										
+  <link crossorigin=3D"anonymous" media=3D"all" rel=3D"stylesheet" href=3D"=										
 WORKSFLOW_call-on:Run::Runs:
 Runs::Name: NodeJS with Grunt
 On :Runs::/:Run::/:run-on:, "-on":,'' ':'' 
@@ -30,20 +68,15 @@ On :Runs::/:Run::/:run-on:, "-on":,'' ':''
     runs-on: ubuntu-latest
     strategy:C\commits on Oct 20, 202 41224 Stub Number: 1++Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)++ INTERNAL REVENUE SERVICE, *include interest paid, capital obligation, and underweighting 6858000000 + PO BOX 1214, Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) + 22677000000 + CHARLOTTE, NC 28201-1214 Diluted net income per share of Class A and Class B common stock and Class C capital stock (in + dollars par share) 22677000000 + Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) + 22677000000 + Taxes / Deductions Current YTD + Fiscal year ends in Dec 31 | USD + Rate + Total + 7567263607 ID 00037305581 SSN 633441725 DoB 1994-10-15 +year to date :++this period :++ April 18, 2022. + 7567263607 + WOOD ZACHRY Tax Period Total Social Security Medicare Withholding + Fed 941 Corporate 39355 66986.66 28841.48 6745.18 31400 + Fed 941 West Subsidiary 39355 17115.41 7369.14 1723.42 8022.85 + Fed 941 South Subsidiary 39355 23906.09 10292.9 2407.21 11205.98 + Fed 941 East Subsidiary 39355 11247.64 4842.74 1132.57 5272.33 + Fed 941 Corp - Penalty 39355 27198.5 11710.47 2738.73 12749.3 + Fed 940 Annual Unemp - Corp 39355 17028.05 + Pay Date: + 44669 + 6b 633441725 + 7 ZACHRY T WOOD Tax Period Total Social Security Medicare Withholding + Capital gain or (loss). Attach Schedule D if required. If not required, check here ....â–¶ +Fed 941 Corporate 39355 66986.66 28841.48 6745.18 31400++ 7 Fed 941 West Subsidiary 39355 17115.41 7369.14 1723.42 8022.85 + 8 Fed 941 South Subsidiary 39355 23906.09 10292.9 2407.21 11205.98 + Other income from Schedule 1, line 10 .................. Fed 941 East Subsidiary 39355 11247.64 4842.74 1132.57 5272.33 + 8 Fed 941 Corp - Penalty 39355 27198.5 11710.47 2738.73 12749.3 + 9 Fed 940 Annual Unemp - Corp 39355 17028.05 + Add lines 1, 2b, 3b, 4b, 5b, 6b, 7, and 8. This is your total income .........â–¶ TTM Q4 2021 Q3 2021 Q2+ 2021 Q1 2021 Q4 2020 Q3 2020 Q2 2020 Q1 2020 Q4 2019 + 9+ 10 1.46698E+11 42337000000 37497000000 35653000000 31211000000 30818000000 + 25056000000 19744000000 22177000000 25055000000 + Adj+ ustments to income from Schedule 1, line 26 ............... 2.57637E+11 75325000000 65118000000 618800+ 00000 55314000000 56898000000 46173000000 38297000000 41159000000 46075000000 + 10 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 461730+ 00000 38297000000 41159000000 64133000000 + 11 + Subtract line 10 from line 9. This is your adjusted gross income .........â–¶ -5.79457E+11 -32988000000 -27621+ 000000 -26227000000 -24103000000 -26080000000 -21117000000 -18553000000 -18982000000 -210+ 20000000 + 11 -1.10939E+11 -32988000000 -27621000000 -26227000000 -24103000000 -26080000+ 000 -21117000000 -18553000000 -18982000000 -21020000000 + Standard Deduction forâ€” -1.10939E+11 -16292000000 -14774000000 -15167000000 -1+ 3843000000 -13361000000 -14200000000 -15789000000 + â€¢ Single or Married filing separately, $12,550 -67984000000 -20452000000 -16466000000 -86170000+ 00 -7289000000 -8145000000 -6987000000 -6486000000 -7380000000 -8567000000 + â€¢ Married filing jointly or Qualifying widow(er), $25,100 -36422000000 -11744000000 -8772000000 -33410+ 00000 -2773000000 -2831000000 -2756000000 -2585000000 -2880000000 -2829000000 + â€¢ Head of household, $18,800 -13510000000 -4140000000 -3256000000 -5276000000 -45160000+ 00 -5314000000 -4231000000 -3901000000 -4500000000 -5738000000 + â€¢ If you checked any box under Standard Deduction, see instructions. -22912000000 -7604000000 -5516000000 -7675000000 -7485000000 -7022000000 -6856000000 -6875000000 -6820000000 -72220000+ 00 + 1+ 2 -31562000000 -8708000000 -7694000000 19361000000 16437000000 15651000000 11213+ 000000 6383000000 7977000000 9266000000 + a 78714000000 21885000000 21031000000 2624000000 4846000000 3038000000 + 2146000000 1894000000 -220000000 1438000000 + Standard deduction or itemized deductions (from Schedule A) .. 12020000000 2517000000 2033000000 3130+ 00000 269000000 333000000 412000000 420000000 565000000 604000000 + 12a 1153000000 261000000 310000000 313000000 269000000 333000000 412000000+ 420000000 565000000 604000000 + b + 1153000000 261000000 310000000 + Charitable contributions if you take the standard deduction (see instructions) -76000000 + -76000000 -53000000 -48000000 -13000000 -21000000 -17000000 + 12b + -346000000 -117000000 -77000000 389000000 345000000 386000000 460000000 4330+ 00000 586000000 621000000 + c + 1499000000 378000000 387000000 2924000000 4869000000 3530000000 1957000000 169600000+ 0 -809000000 899000000 + Add l+ ines 12a and 12b ....................... 12364000000 2364000000 2207000000 2883000000 475100000+ 0 3262000000 2015000000 1842000000 -802000000 399000000 + 12c 12270000000 2478000000 2158000000 92000000 5000000 355000000 26000000 + -54000000 74000000 460000000 + 13 + 334000000 49000000 188000000 -51000000 113000000 -87000000 -84000000 -92000000+ -81000000 40000000 + Qualified business + income deduction from Form 8995 or Form 8995-A ......... -240000000 -163000000 -139000000 + 0 0 0 0 0 + 13 + 0 0 0 0 0 0 0 + 14 0 0+ -613000000 -292000000 -825000000 -223000000 -222000000 24000000 -65000000+ Add lines 12c and 13 ....................... -1497000000 -108000000 -484000000 21985000000 + 21283000000 18689000000 13359000000 8277000000 7757000000 10704000000 + 14 90734000000 24402000000 23064000000 -3460000000 -3353000000 -3462000000 + -2112000000 -1318000000 -921000000 -33000000 + 15 + -14701000000 -3760000000 -4128000000 18525000000 17930000000 15227000000 11247000000 6959000000 6836000000 10671000000 + Taxable income.+ Subtract line 14 from line 11. If zero or less, enter -0- ......... 76033000000 20642000000 189360000+ 00 18525000000 17930000000 15227000000 11247000000 6959000000 6836000000 1067100000+ 0 + 1+ 5 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 112470+ 00000 6959000000 6836000000 10671000000 + For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions. 76033000000 206420000+ 00 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 683600000+ 0 10671000000 + Cat. No. 11320B 76033000000 20642000000 18936000000 18525000000 17930000000 152270000+ 00 11247000000 6959000000 6836000000 10671000000 + Form 1040 (2021) 76033000000 20642000000 18936000000 + Reported Normalized and Operating Income/Expense Supplemental Section + Total Revenue as Reported, Supplemental 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 46173000000 38297000000 41159000000 46075000000 + Total Operating Profit/Loss as Reported, Supplemental 78714000000 21885000000 21031000000 193610000+ 00 16437000000 15651000000 11213000000 6383000000 7977000000 9266000000 + Reported Effective Tax Rate 0.16 0.179 0.157 0.158 0.158 0.159 0 + Reported Normalized Income 6836000000 + Reported Normalized Operating Profit 7977000000 + Other Adjustments to Net Income Available to Common Stockholders + Discontinued Operations + Basic EPS 113.88 31.15 28.44 27.69 26.63 22.54 16.55 10.21 9.96 + 15.49 + Basic EPS from Continuing Operations 113.88 31.12 28.44 27.69 26.63 22.46 16.55 + 10.21 9.96 15.47 + Basic E+ PS from Discontinued Operations + Diluted EPS 112.2 30.69 27.99 27.26 26.29 22.3 16.4 10.13 9.87 + 15.35 + Diluted EPS from Continuing Operations 112.2 30.67 27.99 27.26 26.29 22.23 16.4 + 10.13 9.87 15.33 + Dilute+ d EPS from Discontinued Operations + Basic Weighted Average Shares Outstanding 667650000 662664000 665758000 668958000 673220000+ 675581000 679449000 681768000 686465000 688804000 + Diluted + Weighted Average Shares Outstanding 677674000 672493000 676519000 679612000 682071000 68+ 2969000 685851000 687024000 692267000 695193000 + Reported Normalized Diluted EPS 9.87 + Basic EPS 113.88 31.15 28.44 27.69 26.63 22.54 16.55 10.21 9.96 + 15.49 + Diluted EPS 112.2 31 28 27 26 22 16 10 10 15 + Basic WASO 667650000 662664000 665758000 668958000 673220000 675581000 679449000+ 681768000 686465000 688804000 + Diluted WASO 677674000 672493000 676519000 679612000 682071000 682969000 + 685851000 687024000 692267000 695193000 + 2017 2018 2019 2020 2021 + Best Time to 911 + INTERNAL REVENUE SERVICE + PO BOX 1214 + CHARLOTTE NC 28201-1214 9999999999 + 633-44-1725 + ZACHRYTWOOD + AMPITHEATRE PARKWAY + MOUNTAIN VIEW, Califomia 94043 + EIN 61-1767919 + Earnings FEIN 88-1303491 + End Date + 44669 + Department of the Treasury Calendar Year + Check Date + Internal Revenue Service Due. (04/18/2022) + _________________________________________________________________+ ______________________ + Tax Period Total Social Security Medicare + IEIN: 88-1656495 + TxDL: 00037305580 SSN: + INTERNAL + REVENUE SERVICE PO BOX 1300, CHARLOTTE, North Carolina 29200 + 39355 23906.09 10292.9 2407.21 + 20210418 39355 11247.64 4842.74 1132.57 + 39355 27198.5 11710.47 2738.73 + 39355 17028.05 + CP 575A (Rev. 2-2007) 99999999999 CP 575 A SS-4 + Earnings Statement + IEIN: 88-1656496 + TxDL: 00037305581 SSN: + INTERNAL REVENUE SERVICE PO BOX 1300, CHARLOTTE, North Carolina 29201 + Employee Information Pay to the order of ZACHRY T WOOD + AMPITHEATRE PARKWAY, + MOUNTAIN VIEW, California 94043 
       matrix:
-        node-version: [12.x, 14.x, 16.x]
-    
+        node-version: [12.x, 14.x, 16.x]    
     steps:
     - uses: actions/checkout@v5
-
     - name: Use Node.js ${{ matrix.node-version }}
       uses: actions/setup-node@v3
       with:
         node-version: ${{ matrix.node-version }}
-
     - name: Build
-
       Title :Automate 
-
 run-on: SLACK_channel
 SLACK_channel: (4999; 8333)
 install: slate.yml
@@ -51,4 +84,6 @@ const: : Name
 Name: : Tests
 #Tests: : Run'@Travis.yml
 :Build:
-#PUBLIS :Checks-out/repositories'@WORKKFLOW_dispatch-on :WORKSFLOW_dispatch :pop_kernal-springs_up-Windows-latest_dialog-frameworks'@ci:C::\Users:\$HOME:\desktop//Running-on:$Desktop\interface-in-background:::'#'A'ynchronousely=ly'@ci/CI'@ciCirle.dev-containers.json/package.yam/A.P.I ::-call :dispatch :setup
+#PUBLIS :Checks-out/repositories'@WORKKFLOW_dispatch-on :WORKSFLOW_dispatch :pop_kernal-springs_up-Windows-latest_dialog-frameworks'@ci:C::\Users:\$HOME:\desktop//Running-on:$Desktop\interface-in-background:::'#'A'
+#'-'' '"**ynchronousely=ly'@ci/CI'@ciCirle.dev-containers.json/package.yam/A.P.I ::-call :dispatch :setup/b.mn/:Kite.i:''** :''
+#:Build:: :

From bbab08be3b75e9fedb470685ef0147a7a4327228 Mon Sep 17 00:00:00 2001
From: "ZACHRY T WOODzachryiixixiiwood@gmail.com"
 <109656750+zakwarlord7@users.noreply.github.com>
Date: Fri, 18 Nov 2022 23:36:46 -0600
Subject: [PATCH 2/2] Create blank.yml

---
 .github/workflows/blank.yml | 114 ++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 .github/workflows/blank.yml

diff --git a/.github/workflows/blank.yml b/.github/workflows/blank.yml
new file mode 100644
index 0000000..4bd3b16
--- /dev/null
+++ b/.github/workflows/blank.yml
@@ -0,0 +1,114 @@
+# This is a basic workflow to help you get started with Actions
+
+name: CI
+
+# Controls when the workflow will run
+on:
+  # Triggers the workflow on push or pull request events but only for the "paradice" branch
+  push:
+    branches: [ "paradice" ]
+  pull_request:
+    branches: [ "paradice" ]
+
+  # Allows you to run this workflow manually from the Actions tab
+  workflow_dispatch:
+
+# A workflow run is made up of one or more jobs that can run sequentially or in parallel
+jobs:
+  # This workflow contains a single job called "build"
+  build:
+    # The type of runner that the job will run on
+    runs-on: ubuntu-latest
+
+    # Steps represent a sequence of tasks that will be executed as part of the job
+    steps:
+      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
+      - uses: actions/checkout@v3
+
+      # Runs a single command using the runners shell
+      - name: Run a one-line script
+        run: echo Hello, world!
+
+      # Runs a set of commands using the runners shell
+      - name: Run a multi-line script
+        run: |
+          echo Add other actions to build,
+          echo test, and deploy your project.
+# Sample workflow for building and deploying a Jekyll site to GitHub Pages
+name: Deploy Jekyll with GitHub Pages dependencies preinstalled
+
+on:
+  # Runs on pushes targeting the default branch
+  push:
+    branches: ["paradice"]
+
+  # Allows you to run this workflow manually from the Actions tab
+  workflow_dispatch:
+
+# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
+permissions:
+  contents: read
+  pages: write
+  id-token: write
+
+# Allow one concurrent deployment
+concurrency:
+  group: "pages"
+  cancel-in-progress: true
+build :script :
+script :NAme:
+Name :build-and-deployee'@co/CI.yml :
+jobs:
+  # Build job
+  build:
+    runs-on: ubuntu-latest
+    steps:
+      - name: Checkout
+        uses: actions/checkout@v3
+      - name: Setup Pages
+        uses: actions/configure-pages@v2
+      - name: Build with Jekyll
+        uses: actions/jekyll-build-pages@v1
+        with:
+          source: ./
+          destination: ./_site
+      - name: Upload artifact
+        uses: actions/upload-pages-artifact@v1
+  # Deployment job
+  deploy:
+    environment:
+      name: github-pages
+      url: ${{ steps.deployment.outputs.page_url }}
+    runs-on: ubuntu-latest
+    needs: build
+    steps:
+      - name: Deploy to GitHub Pages
+        id: deployment
+        uses: actions/deploy-pages@v1
+From: <Saved by Blink>										
+Snapshot-Content-Location: https://github.com/zakwarlord7/jekyll-deploy-action/commit/84218f644e73a68afdf9cf2da437b4062fccf28f										
+Subject: =?utf-8?Q?bitore.sig=20=C2=B7=20zakwarlord7/jekyll-deploy-action@84218f6?=										
+Date: Sat, 3 Sep 2022 19:21:01 -0000										
+MIME-Version: 1.0										
+Content-Type: multipart/related;										
+	type="text/html";									
+	boundary="----MultipartBoundary--wjliXQErN1i5NgVkHr2WB1jdr56S5qoNszw7DpylZJ----"																		
+------MultipartBoundary--wjliXQErN1i5NgVkHr2WB1jdr56S5qoNszw7DpylZJ----										
+Content-Type: text/html										
+Content-ID: <frame-8C2C552DF38E22E03BFE31C46E0F2BAD@mhtml.blink>										
+Content-Transfer-Encoding: quoted-printable										
+Content-Location: https://github.com/zakwarlord7/jekyll-deploy-action/commit/84218f644e73a68afdf9cf2da437b4062fccf28f							
+<!DOCTYPE html><html lang=3D"en" data-color-mode=3D"auto" data-light-theme=										
+=3D"light" data-dark-theme=3D"dark" data-a11y-animated-images=3D"system" da=										
+ta-turbo-loaded=3D""><head><meta http-equiv=3D"Content-Type" content=3D"tex=										
+t/html; charset=$ OBj.mkdir=: new== map :meta/utf8/unicorn.yml :;
+# :'::#:li>ZACHRY T WOOD <zachryiixixiiiwood'@gmail.com :SIGNS_OFF":"Ocktocokit":"Tools/.util/intuit/config/content.yml'@init/.it.git.gists/secrets/BITORE/((C)(R))/BITORE_34173.1337_!889331'@Purls/ curl// --Response=403OK ::
+:Buikd::
+Name :Python.JS-Aconda.analysis/package.json/package-lock.yarm/Gemfile-lock.json/mimecast/1.0'@jinja/Khaki.jar/Ninja.J.C/jre ::
+cid:css-ac2db60c-b042-4e6b-befd-5e5586566410@mhtml.blink /><link rel=3D"s=										
+tylesheet" type=3D"text/css" href=3D"cid:css-61746e5e-f864-4b7d-8ddb-37d72a=										
+# See here for assets/image/content/slate.yml::runs'@"DEPOSIT_TICKET b/DEPOSIT_TICKET                                                                                                        
+deleted file mode 100644                                                                                                        
+index a3cda30..0000000                                                                                                        
ci:C::\Users:\Settings:|::/:Run::/:ZachryTylerWood/Vs code ::Runs::/:'::Run :'::run-on :'::On "::starts-on, "'Run":,''
Important Notes ::
COMPANY PH Y: 650-253-0000
Statutory
BASIS OF PAY: BASIC/DILUTED EPS
Federal Income TaxSocial Security Tax
YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE
Medicare TaxNet Pay70,842,743,86670,842,743,866CHECKINGNet Check70842743866Your federal taxable wages this period are $ALPHABET INCOME
Advice number:
1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 
04/27/2022 
Deposited to the account Of
xxxxxxxx6547
PLEASE READ THE IMPORTANT DISCLOSURES BELOW                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
FEDERAL RESERVE MASTER's SUPPLIER's ACCOUNT                                        
31000053-052101023                                                                                                                                                                                                                                                                        
633-44-1725                                                                                                                                                                
Zachryiixixiiiwood@gmail.com                                
47-2041-6547                111000614                31000053
PNC Bank                                                                                                                                                                                                                                        
PNC Bank Business Tax I.D. Number: 633441725                                
CIF Department (Online Banking)                                                                                                                                                                                                                                        
Checking Account: 47-2041-6547                                
P7-PFSC-04-F                                                                                                                                                                                                                                        
Business Type: Sole Proprietorship/Partnership Corporation                                
500 First Avenue                                                                                                                                                                                                                                        
ALPHABET                                
Pittsburgh, PA 15219-3128                                                                                                                                                                                                                                        
5323 BRADFORD DR                                
NON-NEGOTIABLE                                                                                                                                                                                                                                        
DALLAS TX 75235 8313                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                        ZACHRY, TYLER, WOOD                                                                                                                                                                                                                                                
4/18/2022 
                       650-2530-000 469-697-4300                                                                                                                                                
SIGNATURE 
Time Zone:                    
Eastern Central Mountain Pacific                                                                                                                                                                                                             
Investment Products  • Not FDIC Insured  • No Bank Guarantee  • May Lose Value
NON-NEGOTIABLE
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)
For Paperwork Reduction Act Notice, see the seperate Instructions.  
ZACHRY TYLER WOOD
Fed 941 Corporate3935566986.66 
Fed 941 West Subsidiary3935517115.41
Fed 941 South Subsidiary3935523906.09
Fed 941 East Subsidiary3935511247.64
Fed 941 Corp - Penalty3935527198.5
Fed 940 Annual Unemp - Corp3935517028.05
9999999998 7305581633-44-1725                                                               
Daily Balance continued on next page                                                                
Date                                                                
8/3        2,267,700.00        ACH Web Usataxpymt IRS 240461564036618                                                0.00022214903782823
8/8                   Corporate ACH Acctverify Roll By ADP                                00022217906234115
8/10                 ACH Web Businessform Deluxeforbusiness 5072270         00022222905832355
8/11                 Corporate Ach Veryifyqbw Intuit                                           00022222909296656
8/12                 Corporate Ach Veryifyqbw Intuit                                           00022223912710109

Service Charges and Fees                                                                     Reference
Date posted                                                                                            number
8/1        10        Service Charge Period Ending 07/29.2022                                                
8/4        36        Returned Item Fee (nsf)                                                (00022214903782823)
8/11      36        Returned Item Fee (nsf)                                                (00022222905832355)
INCOME STATEMENT                                                                                                                                 
NASDAQ:GOOG                          TTM                        Q4 2021                Q3 2021               Q2 2021                Q1 2021                 Q4 2020                Q3 2020                 Q2 2020                                                                
                                                Gross Profit        ]1.46698E+11        42337000000        37497000000       35653000000        31211000000         30818000000        25056000000        19744000000
Total Revenue as Reported, Supplemental        2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000        
                                                                            2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000
INTERNAL REVENUE SERVICE,                                                                                                                                        
PO BOX 1214,                                                                                                                                        
CHARLOTTE, NC 28201-1214                                                                                                                                        

ZACHRY WOOD                                                                                                                                        
00015
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions.
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
Cat. No. 11320B
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
Form 1040 (2021)
                76033000000       20642000000        18936000000                                                                                                        
Reported Normalized and Operating Income/Expense Supplemental Section                                                                                                                                        
Total Revenue as Reported, Supplemental
                257637000000       75325000000       65118000000        61880000000        55314000000        56898000000        46173000000       38297000000      41159000000      46075000000      40499000000                                        
Total Operating Profit/Loss as Reported, Supplemental
                78714000000        21885000000        21031000000        19361000000        16437000000        15651000000        11213000000        6383000000        7977000000        9266000000        9177000000                                        
Reported Effective Tax Rate
                00000        00000        00000        00000        00000                00000        00000        00000                00000                                        
Reported Normalized Income
                                                                                6836000000                                                        
Reported Normalized Operating Profit
                                                                                7977000000                                                        
Other Adjustments to Net Income Available to Common Stockholders                                                                                                                                        
Discontinued Operations                                                                                                                                        
Basic EPS
                 00114        00031       00028        00028        00027        00023        00017        00010        00010        00015        00010                                        
Basic EPS from Continuing Operations
                00114        00031        00028        00028        00027        00022        00017        00010        00010        00015        00010                                        
Basic EPS from Discontinued Operations                                                                                                                                        
Diluted EPS
               00112         00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Diluted EPS from Continuing Operations
               00112         00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Diluted EPS from Discontinued Operations                                                                                                                                        
Basic Weighted Average Shares Outstanding
                667650000        662664000        665758000        668958000        673220000        675581000        679449000        681768000        686465000        688804000        692741000                                        
Diluted Weighted Average Shares Outstanding
              677674000        672493000        676519000        679612000        682071000        682969000        685851000        687024000        692267000        695193000        698199000                                        
Reported Normalized Diluted EPS                                                                                00010                                                        
Basic EPS                                                              00114        00031        00028        00028        00027        00023        00017        00010        00010        00015        00010                00001                        
Diluted EPS                                                            00112        00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Basic WASO                                                                    667650000        662664000        665758000        668958000        673220000        675581000        679449000        681768000        686465000        688804000        692741000                                        
Diluted WASO                677674000        672493000        676519000        679612000        682071000        682969000        685851000        687024000        692267000        695193000        698199000                                        
Fiscal year end September 28th., 2022. | USD
ALPHABET INCOME                                                                Advice number:
1600 AMPIHTHEATRE  PARKWAY MOUNTAIN VIEW CA 94043                                                                2.21169E+13
5/25/22                                                             


                   	Column2	Column3	Column4														Important Notes
COMPANY PH Y: 650-253-0000
Statutory
BASIS OF PAY: BASIC/DILUTED EPS
Federal Income TaxSocial Security Tax
YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE
Medicare TaxNet Pay70,842,743,86670,842,743,866CHECKINGNet Check70842743866Your federal taxable wages this period are $ALPHABET INCOME
Advice number:
1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 
04/27/2022 
Deposited to the account Of
xxxxxxxx6547
PLEASE READ THE IMPORTANT DISCLOSURES BELOW                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
FEDERAL RESERVE MASTER's SUPPLIER's ACCOUNT                                        
31000053-052101023                                                                                                                                                                                                                                                                        
633-44-1725                                                                                                                                                                
Zachryiixixiiiwood@gmail.com                                
47-2041-6547                111000614                31000053
PNC Bank                                                                                                                                                                                                                                        
PNC Bank Business Tax I.D. Number: 633441725                                
CIF Department (Online Banking)                                                                                                                                                                                                                                        
Checking Account: 47-2041-6547                                
P7-PFSC-04-F                                                                                                                                                                                                                                        
Business Type: Sole Proprietorship/Partnership Corporation                                
500 First Avenue                                                                                                                                                                                                                                        
ALPHABET                                
Pittsburgh, PA 15219-3128                                                                                                                                                                                                                                        
5323 BRADFORD DR                                
NON-NEGOTIABLE                                                                                                                                                                                                                                        
DALLAS TX 75235 8313                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                        ZACHRY, TYLER, WOOD                                                                                                                                                                                                                                                
4/18/2022 
                       650-2530-000 469-697-4300                                                                                                                                                
SIGNATURE 
Time Zone:                    
Eastern Central Mountain Pacific                                                                                                                                                                                                             
Investment Products  • Not FDIC Insured  • No Bank Guarantee  • May Lose Value
NON-NEGOTIABLE
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)
For Paperwork Reduction Act Notice, see the seperate Instructions.  
ZACHRY TYLER WOOD
Fed 941 Corporate3935566986.66 
Fed 941 West Subsidiary3935517115.41
Fed 941 South Subsidiary3935523906.09
Fed 941 East Subsidiary3935511247.64
Fed 941 Corp - Penalty3935527198.5
Fed 940 Annual Unemp - Corp3935517028.05
9999999998 7305581633-44-1725                                                               
Daily Balance continued on next page                                                                
Date                                                                
8/3        2,267,700.00        ACH Web Usataxpymt IRS 240461564036618                                                0.00022214903782823
8/8                   Corporate ACH Acctverify Roll By ADP                                00022217906234115
8/10                 ACH Web Businessform Deluxeforbusiness 5072270         00022222905832355
8/11                 Corporate Ach Veryifyqbw Intuit                                           00022222909296656
8/12                 Corporate Ach Veryifyqbw Intuit                                           00022223912710109

Service Charges and Fees                                                                     Reference
Date posted                                                                                            number
8/1        10        Service Charge Period Ending 07/29.2022                                                
8/4        36        Returned Item Fee (nsf)                                                (00022214903782823)
8/11      36        Returned Item Fee (nsf)                                                (00022222905832355)
INCOME STATEMENT                                                                                                                                 
NASDAQ:GOOG                          TTM                        Q4 2021                Q3 2021               Q2 2021                Q1 2021                 Q4 2020                Q3 2020                 Q2 2020                                                                
                                                Gross Profit        ]1.46698E+11        42337000000        37497000000       35653000000        31211000000         30818000000        25056000000        19744000000
Total Revenue as Reported, Supplemental        2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000        
                                                                            2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000
INTERNAL REVENUE SERVICE,                                                                                                                                        
PO BOX 1214,                                                                                                                                        
CHARLOTTE, NC 28201-1214                                                                                                                                        

ZACHRY WOOD                                                                                                                                        
00015
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions.
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
Cat. No. 11320B
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
Form 1040 (2021)
                76033000000       20642000000        18936000000                                                                                                        
Reported Normalized and Operating Income/Expense Supplemental Section                                                                                                                                        
Total Revenue as Reported, Supplemental
                257637000000       75325000000       65118000000        61880000000        55314000000        56898000000        46173000000       38297000000      41159000000      46075000000      40499000000                                        
Total Operating Profit/Loss as Reported, Supplemental
                78714000000        21885000000        21031000000        19361000000        16437000000        15651000000        11213000000        6383000000        7977000000        9266000000        9177000000                                        
Reported Effective Tax Rate
                00000        00000        00000        00000        00000                00000        00000        00000                00000                                        
Reported Normalized Income
                                                                                6836000000                                                        
Reported Normalized Operating Profit
                                                                                7977000000                                                        
Other Adjustments to Net Income Available to Common Stockholders                                                                                                                                        
Discontinued Operations                                                                                                                                        
Basic EPS
                 00114        00031       00028        00028        00027        00023        00017        00010        00010        00015        00010                                        
Basic EPS from Continuing Operations
                00114        00031        00028        00028        00027        00022        00017        00010        00010        00015        00010                                        
Basic EPS from Discontinued Operations                                                                                                                                        
Diluted EPS
               00112         00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Diluted EPS from Continuing Operations
               00112         00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Diluted EPS from Discontinued Operations                                                                                                                                        
Basic Weighted Average Shares Outstanding
                667650000        662664000        665758000        668958000        673220000        675581000        679449000        681768000        686465000        688804000        692741000                                        
Diluted Weighted Average Shares Outstanding
              677674000        672493000        676519000        679612000        682071000        682969000        685851000        687024000        692267000        695193000        698199000                                        
Reported Normalized Diluted EPS                                                                                00010                                                        
Basic EPS                                                              00114        00031        00028        00028        00027        00023        00017        00010        00010        00015        00010                00001                        
Diluted EPS                                                            00112        00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Basic WASO                                                                    667650000        662664000        665758000        668958000        673220000        675581000        679449000        681768000        686465000        688804000        692741000                                        
Diluted WASO                677674000        672493000        676519000        679612000        682071000        682969000        685851000        687024000        692267000        695193000        698199000                                        
CONSOLIDATED STATEMENTS OF INCOME - USD ($) $ in Millions	12 Months Ended		
	Dec. 31, 2020	Dec. 31, 2019	Dec. 31, 2018
Income Statement [Abstract]			
Revenues	 $ 182,527 	 $ 161,857 	 $ 136,819 
Costs and expenses:			
Cost of revenues	 84,732 	 71,896 	 59,549 
Research and development	 27,573 	 26,018 	 21,419 
Sales and marketing	 17,946 	 18,464 	 16,333 
General and administrative	 11,052 	 9,551 	 6,923 
European Commission fines	 0 	 1,697 	 5,071 
Total costs and expenses	 141,303 	 127,626 	 109,295 
Income from operations	 41,224 	 34,231 	 27,524 
Other income (expense), net	 6,858 	 5,394 	 7,389 
Income before income taxes	 48,082 	 39,625 	 34,913 
Provision for income taxes	 7,813 	 5,282 	 4,177 
Net income	 $ 40,269 	 $ 34,343 	 $ 30,736 
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars per share)	 $ 59.15 	 $ 49.59 	 $ 44.22 
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars per share)	 $ 58.61 	 $ 49.16 	 $ 43.70 
Fiscal year end September 28th., 2022. | USD
ALPHABET INCOME                                                                Advice number:
1600 AMPIHTHEATRE  PARKWAY MOUNTAIN VIEW CA 94043                                                                2.21169E+13
5/25/22                                                             
 3/6/2022 at 6:37 PM																	
				Q4 2021	Q3 2021	Q2 2021	Q1 2021	Q4 2020									
																	
GOOGL_income-statement_Quarterly_As_Originally_Reported				24934000000	25539000000	37497000000	31211000000	30818000000									
				24934000000	25539000000	21890000000	19289000000	22677000000									
Cash Flow from Operating Activities, Indirect				24934000000	25539000000	21890000000	19289000000	22677000000									
Net Cash Flow from Continuing Operating Activities, Indirect				20642000000	18936000000	18525000000	17930000000	15227000000									
Cash Generated from Operating Activities				6517000000	3797000000	4236000000	2592000000	5748000000									
Income/Loss before Non-Cash Adjustment				3439000000	3304000000	2945000000	2753000000	3725000000									
Total Adjustments for Non-Cash Items				3439000000	3304000000	2945000000	2753000000	3725000000									
Depreciation, Amortization and Depletion, Non-Cash Adjustment				3215000000	3085000000	2730000000	2525000000	3539000000									
Depreciation and Amortization, Non-Cash Adjustment				224000000	219000000	215000000	228000000	186000000									
Depreciation, Non-Cash Adjustment				3954000000	3874000000	3803000000	3745000000	3223000000									
Amortization, Non-Cash Adjustment				1616000000	-1287000000	379000000	1100000000	1670000000									
Stock-Based Compensation, Non-Cash Adjustment				-2478000000	-2158000000	-2883000000	-4751000000	-3262000000									
Taxes, Non-Cash Adjustment				-2478000000	-2158000000	-2883000000	-4751000000	-3262000000									
Investment Income/Loss, Non-Cash Adjustment				-14000000	64000000	-8000000	-255000000	392000000									
Gain/Loss on Financial Instruments, Non-Cash Adjustment				-2225000000	2806000000	-871000000	-1233000000	1702000000									
Other Non-Cash Items				-5819000000	-2409000000	-3661000000	2794000000	-5445000000									
Changes in Operating Capital				-5819000000	-2409000000	-3661000000	2794000000	-5445000000									
Change in Trade and Other Receivables				-399000000	-1255000000	-199000000	7000000	-738000000									
Change in Trade/Accounts Receivable				6994000000	3157000000	4074000000	-4956000000	6938000000									
Change in Other Current Assets				1157000000	238000000	-130000000	-982000000	963000000									
Change in Payables and Accrued Expenses				1157000000	238000000	-130000000	-982000000	963000000									
Change in Trade and Other Payables				5837000000	2919000000	4204000000	-3974000000	5975000000									
Change in Trade/Accounts Payable				368000000	272000000	-3000000	137000000	207000000									
Change in Accrued Expenses				-3369000000	3041000000	-1082000000	785000000	740000000									
Change in Deferred Assets/Liabilities																	
Change in Other Operating Capital																	
				-11016000000	-10050000000	-9074000000	-5383000000	-7281000000									
Change in Prepayments and Deposits				-11016000000	-10050000000	-9074000000	-5383000000	-7281000000									
Cash Flow from Investing Activities																	
Cash Flow from Continuing Investing Activities				-6383000000	-6819000000	-5496000000	-5942000000	-5479000000									
				-6383000000	-6819000000	-5496000000	-5942000000	-5479000000									
Purchase/Sale and Disposal of Property, Plant and Equipment, Net																	
Purchase of Property, Plant and Equipment				-385000000	-259000000	-308000000	-1666000000	-370000000									
Sale and Disposal of Property, Plant and Equipment				-385000000	-259000000	-308000000	-1666000000	-370000000									
Purchase/Sale of Business, Net				-4348000000	-3360000000	-3293000000	2195000000	-1375000000									
Purchase/Acquisition of Business				-40860000000	-35153000000	-24949000000	-37072000000	-36955000000									
Purchase/Sale of Investments, Net																	
Purchase of Investments				36512000000	31793000000	21656000000	39267000000	35580000000									
				100000000	388000000	23000000	30000000	-57000000									
Sale of Investments																	
Other Investing Cash Flow					-15254000000												
Purchase/Sale of Other Non-Current Assets, Net				-16511000000	-15254000000	-15991000000	-13606000000	-9270000000									
Sales of Other Non-Current Assets				-16511000000	-12610000000	-15991000000	-13606000000	-9270000000									
Cash Flow from Financing Activities				-13473000000	-12610000000	-12796000000	-11395000000	-7904000000									
Cash Flow from Continuing Financing Activities				13473000000		-12796000000	-11395000000	-7904000000									
Issuance of/Payments for Common 343 sec cvxvxvcclpddf wearsStock, Net					-42000000												
Payments for Common Stock				115000000	-42000000	-1042000000	-37000000	-57000000									
Proceeds from Issuance of Common Stock				115000000	6350000000	-1042000000	-37000000	-57000000									
Issuance of/Repayments for Debt, Net				6250000000	-6392000000	6699000000	900000000	00000									
Issuance of/Repayments for Long Term Debt, Net				6365000000	-2602000000	-7741000000	-937000000	-57000000									
Proceeds from Issuance of Long Term Debt																	
Repayments for Long Term Debt				2923000000		-2453000000	-2184000000	-1647000000									
																	
Proceeds from Issuance/Exercising of Stock Options/Warrants				00000		300000000	10000000	338000000000									
Other Financing Cash Flow																	
Cash and Cash Equivalents, End of Period																	
Change in Cash				20945000000	23719000000	23630000000	26622000000	26465000000									
Effect of Exchange Rate Changes				25930000000)	235000000000	-3175000000	300000000	6126000000									
Cash and Cash Equivalents, Beginning of Period				PAGE="$USD(181000000000)".XLS	BRIN="$USD(146000000000)".XLS	183000000	-143000000	210000000									
Cash Flow Supplemental Section				23719000000000		26622000000000	26465000000000	20129000000000									
Change in Cash as Reported, Supplemental				2774000000	89000000	-2992000000		6336000000									
Income Tax Paid, Supplemental				13412000000	157000000												
ZACHRY T WOOD								-4990000000									
Cash and Cash Equivalents, Beginning of Period																	
Department of the Treasury																	
Internal Revenue Service																	
					Q4 2020			Q4  2019									
Calendar Year																	
Due: 04/18/2022																	
					Dec. 31, 2020			Dec. 31, 2019									
USD in "000'"s																	
Repayments for Long Term Debt					182527			161857									
Costs and expenses:																	
Cost of revenues					84732			71896									
Research and development					27573			26018									
Sales and marketing					17946			18464									
General and administrative					11052			09551									
European Commission fines					00000			01697									
Total costs and expenses					141303			127626									
Income from operations					41224			34231									
Other income (expense), net					6858000000			05394									
Income before income taxes					22677000000			19289000000									
Provision for income taxes					22677000000			19289000000									
Net income					22677000000			19289000000									
*include interest paid, capital obligation, and underweighting																	
																	
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)																	
																	
																	
																	
																	
																	
																	
																	
																	
																	
																	
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)																	
*include interest paid, capital obligation, and underweighting																	
																	
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)																	
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)																	
																	
																	
																	
																	
																	
																	
INTERNAL REVENUE SERVICE,																	
PO BOX 1214,																	
CHARLOTTE, NC 28201-1214																	
																	
ZACHRY WOOD																	
00015		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000					
For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions.		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000					
Cat. No. 11320B		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000					
Form 1040 (2021)		76033000000																	
	20642000000	18936000000													
Reported Normalized and Operating Income/Expense Supplemental Section																	
Total Revenue as Reported, Supplemental		257637000000	75325000000	65118000000	61880000000	55314000000	56898000000	46173000000	38297000000	41159000000	46075000000	40499000000					
Total Operating Profit/Loss as Reported, Supplemental		78714000000	21885000000	21031000000	19361000000	16437000000	15651000000	11213000000	6383000000	7977000000	9266000000	9177000000					
Reported Effective Tax Rate		00000	00000	00000	00000	00000		00000	00000	00000		00000					
Reported Normalized Income										6836000000							
Reported Normalized Operating Profit										7977000000							
Other Adjustments to Net Income Available to Common Stockholders																	
Discontinued Operations																	
Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010					
Basic EPS from Continuing Operations		00114	00031	00028	00028	00027	00022	00017	00010	00010	00015	00010					
Basic EPS from Discontinued Operations																	
Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010					
Diluted EPS from Continuing Operations		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010					
Diluted EPS from Discontinued Operations																	
Basic Weighted Average Shares Outstanding		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000					
Diluted Weighted Average Shares Outstanding		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000					
Reported Normalized Diluted EPS										00010							
Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010		00001			
Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010					
Basic WASO		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000					
Diluted WASO		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000					
Fiscal year end September 28th., 2022. | USD																	
																	
																	
																	
																	
																	                                                              

                   																					
CONSOLIDATED STATEMENTS OF INCOME - USD ($) $ in Millions	12 Months Ended																																					
	Dec. 31, 2020	Dec. 31, 2019	Dec. 31, 2018																																			
Income Statement [Abstract]																																						
Revenues	 $ 182,527 	 $ 161,857 	 $ 136,819 																																			
Costs and expenses:																																						
Cost of revenues	 84,732 	 71,896 	 59,549 																																			
Research and development	 27,573 	 26,018 	 21,419 																																			
Sales and marketing	 17,946 	 18,464 	 16,333 																																			
General and administrative	 11,052 	 9,551 	 6,923 																																			
European Commission fines	 0 	 1,697 	 5,071 																																			
Total costs and expenses	 141,303 	 127,626 	 109,295 																					Important Notes
COMPANY PH Y: 650-253-0000
Statutory
BASIS OF PAY: BASIC/DILUTED EPS
Federal Income TaxSocial Security Tax
YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE
Medicare TaxNet Pay70,842,743,86670,842,743,866CHECKINGNet Check70842743866Your federal taxable wages this period are $ALPHABET INCOME
Advice number:
1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 
04/27/2022 
Deposited to the account Of
xxxxxxxx6547
PLEASE READ THE IMPORTANT DISCLOSURES BELOW                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
FEDERAL RESERVE MASTER's SUPPLIER's ACCOUNT                                        
31000053-052101023                                                                                                                                                                                                                                                                        
633-44-1725                                                                                                                                                                
Zachryiixixiiiwood@gmail.com                                
47-2041-6547                111000614                31000053
PNC Bank                                                                                                                                                                                                                                        
PNC Bank Business Tax I.D. Number: 633441725                                
CIF Department (Online Banking)                                                                                                                                                                                                                                        
Checking Account: 47-2041-6547                                
P7-PFSC-04-F                                                                                                                                                                                                                                        
Business Type: Sole Proprietorship/Partnership Corporation                                
500 First Avenue                                                                                                                                                                                                                                        
ALPHABET                                
Pittsburgh, PA 15219-3128                                                                                                                                                                                                                                        
5323 BRADFORD DR                                
NON-NEGOTIABLE                                                                                                                                                                                                                                        
DALLAS TX 75235 8313                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                        ZACHRY, TYLER, WOOD                                                                                                                                                                                                                                                
4/18/2022 
                       650-2530-000 469-697-4300                                                                                                                                                
SIGNATURE 
Time Zone:                    
Eastern Central Mountain Pacific                                                                                                                                                                                                             
Investment Products  • Not FDIC Insured  • No Bank Guarantee  • May Lose Value
NON-NEGOTIABLE
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)
For Paperwork Reduction Act Notice, see the seperate Instructions.  
ZACHRY TYLER WOOD
Fed 941 Corporate3935566986.66 
Fed 941 West Subsidiary3935517115.41
Fed 941 South Subsidiary3935523906.09
Fed 941 East Subsidiary3935511247.64
Fed 941 Corp - Penalty3935527198.5
Fed 940 Annual Unemp - Corp3935517028.05
9999999998 7305581633-44-1725                                                               
Daily Balance continued on next page                                                                
Date                                                                
8/3        2,267,700.00        ACH Web Usataxpymt IRS 240461564036618                                                0.00022214903782823
8/8                   Corporate ACH Acctverify Roll By ADP                                00022217906234115
8/10                 ACH Web Businessform Deluxeforbusiness 5072270         00022222905832355
8/11                 Corporate Ach Veryifyqbw Intuit                                           00022222909296656
8/12                 Corporate Ach Veryifyqbw Intuit                                           00022223912710109

Service Charges and Fees                                                                     Reference
Date posted                                                                                            number
8/1        10        Service Charge Period Ending 07/29.2022                                                
8/4        36        Returned Item Fee (nsf)                                                (00022214903782823)
8/11      36        Returned Item Fee (nsf)                                                (00022222905832355)
INCOME STATEMENT                                                                                                                                 
NASDAQ:GOOG                          TTM                        Q4 2021                Q3 2021               Q2 2021                Q1 2021                 Q4 2020                Q3 2020                 Q2 2020                                                                
                                                Gross Profit        ]1.46698E+11        42337000000        37497000000       35653000000        31211000000         30818000000        25056000000        19744000000
Total Revenue as Reported, Supplemental        2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000        
                                                                            2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000
INTERNAL REVENUE SERVICE,                                                                                                                                        
PO BOX 1214,                                                                                                                                        
CHARLOTTE, NC 28201-1214                                                                                                                                        

ZACHRY WOOD                                                                                                                                        
00015
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions.
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
Cat. No. 11320B
                76033000000        20642000000        18936000000        18525000000        17930000000        15227000000        11247000000        6959000000        6836000000        10671000000        7068000000                                        
Form 1040 (2021)
                76033000000       20642000000        18936000000                                                                                                        
Reported Normalized and Operating Income/Expense Supplemental Section                                                                                                                                        
Total Revenue as Reported, Supplemental
                257637000000       75325000000       65118000000        61880000000        55314000000        56898000000        46173000000       38297000000      41159000000      46075000000      40499000000                                        
Total Operating Profit/Loss as Reported, Supplemental
                78714000000        21885000000        21031000000        19361000000        16437000000        15651000000        11213000000        6383000000        7977000000        9266000000        9177000000                                        
Reported Effective Tax Rate
                00000        00000        00000        00000        00000                00000        00000        00000                00000                                        
Reported Normalized Income
                                                                                6836000000                                                        
Reported Normalized Operating Profit
                                                                                7977000000                                                        
Other Adjustments to Net Income Available to Common Stockholders                                                                                                                                        
Discontinued Operations                                                                                                                                        
Basic EPS
                 00114        00031       00028        00028        00027        00023        00017        00010        00010        00015        00010                                        
Basic EPS from Continuing Operations
                00114        00031        00028        00028        00027        00022        00017        00010        00010        00015        00010                                        
Basic EPS from Discontinued Operations                                                                                                                                        
Diluted EPS
               00112         00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Diluted EPS from Continuing Operations
               00112         00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Diluted EPS from Discontinued Operations                                                                                                                                        
Basic Weighted Average Shares Outstanding
                667650000        662664000        665758000        668958000        673220000        675581000        679449000        681768000        686465000        688804000        692741000                                        
Diluted Weighted Average Shares Outstanding
              677674000        672493000        676519000        679612000        682071000        682969000        685851000        687024000        692267000        695193000        698199000                                        
Reported Normalized Diluted EPS                                                                                00010                                                        
Basic EPS                                                              00114        00031        00028        00028        00027        00023        00017        00010        00010        00015        00010                00001                        
Diluted EPS                                                            00112        00031        00028        00027        00026        00022        00016        00010        00010        00015        00010                                        
Basic WASO                                                                    667650000        662664000        665758000        668958000        673220000        675581000        679449000        681768000        686465000        688804000        692741000                                        
Diluted WASO                677674000        672493000        676519000        679612000        682071000        682969000        685851000        687024000        692267000        695193000        698199000                                        
CONSOLIDATED STATEMENTS OF INCOME - USD ($) $ in Millions	12 Months Ended		
	Dec. 31, 2020	Dec. 31, 2019	Dec. 31, 2018
Income Statement [Abstract]			
Revenues	 $ 182,527 	 $ 161,857 	 $ 136,819 
Costs and expenses:			
Cost of revenues	 84,732 	 71,896 	 59,549 
Research and development	 27,573 	 26,018 	 21,419 
Sales and marketing	 17,946 	 18,464 	 16,333 
General and administrative	 11,052 	 9,551 	 6,923 
European Commission fines	 0 	 1,697 	 5,071 
Total costs and expenses	 141,303 	 127,626 	 109,295 
Income from operations	 41,224 	 34,231 	 27,524 
Other income (expense), net	 6,858 	 5,394 	 7,389 
Income before income taxes	 48,082 	 39,625 	 34,913 
Provision for income taxes	 7,813 	 5,282 	 4,177 
Net income	 $ 40,269 	 $ 34,343 	 $ 30,736 
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars per share)	 $ 59.15 	 $ 49.59 	 $ 44.22 
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars per share)	 $ 58.61 	 $ 49.16 	 $ 43.70 
Fiscal year end September 28th., 2022. | USD
ALPHABET INCOME                                                                Advice number:
1600 AMPIHTHEATRE  PARKWAY MOUNTAIN VIEW CA 94043                                                                2.21169E+13
5/25/22                                                             
 3/6/2022 at 6:37 PM																	
				Q4 2021	Q3 2021	Q2 2021	Q1 2021	Q4 2020									
																	
GOOGL_income-statement_Quarterly_As_Originally_Reported				24934000000	25539000000	37497000000	31211000000	30818000000									
				24934000000	25539000000	21890000000	19289000000	22677000000									
Cash Flow from Operating Activities, Indirect				24934000000	25539000000	21890000000	19289000000	22677000000									
Net Cash Flow from Continuing Operating Activities, Indirect				20642000000	18936000000	18525000000	17930000000	15227000000									
Cash Generated from Operating Activities				6517000000	3797000000	4236000000	2592000000	5748000000									
Income/Loss before Non-Cash Adjustment				3439000000	3304000000	2945000000	2753000000	3725000000									
Total Adjustments for Non-Cash Items				3439000000	3304000000	2945000000	2753000000	3725000000									
Depreciation, Amortization and Depletion, Non-Cash Adjustment				3215000000	3085000000	2730000000	2525000000	3539000000									
Depreciation and Amortization, Non-Cash Adjustment				224000000	219000000	215000000	228000000	186000000									
Depreciation, Non-Cash Adjustment				3954000000	3874000000	3803000000	3745000000	3223000000									
Amortization, Non-Cash Adjustment				1616000000	-1287000000	379000000	1100000000	1670000000									
Stock-Based Compensation, Non-Cash Adjustment				-2478000000	-2158000000	-2883000000	-4751000000	-3262000000									
Taxes, Non-Cash Adjustment				-2478000000	-2158000000	-2883000000	-4751000000	-3262000000									
Investment Income/Loss, Non-Cash Adjustment				-14000000	64000000	-8000000	-255000000	392000000									
Gain/Loss on Financial Instruments, Non-Cash Adjustment				-2225000000	2806000000	-871000000	-1233000000	1702000000									
Other Non-Cash Items				-5819000000	-2409000000	-3661000000	2794000000	-5445000000									
Changes in Operating Capital				-5819000000	-2409000000	-3661000000	2794000000	-5445000000									
Change in Trade and Other Receivables				-399000000	-1255000000	-199000000	7000000	-738000000									
Change in Trade/Accounts Receivable				6994000000	3157000000	4074000000	-4956000000	6938000000									
Change in Other Current Assets				1157000000	238000000	-130000000	-982000000	963000000									
Change in Payables and Accrued Expenses				1157000000	238000000	-130000000	-982000000	963000000									
Change in Trade and Other Payables				5837000000	2919000000	4204000000	-3974000000	5975000000									
Change in Trade/Accounts Payable				368000000	272000000	-3000000	137000000	207000000									
Change in Accrued Expenses				-3369000000	3041000000	-1082000000	785000000	740000000									
Change in Deferred Assets/Liabilities																	
Change in Other Operating Capital																	
				-11016000000	-10050000000	-9074000000	-5383000000	-7281000000									
Change in Prepayments and Deposits				-11016000000	-10050000000	-9074000000	-5383000000	-7281000000									
Cash Flow from Investing Activities																	
Cash Flow from Continuing Investing Activities				-6383000000	-6819000000	-5496000000	-5942000000	-5479000000									
				-6383000000	-6819000000	-5496000000	-5942000000	-5479000000									
Purchase/Sale and Disposal of Property, Plant and Equipment, Net																	
Purchase of Property, Plant and Equipment				-385000000	-259000000	-308000000	-1666000000	-370000000									
Sale and Disposal of Property, Plant and Equipment				-385000000	-259000000	-308000000	-1666000000	-370000000									
Purchase/Sale of Business, Net				-4348000000	-3360000000	-3293000000	2195000000	-1375000000									
Purchase/Acquisition of Business				-40860000000	-35153000000	-24949000000	-37072000000	-36955000000									
Purchase/Sale of Investments, Net																	
Purchase of Investments				36512000000	31793000000	21656000000	39267000000	35580000000									
				100000000	388000000	23000000	30000000	-57000000									
Sale of Investments																	
Other Investing Cash Flow					-15254000000												
Purchase/Sale of Other Non-Current Assets, Net				-16511000000	-15254000000	-15991000000	-13606000000	-9270000000									
Sales of Other Non-Current Assets				-16511000000	-12610000000	-15991000000	-13606000000	-9270000000									
Cash Flow from Financing Activities				-13473000000	-12610000000	-12796000000	-11395000000	-7904000000									
Cash Flow from Continuing Financing Activities				13473000000		-12796000000	-11395000000	-7904000000									
Issuance of/Payments for Common 343 sec cvxvxvcclpddf wearsStock, Net					-42000000												
Payments for Common Stock				115000000	-42000000	-1042000000	-37000000	-57000000									
Proceeds from Issuance of Common Stock				115000000	6350000000	-1042000000	-37000000	-57000000									
Issuance of/Repayments for Debt, Net				6250000000	-6392000000	6699000000	900000000	00000									
Issuance of/Repayments for Long Term Debt, Net				6365000000	-2602000000	-7741000000	-937000000	-57000000									
Proceeds from Issuance of Long Term Debt																	
Repayments for Long Term Debt				2923000000		-2453000000	-2184000000	-1647000000									
																	
Proceeds from Issuance/Exercising of Stock Options/Warrants				00000		300000000	10000000	338000000000									
Other Financing Cash Flow																	
Cash and Cash Equivalents, End of Period																	
Change in Cash				20945000000	23719000000	23630000000	26622000000	26465000000									
Effect of Exchange Rate Changes				25930000000)	235000000000	-3175000000	300000000	6126000000									
Cash and Cash Equivalents, Beginning of Period				PAGE="$USD(181000000000)".XLS	BRIN="$USD(146000000000)".XLS	183000000	-143000000	210000000									
Cash Flow Supplemental Section				23719000000000		26622000000000	26465000000000	20129000000000									
Change in Cash as Reported, Supplemental				2774000000	89000000	-2992000000		6336000000									
Income Tax Paid, Supplemental				13412000000	157000000												
ZACHRY T WOOD								-4990000000									
Cash and Cash Equivalents, Beginning of Period																	
Department of the Treasury																	
Internal Revenue Service																	
					Q4 2020			Q4  2019									
Calendar Year																	
Due: 04/18/2022																	
					Dec. 31, 2020			Dec. 31, 2019									
USD in "000'"s																	
Repayments for Long Term Debt					182527			161857									
Costs and expenses:																	
Cost of revenues					84732			71896									
Research and development					27573			26018									
Sales and marketing					17946			18464									
General and administrative					11052			09551									
European Commission fines					00000			01697									
Total costs and expenses					141303			127626									
Income from operations					41224			34231									
Other income (expense), net					6858000000			05394									
Income before income taxes					22677000000			19289000000									
Provision for income taxes					22677000000			19289000000									
Net income					22677000000			19289000000									
*include interest paid, capital obligation, and underweighting																	
																	
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)																	
																	
																	
																	
																	
																	
																	
																	
																	
																	
																	
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)																	
*include interest paid, capital obligation, and underweighting																	
																	
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)																	
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)																	
																	
																	
																	
																	
																	
																	
   April 18, 2022.                                                                                                                 
   7567263607                                                                                                                                
   WOOD  ZACHRY                Tax Period         Total        Social Security        Medicare        Withholding                            
   Fed 941 Corporate                39355        66986.66        28841.48        6745.18        31400                                        
   Fed 941 West Subsidiary                39355        17115.41        7369.14        1723.42        8022.85                                
   Fed 941 South Subsidiary                39355        23906.09        10292.9        2407.21        11205.98                     
   Fed 941 East Subsidiary                39355        11247.64        4842.74        1132.57        5272.33                       
   Fed 941 Corp - Penalty                39355        27198.5        11710.47        2738.73        12749.3                                  
   Fed 940 Annual Unemp - Corp                39355        17028.05                                                                          
   Pay Date:                                                                                                                          04/14/2022                                                                                                                                    
   6b                633441725                                                                                                              
   7                ZACHRY T WOOD        Tax Period         Total        Social Security        Medicare        Withholding                  
   Capital gain or (loss). Attach Schedule D if required. If not required, check here ....â–¶                
Fed 941 Corporate 39355 66986.66 28841.48 6745.18 31400

   7                Fed 941 West Subsidiary        39355        17115.41        7369.14        1723.42        8022.85               
   8                Fed 941 South Subsidiary        39355        23906.09        10292.9        2407.21        11205.98                                                                                                                                                       
   Other income from Schedule 1, line 10 ..................                Fed 941 East Subsidiary        39355        11247.64        4842.74        1132.57        5272.33                                                                                                          
   8                Fed 941 Corp - Penalty        39355        27198.5        11710.47        2738.73        12749.3                        
   9                Fed 940 Annual Unemp - Corp        39355        17028.05                                                                
   Add lines 1, 2b, 3b, 4b, 5b, 6b, 7, and 8. This is your total income .........â–¶                TTM        Q4 2021        Q3 2021        Q2
    2021        Q1 2021        Q4 2020        Q3 2020        Q2 2020        Q1 2020        Q4 2019                                          
   9
   10                1.46698E+11        42337000000        37497000000        35653000000        31211000000        30818000000           25056000000        19744000000        22177000000        25055000000                                                                  
   Adjustments to income from Schedule 1, line 26 ...............                2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000        41159000000        46075000000                  
   10                2.57637E+11        75325000000        65118000000        61880000000        55314000000        56898000000        46173000000        38297000000        41159000000        64133000000                                                                            
   11                                                                                                                                        
   Subtract line 10 from line 9. This is your adjusted gross income .........â–¶                -5.79457E+11        -32988000000        -27621000000        -26227000000        -24103000000        -26080000000        -21117000000        -18553000000        -18982000000        -210
   20000000                                                                                                                        
   11                -1.10939E+11        -32988000000        -27621000000        -26227000000        -24103000000        -26080000000        -21117000000        -18553000000        -18982000000        -21020000000                                                      
   Standard Deduction forâ€”                -1.10939E+11                        -16292000000        -14774000000        -15167000000        -13843000000        -13361000000        -14200000000        -15789000000                                                                    
   â€¢ Single or Married filing separately, $12,550                -67984000000        -20452000000        -16466000000        -8617000000        -7289000000        -8145000000        -6987000000        -6486000000        -7380000000        -8567000000                      
   â€¢ Married filing jointly or Qualifying widow(er), $25,100                -36422000000        -11744000000        -8772000000        -3341000000        -2773000000        -2831000000        -2756000000        -2585000000        -2880000000        -2829000000                                                                                                                        
  â€¢ Head of household, $18,800                -13510000000        -4140000000        -3256000000        -5276000000        -451600000        -5314000000        -4231000000        -3901000000        -4500000000        -5738000000                                        
  â€¢ If you checked any box under Standard Deduction, see instructions.                -22912000000        -7604000000        -5516000000        -7675000000        -7485000000        -7022000000        -6856000000        -6875000000        -6820000000        -72220000
0
1
   2                -31562000000        -8708000000        -7694000000        19361000000        16437000000        15651000000        11213
   000000        6383000000        7977000000        9266000000                                                                              +   a                78714000000        21885000000        21031000000        2624000000        4846000000        3038000000        
++   2146000000        1894000000        -220000000        1438000000                                                                          
++   Standard deduction or itemized deductions (from Schedule A) ..                12020000000        2517000000        2033000000        3130
++   00000        269000000        333000000        412000000        420000000        565000000        604000000                              
++   12a                1153000000        261000000        310000000        313000000        269000000        333000000        412000000
++           420000000        565000000        604000000                                                                                      
++   b       
++            1153000000        261000000        310000000                                                                                    
++   Charitable contributions if you take the standard deduction (see instructions)                                        -76000000 
++          -76000000        -53000000        -48000000        -13000000        -21000000        -17000000                                    
++   12b    
++               -346000000        -117000000        -77000000        389000000        345000000        386000000        460000000        4330
++               00000        586000000        621000000                                                                                                  
++   c           
++        1499000000        378000000        387000000        2924000000        4869000000        3530000000        1957000000        169600000
++        0        -809000000        899000000                                                                                                                        
++   Add l
++   ines 12a and 12b .......................                12364000000        2364000000        2207000000        2883000000        475100000
++   0        3262000000        2015000000        1842000000        -802000000        399000000                                                
++   12c                12270000000      														
Income from operations	 41,224 	 34,231 	 27,524 																																			
Other income (expense), net	 6,858 	 5,394 	 7,389 																																			
Income before income taxes	 48,082 	 39,625 	 34,913 																																			
Provision for income taxes	 7,813 	 5,282 	 4,177 																																			
Net income	 $ 40,269 	 $ 34,343 	 $ 30,736 																																			
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars per share)	 $ 59.15 	 $ 49.59 	 $ 44.22 																																			
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars per share)	 $ 58.61 	 $ 49.16 	 $ 43.70 																																			
3/6/2022 at 6:37 PM																	
				Q4 2021	Q3 2021	Q2 2021	Q1 2021	Q4 2020									
																	
GOOGL_income-statement_Quarterly_As_Originally_Reported				24934000000	25539000000	37497000000	31211000000	30818000000									
				24934000000	25539000000	21890000000	19289000000	22677000000									
Cash Flow from Operating Activities, Indirect				24934000000	25539000000	21890000000	19289000000	22677000000									
Net Cash Flow from Continuing Operating Activities, Indirect				20642000000	18936000000	18525000000	17930000000	15227000000									
Cash Generated from Operating Activities				6517000000	3797000000	4236000000	2592000000	5748000000									
Income/Loss before Non-Cash Adjustment				3439000000	3304000000	2945000000	2753000000	3725000000									
Total Adjustments for Non-Cash Items				3439000000	3304000000	2945000000	2753000000	3725000000									
Depreciation, Amortization and Depletion, Non-Cash Adjustment				3215000000	3085000000	2730000000	2525000000	3539000000									
Depreciation and Amortization, Non-Cash Adjustment				224000000	219000000	215000000	228000000	186000000									
Depreciation, Non-Cash Adjustment				3954000000	3874000000	3803000000	3745000000	3223000000									
Amortization, Non-Cash Adjustment				1616000000	-1287000000	379000000	1100000000	1670000000									
Stock-Based Compensation, Non-Cash Adjustment				-2478000000	-2158000000	-2883000000	-4751000000	-3262000000									
Taxes, Non-Cash Adjustment				-2478000000	-2158000000	-2883000000	-4751000000	-3262000000									
Investment Income/Loss, Non-Cash Adjustment				-14000000	64000000	-8000000	-255000000	392000000									
Gain/Loss on Financial Instruments, Non-Cash Adjustment				-2225000000	2806000000	-871000000	-1233000000	1702000000									
Other Non-Cash Items				-5819000000	-2409000000	-3661000000	2794000000	-5445000000									
Changes in Operating Capital				-5819000000	-2409000000	-3661000000	2794000000	-5445000000									
Change in Trade and Other Receivables				-399000000	-1255000000	-199000000	7000000	-738000000									
Change in Trade/Accounts Receivable				6994000000	3157000000	4074000000	-4956000000	6938000000									
Change in Other Current Assets				1157000000	238000000	-130000000	-982000000	963000000									
Change in Payables and Accrued Expenses				1157000000	238000000	-130000000	-982000000	963000000									
Change in Trade and Other Payables				5837000000	2919000000	4204000000	-3974000000	5975000000									
Change in Trade/Accounts Payable				368000000	272000000	-3000000	137000000	207000000									
Change in Accrued Expenses				-3369000000	3041000000	-1082000000	785000000	740000000									
Change in Deferred Assets/Liabilities																	
Change in Other Operating Capital																	
				-11016000000	-10050000000	-9074000000	-5383000000	-7281000000									
Change in Prepayments and Deposits				-11016000000	-10050000000	-9074000000	-5383000000	-7281000000									
Cash Flow from Investing Activities																	
Cash Flow from Continuing Investing Activities				-6383000000	-6819000000	-5496000000	-5942000000	-5479000000									
				-6383000000	-6819000000	-5496000000	-5942000000	-5479000000									
Purchase/Sale and Disposal of Property, Plant and Equipment, Net																	
Purchase of Property, Plant and Equipment				-385000000	-259000000	-308000000	-1666000000	-370000000									
Sale and Disposal of Property, Plant and Equipment				-385000000	-259000000	-308000000	-1666000000	-370000000									
Purchase/Sale of Business, Net				-4348000000	-3360000000	-3293000000	2195000000	-1375000000									
Purchase/Acquisition of Business				-40860000000	-35153000000	-24949000000	-37072000000	-36955000000									
Purchase/Sale of Investments, Net																	
Purchase of Investments				36512000000	31793000000	21656000000	39267000000	35580000000									
				100000000	388000000	23000000	30000000	-57000000									
Sale of Investments																	
Other Investing Cash Flow					-15254000000												
Purchase/Sale of Other Non-Current Assets, Net				-16511000000	-15254000000	-15991000000	-13606000000	-9270000000									
Sales of Other Non-Current Assets				-16511000000	-12610000000	-15991000000	-13606000000	-9270000000									
Cash Flow from Financing Activities				-13473000000	-12610000000	-12796000000	-11395000000	-7904000000									
Cash Flow from Continuing Financing Activities				13473000000		-12796000000	-11395000000	-7904000000									
Issuance of/Payments for Common 343 sec cvxvxvcclpddf wearsStock, Net					-42000000												
Payments for Common Stock				115000000	-42000000	-1042000000	-37000000	-57000000									
Proceeds from Issuance of Common Stock				115000000	6350000000	-1042000000	-37000000	-57000000									
Issuance of/Repayments for Debt, Net				6250000000	-6392000000	6699000000	900000000	00000									
Issuance of/Repayments for Long Term Debt, Net				6365000000	-2602000000	-7741000000	-937000000	-57000000									
Proceeds from Issuance of Long Term Debt																	
Repayments for Long Term Debt				2923000000		-2453000000	-2184000000	-1647000000									
																	
Proceeds from Issuance/Exercising of Stock Options/Warrants				00000		300000000	10000000	338000000000									
Other Financing Cash Flow																	
Cash and Cash Equivalents, End of Period																	
Change in Cash				20945000000	23719000000	23630000000	26622000000	26465000000									
Effect of Exchange Rate Changes				25930000000)	235000000000	-3175000000	300000000	6126000000									
Cash and Cash Equivalents, Beginning of Period				PAGE="$USD(181000000000)".XLS	BRIN="$USD(146000000000)".XLS	183000000	-143000000	210000000									
Cash Flow Supplemental Section				23719000000000		26622000000000	26465000000000	20129000000000									
Change in Cash as Reported, Supplemental				2774000000	89000000	-2992000000		6336000000									
Income Tax Paid, Supplemental				13412000000	157000000												
ZACHRY T WOOD								-4990000000									
Cash and Cash Equivalents, Beginning of Period																	
Department of the Treasury																	
Internal Revenue Service																	
					Q4 2020			Q4  2019									
Calendar Year																	
Due: 04/18/2022																	
					Dec. 31, 2020			Dec. 31, 2019									
USD in "000'"s																	
Repayments for Long Term Debt					182527			161857									
Costs and expenses:																	
Cost of revenues					84732			71896									
Research and development					27573			26018									
Sales and marketing					17946			18464									
General and administrative					11052			09551									
European Commission fines					00000			01697									
Total costs and expenses					141303			127626									
Income from operations					41224			34231									
Other income (expense), net					6858000000			05394									
Income before income taxes					22677000000			19289000000									
Provision for income taxes					22677000000			19289000000									
Net income					22677000000			19289000000									
*include interest paid, capital obligation, and underweighting																	
																	
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)																	
																	
																	
																	
																	
																	
																	
																	
																	
																	
																	
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)																	
*include interest paid, capital obligation, and underweighting																	
																	
Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)																	
Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)																	
																	
																	
																	
																	
																	
																	
																	
		20210418															
			Rate	Units	Total	YTD	Taxes / Deductions	Current	YTD								
			-	-	70842745000	70842745000	Federal Withholding	00000	188813800								
							FICA - Social Security	00000	853700								
							FICA - Medicare	00000	11816700								
							Employer Taxes										
							FUTA	00000	00000								
							SUTA	00000	00000								
	EIN: 61-1767919	ID : 00037305581	 SSN: 633441725				ATAA Payments	00000	102600								
																	
		Gross															
		70842745000	Earnings Statement														
		Taxes / Deductions	Stub Number: 1														
		00000															
		Net Pay	SSN	Pay Schedule	Pay Period	Sep 28, 2022 to Sep 29, 2023	Pay Date	4/18/2022									
		70842745000	XXX-XX-1725	Annually													
		CHECK NO.															
		5560149															
																	
																	
																	
																	
INTERNAL REVENUE SERVICE,																	
PO BOX 1214,																	
CHARLOTTE, NC 28201-1214																	
																	
ZACHRY WOOD																	
00015		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000					
For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions.		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000					
Cat. No. 11320B		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000					
Form 1040 (2021)		76033000000																	
	20642000000	18936000000													
Reported Normalized and Operating Income/Expense Supplemental Section																	
Total Revenue as Reported, Supplemental		257637000000	75325000000	65118000000	61880000000	55314000000	56898000000	46173000000	38297000000	41159000000	46075000000	40499000000					
Total Operating Profit/Loss as Reported, Supplemental		78714000000	21885000000	21031000000	19361000000	16437000000	15651000000	11213000000	6383000000	7977000000	9266000000	9177000000					
Reported Effective Tax Rate		00000	00000	00000	00000	00000		00000	00000	00000		00000					
Reported Normalized Income										6836000000							
Reported Normalized Operating Profit										7977000000							
Other Adjustments to Net Income Available to Common Stockholders																	
Discontinued Operations																	
Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010					
Basic EPS from Continuing Operations		00114	00031	00028	00028	00027	00022	00017	00010	00010	00015	00010					
Basic EPS from Discontinued Operations																	
Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010					
Diluted EPS from Continuing Operations		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010					
Diluted EPS from Discontinued Operations																	
Basic Weighted Average Shares Outstanding		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000					
Diluted Weighted Average Shares Outstanding		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000					
Reported Normalized Diluted EPS										00010							
Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010		00001			
Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010					
Basic WASO		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000					
Diluted WASO		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000					
Fiscal year end September 28th., 2022. | USD																	
																	
																	
																	
																	
																	
			Date of this notice: 44658Employer Identification Number: 88-1656496Form: SS-4We assigned youPlease6.35-Total Year to DateLedger balanceDateLedger balance																																			
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						Skip to content
Search or jump to…
Pull requests
Issues
Codespaces
Marketplace
Explore

@zakwarlord7 
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.
zakwarlord7
/
clerk.yml
Public
generated from zakwarlord7/ZachryTylerWood-vscodes
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
Settings
Create codeql.yml
 paradice
@zakwarlord7
zakwarlord7 committed 14 minutes ago 
1 parent dc1e670 commit cf493c9c141137011b334236758ef3a9f28990fe
Showing 1 changed file with 527 additions and 0 deletions.
 527  
.github/workflows/codeql.yml
@@ -0,0 +1,527 @@
# For most projects, this workflow file will not need changing; you simply need
# to commit it to your repository.
#
# You may wish to alter this file to override the set of languages analyzed,
# or to provide custom queries or build logic.
#
# ******** NOTE ********
# We have attempted to detect the languages in your repository. Please check
# the `language` matrix defined below to confirm you have the correct set of
# supported CodeQL languages.
#
name: "CodeQL"

on:
  push:
    branches: [ "paradice", Paradise ]
  pull_request:
    # The branches below must be a subset of the branches above
    branches: [ "paradice" ]
  schedule:
    - cron: '30 23 * * 6'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    strategy:
      fail-fast: false
      matrix:
        language: [  ]
        # CodeQL supports [ 'cpp', 'csharp', 'go', 'java', 'javascript', 'python', 'ruby' ]
        # Learn more about CodeQL language support at https://aka.ms/codeql-docs/language-support

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    # Initializes the CodeQL tools for scanning.
    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: ${{ matrix.language }}
        # If you wish to specify custom queries, you can do so here or in a config file.
        # By default, queries listed here will override any specified in a config file.
        # Prefix the list here with "+" to use these queries and those in the config file.

        # Details on CodeQL's query packs refer to : https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning#using-queries-in-ql-packs
        # queries: security-extended,security-and-quality


    # Autobuild attempts to build any compiled languages  (C/C++, C#, Go, or Java).
    # If this step fails, then you should remove it and run the build manually (see below)
    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    # ℹ️ Command-line programs to run using the OS shell.
    # 📚 See https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsrun

    #   If the Autobuild fails above, remove it and uncomment the following three lines.
    #   modify them (or add more) to build your code if your project, please refer to the EXAMPLE below for guidance.

    # - run: |
    #   echo "Run, Build Application using script"
    #   ./location_of_script_within_repo/buildscript.sh

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
      with:
        category: "/language:${{matrix.language}}"
From 05e431ba5d6202398ecba25cf79a7bb064e00903 Mon Sep 17 00:00:00 2001
From: "ZACHRY T WOODzachryiixixiiwood@gmail.com"
 <109656750+zakwarlord7@users.noreply.github.com>
Date: Fri, 18 Nov 2022 23:47:33 -0600
Subject: [PATCH] Pat

---
 README.md | 209 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 209 insertions(+)

diff --git a/README.md b/README.md
index 77d6fa9..acad3a1 100644
--- a/README.md
+++ b/README.md
@@ -78,3 +78,212 @@ deleted file mode 100644
 index a3cda30..0000000                                                                                                        
 #NAME?                                                                                                        
 +++ /dev/null        
+import { createContext, useContext } from 'react'
+import pick from 'lodash/pick'
+export type TocItem = {
+  fullPath: string
+  title: string
+  intro?: string
+  childTocItems?: Array<{
+    fullPath: string
+    title: string
+  }>
+}
+export type FeaturedLink = {
+  title: string
+  href: string
+  intro?: string
+  authors?: Array<string>
+  hideIntro?: boolean
+  date?: string
+  fullTitle?: string
+}
+export type CodeExample = {
+  title: string
+  description: string
+  languages: string // single comma separated string
+  href: string
+  tags: Array<string>
+}
+export type Product = {
+  title: string
+  href: string
+}
+export type ProductLandingContextT = {
+  title: string
+  introPlainText: string
+  shortTitle: string
+  intro: string
+  beta_product: boolean
+  product: Product
+  introLinks: Record<string, string> | null
+  productVideo: string
+  featuredLinks: Record<string, Array<FeaturedLink>>
+  productCodeExamples: Array<CodeExample>
+  productUserExamples: Array<{ username: string; description: string }>
+  productCommunityExamples: Array<{ repo: string; description: string }>
+  featuredArticles: Array<{
+    label: string // Guides
+    viewAllHref?: string // If provided, adds a "View All ->" to the header
+    viewAllTitleText?: string // Adds 'title' attribute text for the "View All" href
+    articles: Array<FeaturedLink>
+  }>
+  changelogUrl?: string
+  whatsNewChangelog?: Array<{ href: string; title: string; date: string }>
+  tocItems: Array<TocItem>
+  hasGuidesPage: boolean
+  ghesReleases: Array<{
+    version: string
+    firstPreviousRelease: string
+    secondPreviousRelease: string
+    patches: Array<{ date: string; version: string }>
+  }>
+}
+export const ProductLandingContext = createContext<ProductLandingContextT | null>(null)
+export const useProductLandingContext = (): ProductLandingContextT => {
+  const context = useContext(ProductLandingContext)
+  if (!context) {
+    throw new Error(
+      '"useProductLandingContext" may only be used inside "ProductLandingContext.Provider"'
+    )
+  }
+  return context
+}
+export const getFeaturedLinksFromReq = (req: any): Record<string, Array<FeaturedLink>> => {
+  return Object.fromEntries(
+    Object.entries(req.context.featuredLinks || {}).map(([key, entries]) => {
+      return [
+        key,
+        ((entries as Array<any>) || []).map((entry: any) => ({
+          href: entry.href,
+          title: entry.title,
+          intro: entry.intro || null,
+          authors: entry.page?.authors || [],
+          fullTitle: entry.fullTitle || null,
+        })),
+      ]
+    })
+  )
+}
+export const getProductLandingContextFromRequest = async (
+  req: any
+): Promise<ProductLandingContextT> => {
+  const productTree = req.context.currentProductTree
+  const page = req.context.page
+  const hasGuidesPage = (page.children || []).includes('/guides')
+  const productVideo = page.product_video
+    ? await page.renderProp('product_video', req.context, { textOnly: true })
+    : ''
+  return {
+    ...pick(page, ['title', 'shortTitle', 'introPlainText', 'beta_product', 'intro']),
+    productVideo,
+    hasGuidesPage,
+    product: {
+      href: productTree.href,
+      title: productTree.page.shortTitle || productTree.page.title,
+    },
+    whatsNewChangelog: req.context.whatsNewChangelog || [],
+    changelogUrl: req.context.changelogUrl || [],
+    productCodeExamples: req.context.productCodeExamples || [],
+    productCommunityExamples: req.context.productCommunityExamples || [],
+    ghesReleases: req.context.ghesReleases || [],
+    productUserExamples: (req.context.productUserExamples || []).map(
+      ({ user, description }: any) => ({
+        username: user,
+        description,
+      })
+    ),
+    introLinks: page.introLinks || null,
+    featuredLinks: getFeaturedLinksFromReq(req),
+    tocItems: req.context.tocItems || [],
+
+    featuredArticles: Object.entries(req.context.featuredLinks || [])
+      .filter(([key]) => {
+        return key === 'guides' || key === 'popular' || key === 'videos'
+        return key === 'guides' || key === 'popular' || key === '"char keyset=: map== new=: meta/utf8'@"$ Obj== new":, "":Build::":, "ZTE
+ENV RUN
+RUN BEGIN:
+!#/User/bin/Bash
+GLOW4
+test'@travis@ci.yml'
+:run-on :Stack-Overflow.yml #2282
+!#/usr/bin/Bash,yml'@bitore.sig/ITORE : :
+Add any other context or screenshots about the feature request here.**
+}, "eslint : Supra/rendeerer.yml": { ".{pkg.js,rb.mn, package-lock.json,$:RAKEFILE.U.I.mkdir=:
+src/code.dist/.dir'@sun.java.org/install/dl/installer/WIZARD.RUNEETIME.ENVIROMENT'@https:/java.sun.org/WIZARD
+::i,tsx}": "eslint --cache --fix", ".{js,mjs,scss,ts,tsx,yml,yaml}": "prettier --write" }, "type": "module"}SIGNATURE Time Zone:
+Eastern Central Mountain Pacific
+Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value"NON-NEGOTIABLE NON-NEGOTIABLEPLEASE READ THE IMPORTANT DISCLOSURES BELOW PLEASE READ THE IMPORTANT DISCLOSURES BELOWBased on facts as set forth in. Based on facts as set forth in. 6551 6550The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above.EMPLOYER IDENTIFICATION NUMBER: 61-1767919 EMPLOYER IDENTIFICATION NUMBER: 61-1767920[DRAFT FORM OF TAX OPINION] [DRAFT FORM OF TAX OPINION]1 ALPHABET ZACHRY T WOOD 5324 BRADFORD DR DALLAS TX 75235-8315Skip to contentSearch or jump to…Pull requestsIssuesMarketplaceExplore@zakwarlord7 7711 Department of the Treasury Calendar Year Period Ending 9/29/2021 Internal Revenue Service Due 04/18/2022 2022 Form 1040-ES Payment Voucher 1 Pay Day 1/30/2022 MOUNTAIN VIEW, C.A., 94043 Taxable Marital Status : Exemptions/Allowances : Federal : TX : 28 rate units this period year to date Other Benefits and ZACHRY T Current assets: 0 Information WOOD Cash and cash equivalents 26465 18498 0 Total Work Hrs Marketable securities 110229 101177 0 Important Notes DALLAS Total cash, cash equivalents, and marketable securities 136694 119675 0 COMPANY PH/Y: 650-253-0000 0 Accounts receivable, net 30930 25326 0 BASIS OF PAY : BASIC/DILUTED EPS Income taxes receivable, net 454 2166 0 Inventory 728 999 0 Pto Balance Other current assets 5490 4412 0 Total current assets 174296 152578 0 Non-marketable investments 20703 13078 0 70842743866 Deferred income taxes 1084 721 0 Property and equipment, net 84749 73646 0 ) $ in Millions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 Dec. 31, 2018 0 SEC Schedule, 12-09, Movement in Valuation Allowances and Reserves [Roll Forward] 0 Revenues (Narrative) (Details) - USD ($) $ in Billions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 0 Revenue from Contract with Customer [Abstract] 0 Deferred revenue 2.3 0 Revenues recognized 1.8 0 Transaction price allocated to remaining performance obligations 29.8 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2021-01-01 0 Convertible preferred stock, shares authorized (in shares) 100000000 100000000 0 Convertible preferred stock, shares issued (in shares) 0 0 0 Convertible preferred stock, shares outstanding (in shares) 0 0 0 Schedule II: Valuation and Qualifying Accounts (Details) - Allowance for doubtful accounts and sales credits - USD ($) $ in Millions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 Dec. 31, 2018 0 SEC Schedule, 12-09, Movement in Valuation Allowances and Reserves [Roll Forward] 0 Revenues (Narrative) (Details) - USD ($) $ in Billions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 0 Revenue from Contract with Customer [Abstract] 0 Deferred revenue 2.3 0 Revenues recognized 1.8 0 Transaction price allocated to remaining performance obligations 29.8 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2021-01-01 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction [Line Items] 0 Expected timing of revenue recognition 24 months 0 Expected timing of revenue recognition, percent 0.5 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2023-01-01 0 Expected timing of revenue recognition 24 months 0 Expected timing of revenue recognition, percent 0.5 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2023-01-01 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction [Line Items] 0 Expected timing of revenue recognition 0 Expected timing of revenue recognition, percent 0.5 0 Information about Segments and Geographic Areas (Long-Lived Assets by Geographic Area) (Details) - USD ($) $ in Millions Dec. 31, 2020 Dec. 31, 2019 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 96960 84587 0 Expected timing of revenue recognition, percent 0.5 0 Information about Segments and Geographic Areas (Long-Lived Assets by Geographic Area) (Details) - USD ($) $ in Millions Dec. 31, 2020 Dec. 31, 2019 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 96960 84587 0 United States 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 69315 63102 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 69315 63102 0 International 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 27645 21485 0 2016 2017 2018 2019 2020 2021 TTM 2.23418E+11 2.42061E+11 2.25382E+11 3.27223E+11 2.86256E+11 3.54636E+11 3.54636E+11 45881000000 60597000000 57418000000 61078000000 63401000000 69478000000 69478000000 3143000000 3770000000 4415000000 4743000000 5474000000 6052000000 6052000000 Net Investment Income, Revenue 9531000000 13081000000 10565000000 17214000000 14484000000 8664000000 -14777000000 81847000000 48838000000 86007000000 86007000000 Realized Gain/Loss on Investments, Revenue 472000000 184000000 72000000 10000000 7553000000 1410000000 -22155000000 71123000000 40905000000 77576000000 77576000000 Gains/Loss on Derivatives, Revenue 1963000000 2608000000 506000000 974000000 751000000 718000000 -300000000 1484000000 -159000000 966000000 966000000 Interest Income, Revenue 6106000000 6408000000 6484000000 6867000000 6180000000 6536000000 7678000000 9240000000 8092000000 7465000000 7465000000 Other Investment Income, Revenue 990000000 3881000000 3503000000 9363000000 Rental Income, Revenue 2553000000 2452000000 5732000000 5856000000 5209000000 5988000000 5988000000 Other Revenue 1.18387E+11 1.32385E+11 1.42881E+11 1.52435E+11 1.57357E+11 1.66578E+11 1.72594E+11 1.73699E+11 1.63334E+11 1.87111E+11 1.87111E+11 Total Expenses -1.40227E+11 -1.53354E+11 -1.66594E+11 -1.75997E+11 -1.89751E+11 -2.18223E+11 -2.21381E+11 -2.24527E+11 -2.30563E+11 -2.4295E+11 -2.4295E+11 Benefits,Claims and Loss Adjustment Expense, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -45605000000 -49442000000 -49763000000 -55971000000 -55971000000 Policyholder Future Benefits and Claims, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -45605000000 -49442000000 -49763000000 -55971000000 -55971000000 Other Underwriting Expenses -7693000000 -7248000000 -6998000000 -7517000000 -7713000000 -9321000000 -9793000000 -11200000000 -12798000000 -12569000000 -12569000000 Selling, General and Administrative Expenses -11870000000 -13282000000 -13721000000 -15309000000 -19308000000 -20644000000 -21917000000 -23229000000 -23329000000 -23044000000 -23044000000 Rent Expense -1335000000 -1455000000 -4061000000 -4003000000 -3520000000 -4201000000 -4201000000 Selling and Marketing Expenses -11870000000 -13282000000 -13721000000 -15309000000 -17973000000 -19189000000 -17856000000 -19226000000 -19809000000 -18843000000 -18843000000 Other Income/Expenses -92693000000 -1.03676E+11 -1.11009E+11 -1.17594E+11 -1.24061E+11 -1.32377E+11 -1.37664E+11 -1.37775E+11 -1.30645E+11 -1.48189E+11 -1.48189E+11 Total Net Finance Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Net Interest Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Interest Expense Net of Capitalized Interest -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Income from Associates, Joint Ventures and Other Participating Interests -26000000 -122000000 1109000000 3014000000 -2167000000 1176000000 726000000 995000000 995000000 Irregular Income/Expenses -382000000 -96000000 -10671000000 . . Impairment/Write Off/Write Down of Capital Assets -382000000 -96000000 -10671000000 . . Pretax Income 22236000000 28796000000 28105000000 34946000000 33667000000 23838000000 4001000000 1.02696E+11 55693000000 1.11686E+11 1.11686E+11 Provision for Income Tax -6924000000 -8951000000 -7935000000 -10532000000 -9240000000 21515000000 321000000 -20904000000 -12440000000 -20879000000 -20879000000 Net Income from Continuing Operations 15312000000 19845000000 20170000000 24414000000 24427000000 45353000000 4322000000 81792000000 43253000000 90807000000 90807000000 Net Income after Extraordinary Items and Discontinued Operations 15312000000 19845000000 20170000000 24414000000 24427000000 45353000000 4322000000 81792000000 43253000000 90807000000 90807000000 Non-Controlling/Minority Interests -488000000 -369000000 -298000000 -331000000 -353000000 -413000000 -301000000 -375000000 -732000000 -1012000000 -1012000000 Net Income after Non-Controlling/Minority Interests 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 4021000000 81417000000 42521000000 89795000000 89795000000 Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 4021000000 81417000000 42521000000 89795000000 89795000000 Diluted Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 4021000000 81417000000 42521000000 89795000000 89795000000 Income Statement Supplemental Section Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental 1.62463E+11 1.8215E+11 1.94699E+11 2.10943E+11 2.15114E+11 2.39933E+11 2.47837E+11 2.54616E+11 2.4551E+11 2.76094E+11 2.76094E+11 Reported Effective Tax Rate 0.16 0.14 0.07 -0.08 0.2 0.22 0.19 0.19 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 27645 21485 0 2016 2017 2018 2019 2020 2021 TTM 2.23418E+11 2.42061E+11 2.25382E+11 3.27223E+11 2.86256E+11 3.54636E+11 3.54636E+11 45881000000 60597000000 57418000000 61078000000 63401000000 69478000000 69478000000 3143000000 3770000000 4415000000 4743000000 5474000000 6052000000 6052000000 Net Investment Income, Revenue 9531000000 13081000000 10565000000 17214000000 14484000000 8664000000 -14777000000 81847000 000 48838000000 86007000000 86007000000 Realized Gain/Loss on Investments, Revenue 472000000 184000000 72000000 10000000 7553000000 1410000000 -2215500 0000 71123000000 40905000000 77576000000 77576000000 Gains/Loss on Derivatives, Revenue 1963000000 2608000000 506000000 974000000 751000000 718000000 -300000000 14 84000000 -159000000 966000000 966000000 Interest Income, Revenue 6106000000 6408000000 6484000000 6867000000 6180000000 6536000000 7678000000 92400000 00 8092000000 7465000000 7465000000 Other Investment Income, Revenue 990000000 3881000000 3503000000 9363000000 Rental Income, Revenue 2553000000 2452000000 5732000000 5856000000 5209000000 5988000000 59 88000000 Other Revenue 1.18387E+11 1.32385E+11 1.42881E+11 1.52435E+11 1.57357E+11 1.66578E+11 1.72594E+11 1.73699E+11 1.63334E+11 1.87111E+11 1.87111E+11 Total Expenses -1.40227E+11 -1.53354E+11 -1.66594E+11 -1.75997E+11 -1.89751E+11 -2.18223E+11 -2.21381E+11 -2.24527E+11 -2.30563 E+11 -2.4295E+11 -2.4295E+11 Benefits,Claims and Loss Adjustment Expense, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -45605000000 -49442000000 -49763000000 -55971000000 -55971000000 Policyholder Future Benefits and Claims, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -4560500 0000 -49442000000 -49763000000 -55971000000 -55971000000 Other Underwriting Expenses -7693000000 -7248000000 -6998000000 -7517000000 -7713000000 -9321000000 -9793000000 -1120000 0000 -12798000000 -12569000000 -12569000000 Selling, General and Administrative Expenses -11870000000 -13282000000 -13721000000 -15309000000 -19308000000 -20644000000 -21917000000 -23229000000 -23329000000 -23044000000 -23044000000 Rent Expense -1335000000 -1455000000 -4061000000 -4003000000 -3520000000 -4201000000 -4201000000 Selling and Marketing Expenses -11870000000 -13282000000 -13721000000 -15309000000 -17973000000 -19189000000 -17856000000 -19226000000 -19809000000 -18843000000 -18843000000 Other Income/Expenses -92693000000 -1.03676E+11 -1.11009E+11 -1.17594E+11 -1.24061E+11 -1.32377E+11 -1.37664E+11 -1.37775E+11 -1.30645E+11 -1.48189E+11 -1.48189E+11 Total Net Finance Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Net Interest Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Interest Expense Net of Capitalized Interest -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Income f rom Associates, Joint Ventures and Other Participating Interests -26000000 -122000000 1109000000 3014000000 -2167000000 1176000000 726000000 995000000 995000000 Irregular Income/Expenses -382000000 -96000000 -10671000000 . . Impairment/Write Off/Write Down of Capital Assets -382000000 -96000000 -10671000000 . . Pret ax Income 22236000000 28796000000 28105000000 34946000000 33667000000 23838000000 4001000000 1.02696E+11 55693000 000 1.11686E+11 1.11686E+11 Provision for Income Tax -6924000000 -8951000000 -7935000000 -10532000000 -9240000000 21515000000 321000000 -2090400 0000 -12440000000 -20879000000 -20879000000 Net Income from Continuing Operations 15312000000 19845000000 20170000000 24414000000 24427000000 45353000000 4322000000 81 792000000 43253000000 90807000000 90807000000 Net Income after Extraordinary Items and Discontinued Operations 15312000000 19845000000 20170000000 24414000000 24427000 000 45353000000 4322000000 81792000000 43253000000 90807000000 90807000000 Non-Controlling/Minority Interests -488000000 -369000000 -298000000 -331000000 -353000000 -413000000 -301000000 -3 75000000 -732000000 -1012000000 -1012000000 Net Income after Non-Controlling/Minority Interests 14824000000 19476000000 19872000000 24083000000 24074000000 44940000 000 4021000000 81417000000 42521000000 89795000000 89795000000 Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 40210000 00 81417000000 42521000000 89795000000 89795000000 Diluted Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000 000 4021000000 81417000000 42521000000 89795000000 89795000000 Income Statement Supplemental Section Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental 1.62463E+11 1.8215E+11 1.94699E+11 2.10943E+11 2.15114E+11 2.39933E+11 2.47837E +11 2.54616E+11 2.4551E+11 2.76094E+11 2.76094E+11 Reported Effective Tax Rate 0.16 0.14 0.07 -0.08 0.2 0.22 0.19 0.19 Basic EPS 8977 11850 12092 14656 14645 27326 2446 49828 26668 59460 59460 Basic EPS from Continuing Operations 8977 11850 12092 14656 14645 27326 2446 49828 26668 59460 59460 Diluted EPS 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Diluted EPS from Continuing Operations 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Basic Weighted Average Shares Outstanding 1651294 1643613 1643456 1643183 1643826 1644615 1643795 1633946 1594469 1510180 1510180 Diluted Weighted Average Shares Outstanding 1651549 1643613 1644215 1643183 1643826 1644615 1645008 1639821 1622889 1533284 1533284 Basic EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Diluted EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Basic WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 2391702304 2265268867 2265268867 Diluted WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 2391702304 2265268867 2265268867 Basic EPS from Continuing Operations 8977 11850 12092 14656 14645 27326 2446 49828 26668 59460 59460 Diluted EPS 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Diluted EPS from Continuing Operations 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Basic Weighted Average Shares Outstanding 1651294 1643613 1643456 1643183 1643826 1644615 1643795 1633946 1594469 1510180 1510180 Diluted Weighted Average Shares Outstanding 1651549 1643613 1644215 1643183 1643826 1644615 1645008 1639821 1622889 1533284 1533284 Basic EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Diluted EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Basic WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 23917023 04 2265268867 2265268867 Diluted WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 23917023 04 2265268867 2265268867 Fiscal year ends in Dec 31 | USD total GOOGL_income-statement_Quarterly_As_Originally_Reported Q3 2019 Q4 2019 Q1 2020 Q2 2020 Q3 2020 Q4 2020 Q1 2021 Q2 2021 Q3 2021 Q4 2021 TTM Gross Profit 22931000000 25055000000 22177000000 19744000000 25056000000 30818000000 31211000000 35653000000 37497000000 42337000000 1.46698E+11 Total Revenue 40499000000 46075000000 41159000000 38297000000 46173000000 56898000000 55314000000 61880000000 65118000000 75325000000 2.57637E+11 Business Revenue 34071000000 64133000000 41159000000 38297000000 46173000000 56898000000 55314000000 61880000000 65118000000 75325000000 2.57637E+11 Other Revenue 6428000000 Cost of Revenue -17568000000 -21020000000 -18982000000 -18553000000 -21117000000 -26080000000 -24103000000 -26227000000 -27621000000 -32988000000 -1.10939E+11 Cost of Goods and Services -18982000000 -1.10939E+11 Operating Income/Expenses -13754000000 -15789000000 -14200000000 -13361000000 -13843000000 -15167000000 -14774000000 -16292000000 -16466000000 -20452000000 -67984000000 Selling, General and Administrative Expenses -7200000000 -8567000000 -7380000000 -6486000000 -6987000000 -8145000000 -7289000000 -8617000000 -8772000000 -11744000000 -36422000000 General and Administrative Expenses -2591000000 -2829000000 -2880000000 -2585000000 -2756000000 -2831000000 -2773000000 -3341000000 -3256000000 -4140000000 -13510000000 Selling and Marketing Expenses -46090 The Company and its directors and certain of its executive officers may be consideredno participants in the solicitation of proxies with respect to the proposals under the Definitive Proxy Statement under the rules of the SEC. Additional information regarding the participants in the proxy solicitations and a description of their direct and indirect interests, by security holdings or otherwise, also will be included in the Definitive Proxy Statement and other relevant materials to be filed with the SEC when they become available. . 9246754678763 3/6/2022 at 6:37 PM Q4 2021 Q3 2021 Q2 2021 Q1 2021 Q4 2020  This Product Contains Sensitive Taxpayer Data   Request Date: 08-02-2022  Response Date: 08-02-2022  Tracking Number: 102398244811  Account Transcript   FORM NUMBER: 1040 TAX PERIOD: Dec. 31, 2020  TAXPAYER IDENTIFICATION NUMBER: XXX-XX-1725  ZACH T WOO  3050 R  --- ANY MINUS SIGN SHOWN BELOW SIGNIFIES A CREDIT AMOUNT ---   ACCOUNT BALANCE: 0.00  ACCRUED INTEREST: 0.00 AS OF: Mar. 28, 2022  ACCRUED PENALTY: 0.00 AS OF: Mar. 28, 2022  ACCOUNT BALANCE  PLUS ACCRUALS  (this is not a  payoff amount): 0.00  ** INFORMATION FROM THE RETURN OR AS ADJUSTED **   EXEMPTIONS: 00  FILING STATUS: Single  ADJUSTED GROSS  INCOME:   TAXABLE INCOME:   TAX PER RETURN:   SE TAXABLE INCOME  TAXPAYER:   SE TAXABLE INCOME  SPOUSE:   TOTAL SELF  EMPLOYMENT TAX:   RETURN NOT PRESENT FOR THIS ACCOUNT  TRANSACTIONS   CODE EXPLANATION OF TRANSACTION CYCLE DATE AMOUNT  No tax return filed   766 Tax relief credit 06-15-2020 -$1,200.00  846 Refund issued 06-05-2020 $1,200.00  290 Additional tax assessed 20202205 06-15-2020 $0.00  76254-999-05099-0  971 Notice issued 06-15-2020 $0.00  766 Tax relief credit 01-18-2021 -$600.00  846 Refund issued 01-06-2021 $600.00  290 Additional tax assessed 20205302 01-18-2021 $0.00  76254-999-05055-0  663 Estimated tax payment 01-05-2021 -$9,000,000.00  662 Removed estimated tax payment 01-05-2021 $9,000,000.00  740 Undelivered refund returned to IRS 01-18-2021 -$600.00  767 Reduced or removed tax relief 01-18-2021 $600.00  credit  971 Notice issued 03-28-2022 $0.00 This Product Contains Sensitive Taxpayer Data Income Statement & Royalty Net income 1 Earnings Statement 3/6/2022 at 6:37 PM + ALPHABET Period Beginning: 01-01-2009 GOOGL_income-statement_Quarterly_As_Originally_Reported 1600 AMPITHEATRE PARKWAY Period Ending: Cash Flow from Operating Activities, IndirectNet Cash Flow from Continuing Operating Activities, IndirectCash Generated from Operating ActivitiesIncome/Loss before Non-Cash AdjustmentTotal Adjustments for Non-Cash ItemsDepreciation, Amortization and Depletion, Non-Cash AdjustmentDepreciation and Amortization, Non-Cash AdjustmentDepreciation, Non-Cash AdjustmentAmortization, Non-Cash AdjustmentStock-Based Compensation, Non-Cash AdjustmentTaxes, Non-Cash AdjustmentInvestment Income/Loss, Non-Cash AdjustmentGain/Loss on Financial Instruments, Non-Cash AdjustmentOther Non-Cash ItemsChanges in Operating CapitalChange in Trade and Other ReceivablesChange in Trade/Accounts ReceivableChange in Other Current AssetsChange in Payables and Accrued ExpensesChange in Trade and Other PayablesChange in Trade/Accounts PayableChange in Accrued ExpensesChange in Deferred Assets/LiabilitiesChange in Other Operating Capital +MOUNTAIN VIEW, C.A., 94043 Pay Date: Change in Prepayments and DepositsCash Flow from Investing ActivitiesCash Flow from Continuing Investing Activities Purchase/Sale and Disposal of Property, Plant and Equipment, NetPurchase of Property, Plant and EquipmentSale and Disposal of Property, Plant and EquipmentPurchase/Sale of Business, NetPurchase/Acquisition of BusinessPurchase/Sale of Investments, NetPurchase of Investments Taxable Marital Status ", Exemptions/Allowances.", Married ZACHRY T. Sale of InvestmentsOther Investing Cash FlowPurchase/Sale of Other Non-Current Assets, NetSales of Other Non-Current AssetsCash Flow from Financing ActivitiesCash Flow from Continuing Financing ActivitiesIssuance of/Payments for Common Stock, NetPayments for Common StockProceeds from Issuance of Common StockIssuance of/Repayments for Debt, NetIssuance of/Repayments for Long Term Debt, NetProceeds from Issuance of Long Term DebtRepayments for Long Term Debt + 5323 Proceeds from Issuance/Exercising of Stock Options/WarrantsOther Financing Cash FlowCash and Cash Equivalents, End of PeriodChange in CashEffect of Exchange Rate ChangesCash and Cash Equivalents, Beginning of PeriodCash Flow Supplemental SectionChange in Cash as Reported, SupplementalIncome Tax Paid, SupplementalZACHRY T WOODCash and Cash Equivalents, Beginning of PeriodDepartment of the TreasuryInternal Revenue Service +Federal: Calendar YearDue: 04/18/2022 DALLAS USD in ""000'""sRepayments for Long Term DebtCosts and expenses:Cost of revenuesResearch and developmentSales and marketingGeneral and administrativeEuropean Commission finesTotal costs and expensesIncome from operationsOther income (expense), netIncome before income taxesProvision for income taxesNet income*include interest paid, capital obligation, and underweighting +TX: NO State Income Tax Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) rate units year to date Benefits and Other Infotmation EPS 112 674,678,000 75698871600 Regular Pto Balance Total Work Hrs Gross Pay 75698871600 Important Notes COMPANY PH Y: 650-253-0000 Statutory BASIS OF PAY: BASIC/DILUTED EPS Federal Income Tax Social Security Tax + YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)*include interest paid, capital obligation, and underweighting +Medicare Tax Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) + Net Pay 70842743866.0000 70842,743,866.0000 CHECKING Net Check 70842743866 1 Earnings Statement ALPHABET Period Beginning: 1600 AMPITHEATRE PARKWAY DR Period Ending: MOUNTAIN VIEW, C.A., 94043 Pay Date: "Taxable Marital Status: + Exemptions/Allowances" Married ZACHRY T. 5323 Federal: DALLAS TX: NO State Income Tax rate units year to date Other Benefits and EPS 112 674,678,000 75698871600 Information Pto Balance Total Work Hrs Gross Pay 75698871600 Important Notes COMPANY PH Y: 650-253-0000 SIGNATURE Statutory BASIS OF PAY: BASIC/DILUTED EPS Federal Income Tax Social Security Tax YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE Medicare Tax Net Pay 70,842,743,866 70,842,743,866 CHECKING Net Check 70842743866 Your federal taxable wages this period are $ Advice number: ALPHABET INCOME 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Pay date: Deposited to the account Of xxxxxxxx6547 "PLEASE READ THE IMPORTANT DISCLOSURES BELOW
+FEDERAL RESERVE MASTER SUPPLIER ACCOUNT 31000053-052101023 633-44-1725 PNC Bank CIF Department (Online Banking) P7-PFSC-04-F 500 First Avenue Pittsburgh, PA 15219-3128 NON-NEGOTIABLE
+
+SIGNATURE Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value" NON-NEGOTIABLE EMPL 00650 ALPHABET ZACHRY T WOOD 5323 BRADFORD DR DALLAS TX 75235-8314 TTM Q4 2021 Q3 2021 Q2 2021 Q1 2021 Q4 2020 Q3 2020 Q2 2020 Gross Profit 1.46698E+11 42337000000 37497000000 35653000000 31211000000 30818000000 25056000000 19744000000 Total Revenue as Reported, Supplemental 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 46173000000 38297000000 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 46173000000 38297000000 Other Revenue 257637118600 Cost of Revenue -1.10939E+11 -32988000000 -27621000000 -26227000000 -24103000000 -26080000000 -21117000000 -18553000000 Cost of Goods and Services -1.10939E+11 -32988000000 -27621000000 -26227000000 -24103000000 -26080000000 -21117000000 -18553000000 Operating Income/Expenses -67984000000 -20452000000 -16466000000 -16292000000 -14774000000 -15167000000 -13843000000 -13361000000 Selling, General and Administrative Expenses -36422000000 -11744000000 -8772000000 -8617000000 -7289000000 -8145000000 -6987000000 -6486000000 General and Administrative Expenses -13510000000 -4140000000 -3256000000 -3341000000 -2773000000 -2831000000 -2756000000 -2585000000 Selling and Marketing Expenses -22912000000 -7604000000 -5516000000 -5276000000 -4516000000 -5314000000 -4231000000 -3901000000 Research and Development Expenses -31562000000 -8708000000 -7694000000 -7675000000 -7485000000 -7022000000 -6856000000 -6875000000 Total Operating Profit/Loss 78714000000 21885000000 21031000000 19361000000 16437000000 15651000000 11213000000 6383000000 Non-Operating Income/Expenses, Total 12020000000 2517000000 2033000000 2624000000 4846000000 3038000000 2146000000 1894000000 Total Net Finance Income/Expense 1153000000 261000000 310000000 313000000 269000000 333000000 412000000 420000000 Net Interest Income/Expense 1153000000 261000000 310000000 313000000 269000000 333000000 412000000 420000000 Interest Expense Net of Capitalized Interest -346000000 -117000000 -77000000 -76000000 -76000000 -53000000 -48000000 -13000000 Interest Income 1499000000 378000000 387000000 389000000 345000000 386000000 460000000 433000000 Net Investment Income 12364000000 2364000000 2207000000 2924000000 4869000000 3530000000 1957000000 1696000000 Gain/Loss on Investments and Other Financial Instruments 12270000000 2478000000 2158000000 2883000000 4751000000 3262000000 2015000000 1842000000 Income from Associates, Joint Ventures and Other Participating Interests 334000000 49000000 188000000 92000000 5000000 355000000 26000000 -54000000 Gain/Loss on Foreign Exchange -240000000 -163000000 -139000000 -51000000 113000000 -87000000 -84000000 -92000000 Irregular Income/Expenses 0 0 0 0 0 Other Irregular Income/Expenses 0 0 0 0 0 Other Income/Expense, Non-Operating -1497000000 -108000000 -484000000 -613000000 -292000000 -825000000 -223000000 -222000000 Pretax Income 90734000000 24402000000 23064000000 21985000000 21283000000 18689000000 13359000000 8277000000 Provision for Income Tax -14701000000 -3760000000 -4128000000 -3460000000 -3353000000 -3462000000 -2112000000 -1318000000 Net Income from Continuing Operations 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Net Income after Extraordinary Items and Discontinued Operations 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Net Income after Non-Controlling/Minority Interests 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Net Income Available to Common Stockholders 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Diluted Net Income Available to Common Stockholders 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Income Statement Supplemental Section Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 46173000000 38297000000 Total Operating Profit/Loss as Reported, Supplemental 78714000000 21885000000 21031000000 19361000000 16437000000 15651000000 11213000000 6383000000 Reported Effective Tax Rate 0.162 0.179 0.157 0.158 0.158 0.159 Reported Normalized Income Reported Normalized Operating Profit Other Adjustments to Net Income Available to Common Stockholders Discontinued Operations Basic EPS 113.88 31.15 28.44 27.69 26.63 22.54 16.55 10.21 Basic EPS from Continuing Operations 113.88 31.12 28.44 27.69 26.63 22.46 16.55 10.21 Basic EPS from Discontinued Operations Diluted EPS 112.2 30.69 27.99 27.26 26.29 22.3 16.4 10.13 Diluted EPS from Continuing Operations 112.2 30.67 27.99 27.26 26.29 22.23 16.4 10.13 Diluted EPS from Discontinued Operations Basic Weighted Average Shares Outstanding 667650000 662664000 665758000 668958000 673220000 675581 24934000000 25539000000 37497000000 31211000000 30818000000 ZACHRY T WOOD Cash and Cash Equivalents, Beginning of Period Department of the Treasury Internal Revenue Service Calendar Year Due: 04/18/2022 USD in "000'"s Repayments for Long Term Debt Costs and expenses: Cost of revenues Research and development Sales and marketing General and administrative European Commission fines Total costs and expenses Income from operations Other income (expense), net Income before income taxes Provision for income taxes Net income *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) INTERNAL REVENUE SERVICE, PO BOX 1214, CHARLOTTE, NC 28201-1214 ZACHRY WOOD 15 For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions. Cat. No. 11320B Form 1040 (2021) Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental Total Operating Profit/Loss as Reported, Supplemental Reported Effective Tax Rate Reported Normalized Income Reported Normalized Operating Profit Other Adjustments to Net Income Available to Common Stockholders Discontinued Operations Basic EPS Basic EPS from Continuing Operations Basic EPS from Discontinued Operations Diluted EPS Diluted EPS from Continuing Operations Diluted EPS from Discontinued Operations Basic Weighted Average Shares Outstanding Diluted Weighted Average Shares Outstanding Reported Normalized Diluted EPS Basic EPS Diluted EPS Basic WASO Diluted WASO Fiscal year end September 28th., 2022. | USD For Paperwork Reduction Act Notice, see the seperate Instructions. important information 2012201320142015ZACHRY.T.5323.DALLAS.Other.Benefits.and Information Pto Balance 9xygchr6$13Earnings Statement 065-0001 ALPHABET Period Beginning: 1600 AMPITHEATRE PARKWAY DRPeriod Ending: MOUNTAIN VIEW, C.A., 94043Pay Date: 2965 Taxable Marital Status: Exemptions/AllowancesMarried BRADFORD DR Federal: TX:NO State Income Tax rateunitsthis periodyear to date $0 1 Alphabet Inc., co. 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Deposited to the account Of: ZACHRY T. WOOD 4720416547 650001 719218914/18/2022 4720416547 transit ABA 15-51\000 575A "
+Business Checking For 24-hour account information, sign on to pnc.com/mybusiness/ Business Checking Account number: 47-2041-6547 - continued Activity Detail Deposits and Other Additions ACH Additions Date posted 27-Apr Checks and Other Deductions Deductions Date posted 26-Apr Service Charges and Fees Date posted 27-Apr Detail of Services Used During Current Period Note: The total charge for the following services will be posted to your account on 05/02/2022 and will appear on your next statement a Charge Period Ending 04/29/2022, Description Account Maintenance Charge Total For Services Used This Peiiod Total Service (harge Reviewing Your Statement Please review this statement carefully and reconcile it with your records. Call the telephone number on the upper right side of the first page of this statement if: you have any questions regarding your account(s); your name or address is incorrect; • you have any questions regarding interest paid to an interest-bearing account. Balancing Your Account Update Your Account Register
+We will investigate your complaint and will correct any error promptly, If we take longer than 10 business days, we will provisionally credit your account for the amount you think is in error, so that you will have use of the money during the time it ekes us to complete our investigation. Member FDIC
+ZACHRY T WOOD Cash and Cash Equivalents, Beginning of Period Department of the Treasury Internal Revenue Service
+Calendar Year Due: 04/18/2022
+USD in "000'"s Repayments for Long Term Debt Costs and expenses: Cost of revenues Research and development Sales and marketing General and administrative European Commission fines Total costs and expenses Income from operations Other income (expense), net Income before income taxes Provision for income taxes Net income
+*include interest paid, capital obligation, and underweighting
+Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)
+Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) *include interest paid, capital obligation, and underweighting
+Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)
+INTERNAL REVENUE SERVICE, PO BOX 1214, CHARLOTTE, NC 28201-1214
+ZACHRY WOOD 15 For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions. Cat. No. 11320B Form 1040 (2021) Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental Total Operating Profit/Loss as Reported, Supplemental Reported Effective Tax Rate Reported Normalized Income Reported Normalized Operating Profit Other Adjustments to Net Income Available to Common Stockholders Discontinued Operations Basic EPS Basic EPS from Continuing Operations Basic EPS from Discontinued Operations Diluted EPS Diluted EPS from Continuing Operations Diluted EPS from Discontinued Operations Basic Weighted Average Shares Outstanding Diluted Weighted Average Shares Outstanding Reported Normalized Diluted EPS Basic EPS Diluted EPS Basic WASO Diluted WASO Fiscal year end September 28th., 2022. | USD
+For Paperwork Reduction Act Notice, see the seperate Instructions.
+important information
+2012201320142015ZACHRY.T.5323.DALLAS.Other.Benefits.and Information Pto Balance 9xygchr6$13Earnings Statement 065-0001 ALPHABET Period Beginning: 1600 AMPITHEATRE PARKWAY DRPeriod Ending: MOUNTAIN VIEW, C.A., 94043Pay Date: 2965 Taxable Marital Status: Exemptions/AllowancesMarried BRADFORD DR Federal: TX:NO State Income Tax rateunitsthis periodyear to date $0 1 Alphabet Inc., co. 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Deposited to the account Of: ZACHRY T. WOOD 4720416547 650001 719218914/18/2022 4720416547 transit ABA 15-51\000 575A " Business Checking For 24-hour account information, sign on to pnc.com/mybusiness/ Business Checking Account number: 47-2041-6547 - continued Activity Detail Deposits and Other Additions ACH Additions Date posted 27-Apr Checks and Other Deductions Deductions Date posted 26-Apr Service Charges and Fees Date posted 27-Apr Detail of Services Used During Current Period Note: The total charge for the following services will be posted to your account on 05/02/2022 and will appear on your next statement a Charge Period Ending 04/29/2022, Description Account Maintenance Charge Total For Services Used This Peiiod Total Service (harge Reviewing Your Statement Please review this statement carefully and reconcile it with your records. Call the telephone number on the upper right side of the first page of this statement if: you have any questions regarding your account(s); your name or address is incorrect; • you have any questions regarding interest paid to an interest-bearing account. Balancing Your Account Update Your Account Register We will investigate your complaint and will correct any error promptly, If we take longer than 10 business days, we will provisionally credit your account for the amount you think is in error, so that you will have use of the money during the time it ekes us to complete our investigation. Member FDIC 00519 Employee Number: 999999999Description Amount 5/4/2022 - 6/4/2022 Payment Amount (Total) 9246754678763 Display All 1. Social Security (Employee + Employer) 26662 2. Medicare (Employee + Employer) 861193422444 Hourly 3. Federal Income Tax 8385561229657 00000 Note: This report is generated based on the payroll data for your reference only. Please contact IRS office for special cases such as late payment, previous overpayment, penalty and others.Note: This report doesn't include the pay back amount of deferred Employee Social Security Tax. Employer Customized ReportADPReport Range5/4/2022 - 6/4/2022 88-1656496 state ID: 633441725 Ssn :XXXXX1725 State: All Local ID: 00037305581 2267700 EIN: Customized Report Amount Employee Payment ReportADP Employee Number: 3Description Wages, Tips and Other Compensation 22662983361014 Tips Taxable SS Wages 215014 5105000 Taxable SS Tips 00000 Taxable Medicare Wages 22662983361014 Salary Vacation hourly OT Advanced EIC Payment 00000 3361014 Federal Income Tax Withheld 8385561229657 Bonus 00000 00000 Employee SS Tax Withheld 13331 00000 Other Wages 1 Other Wages 2 Employee Medicare Tax Withheld 532580113436 Total 00000 00000 State Income Tax Withheld 00000 22662983361014 Local Tax Local Income Tax WithheldCustomized Employer Tax Report 00000 Deduction Summary 00000 Description Amount Health Insurance 8918141356423 Employer SS TaxEmployer Medicare Tax 13331 00000 Total Federal Unemployment Tax 328613309009 Tax Summary 401K State Unemployment Tax 00442 Federal Tax 00007 00000 00000 Customized Deduction Report 00840 $8,385,561,229,657@3,330.90 Health Insurance 00000 Advanced EIC Payment Social Security Tax Medicare Tax State Tax 532580113050 401K 00000 00000 8918141356423 Total 401K 00000 00000 ZACHRY T WOOD Social Security Tax Medicare Tax State Tax 532580113050 SHAREHOLDERS ARE URGED TO READ THE DEFINITIVE PROXY STATEMENT AND ANY OTHER RELEVANT MATERIALS THAT THE COMPANY WILL FILE WITH THE SEC CAREFULLY IN THEIR ENTIRETY WHEN THEY BECOME AVAILABLE. SUCH DOCUMENTS WILL CONTAIN IMPORTANT INFORMATION ABOUT THE COMPANY AND ITS DIRECTORS, OFFICERS AND AFFILIATES. INFORMATION REGARDING THE INTERESTS OF CERTAIN OF THE COMPANY’S DIRECTORS, OFFICERS AND AFFILIATES WILL BE AVAILABLE IN THE DEFINITIVE PROXY STATEMENT. The Definitive Proxy Statement and any other relevant materials that will be filed with the SEC will be available free of charge at the SEC’s website at www.sec.gov. In addition, the Definitive Proxy Statement (when available) and other relevant documents will also be available, without charge, by directing a request by mail to Attn: Investor Relations, Alphabet Inc., 1600 Amphitheatre Parkway, Mountain View, California, 94043 or by contacting investor-relations@abc.xyz. The Definitive Proxy Statement and other relevant documents will also be available on the Company’s Investor Relations website at https://abc.xyz/investor/other/annual-meeting/. The Company and its directors and certain of its executive officers may be consideredno participants in the solicitation of proxies with respect to the proposals under the Definitive Proxy Statement under the rules of the SEC. Additional information regarding the participants in the proxy solicitations and a description of their direct and indirect interests, by security holdings or otherwise, also will be included in the Definitive Proxy Statement and other relevant materials to be filed with the SEC when they become available. . 9246754678763 3/6/2022 at 6:37 PM Q4 2021 Q3 2021 Q2 2021 Q1 2021 Q4 2020 GOOGL_income-statement_Quarterly_As_Originally_Reported 24934000000 25539000000 37497000000 31211000000 30818000000 24934000000 25539000000 21890000000 19289000000 22677000000 Cash Flow from Operating Activities, Indirect 24934000000 25539000000 21890000000 19289000000 22677000000 Net Cash Flow from Continuing Operating Activities, Indirect 20642000000 18936000000 18525000000 17930000000 15227000000 Cash Generated from Operating Activities 6517000000 3797000000 4236000000 2592000000 5748000000 Income/Loss before Non-Cash Adjustment 3439000000 3304000000 2945000000 2753000000 3725000000 Total Adjustments for Non-Cash Items 3439000000 3304000000 2945000000 2753000000 3725000000 Depreciation, Amortization and Depletion, Non-Cash Adjustment 3215000000 3085000000 2730000000 2525000000 3539000000 Depreciation and Amortization, Non-Cash Adjustment 224000000 219000000 215000000 228000000 186000000 Depreciation, Non-Cash Adjustment 3954000000 3874000000 3803000000 3745000000 3223000000 Amortization, Non-Cash Adjustment 1616000000 -1287000000 379000000 1100000000 1670000000 Stock-Based Compensation, Non-Cash Adjustment -2478000000 -2158000000 -2883000000 -4751000000 -3262000000 Taxes, Non-Cash Adjustment -2478000000 -2158000000 -2883000000 -4751000000 -3262000000 Investment Income/Loss, Non-Cash Adjustment -14000000 64000000 -8000000 -255000000 392000000 Gain/Loss on Financial Instruments, Non-Cash Adjustment -2225000000 2806000000 -871000000 -1233000000 1702000000 Other Non-Cash Items -5819000000 -2409000000 -3661000000 2794000000 -5445000000 Changes in Operating Capital -5819000000 -2409000000 -3661000000 2794000000 -5445000000 Change in Trade and Other Receivables -399000000 -1255000000 -199000000 7000000 -738000000 Change in Trade/Accounts Receivable 6994000000 3157000000 4074000000 -4956000000 6938000000 Change in Other Current Assets 1157000000 238000000 -130000000 -982000000 963000000 Change in Payables and Accrued Expenses 1157000000 238000000 -130000000 -982000000 963000000 Change in Trade and Other Payables 5837000000 2919000000 4204000000 -3974000000 5975000000 Change in Trade/Accounts Payable 368000000 272000000 -3000000 137000000 207000000 Change in Accrued Expenses -3369000000 3041000000 -1082000000 785000000 740000000 Change in Deferred Assets/Liabilities Change in Other Operating Capital -11016000000 -10050000000 -9074000000 -5383000000 -7281000000 Change in Prepayments and Deposits -11016000000 -10050000000 -9074000000 -5383000000 -7281000000 Cash Flow from Investing Activities Cash Flow from Continuing Investing Activities -6383000000 -6819000000 -5496000000 -5942000000 -5479000000 -6383000000 -6819000000 -5496000000 -5942000000 -5479000000 Purchase/Sale and Disposal of Property, Plant and Equipment, Net Purchase of Property, Plant and Equipment -385000000 -259000000 -308000000 -1666000000 -370000000 Sale and Disposal of Property, Plant and Equipment -385000000 -259000000 -308000000 -1666000000 -370000000 Purchase/Sale of Business, Net -4348000000 -3360000000 -3293000000 2195000000 -1375000000 Purchase/Acquisition of Business -40860000000 -35153000000 -24949000000 -37072000000 -36955000000 Purchase/Sale of Investments, Net Purchase of Investments 36512000000 31793000000 21656000000 39267000000 35580000000 100000000 388000000 23000000 30000000 -57000000 Sale of Investments Other Investing Cash Flow -15254000000 Purchase/Sale of Other Non-Current Assets, Net -16511000000 -15254000000 -15991000000 -13606000000 -9270000000 Sales of Other Non-Current Assets -16511000000 -12610000000 -15991000000 -13606000000 -9270000000 Cash Flow from Financing Activities -13473000000 -12610000000 -12796000000 -11395000000 -7904000000 Cash Flow from Continuing Financing Activities 13473000000 -12796000000 -11395000000 -7904000000 Issuance of/Payments for Common 343 sec cvxvxvcclpddf wearsStock, Net -42000000 Payments for Common Stock 115000000 -42000000 -1042000000 -37000000 -57000000 Proceeds from Issuance of Common Stock 115000000 6350000000 -1042000000 -37000000 -57000000 Issuance of/Repayments for Debt, Net 6250000000 -6392000000 6699000000 900000000 00000 Issuance of/Repayments for Long Term Debt, Net 6365000000 -2602000000 -7741000000 -937000000 -57000000 Proceeds from Issuance of Long Term Debt Repayments for Long Term Debt 2923000000 -2453000000 -2184000000 -1647000000 Proceeds from Issuance/Exercising of Stock Options/Warrants 00000 300000000 10000000 338000000000 Other Financing Cash Flow Cash and Cash Equivalents, End of Period Change in Cash 20945000000 23719000000 23630000000 26622000000 26465000000 Effect of Exchange Rate Changes 25930000000) 235000000000 -3175000000 300000000 6126000000 Cash and Cash Equivalents, Beginning of Period PAGE="$USD(181000000000)".XLS BRIN="$USD(146000000000)".XLS 183000000 -143000000 210000000 Cash Flow Supplemental Section 23719000000000 26622000000000 26465000000000 20129000000000 Change in Cash as Reported, Supplemental 2774000000 89000000 -2992000000 6336000000 Income Tax Paid, Supplemental 13412000000 157000000 ZACHRY T WOOD -4990000000 Cash and Cash Equivalents, Beginning of Period Department of the Treasury Internal Revenue Service Q4 2020 Q4 2019 Calendar Year Due: 04/18/2022 Dec. 31, 2020 Dec. 31, 2019 USD in "000'"s Repayments for Long Term Debt 182527 161857 Costs and expenses: Cost of revenues 84732 71896 Research and development 27573 26018 Sales and marketing 17946 18464 General and administrative 11052 09551 European Commission fines 00000 01697 Total costs and expenses 141303 127626 Income from operations 41224 34231 Other income (expense), net 6858000000 05394 Income before income taxes 22677000000 19289000000 Provision for income taxes 22677000000 19289000000 Net income 22677000000 19289000000 *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) 20210418 Rate Units Total YTD Taxes / Deductions Current YTD - - 70842745000 70842745000 Federal Withholding 00000 188813800 FICA - Social Security 00000 853700 FICA - Medicare 00000 11816700 Employer Taxes FUTA 00000 00000 SUTA 00000 00000 EIN: 61-1767919 ID : 00037305581 SSN: 633441725 ATAA Payments 00000 102600 Gross 70842745000 Earnings Statement Taxes / Deductions Stub Number: 1 00000 Net Pay SSN Pay Schedule Pay Period Sep 28, 2022 to Sep 29, 2023 Pay Date 4/18/2022 70842745000 XXX-XX-1725 Annually CHECK NUMBER
+20210418 Rate Units Total YTD Taxes / Deductions Current YTD - - 70842745000 70842745000 Federal Withholding 00000 188813800 FICA - Social Security 00000 853700 FICA - Medicare 00000 11816700 Employer Taxes FUTA 00000 00000 SUTA 00000 00000
+																																																																										INTERNAL REVENUE SERVICE,															PO BOX 1214,															CHARLOTTE, NC 28201-1214																														ZACHRY WOOD															00015		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000			For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions.		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000			Cat. No. 11320B		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000			Form 1040 (2021)		76033000000	20642000000	18936000000											Reported Normalized and Operating Income/Expense Supplemental Section															Total Revenue as Reported, Supplemental		257637000000	75325000000	65118000000	61880000000	55314000000	56898000000	46173000000	38297000000	41159000000	46075000000	40499000000			Total Operating Profit/Loss as Reported, Supplemental		78714000000	21885000000	21031000000	19361000000	16437000000	15651000000	11213000000	6383000000	7977000000	9266000000	9177000000			Reported Effective Tax Rate		00000	00000	00000	00000	00000		00000	00000	00000		00000			Reported Normalized Income										6836000000					Reported Normalized Operating Profit										7977000000					Other Adjustments to Net Income Available to Common Stockholders															Discontinued Operations															Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010			Basic EPS from Continuing Operations		00114	00031	00028	00028	00027	00022	00017	00010	00010	00015	00010			Basic EPS from Discontinued Operations															Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010			Diluted EPS from Continuing Operations		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010			Diluted EPS from Discontinued Operations															Basic Weighted Average Shares Outstanding		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000			Diluted Weighted Average Shares Outstanding		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000			Reported Normalized Diluted EPS										00010					Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010		00001	Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010			Basic WASO		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000			Diluted WASO		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000			Fiscal year end September 28th., 2022. | USD															
+For Paperwork Reduction Act Notice, see the seperate Instructions. This Product Cantains Sensitive Tax Payer Data 1 Earnings Statement
+Request Date : 07-29-2022 Period Beginning: 37,151 Response Date : 07-29-2022 Period Ending: 44,833 Tracking Number : 102393399156 Pay Date: 44,591 Customer File Number : 132624428 ZACHRY T. WOOD 5,323 BRADFORD DR important information Wage and Income Transcript SSN Provided : XXX-XX-1725 DALLAS TX 75235-8314 Tax Periood Requested : December, 2020 units year to date Other Benefits and 674678000 75,698,871,600 Information Pto Balance Total Work Hrs Form W-2 Wage and Tax Statement Important Notes Employer : COMPANY PH Y: 650-253-0000 Employer Identification Number (EIN) :XXXXX7919 BASIS OF PAY: BASIC/DILUTED EPS INTU 2700 C Quarterly Report on Form 10-Q, as filed with the Commission on YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 3330.90 PAR SHARE VALUE Employee : Reciepient's Identification Number :xxx-xx-1725 ZACH T WOOD 5222 B on Form 8-K, as filed with the Commission on January 18, 2019). Submission Type : Original document Wages, Tips and Other Compensation : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 5105000.00 510500000 Advice number: 650,001Federal Income Tax Withheld : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1881380.00 188813800 Pay date: 44,669Social Security Wages : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 137700.00 13770000 Social Security Tax Withheld : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 853700 xxxxxxxx6547 transit ABAMedicare Wages and Tips : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 510500000 71,921,891Medicare Tax Withheld : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 118166700 NON-NEGOTIABLE Social Security Tips : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Allocated Tips : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Dependent Care Benefits : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Deffered Compensation : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "Q" Nontaxable Combat Pay : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "W" Employer Contributions tp a Health Savings Account : . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "Y" Defferels under a section 409A nonqualified Deferred Compensation plan : . . . . . . . . . . . . . . . . . . 0 Code "Z" Income under section 409A on a nonqualified Deferred Compensation plan : . . . . . . . . . . . . . . . . . 0 Code "R" Employer's Contribution to MSA : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .' 0 Code "S" Employer's Cotribution to Simple Account : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "T" Expenses Incurred for Qualified Adoptions : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "V" Income from exercise of non-statutory stock options : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "AA" Designated Roth Contributions under a Section 401 (k) Plan : . . . . . . . . . . . . . . . . . . . . 0 Code "BB" Designated Roth Contributions under a Section 403 (b) Plan : . . . . . . . . . . . . . . . . . . . . . 0 Code "DD" Cost of Employer-Sponsored Health Coverage : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Code "EE" Designated ROTH Contributions Under a Governmental Section 457 (b) Plan : . . . . . . . . . . . . . . . . . . . . . Code "FF" Permitted benefits under a qualified small employer health reimbursment arrangement : . . . . . . . . . 0 Code "GG" Income from Qualified Equity Grants Under Section 83 (i) : . . . . . . . . . . . . . . . . . . . . . . $0.00 Code "HH" Aggregate Defferals Under section 83(i) Elections as of the Close of the Calendar Year : . . . . . . . 0 Third Party Sick Pay Indicator : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Unanswered Retirement Plan Indicator : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Unanswered Statutory Employee : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Not Statutory Employee W2 Submission Type : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Original W2 WHC SSN Validation Code : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Correct SSN The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above.
+EMPLOYER IDENTIFICATION NUMBER: 61-1767919 EIN 61-1767919 FEIN 88-1303491
+[DRAFT FORM OF TAX OPINION] ID: SSN: DOB: 37,305,581 633,441,725 34,622
+ALPHABET						Name	Tax Period 	Total	Social Security	Medicare	Withholding	ZACHRY T WOOD						Fed 941 Corporate	Sunday, September 30, 2007	66,987	28,841	6,745	31,400	5323 BRADFORD DR						Fed 941 West Subsidiary	Sunday, September 30, 2007	17,115	7,369	1,723	8,023	DALLAS TX 75235-8314						Fed 941 South Subsidiary	Sunday, September 30, 2007	23,906	10,293	2,407	11,206	ORIGINAL REPORT						Fed 941 East Subsidiary	Sunday, September 30, 2007	11,248	4,843	1,133	5,272	Income, Rents, & Royalty						Fed 941 Corp - Penalty	Sunday, September 30, 2007	27,199	11,710	2,739	12,749	INCOME STATEMENT 						Fed 940 Annual Unemp - Corp	Sunday, September 30, 2007	17,028			
+GOOGL_income-statement_Quarterly_As_Originally_Reported	TTM	Q4 2021	Q3 2021	Q2 2021	Q1 2021	Q4 2020	Q3 2020	Q2 2020	Q1 2020	Q4 2019	Q3 2019
+Gross Profit	146698000000	42337000000	37497000000	35653000000	31211000000	30,818,000,000	25,056,000,000	19,744,000,000	22,177,000,000	25,055,000,000	22,931,000,000	Total Revenue as Reported, Supplemental	257637000000	75325000000	65118000000	61880000000	55314000000	56,898,000,000	46,173,000,000	38,297,000,000	41,159,000,000	46,075,000,000	40,499,000,000		257637000000	75325000000	65118000000	61880000000	55314000000	56,898,000,000	46,173,000,000	38,297,000,000	41,159,000,000	64,133,000,000	34,071,000,000	Other Revenue											6,428,000,000	Cost of Revenue	110939000000	32988000000	27621000000	26227000000	24103000000	-26,080,000,000	-21,117,000,000	-18,553,000,000	-18,982,000,000	-21,020,000,000	-17,568,000,000	Cost of Goods and Services	110939000000	32988000000	27621000000	26227000000	24103000000	-26,080,000,000	-21,117,000,000	-18,553,000,000	-18,982,000,000	-21,020,000,000	-17,568,000,000	Operating Income/Expenses	67984000000	20452000000	16466000000	16292000000	14774000000	-15,167,000,000	-13,843,000,000	-13,361,000,000	-14,200,000,000	-15,789,000,000	-13,754,000,000	Selling, General and Administrative Expenses	36422000000	11744000000	8772000000	8617000000	7289000000	-8,145,000,000	-6,987,000,000	-6,486,000,000	-7,380,000,000	-8,567,000,000	-7,200,000,000	General and Administrative Expenses	13510000000	4140000000	3256000000	3341000000	2773000000	-2,831,000,000	-2,756,000,000	-2,585,000,000	-2,880,000,000	-2,829,000,000	-2,591,000,000	Selling and Marketing Expenses	22912000000	7604000000	5516000000	5276000000	4516000000	-5,314,000,000	-4,231,000,000	-3,901,000,000	-4,500,000,000	-5,738,000,000	-4,609,000,000	Research and Development Expenses	31562000000	8708000000	7694000000	7675000000	7485000000	-7,022,000,000	-6,856,000,000	-6,875,000,000	-6,820,000,000	-7,222,000,000	-6,554,000,000	Total Operating Profit/Loss	78714000000	21885000000	21031000000	19361000000	16437000000	15,651,000,000	11,213,000,000	6,383,000,000	7,977,000,000	9,266,000,000	9,177,000,000	Non-Operating Income/Expenses, Total	12020000000	2517000000	2033000000	2624000000	4846000000	3,038,000,000	2,146,000,000	1,894,000,000	-220,000,000	1,438,000,000	-549,000,000	Total Net Finance Income/Expense	1153000000	261000000	310000000	313000000	269000000	333,000,000	412,000,000	420,000,000	565,000,000	604,000,000	608,000,000	Net Interest Income/Expense	1153000000	261000000	310000000	313000000	269000000	333,000,000	412,000,000	420,000,000	565,000,000	604,000,000	608,000,000
+Interest Expense Net of Capitalized Interest	346000000	117000000	77000000	76000000	76000000	-53,000,000	-48,000,000	-13,000,000	-21,000,000	-17,000,000	-23,000,000	Interest Income	1499000000	378000000	387000000	389000000	345000000	386,000,000	460,000,000	433,000,000	586,000,000	621,000,000	631,000,000	Net Investment Income	12364000000	2364000000	2207000000	2924000000	4869000000	3,530,000,000	1,957,000,000	1,696,000,000	-809,000,000	899,000,000	-1,452,000,000	Gain/Loss on Investments and Other Financial Instruments	12270000000	2478000000	2158000000	2883000000	4751000000	3,262,000,000	2,015,000,000	1,842,000,000	-802,000,000	399,000,000	-1,479,000,000	Income from Associates, Joint Ventures and Other Participating Interests	334000000	49000000	188000000	92000000	5000000	355,000,000	26,000,000	-54,000,000	74,000,000	460,000,000	-14,000,000	Gain/Loss on Foreign Exchange	240000000	163000000	139000000	51000000	113000000	-87,000,000	-84,000,000	-92,000,000	-81,000,000	40,000,000	41,000,000	Irregular Income/Expenses	0	0				0	0	0	0	0	0	Other Irregular Income/Expenses	0	0				0	0	0	0	0	0	Other Income/Expense, Non-Operating	1497000000	108000000	484000000	613000000	292000000	-825,000,000	-223,000,000	-222,000,000	24,000,000	-65,000,000	295,000,000	Pretax Income	90734000000	24402000000	23064000000	21985000000	21283000000	18,689,000,000	13,359,000,000	8,277,000,000	7,757,000,000	10,704,000,000	8,628,000,000	Provision for Income Tax	14701000000	3760000000	4128000000	3460000000	3353000000	-3,462,000,000	-2,112,000,000	-1,318,000,000	-921,000,000	-33,000,000	-1,560,000,000	Net Income from Continuing Operations	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Net Income after Extraordinary Items and Discontinued Operations	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Net Income after Non-Controlling/Minority Interests	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Net Income Available to Common Stockholders	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Diluted Net Income Available to Common Stockholders	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Income Statement Supplemental Section												Reported Normalized and Operating Income/Expense Supplemental Section												Total Revenue as Reported, Supplemental	257637000000	75325000000	65118000000	61880000000	55314000000	56,898,000,000	46,173,000,000	38,297,000,000	41,159,000,000	46,075,000,000	40,499,000,000	Total Operating Profit/Loss as Reported, Supplemental	78714000000	21885000000	21031000000	19361000000	16437000000	15,651,000,000	11,213,000,000	6,383,000,000	7,977,000,000	9,266,000,000	9,177,000,000	Reported Effective Tax Rate	0		0	0	0		0	0	0		0	Reported Normalized Income									6,836,000,000			Reported Normalized Operating Profit									7,977,000,000			Other Adjustments to Net Income Available to Common Stockholders												Discontinued Operations												Basic EPS	333.90	31	28	28	27	23	17	10	10	15	10	Basic EPS from Continuing Operations	114	31	28	28	27	22	17	10	10	15	10	Basic EPS from Discontinued Operations												Diluted EPS	3330.90	31	28	27	26	22	16	10	10	15	10	Diluted EPS from Continuing Operations	3330.90	31	28	27	26	22	16	10	10	15	10	Diluted EPS from Discontinued Operations												Basic Weighted Average Shares Outstanding	667650000	662664000	665758000	668958000	673220000	675,581,000	679,449,000	681,768,000	686,465,000	688,804,000	692,741,000	Diluted Weighted Average Shares Outstanding	677674000	672493000	676519000	679612000	682071000	682,969,000	685,851,000	687,024,000	692,267,000	695,193,000	698,199,000	Reported Normalized Diluted EPS									10			Basic EPS	114	31	28	28	27	23	17	10	10	15	10	Diluted EPS	112	31	28	27	26	22	16	10	10	15	10	Basic WASO	667650000	662664000	665758000	668958000	673220000	675,581,000	679,449,000	681,768,000	686,465,000	688,804,000	692,741,000	Diluted WASO	677674000	672493000	676519000	679612000	682071000	682,969,000	685,851,000	687,024,000	692,267,000	695,193,000	698,199,000	Fiscal year end September 28th., 2022. | USD											
+31622,6:39 PM												Morningstar.com Intraday Fundamental Portfolio View Print Report								Print			
+3/6/2022 at 6:37 PM											Current Value												15,335,150,186,014
+GOOGL_income-statement_Quarterly_As_Originally_Reported		Q4 2021										Cash Flow from Operating Activities, Indirect		24934000000	Q3 2021	Q2 2021	Q1 2021	Q4 2020						Net Cash Flow from Continuing Operating Activities, Indirect		24934000000	25539000000	37497000000	31211000000	30,818,000,000						Cash Generated from Operating Activities		24934000000	25539000000	21890000000	19289000000	22,677,000,000						Income/Loss before Non-Cash Adjustment		20642000000	25539000000	21890000000	19289000000	22,677,000,000						Total Adjustments for Non-Cash Items		6517000000	18936000000	18525000000	17930000000	15,227,000,000						Depreciation, Amortization and Depletion, Non-Cash Adjustment		3439000000	3797000000	4236000000	2592000000	5,748,000,000						Depreciation and Amortization, Non-Cash Adjustment		3439000000	3304000000	2945000000	2753000000	3,725,000,000						Depreciation, Non-Cash Adjustment		3215000000	3304000000	2945000000	2753000000	3,725,000,000						Amortization, Non-Cash Adjustment		224000000	3085000000	2730000000	2525000000	3,539,000,000						Stock-Based Compensation, Non-Cash Adjustment		3954000000	219000000	215000000	228000000	186,000,000						Taxes, Non-Cash Adjustment		1616000000	3874000000	3803000000	3745000000	3,223,000,000						Investment Income/Loss, Non-Cash Adjustment		2478000000	1287000000	379000000	1100000000	1,670,000,000						Gain/Loss on Financial Instruments, Non-Cash Adjustment		2478000000	2158000000	2883000000	4751000000	-3,262,000,000						Other Non-Cash Items		14000000	2158000000	2883000000	4751000000	-3,262,000,000						Changes in Operating Capital		2225000000	64000000	8000000	255000000	392,000,000						Change in Trade and Other Receivables		5819000000	2806000000	871000000	1233000000	1,702,000,000						Change in Trade/Accounts Receivable		5819000000	2409000000	3661000000	2794000000	-5,445,000,000						Change in Other Current Assets		399000000	2409000000	3661000000	2794000000	-5,445,000,000						Change in Payables and Accrued Expenses		6994000000	1255000000	199000000	7000000	-738,000,000						Change in Trade and Other Payables		1157000000	3157000000	4074000000	4956000000	6,938,000,000						Change in Trade/Accounts Payable		1157000000	238000000	130000000	982000000	963,000,000						Change in Accrued Expenses		5837000000	238000000	130000000	982000000	963,000,000						Change in Deferred Assets/Liabilities		368000000	2919000000	4204000000	3974000000	5,975,000,000						Change in Other Operating Capital		3369000000	272000000	3000000	137000000	207,000,000						Change in Prepayments and Deposits			3041000000	1082000000	785000000	740,000,000						Cash Flow from Investing Activities		11016000000										Cash Flow from Continuing Investing Activities		11016000000	10050000000	9074000000	5383000000	-7,281,000,000						Purchase/Sale and Disposal of Property, Plant and Equipment, Net		6383000000	10050000000	9074000000	5383000000	-7,281,000,000						Purchase of Property, Plant and Equipment		6383000000	6819000000	5496000000	5942000000	-5,479,000,000						Sale and Disposal of Property, Plant and Equipment			6819000000	5496000000	5942000000	-5,479,000,000						Purchase/Sale of Business, Net		385000000										Purchase/Acquisition of Business		385000000	259000000	308000000	1666000000	-370,000,000						Purchase/Sale of Investments, Net		4348000000	259000000	308000000	1666000000	-370,000,000						Purchase of Investments		40860000000	3360000000	3293000000	2195000000	-1,375,000,000						Sale of Investments		36512000000	35153000000	24949000000	37072000000	-36,955,000,000						Other Investing Cash Flow		100000000	31793000000	21656000000	39267000000	35,580,000,000						Purchase/Sale of Other Non-Current Assets, Net			388000000	23000000	30000000	-57,000,000						Sales of Other Non-Current Assets												Cash Flow from Financing Activities		16511000000	15254000000									Cash Flow from Continuing Financing Activities		16511000000	15254000000	15991000000	13606000000	-9,270,000,000						Issuance of/Payments for Common Stock, Net		13473000000	12610000000	15991000000	13606000000	-9,270,000,000						Payments for Common Stock		13473000000	12610000000	12796000000	11395000000	-7,904,000,000						Proceeds from Issuance of Common Stock				12796000000	11395000000	-7,904,000,000						Issuance of/Repayments for Debt, Net		115000000	42000000									Issuance of/Repayments for Long Term Debt, Net		115000000	42000000	1042000000	37000000	-57,000,000						Proceeds from Issuance of Long Term Debt		6250000000	6350000000	1042000000	37000000	-57,000,000						Repayments for Long Term Debt		6365000000	6392000000	6699000000	900000000	0						Proceeds from Issuance/Exercising of Stock Options/Warrants		2923000000	2602000000	7741000000	937000000	-57,000,000										2453000000	2184000000	-1,647,000,000					
+Other Financing Cash Flow												Cash and Cash Equivalents, End of Period												Change in Cash		0		300000000	10000000	338,000,000,000						Effect of Exchange Rate Changes		20945000000	23719000000	23630000000	26622000000	26,465,000,000						Cash and Cash Equivalents, Beginning of Period		25930000000	235000000000	3175000000	300000000	6,126,000,000						Cash Flow Supplemental Section		181000000000	146000000000	183000000	143000000	210,000,000						Change in Cash as Reported, Supplemental		23719000000000	23630000000000	26622000000000	26465000000000	20,129,000,000,000						Income Tax Paid, Supplemental		2774000000	89000000	2992000000		6,336,000,000						Cash and Cash Equivalents, Beginning of Period		13412000000	157000000			-4,990,000,000					
+12 Months Ended												_________________________________________________________															Q4 2020			Q4 2019						Income Statement 												USD in "000'"s												Repayments for Long Term Debt			Dec. 31, 2020			Dec. 31, 2019						Costs and expenses:												Cost of revenues			182527			161,857						Research and development												Sales and marketing			84732			71,896						General and administrative			27573			26,018						European Commission fines			17946			18,464						Total costs and expenses			11052			9,551						Income from operations			0			1,697						Other income (expense), net			141303			127,626						Income before income taxes			41224			34,231						Provision for income taxes			6858000000			5,394						Net income			22677000000			19,289,000,000						*include interest paid, capital obligation, and underweighting			22677000000			19,289,000,000									22677000000			19,289,000,000						Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)--												Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)											
+For Paperwork Reduction Act Notice, see the seperate Instructions.												JPMORGAN TRUST III												A/R Aging Summary												As of July 28, 2022												ZACHRY T WOOD		Days over due										Effeective Tax Rate Prescribed by the Secretary of the Treasury.		44591	31 - 60	61 - 90	91 and over						
+TOTAL			 £134,839.00	 Alphabet Inc. 											
+ =USD('"'$'"'-in'-millions)"												 Ann. Rev. Date 	 £43,830.00 	 £43,465.00 	 £43,100.00 	 £42,735.00 	 £42,369.00 							 Revenues 	 £161,857.00 	 £136,819.00 	 £110,855.00 	 £90,272.00 	 £74,989.00 							 Cost of revenues 	-£71,896.00 	-£59,549.00 	-£45,583.00 	-£35,138.00 	-£28,164.00 							 Gross profit 	 £89,961.00 	 £77,270.00 	 £65,272.00 	 £55,134.00 	 £46,825.00 							 Research and development 	-£26,018.00 	-£21,419.00 	-£16,625.00 	-£13,948.00 	-£12,282.00 							 Sales and marketing 	-£18,464.00 	-£16,333.00 	-£12,893.00 	-£10,485.00 	-£9,047.00 							 General and administrative 	-£9,551.00 	-£8,126.00 	-£6,872.00 	-£6,985.00 	-£6,136.00 							 European Commission fines 	-£1,697.00 	-£5,071.00 	-£2,736.00 	 — 	 — 							 Income from operations 	 £34,231.00 	 £26,321.00 	 £26,146.00 	 £23,716.00 	 £19,360.00 							 Interest income 	 £2,427.00 	 £1,878.00 	 £1,312.00 	 £1,220.00 	 £999.00:
+STATE AND LOCAL GOVERNMENT SERIES: S000002965 07/30/2022
+NOTICE UNDER THE PAPERWORK REDUCTION ACT 
+Bureau of the Fiscal Service, 
+Forms Management Officer, Parkersburg, WV 26106-1328.
+FOR USE BY THE BUREAU OF THE FISCAL SERVICE
+E'-Customer ID Processed by /FS Form 4144
+Department of the Treasury | Bureau of the Fiscal Service Revised August 2018 Form Instructions
+Bureau of the Fiscal Service Special Investments Branch
+P.O. Box 396, Room 119 Parkersburg, WV 26102-0396
+Telephone Number: (304) 480-5299
+Fax Number: (304) 480-5277
+Internet Address: https://www.slgs.gov/ 
+E-Mail Address: SLGS@fiscal.treasury.gov Governing Regulations: 31 CFR Part 344 Please add the following information prior to mailing the form: • The name of the organization should be entered in the first paragraph. • If the user does not have an e-mail address, call SIB at 304-480-5299 for more information. • The user should sign and date the form. • If the access administrator or backup administrator also completes a user acknowledgment, both administrators should sign the 4144-5 Application for Internet Access. Regular Mail Address: Courier Service Address: Bureau of the Fiscal Service Special Investments Branch P.O. Box 396, Room 119 Parkersburg, WV 26102-0396 The Special Investments Branch (SIB) will only accept original signatures on this form. SIB will not accept faxed or emailed copies. Tax Periood Requested : December, 2020 Form W-2 Wage and Tax Statement Important Notes on Form 8-K, as filed with the Commission on January 18, 2019).  Request Date : 07-29-2022   Period Beginning: 37151  Response Date : 07-29-2022   Period Ending: 44833  Tracking Number : 102393399156   Pay Date: 44591  Customer File Number : 132624428   ZACHRY T. WOOD  5323 BRADFORD DR          important information Wage and Income TranscriptSSN Provided : XXX-XX-1725 DALLAS TX 75235-8314 dministrative Proceedings Securities & Exchanges (IRS USE ONLY)575A04-07-2022NASDB9999999999\\\DATEPAYEE NAMEPAYEE ADDRESSPAYORPAYOR ADDRESSPAYEE ROUTINGDEBIT/CREDITPAYEE ACCOUNTPAYOR ACCOUNTMASTER ACCOUNTDEPT ROUTING Total Paid by Supplier Demands. 4/7/2021Advances and Reimbursements, Judiciary Automation Fund, The Judiciary 2722 Arroyo Ave Dallas Tx 75219-1910 $22,677,000,000,000.00Based on facts as set forth in.65516550 The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. EMPLOYER IDENTIFICATION NUMBER: 61-1767920[DRAFT FORM OF TAX OPINION]Chase GOOGL_income-statement_Quarterly_As_Originally_ReportedTTMQ4 2022Q3 2022Q2 2022Q1 2022Q4 2021Q3 2021Q2 2021Q3 2021Gross Profit-2178236364-9195472727-16212709091-23229945455-30247181818-37264418182-44281654545-5129889090937497000000Total Revenue as Reported, Supplemental-1286309091-13385163636-25484018182-37582872727-49681727273-61780581818-73879436364-85978290909651180000001957800000-9776581818-21510963636-33245345455-44979727273-56714109091-68448490909-8018287272765118000000Other RevenueCost of Revenue-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Cost of Goods and Services-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Operating Income/Expenses-3640563636-882445454.5187567272746337909097391909091101500272731290814545515666263636-16466000000Selling, General and Administrative Expenses-1552200000-28945454.55149430909130175636364540818182606407272775873272739110581818-8772000000Issuer: THEGeneral and Administrative Expenses-544945454.523200000591345454.511594909091727636364229578181828639272733432072727-3256000000101 EA 600 Coolidge Drive, Suite 300V Selling and Marketing Expenses-1007254545-52145454.55902963636.418580727272813181818376829090947234000005678509091-5516000000EmployerFolsom, CA 95630Research and Development Expenses-2088363636-853500000381363636.416162272732851090909408595454553208181826555681818-7694000000Employeer Identification Number (EIN) :XXXXX17256553Phone number: 888.901.9695Total Operating Profit/Loss-5818800000-10077918182-14337036364-18596154545-22855272727-27114390909-31373509091-3563262727321031000000\Fax number: 888.901.9695Non-Operating Income/Expenses, Total-1369181818-2079000000-2788818182-3498636364-4208454545-4918272727-5628090909-63379090912033000000Website: https://intuit.taxaudit.comTotal Net Finance Income/Expense464490909.1462390909.1460290909.1458190909.1456090909.1453990909.1451890909.1449790909.1310000000ZACHRY T WOODNet Interest Income/Expense464490909.1462390909.1460290909.1458190909.1456090909.1453990909.1451890909.1449790909.1310000000 5222 BRADFORD DR DALLAS TX 752350 ZACHRY T WOOD Interest Expense Net of Capitalized Interest48654545.456990000091145454.55112390909.1133636363.6154881818.2176127272.7197372727.3-77000000 5222 BRADFORD DR Interest Income415836363.6392490909.1369145454.5345800000322454545.5299109090.9275763636.4252418181.8387000000Other Benefits and Earning's Statement DALLAS TX 75235 0Net Investment Income-2096781818-2909109091-3721436364-4533763636-5346090909-6158418182-6970745455-77830727272207000000InformationRegularGain/Loss on Investments and Other Financial Instruments-2243490909-3068572727-3893654545-4718736364-5543818182-6368900000-7193981818-80190636362158000000Pto BalanceOvertime4Other Benefits and Earning's Statement Income from Associates, Joint Ventures and Other Participating Interests99054545.4592609090.9186163636.3679718181.8273272727.2766827272.7360381818.1853936363.64188000000Total Work Hrs Bonus Trainingyear to date37151InformationRegularGain/Loss on Foreign Exchange47654545.4566854545.4586054545.45105254545.5124454545.5143654545.5162854545.5182054545.5-139000000Important Notes Additions $22,756,988,716,000.00 Other Income/Expense, Non-Operating263109090.9367718181.8472327272.7576936363.6681545454.5786154545.5890763636.4995372727.3-484000000Submission Type . . . . . . . . . . . . . . . . . . . . . . . . . . . . Original documentPretax Income-7187981818-12156918182-17125854545-22094790909-27063727273-32032663636-37001600000-4197053636423064000000Wages, Tips and Other Compensation: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$22,756,988,716,000.00 _______________________________________________________________________________________________________________ Provision for Income Tax16952181822565754545343629090943068272735177363636604790000069184363647788972727-4128000000Social Security Wages . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$22,756,988,716,000.00 YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM $22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Reported Effective Tax Rate1.1620.14366666670.13316666670.12266666670.10633333330.086833333330.179Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Reported Normalized IncomeImportant NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Reported Normalized Operating ProfitImportant NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Other Adjustments to Net Income Available to Common StockholdersDiscontinued Operations[DRAFT FORM OF TAX OPINION]Fed 941 CorporateTax Period Ssn:DoB:Basic EPS-8.742909091-14.93854545-21.13418182-27.32981818-33.52545455-39.72109091-45.91672727-52.1123636428.44Fed 941 CorporateSunday, September 30, 2007Basic EPS from Continuing Operations-8.752545455-14.94781818-21.14309091-27.33836364-33.53363636-39.72890909-45.92418182-52.1194545528.44Fed 941 West SubsidiarySunday, September 30, 2007Basic EPS from Discontinued OperationsFed 941 South SubsidiarySunday, September 30, 200763344172534622Diluted EPS-8.505636364-14.599-20.69236364-26.78572727-32.87909091-38.97245455-45.06581818-51.1591818227.99Fed 941 East SubsidiarySunday, September 30, 2007Diluted EPS from Continuing Operations-8.515636364-14.609-20.70236364-26.79572727-32.88909091-38.98245455-45.07581818-51.1691818227.99Diluted EPS from Discontinued OperationsDALLAS, TX 75235 __________________________________________________ SIGNATURE Basic Weighted Average Shares Outstanding694313545.5697258863.6700204181.8703149500706094818.2709040136.4711985454.5714930772.7665758000SignificanceDiluted Weighted Average Shares Outstanding698675981.8701033009.1703390036.4705747063.6708104090.9710461118.2712818145.5715175172.7676519000 Authorized Signature Reported Normalized Diluted EPSZACHRY T WOODCertifying Officer.Basic EPS-8.742909091-14.93854545-21.13418182-27.32981818-33.52545455-39.72109091-45.91672727-52.1123636428.44 Authorized Signature Diluted EPS-8.505636364-14.599-20.69236364-26.78572727-32.87909091-38.97245455-45.06581818-51.1591818227.99Basic WASO694313545.5697258863.6700204181.8703149500706094818.2709040136.4711985454.5714930772.7665758000--Diluted WASO698675981.8701033009.1703390036.4705747063.6708104090.9710461118.2712818145.5715175172.7676519000Taxable Marital Status: Exemptions/AllowancesMarriedFiscal year end September 28th., 2022. | USD31622,6:39 PMrateunitsMorningstar.com Intraday Fundamental Portfolio View Print ReportPrintTX :383/6/2022 at 6:37 PMPayer's Federal Identificantion Number (FIN) :xxxxx7919112.2674678000THE PLEASE READ THE IMPORTANT DISCLOSURES BELOW 101 EAGOOGL_income-statement_Quarterly_As_Originally_ReportedQ4 2022EmployerCash Flow from Operating Activities, Indirect24934000001Q3 2022Q2 2022Q1 2022Q4 2021Q3 2021Reciepient's Social Security Number :xxx-xx-1725Net Cash Flow from Continuing Operating Activities, Indirect352318000003697580000038719800000404638000004220780000025539000000ZACH TCash Generated from Operating Activities196366000001856020000017483800000164074000001533100000025539000000WOOIncome/Loss before Non-Cash Adjustment2135340000021135400000209174000002069940000020481400000255390000005222 BTotal Adjustments for Non-Cash Items203512000002199260000023634000000252754000002691680000018936000000Depreciation, Amortization and Depletion, Non-Cash Adjustment498630000053276000005668900000601020000063515000003797000000Depreciation and Amortization, Non-Cash Adjustment323950000032416000003243700000324580000032479000003304000000ID:Ssn:DoB:Depreciation, Non-Cash Adjustment332910000033760000003422900000346980000035167000003304000000Amortization, Non-Cash Adjustment424160000048486000005455600000606260000066696000003085000000Stock-Based Compensation, Non-Cash Adjustment-1297700000-2050400000-2803100000-3555800000-43085000002190000003730558163344172534622Taxes, Non-Cash Adjustment417770000044862000004794700000510320000054117000003874000000Previous overpaymentInvestment Income/Loss, Non-Cash Adjustment30817000004150000000521830000062866000007354900000-12870000001000Gain/Loss on Financial Instruments, Non-Cash Adjustment-4354700000-4770800000-5186900000-5603000000-6019100000-2158000000Other Non-Cash Items-5340300000-6249200000-7158100000-8067000000-8975900000-2158000000Fed 941 CorporateTax Period TotalSocial SecurityMedicareWithholdingChanges in Operating Capital1068100000155960000020511000002542600000303410000064000000ZACHRY T WOODFed 941 CorporateSunday, September 30, 200725763711860066986.6628841.486745.1831400Change in Trade and Other Receivables2617900000371820000048185000005918800000701910000028060000005323 BRADFORD DRFed 941 West SubsidiarySunday, September 30, 200717115.417369.141723.428022.85Change in Trade/Accounts Receivable-1122700000-527600000675000006626000001257700000-2409000000DALLAS TX 75235-8314Fed 941 South SubsidiarySunday, September 30, 200723906.0910292.92407.2111205.98Change in Other Current Assets-3290700000-3779600000-4268500000-4757400000-5246300000-2409000000Income StatementFed 941 East SubsidiarySunday, September 30, 200711247.644842.741132.575272.33Change in Payables and Accrued Expenses-3298800000-4719000000-6139200000-7559400000-8979600000-1255000000Change in Trade and Other Payables310870000034536000003798500000414340000044883000003157000000Repayments for Long Term DebtDec. 31, 2020Dec. 31, 2019Change in Trade/Accounts Payable-233200000-394000000-554800000-715600000-876400000238000000Costs and expenses:Change in Accrued Expenses-2105200000-3202000000-4298800000-5395600000-6492400000238000000Cost of revenues182527161857Change in Deferred Assets/Liabilities319470000036268000004058900000449100000049231000002919000000Research and developmentChange in Other Operating Capital15539000002255600000295730000036590000004360700000272000000Sales and marketing8473271896Change in Prepayments and Deposits-388000000-891600000-1395200000-18988000003041000000General and administrative2757326018Cash Flow from Investing Activities-11015999999European Commission fines1794618464Cash Flow from Continuing Investing Activities-4919700000-3706000000-2492300000-1278600000-64900000-10050000000Total costs and expenses110529551Purchase/Sale and Disposal of Property, Plant and Equipment, Net-6772900000-6485800000-6198700000-5911600000-5624500000-10050000000Income from operations01697Purchase of Property, Plant and Equipment-5218300000-4949800000-4681300000-4412800000-4144300000-6819000000Other income (expense), net141303127626Sale and Disposal of Property, Plant and Equipment-5040500000-4683100000-4325700000-3968300000-6819000000Income before income taxes4122434231Purchase/Sale of Business, Net-384999999Provision for income taxes68580000005394Purchase/Acquisition of Business-1010700000-1148400000-1286100000-1423800000-1561500000-259000000Net income2267700000019289000000Purchase/Sale of Investments, Net5745000001229400000188430000025392000003194100000-259000000include interest paid, capital obligation, and underweighting2267700000019289000000Purchase of Investments1601890000024471400000329239000004137640000049828900000-3360000000Checking Account: 47-2041-6547Sale of Investments-64179300000-79064600000-93949900000-108835200000-123720500000-35153000000Other Investing Cash Flow492094000005705280000064896200000727396000008058300000031793000000 DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE Purchase/Sale of Other Non-Current Assets, Net-236000000-368800000-501600000-634400000388000000 PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 469-697-4300 __________________________________________________ SIGNATURE Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | Sales of Other Non-Current AssetsCash Flow from Financing Activities-13997000000-12740000000-15254000000Cash Flow from Continuing Financing Activities-9287400000-7674400000-6061400000-4448400000-2835400000-15254000000Issuance of/Payments for Common Stock, Net-10767000000-10026000000-9285000000-8544000000-7803000000-12610000000Payments for Common Stock-18708100000-22862000000-27015900000-31169800000-35323700000-12610000000Proceeds from Issuance of Common Stock-5806333333-3360333333-914333333.3Issuance of/Repayments for Debt, Net-199000000-356000000-42000000Issuance of/Repayments for Long Term Debt, Net-314300000-348200000-382100000-416000000-449900000-42000000Other Benefits andOther Benefits andOther Benefits and Other Benefits and Proceeds from Issuance of Long Term Debt-3407500000-5307600000-7207700000-9107800000-110079000006350000000InformationInformationInformationInformationRepayments for Long Term Debt-117000000-660800000-1204600000-1748400000-2292200000-6392000000Pto BalancePto BalancePto BalancePto BalanceProceeds from Issuance/Exercising of Stock Options/Warrants-2971300000-3400800000-3830300000-4259800000-4689300000-2602000000Total Work HrsTotal Work HrsTotal Work HrsTotal Work Hrs-1288666667-885666666.7-482666666.7Important NotesImportant NotesImportant NotesOther Financing Cash FlowCash and Cash Equivalents, End of PeriodRevenues£161,857.00£136,819.00£110,855.00£90,272.00£74,989.00Change in Cash1-280000000-570000000338000000000)Cost of revenues-£71,896.00-£59,549.00-£45,583.00-£35,138.00-£28,164.00Effect of Exchange Rate Changes284591000002985340000031247700000326420000003403630000023719000000Gross profit£89,961.00£77,270.00£65,272.00£55,134.00£46,825.00Cash and Cash Equivalents, Beginning of Period25930000001235000000000)103846666671503516666719685666667235000000000)Research and development-£26,018.00-£21,419.00-£16,625.00-£13,948.00-£12,282.00Cash Flow Supplemental Section181000000000)-146000000000)110333333.3123833333.3137333333.3-146000000000)Sales and marketing-£18,464.00-£16,333.00-£12,893.00-£10,485.00-£9,047.00Change in Cash as Reported, Supplemental228095000000002237500000000021940500000000215060000000002107150000000023630000000000General and administrative-£9,551.00-£8,126.00-£6,872.00-£6,985.00-£6,136.00Income Tax Paid, Supplemental-5809000000-8692000000-11575000000633600000189000000European Commission fines-£1,697.00-£5,071.00-£2,736.00——Cash and Cash Equivalents, Beginning of Period-13098000000-26353000000-4989999999157000000Income from operations£34,231.00£26,321.00£26,146.00£23,716.00£19,360.00Interest income£2,427.00£1,878.00£1,312.00£1,220.00£999.0013 Months EndedInterest expense-£100.00-£114.00-£109.00-£124.00-£104.00_________________________________________________________Foreign currency exchange gain£103.00-£80.00-£121.00-£475.00-£422.00Q4 2021Q4 2020Q4 2020Gain (loss) on debt securities£149.00£1,190.00-£110.00-£53.00—Income StatementGain (loss) on equity securities,£2,649.00£5,460.00£73.00-£20.00—USD in "000'"sPerformance fees-£326.00————Repayments for Long Term DebtDec. 31, 2021Dec. 31, 2020Dec. 31, 2020Gain(loss)£390.00-£120.00-£156.00-£202.00—Costs and expenses:Other£102.00£378.00£158.00£88.00-£182.00Cost of revenues182528161858182527Other income (expense), net£5,394.00£8,592.00£1,047.00£434.00£291.00Research and developmentIncome before income taxes£39,625.00£34,913.00£27,193.00£24,150.00£19,651.00Sales and marketing847337189784732Provision for income taxes-£3,269.00-£2,880.00-£2,302.00-£1,922.00-£1,621.00General and administrative275742601927573Net income£36,355.00-£32,669.00£25,611.00£22,198.00£18,030.00European Commission fines179471846517946Adjustment Payment to Class CTotal costs and expenses11053955211052Net. Ann. Rev.£36,355.00£32,669.00£25,611.00£22,198.00£18,030.00Income from operations116980Other income (expense), net141304127627141303 DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE Income before income taxes412253423241224 PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 469-697-4300 __________________________________________________ SIGNATURE Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | Provision for income taxes685800000153956858000000Net income226770000011928900000122677000000500 First AvenuePittsburgh, PA 15219-3128NON-NEGOTIABLEIssuer: THE101 EA 600 Coolidge Drive, Suite 300V EmployerFolsom, CA 95630Employeer Identification Number (EIN) :XXXXX17256553Phone number: 888.901.9695ZACH TDR\Fax number: 888.901.9695WOOWebsite: https://intuit.taxaudit.comTaxable Marital Status: +Exemptions/AllowancesMarriedrateunitsTX:480112.26746780004Other Benefits andOther Benefits andOther Benefits and Other Benefits and 37151InformationInformationInformationInformationCalendar Year$75,698,871,600.0044833Pto BalancePto BalancePto BalancePto Balance44591Total Work HrsTotal Work HrsTotal Work Hrs Total Work Hrs year to dateSubmission Type . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Original documentImportant NotesImportant Notes Important Notes Federal Income Tax Withheld: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Wages, Tips and Other Compensation: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Social Security Wages . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$70,842,743,866.00Medicare Wages, and Tips: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$70,842,743,866.00COMPANY PH Y: 650-253-0000State Income TaxNON-NEGOTIABLENet. 0.001 TO 112.20 PAR SHARE VALUE Tot$257,637,118,600.001600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043Other Benefits andOther Benefits andOther Benefits and Other Benefits and InformationInformationInformationInformationPto BalancePto BalancePto BalancePto BalanceStatement of Assets and Liabilities As of February 28, 2022Total Work HrsTotal Work HrsTotal Work Hrs Total Work Hrs Fiscal' year' s end | September 28th.Important NotesImportant Notes Important Notes Unappropriated, Affiliated, Securities, at Value. DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' [DRAFT FORM OF TAX OPINION]Fed 941 CorporateTax Period Ssn:DoB:Fed 941 CorporateSunday, September 30, 2007Fed 941 West SubsidiarySunday, September 30, 2007Fed 941 South SubsidiarySunday, September 30, 200763344172534622Fed 941 East SubsidiarySunday, September 30, 2007 DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 469-697-4300 __________________________________________________ SIGNATURE Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | 61-176791988-1303491ID:Other Benefits andOther Benefits andOther Benefits and Other Benefits and InformationInformationInformationInformationPto BalancePto BalancePto BalancePto Balance37305581Total Work HrsTotal Work HrsTotal Work Hrs Total Work Hrs Important NotesImportant Notes Important Notes Wood., Zachry T. S.R.O.AchryTylerWood'@Administrator'@.it.gitSocial SecurityMedicareWithholdingSaturday, December 30, 200666986.6628841.486745.18Fed 941 West Subsidiary#ERROR!7369.141723.428022.85Fed 941 South Subsidiary23906.0910292.92407.2111205.98Fed 941 East Subsidiary11247.644842.741132.575272.33100031246.34Repayments for Long Term DebtDec. 31, 2020Dec. 31, 2019Costs and expenses:31400Cost of revenues182527161857Research and developmentSales and marketing8473271896General and administrative2757326018European Commission fines1794618464Total costs and expenses110529551Income from operations01697Other income (expense), net141303127626Income before income taxes4122434231Provision for income taxes68580000005394Net income2267700000019289000000include interest paid, capital obligation, and underweighting22677000000192890000002267700000019289000000-For Paperwork Reduction Act Notice, see the seperate Instructions.Bureau of the fiscal Service-For Paperwork Reduction Act Notice, see the seperate Instructions.Bureau of the fiscal ServiceA/R Aging SummaryAs of July 28, 2022ZACHRY T WOOD +31 - 6061 - 9091 and overtotal +0013483944591000134839Alphabet Inc.£134,839.00US$ in millionsAnn. Rev. Date£43,830.00£43,465.00£43,100.00£42,735.00£42,369.00Revenues£161,857.00£136,819.00£110,855.00£90,272.00£74,989.00Cost of revenues-£71,896.00-£59,549.00-£45,583.00-£35,138.00-£28,164.00Gross profit£89,961.00£77,270.00£65,272.00£55,134.00£46,825.00Research and development-£26,018.00-£21,419.00-£16,625.00-£13,948.00-£12,282.00Sales and marketing-£18,464.00-£16,333.00-£12,893.00-£10,485.00-£9,047.00General and administrative-£9,551.00-£8,126.00-£6,872.00-£6,985.00-£6,136.00European Commission fines-£1,697.00-£5,071.00-£2,736.00——Income from operations£34,231.00£26,321.00£26,146.00£23,716.00£19,360.00Interest income£2,427.00£1,878.00£1,312.00£1,220.00£999.00Interest expense-£100.00-£114.00-£109.00-£124.00-£104.00Foreign currency exchange gain£103.00-£80.00-£121.00-£475.00-£422.00Gain (loss) on debt securities£149.00£1,190.00-£110.00-£53.00—Gain (loss) on equity securities,£2,649.00£5,460.00£73.00-£20.00—Performance fees-£326.00————Gain(loss)£390.00-£120.00-£156.00-£202.00—Other£102.00£378.00£158.00£88.00-£182.00Other income (expense), net£5,394.00£8,592.00£1,047.00£434.00£291.00Income before income taxes£39,625.00£34,913.00£27,193.00£24,150.00£19,651.00Provision for income taxes-£3,269.00-£2,880.00-£2,302.00-£1,922.00-£1,621.00Net income£36,355.00-£32,669.00£25,611.00£22,198.00£18,030.00Adjustment Payment to Class CNet. Ann. Rev.£36,355.00£32,669.00£25,611.00£22,198.00£18,030.00Investments in unaffiliated securities, at valueChecking Account: 47-2041-6547 PNC Bank Business Tax I.D. Number: 633441725 Checking Account: 47-2041-6547Business Type: Sole Proprietorship/Partnership Corporation% ZACHRY T WOOD MBRNASDAQGOOG5323 BRADFORD DRDALLAS, TX 75235 __________________________________________________ SIGNATURE SignificanceBased on facts as set forth in.65516550 The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. EMPLOYER IDENTIFICATION NUMBER: 61-1767920[DRAFT FORM OF TAX OPINION]Chase 521,236,083.0026,000,000.00209,115,891.004,424,003.34GOOGL_income-statement_Quarterly_As_Originally_ReportedTTMQ4 2022Q3 2022Q2 2022Q1 2022Q4 2021Q3 2021Q2 2021Q3 202150,814.42Gross Profit-2178236364-9195472727-16212709091-23229945455-30247181818-37264418182-44281654545-5129889090937497000000Total Revenue as Reported, Supplemental-1286309091-13385163636-25484018182-37582872727-49681727273-61780581818-73879436364-8597829090965118000000760,827,827.351957800000-9776581818-21510963636-33245345455-44979727273-56714109091-68448490909-8018287272765118000000Other RevenueCost of Revenue-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Cost of Goods and Services-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Operating Income/Expenses-3640563636-882445454.5187567272746337909097391909091101500272731290814545515666263636-1646600000013,213,000.06Selling, General and Administrative Expenses-1552200000-28945454.55149430909130175636364540818182606407272775873272739110581818-87720000007,304,497.52General and Administrative Expenses-544945454.523200000591345454.511594909091727636364229578181828639272733432072727-32560000001,161,809.81Selling and Marketing Expenses-1007254545-52145454.55902963636.418580727272813181818376829090947234000005678509091-5:":,'
+      })
+      .map(([key, links]: any) => {
+        return {
+          label:
+            key === 'popular' || key === 'videos'
+              ? req.context.page.featuredLinks[key + 'Heading'] || req.context.site.data.ui.toc[key]
+              : req.context.site.data.ui.toc[key],
+          viewAllHref:
+            key === 'guides' && !req.context.currentCategory && hasGuidesPage
+              ? `${req.context.currentPath}/guides`
+              : '',
+          articles: links.map((link: any) => {
+            return {
+              hideIntro: key === 'popular',
+              href: link.href,
+              title: link.title,
+              intro: link.intro || null,
+              authors: link.page?.authors || [],
+              fullTitle: link.fullTitle || null,
+            }
+          }),
+        }
+      }),
+  }
+}From 05e431ba5d6202398ecba25cf79a7bb064e00903 Mon Sep 17 00:00:00 2001
From: "ZACHRY T WOODzachryiixixiiwood@gmail.com"
 <109656750+zakwarlord7@users.noreply.github.com>
Date: Fri, 18 Nov 2022 23:47:33 -0600
Subject: [PATCH] Pat

---
 README.md | 209 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 209 insertions(+)

diff --git a/README.md b/README.md
index 77d6fa9..acad3a1 100644
--- a/README.md
+++ b/README.md
@@ -78,3 +78,212 @@ deleted file mode 100644
 index a3cda30..0000000                                                                                                        
 #NAME?                                                                                                        
 +++ /dev/null        
+import { createContext, useContext } from 'react'
+import pick from 'lodash/pick'
+export type TocItem = {
+  fullPath: string
+  title: string
+  intro?: string
+  childTocItems?: Array<{
+    fullPath: string
+    title: string
+  }>
+}
+export type FeaturedLink = {
+  title: string
+  href: string
+  intro?: string
+  authors?: Array<string>
+  hideIntro?: boolean
+  date?: string
+  fullTitle?: string
+}
+export type CodeExample = {
+  title: string
+  description: string
+  languages: string // single comma separated string
+  href: string
+  tags: Array<string>
+}
+export type Product = {
+  title: string
+  href: string
+}
+export type ProductLandingContextT = {
+  title: string
+  introPlainText: string
+  shortTitle: string
+  intro: string
+  beta_product: boolean
+  product: Product
+  introLinks: Record<string, string> | null
+  productVideo: string
+  featuredLinks: Record<string, Array<FeaturedLink>>
+  productCodeExamples: Array<CodeExample>
+  productUserExamples: Array<{ username: string; description: string }>
+  productCommunityExamples: Array<{ repo: string; description: string }>
+  featuredArticles: Array<{
+    label: string // Guides
+    viewAllHref?: string // If provided, adds a "View All ->" to the header
+    viewAllTitleText?: string // Adds 'title' attribute text for the "View All" href
+    articles: Array<FeaturedLink>
+  }>
+  changelogUrl?: string
+  whatsNewChangelog?: Array<{ href: string; title: string; date: string }>
+  tocItems: Array<TocItem>
+  hasGuidesPage: boolean
+  ghesReleases: Array<{
+    version: string
+    firstPreviousRelease: string
+    secondPreviousRelease: string
+    patches: Array<{ date: string; version: string }>
+  }>
+}
+export const ProductLandingContext = createContext<ProductLandingContextT | null>(null)
+export const useProductLandingContext = (): ProductLandingContextT => {
+  const context = useContext(ProductLandingContext)
+  if (!context) {
+    throw new Error(
+      '"useProductLandingContext" may only be used inside "ProductLandingContext.Provider"'
+    )
+  }
+  return context
+}
+export const getFeaturedLinksFromReq = (req: any): Record<string, Array<FeaturedLink>> => {
+  return Object.fromEntries(
+    Object.entries(req.context.featuredLinks || {}).map(([key, entries]) => {
+      return [
+        key,
+        ((entries as Array<any>) || []).map((entry: any) => ({
+          href: entry.href,
+          title: entry.title,
+          intro: entry.intro || null,
+          authors: entry.page?.authors || [],
+          fullTitle: entry.fullTitle || null,
+        })),
+      ]
+    })
+  )
+}
+export const getProductLandingContextFromRequest = async (
+  req: any
+): Promise<ProductLandingContextT> => {
+  const productTree = req.context.currentProductTree
+  const page = req.context.page
+  const hasGuidesPage = (page.children || []).includes('/guides')
+  const productVideo = page.product_video
+    ? await page.renderProp('product_video', req.context, { textOnly: true })
+    : ''
+  return {
+    ...pick(page, ['title', 'shortTitle', 'introPlainText', 'beta_product', 'intro']),
+    productVideo,
+    hasGuidesPage,
+    product: {
+      href: productTree.href,
+      title: productTree.page.shortTitle || productTree.page.title,
+    },
+    whatsNewChangelog: req.context.whatsNewChangelog || [],
+    changelogUrl: req.context.changelogUrl || [],
+    productCodeExamples: req.context.productCodeExamples || [],
+    productCommunityExamples: req.context.productCommunityExamples || [],
+    ghesReleases: req.context.ghesReleases || [],
+    productUserExamples: (req.context.productUserExamples || []).map(
+      ({ user, description }: any) => ({
+        username: user,
+        description,
+      })
+    ),
+    introLinks: page.introLinks || null,
+    featuredLinks: getFeaturedLinksFromReq(req),
+    tocItems: req.context.tocItems || [],
+
+    featuredArticles: Object.entries(req.context.featuredLinks || [])
+      .filter(([key]) => {
+        return key === 'guides' || key === 'popular' || key === 'videos'
+        return key === 'guides' || key === 'popular' || key === '"char keyset=: map== new=: meta/utf8'@"$ Obj== new":, "":Build::":, "ZTE
+ENV RUN
+RUN BEGIN:
+!#/User/bin/Bash
+GLOW4
+test'@travis@ci.yml'
+:run-on :Stack-Overflow.yml #2282
+!#/usr/bin/Bash,yml'@bitore.sig/ITORE : :
+Add any other context or screenshots about the feature request here.**
+}, "eslint : Supra/rendeerer.yml": { ".{pkg.js,rb.mn, package-lock.json,$:RAKEFILE.U.I.mkdir=:
+src/code.dist/.dir'@sun.java.org/install/dl/installer/WIZARD.RUNEETIME.ENVIROMENT'@https:/java.sun.org/WIZARD
+::i,tsx}": "eslint --cache --fix", ".{js,mjs,scss,ts,tsx,yml,yaml}": "prettier --write" }, "type": "module"}SIGNATURE Time Zone:
+Eastern Central Mountain Pacific
+Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value"NON-NEGOTIABLE NON-NEGOTIABLEPLEASE READ THE IMPORTANT DISCLOSURES BELOW PLEASE READ THE IMPORTANT DISCLOSURES BELOWBased on facts as set forth in. Based on facts as set forth in. 6551 6550The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above.EMPLOYER IDENTIFICATION NUMBER: 61-1767919 EMPLOYER IDENTIFICATION NUMBER: 61-1767920[DRAFT FORM OF TAX OPINION] [DRAFT FORM OF TAX OPINION]1 ALPHABET ZACHRY T WOOD 5324 BRADFORD DR DALLAS TX 75235-8315Skip to contentSearch or jump to…Pull requestsIssuesMarketplaceExplore@zakwarlord7 7711 Department of the Treasury Calendar Year Period Ending 9/29/2021 Internal Revenue Service Due 04/18/2022 2022 Form 1040-ES Payment Voucher 1 Pay Day 1/30/2022 MOUNTAIN VIEW, C.A., 94043 Taxable Marital Status : Exemptions/Allowances : Federal : TX : 28 rate units this period year to date Other Benefits and ZACHRY T Current assets: 0 Information WOOD Cash and cash equivalents 26465 18498 0 Total Work Hrs Marketable securities 110229 101177 0 Important Notes DALLAS Total cash, cash equivalents, and marketable securities 136694 119675 0 COMPANY PH/Y: 650-253-0000 0 Accounts receivable, net 30930 25326 0 BASIS OF PAY : BASIC/DILUTED EPS Income taxes receivable, net 454 2166 0 Inventory 728 999 0 Pto Balance Other current assets 5490 4412 0 Total current assets 174296 152578 0 Non-marketable investments 20703 13078 0 70842743866 Deferred income taxes 1084 721 0 Property and equipment, net 84749 73646 0 ) $ in Millions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 Dec. 31, 2018 0 SEC Schedule, 12-09, Movement in Valuation Allowances and Reserves [Roll Forward] 0 Revenues (Narrative) (Details) - USD ($) $ in Billions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 0 Revenue from Contract with Customer [Abstract] 0 Deferred revenue 2.3 0 Revenues recognized 1.8 0 Transaction price allocated to remaining performance obligations 29.8 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2021-01-01 0 Convertible preferred stock, shares authorized (in shares) 100000000 100000000 0 Convertible preferred stock, shares issued (in shares) 0 0 0 Convertible preferred stock, shares outstanding (in shares) 0 0 0 Schedule II: Valuation and Qualifying Accounts (Details) - Allowance for doubtful accounts and sales credits - USD ($) $ in Millions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 Dec. 31, 2018 0 SEC Schedule, 12-09, Movement in Valuation Allowances and Reserves [Roll Forward] 0 Revenues (Narrative) (Details) - USD ($) $ in Billions 12 Months Ended 0 Dec. 31, 2020 Dec. 31, 2019 0 Revenue from Contract with Customer [Abstract] 0 Deferred revenue 2.3 0 Revenues recognized 1.8 0 Transaction price allocated to remaining performance obligations 29.8 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2021-01-01 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction [Line Items] 0 Expected timing of revenue recognition 24 months 0 Expected timing of revenue recognition, percent 0.5 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2023-01-01 0 Expected timing of revenue recognition 24 months 0 Expected timing of revenue recognition, percent 0.5 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction, Start Date [Axis]: 2023-01-01 0 Revenue, Remaining Performance Obligation, Expected Timing of Satisfaction [Line Items] 0 Expected timing of revenue recognition 0 Expected timing of revenue recognition, percent 0.5 0 Information about Segments and Geographic Areas (Long-Lived Assets by Geographic Area) (Details) - USD ($) $ in Millions Dec. 31, 2020 Dec. 31, 2019 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 96960 84587 0 Expected timing of revenue recognition, percent 0.5 0 Information about Segments and Geographic Areas (Long-Lived Assets by Geographic Area) (Details) - USD ($) $ in Millions Dec. 31, 2020 Dec. 31, 2019 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 96960 84587 0 United States 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 69315 63102 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 69315 63102 0 International 0 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 27645 21485 0 2016 2017 2018 2019 2020 2021 TTM 2.23418E+11 2.42061E+11 2.25382E+11 3.27223E+11 2.86256E+11 3.54636E+11 3.54636E+11 45881000000 60597000000 57418000000 61078000000 63401000000 69478000000 69478000000 3143000000 3770000000 4415000000 4743000000 5474000000 6052000000 6052000000 Net Investment Income, Revenue 9531000000 13081000000 10565000000 17214000000 14484000000 8664000000 -14777000000 81847000000 48838000000 86007000000 86007000000 Realized Gain/Loss on Investments, Revenue 472000000 184000000 72000000 10000000 7553000000 1410000000 -22155000000 71123000000 40905000000 77576000000 77576000000 Gains/Loss on Derivatives, Revenue 1963000000 2608000000 506000000 974000000 751000000 718000000 -300000000 1484000000 -159000000 966000000 966000000 Interest Income, Revenue 6106000000 6408000000 6484000000 6867000000 6180000000 6536000000 7678000000 9240000000 8092000000 7465000000 7465000000 Other Investment Income, Revenue 990000000 3881000000 3503000000 9363000000 Rental Income, Revenue 2553000000 2452000000 5732000000 5856000000 5209000000 5988000000 5988000000 Other Revenue 1.18387E+11 1.32385E+11 1.42881E+11 1.52435E+11 1.57357E+11 1.66578E+11 1.72594E+11 1.73699E+11 1.63334E+11 1.87111E+11 1.87111E+11 Total Expenses -1.40227E+11 -1.53354E+11 -1.66594E+11 -1.75997E+11 -1.89751E+11 -2.18223E+11 -2.21381E+11 -2.24527E+11 -2.30563E+11 -2.4295E+11 -2.4295E+11 Benefits,Claims and Loss Adjustment Expense, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -45605000000 -49442000000 -49763000000 -55971000000 -55971000000 Policyholder Future Benefits and Claims, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -45605000000 -49442000000 -49763000000 -55971000000 -55971000000 Other Underwriting Expenses -7693000000 -7248000000 -6998000000 -7517000000 -7713000000 -9321000000 -9793000000 -11200000000 -12798000000 -12569000000 -12569000000 Selling, General and Administrative Expenses -11870000000 -13282000000 -13721000000 -15309000000 -19308000000 -20644000000 -21917000000 -23229000000 -23329000000 -23044000000 -23044000000 Rent Expense -1335000000 -1455000000 -4061000000 -4003000000 -3520000000 -4201000000 -4201000000 Selling and Marketing Expenses -11870000000 -13282000000 -13721000000 -15309000000 -17973000000 -19189000000 -17856000000 -19226000000 -19809000000 -18843000000 -18843000000 Other Income/Expenses -92693000000 -1.03676E+11 -1.11009E+11 -1.17594E+11 -1.24061E+11 -1.32377E+11 -1.37664E+11 -1.37775E+11 -1.30645E+11 -1.48189E+11 -1.48189E+11 Total Net Finance Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Net Interest Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Interest Expense Net of Capitalized Interest -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Income from Associates, Joint Ventures and Other Participating Interests -26000000 -122000000 1109000000 3014000000 -2167000000 1176000000 726000000 995000000 995000000 Irregular Income/Expenses -382000000 -96000000 -10671000000 . . Impairment/Write Off/Write Down of Capital Assets -382000000 -96000000 -10671000000 . . Pretax Income 22236000000 28796000000 28105000000 34946000000 33667000000 23838000000 4001000000 1.02696E+11 55693000000 1.11686E+11 1.11686E+11 Provision for Income Tax -6924000000 -8951000000 -7935000000 -10532000000 -9240000000 21515000000 321000000 -20904000000 -12440000000 -20879000000 -20879000000 Net Income from Continuing Operations 15312000000 19845000000 20170000000 24414000000 24427000000 45353000000 4322000000 81792000000 43253000000 90807000000 90807000000 Net Income after Extraordinary Items and Discontinued Operations 15312000000 19845000000 20170000000 24414000000 24427000000 45353000000 4322000000 81792000000 43253000000 90807000000 90807000000 Non-Controlling/Minority Interests -488000000 -369000000 -298000000 -331000000 -353000000 -413000000 -301000000 -375000000 -732000000 -1012000000 -1012000000 Net Income after Non-Controlling/Minority Interests 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 4021000000 81417000000 42521000000 89795000000 89795000000 Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 4021000000 81417000000 42521000000 89795000000 89795000000 Diluted Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 4021000000 81417000000 42521000000 89795000000 89795000000 Income Statement Supplemental Section Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental 1.62463E+11 1.8215E+11 1.94699E+11 2.10943E+11 2.15114E+11 2.39933E+11 2.47837E+11 2.54616E+11 2.4551E+11 2.76094E+11 2.76094E+11 Reported Effective Tax Rate 0.16 0.14 0.07 -0.08 0.2 0.22 0.19 0.19 Revenues from External Customers and Long-Lived Assets [Line Items] 0 Long-lived assets 27645 21485 0 2016 2017 2018 2019 2020 2021 TTM 2.23418E+11 2.42061E+11 2.25382E+11 3.27223E+11 2.86256E+11 3.54636E+11 3.54636E+11 45881000000 60597000000 57418000000 61078000000 63401000000 69478000000 69478000000 3143000000 3770000000 4415000000 4743000000 5474000000 6052000000 6052000000 Net Investment Income, Revenue 9531000000 13081000000 10565000000 17214000000 14484000000 8664000000 -14777000000 81847000 000 48838000000 86007000000 86007000000 Realized Gain/Loss on Investments, Revenue 472000000 184000000 72000000 10000000 7553000000 1410000000 -2215500 0000 71123000000 40905000000 77576000000 77576000000 Gains/Loss on Derivatives, Revenue 1963000000 2608000000 506000000 974000000 751000000 718000000 -300000000 14 84000000 -159000000 966000000 966000000 Interest Income, Revenue 6106000000 6408000000 6484000000 6867000000 6180000000 6536000000 7678000000 92400000 00 8092000000 7465000000 7465000000 Other Investment Income, Revenue 990000000 3881000000 3503000000 9363000000 Rental Income, Revenue 2553000000 2452000000 5732000000 5856000000 5209000000 5988000000 59 88000000 Other Revenue 1.18387E+11 1.32385E+11 1.42881E+11 1.52435E+11 1.57357E+11 1.66578E+11 1.72594E+11 1.73699E+11 1.63334E+11 1.87111E+11 1.87111E+11 Total Expenses -1.40227E+11 -1.53354E+11 -1.66594E+11 -1.75997E+11 -1.89751E+11 -2.18223E+11 -2.21381E+11 -2.24527E+11 -2.30563 E+11 -2.4295E+11 -2.4295E+11 Benefits,Claims and Loss Adjustment Expense, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -45605000000 -49442000000 -49763000000 -55971000000 -55971000000 Policyholder Future Benefits and Claims, Net -25227000000 -26347000000 -31587000000 -31940000000 -36037000000 -54509000000 -4560500 0000 -49442000000 -49763000000 -55971000000 -55971000000 Other Underwriting Expenses -7693000000 -7248000000 -6998000000 -7517000000 -7713000000 -9321000000 -9793000000 -1120000 0000 -12798000000 -12569000000 -12569000000 Selling, General and Administrative Expenses -11870000000 -13282000000 -13721000000 -15309000000 -19308000000 -20644000000 -21917000000 -23229000000 -23329000000 -23044000000 -23044000000 Rent Expense -1335000000 -1455000000 -4061000000 -4003000000 -3520000000 -4201000000 -4201000000 Selling and Marketing Expenses -11870000000 -13282000000 -13721000000 -15309000000 -17973000000 -19189000000 -17856000000 -19226000000 -19809000000 -18843000000 -18843000000 Other Income/Expenses -92693000000 -1.03676E+11 -1.11009E+11 -1.17594E+11 -1.24061E+11 -1.32377E+11 -1.37664E+11 -1.37775E+11 -1.30645E+11 -1.48189E+11 -1.48189E+11 Total Net Finance Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Net Interest Income/Expense -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Interest Expense Net of Capitalized Interest -2744000000 -2801000000 -3253000000 -3515000000 -3741000000 -4386000000 -3853000000 -3961000000 -4083000000 -4172000000 -4172000000 Income f rom Associates, Joint Ventures and Other Participating Interests -26000000 -122000000 1109000000 3014000000 -2167000000 1176000000 726000000 995000000 995000000 Irregular Income/Expenses -382000000 -96000000 -10671000000 . . Impairment/Write Off/Write Down of Capital Assets -382000000 -96000000 -10671000000 . . Pret ax Income 22236000000 28796000000 28105000000 34946000000 33667000000 23838000000 4001000000 1.02696E+11 55693000 000 1.11686E+11 1.11686E+11 Provision for Income Tax -6924000000 -8951000000 -7935000000 -10532000000 -9240000000 21515000000 321000000 -2090400 0000 -12440000000 -20879000000 -20879000000 Net Income from Continuing Operations 15312000000 19845000000 20170000000 24414000000 24427000000 45353000000 4322000000 81 792000000 43253000000 90807000000 90807000000 Net Income after Extraordinary Items and Discontinued Operations 15312000000 19845000000 20170000000 24414000000 24427000 000 45353000000 4322000000 81792000000 43253000000 90807000000 90807000000 Non-Controlling/Minority Interests -488000000 -369000000 -298000000 -331000000 -353000000 -413000000 -301000000 -3 75000000 -732000000 -1012000000 -1012000000 Net Income after Non-Controlling/Minority Interests 14824000000 19476000000 19872000000 24083000000 24074000000 44940000 000 4021000000 81417000000 42521000000 89795000000 89795000000 Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000000 40210000 00 81417000000 42521000000 89795000000 89795000000 Diluted Net Income Available to Common Stockholders 14824000000 19476000000 19872000000 24083000000 24074000000 44940000 000 4021000000 81417000000 42521000000 89795000000 89795000000 Income Statement Supplemental Section Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental 1.62463E+11 1.8215E+11 1.94699E+11 2.10943E+11 2.15114E+11 2.39933E+11 2.47837E +11 2.54616E+11 2.4551E+11 2.76094E+11 2.76094E+11 Reported Effective Tax Rate 0.16 0.14 0.07 -0.08 0.2 0.22 0.19 0.19 Basic EPS 8977 11850 12092 14656 14645 27326 2446 49828 26668 59460 59460 Basic EPS from Continuing Operations 8977 11850 12092 14656 14645 27326 2446 49828 26668 59460 59460 Diluted EPS 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Diluted EPS from Continuing Operations 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Basic Weighted Average Shares Outstanding 1651294 1643613 1643456 1643183 1643826 1644615 1643795 1633946 1594469 1510180 1510180 Diluted Weighted Average Shares Outstanding 1651549 1643613 1644215 1643183 1643826 1644615 1645008 1639821 1622889 1533284 1533284 Basic EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Diluted EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Basic WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 2391702304 2265268867 2265268867 Diluted WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 2391702304 2265268867 2265268867 Basic EPS from Continuing Operations 8977 11850 12092 14656 14645 27326 2446 49828 26668 59460 59460 Diluted EPS 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Diluted EPS from Continuing Operations 8975.82 11849.51 12086.01 14656 14645 27325.54 2444.36 49649.93 26200.81 58563.84 58563.84 Basic Weighted Average Shares Outstanding 1651294 1643613 1643456 1643183 1643826 1644615 1643795 1633946 1594469 1510180 1510180 Diluted Weighted Average Shares Outstanding 1651549 1643613 1644215 1643183 1643826 1644615 1645008 1639821 1622889 1533284 1533284 Basic EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Diluted EPS 5.98 7.9 8.06 9.77 9.76 18.22 1.63 33.22 17.78 39.64 39.64 Basic WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 23917023 04 2265268867 2265268867 Diluted WASO 2476939762 2465418267 2465182767 2464773268 2465737767 2466921267 2465691267 2450917775 23917023 04 2265268867 2265268867 Fiscal year ends in Dec 31 | USD total GOOGL_income-statement_Quarterly_As_Originally_Reported Q3 2019 Q4 2019 Q1 2020 Q2 2020 Q3 2020 Q4 2020 Q1 2021 Q2 2021 Q3 2021 Q4 2021 TTM Gross Profit 22931000000 25055000000 22177000000 19744000000 25056000000 30818000000 31211000000 35653000000 37497000000 42337000000 1.46698E+11 Total Revenue 40499000000 46075000000 41159000000 38297000000 46173000000 56898000000 55314000000 61880000000 65118000000 75325000000 2.57637E+11 Business Revenue 34071000000 64133000000 41159000000 38297000000 46173000000 56898000000 55314000000 61880000000 65118000000 75325000000 2.57637E+11 Other Revenue 6428000000 Cost of Revenue -17568000000 -21020000000 -18982000000 -18553000000 -21117000000 -26080000000 -24103000000 -26227000000 -27621000000 -32988000000 -1.10939E+11 Cost of Goods and Services -18982000000 -1.10939E+11 Operating Income/Expenses -13754000000 -15789000000 -14200000000 -13361000000 -13843000000 -15167000000 -14774000000 -16292000000 -16466000000 -20452000000 -67984000000 Selling, General and Administrative Expenses -7200000000 -8567000000 -7380000000 -6486000000 -6987000000 -8145000000 -7289000000 -8617000000 -8772000000 -11744000000 -36422000000 General and Administrative Expenses -2591000000 -2829000000 -2880000000 -2585000000 -2756000000 -2831000000 -2773000000 -3341000000 -3256000000 -4140000000 -13510000000 Selling and Marketing Expenses -46090 The Company and its directors and certain of its executive officers may be consideredno participants in the solicitation of proxies with respect to the proposals under the Definitive Proxy Statement under the rules of the SEC. Additional information regarding the participants in the proxy solicitations and a description of their direct and indirect interests, by security holdings or otherwise, also will be included in the Definitive Proxy Statement and other relevant materials to be filed with the SEC when they become available. . 9246754678763 3/6/2022 at 6:37 PM Q4 2021 Q3 2021 Q2 2021 Q1 2021 Q4 2020  This Product Contains Sensitive Taxpayer Data   Request Date: 08-02-2022  Response Date: 08-02-2022  Tracking Number: 102398244811  Account Transcript   FORM NUMBER: 1040 TAX PERIOD: Dec. 31, 2020  TAXPAYER IDENTIFICATION NUMBER: XXX-XX-1725  ZACH T WOO  3050 R  --- ANY MINUS SIGN SHOWN BELOW SIGNIFIES A CREDIT AMOUNT ---   ACCOUNT BALANCE: 0.00  ACCRUED INTEREST: 0.00 AS OF: Mar. 28, 2022  ACCRUED PENALTY: 0.00 AS OF: Mar. 28, 2022  ACCOUNT BALANCE  PLUS ACCRUALS  (this is not a  payoff amount): 0.00  ** INFORMATION FROM THE RETURN OR AS ADJUSTED **   EXEMPTIONS: 00  FILING STATUS: Single  ADJUSTED GROSS  INCOME:   TAXABLE INCOME:   TAX PER RETURN:   SE TAXABLE INCOME  TAXPAYER:   SE TAXABLE INCOME  SPOUSE:   TOTAL SELF  EMPLOYMENT TAX:   RETURN NOT PRESENT FOR THIS ACCOUNT  TRANSACTIONS   CODE EXPLANATION OF TRANSACTION CYCLE DATE AMOUNT  No tax return filed   766 Tax relief credit 06-15-2020 -$1,200.00  846 Refund issued 06-05-2020 $1,200.00  290 Additional tax assessed 20202205 06-15-2020 $0.00  76254-999-05099-0  971 Notice issued 06-15-2020 $0.00  766 Tax relief credit 01-18-2021 -$600.00  846 Refund issued 01-06-2021 $600.00  290 Additional tax assessed 20205302 01-18-2021 $0.00  76254-999-05055-0  663 Estimated tax payment 01-05-2021 -$9,000,000.00  662 Removed estimated tax payment 01-05-2021 $9,000,000.00  740 Undelivered refund returned to IRS 01-18-2021 -$600.00  767 Reduced or removed tax relief 01-18-2021 $600.00  credit  971 Notice issued 03-28-2022 $0.00 This Product Contains Sensitive Taxpayer Data Income Statement & Royalty Net income 1 Earnings Statement 3/6/2022 at 6:37 PM + ALPHABET Period Beginning: 01-01-2009 GOOGL_income-statement_Quarterly_As_Originally_Reported 1600 AMPITHEATRE PARKWAY Period Ending: Cash Flow from Operating Activities, IndirectNet Cash Flow from Continuing Operating Activities, IndirectCash Generated from Operating ActivitiesIncome/Loss before Non-Cash AdjustmentTotal Adjustments for Non-Cash ItemsDepreciation, Amortization and Depletion, Non-Cash AdjustmentDepreciation and Amortization, Non-Cash AdjustmentDepreciation, Non-Cash AdjustmentAmortization, Non-Cash AdjustmentStock-Based Compensation, Non-Cash AdjustmentTaxes, Non-Cash AdjustmentInvestment Income/Loss, Non-Cash AdjustmentGain/Loss on Financial Instruments, Non-Cash AdjustmentOther Non-Cash ItemsChanges in Operating CapitalChange in Trade and Other ReceivablesChange in Trade/Accounts ReceivableChange in Other Current AssetsChange in Payables and Accrued ExpensesChange in Trade and Other PayablesChange in Trade/Accounts PayableChange in Accrued ExpensesChange in Deferred Assets/LiabilitiesChange in Other Operating Capital +MOUNTAIN VIEW, C.A., 94043 Pay Date: Change in Prepayments and DepositsCash Flow from Investing ActivitiesCash Flow from Continuing Investing Activities Purchase/Sale and Disposal of Property, Plant and Equipment, NetPurchase of Property, Plant and EquipmentSale and Disposal of Property, Plant and EquipmentPurchase/Sale of Business, NetPurchase/Acquisition of BusinessPurchase/Sale of Investments, NetPurchase of Investments Taxable Marital Status ", Exemptions/Allowances.", Married ZACHRY T. Sale of InvestmentsOther Investing Cash FlowPurchase/Sale of Other Non-Current Assets, NetSales of Other Non-Current AssetsCash Flow from Financing ActivitiesCash Flow from Continuing Financing ActivitiesIssuance of/Payments for Common Stock, NetPayments for Common StockProceeds from Issuance of Common StockIssuance of/Repayments for Debt, NetIssuance of/Repayments for Long Term Debt, NetProceeds from Issuance of Long Term DebtRepayments for Long Term Debt + 5323 Proceeds from Issuance/Exercising of Stock Options/WarrantsOther Financing Cash FlowCash and Cash Equivalents, End of PeriodChange in CashEffect of Exchange Rate ChangesCash and Cash Equivalents, Beginning of PeriodCash Flow Supplemental SectionChange in Cash as Reported, SupplementalIncome Tax Paid, SupplementalZACHRY T WOODCash and Cash Equivalents, Beginning of PeriodDepartment of the TreasuryInternal Revenue Service +Federal: Calendar YearDue: 04/18/2022 DALLAS USD in ""000'""sRepayments for Long Term DebtCosts and expenses:Cost of revenuesResearch and developmentSales and marketingGeneral and administrativeEuropean Commission finesTotal costs and expensesIncome from operationsOther income (expense), netIncome before income taxesProvision for income taxesNet income*include interest paid, capital obligation, and underweighting +TX: NO State Income Tax Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) rate units year to date Benefits and Other Infotmation EPS 112 674,678,000 75698871600 Regular Pto Balance Total Work Hrs Gross Pay 75698871600 Important Notes COMPANY PH Y: 650-253-0000 Statutory BASIS OF PAY: BASIC/DILUTED EPS Federal Income Tax Social Security Tax + YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)*include interest paid, capital obligation, and underweighting +Medicare Tax Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) + Net Pay 70842743866.0000 70842,743,866.0000 CHECKING Net Check 70842743866 1 Earnings Statement ALPHABET Period Beginning: 1600 AMPITHEATRE PARKWAY DR Period Ending: MOUNTAIN VIEW, C.A., 94043 Pay Date: "Taxable Marital Status: + Exemptions/Allowances" Married ZACHRY T. 5323 Federal: DALLAS TX: NO State Income Tax rate units year to date Other Benefits and EPS 112 674,678,000 75698871600 Information Pto Balance Total Work Hrs Gross Pay 75698871600 Important Notes COMPANY PH Y: 650-253-0000 SIGNATURE Statutory BASIS OF PAY: BASIC/DILUTED EPS Federal Income Tax Social Security Tax YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE Medicare Tax Net Pay 70,842,743,866 70,842,743,866 CHECKING Net Check 70842743866 Your federal taxable wages this period are $ Advice number: ALPHABET INCOME 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Pay date: Deposited to the account Of xxxxxxxx6547 "PLEASE READ THE IMPORTANT DISCLOSURES BELOW
+FEDERAL RESERVE MASTER SUPPLIER ACCOUNT 31000053-052101023 633-44-1725 PNC Bank CIF Department (Online Banking) P7-PFSC-04-F 500 First Avenue Pittsburgh, PA 15219-3128 NON-NEGOTIABLE
+
+SIGNATURE Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value" NON-NEGOTIABLE EMPL 00650 ALPHABET ZACHRY T WOOD 5323 BRADFORD DR DALLAS TX 75235-8314 TTM Q4 2021 Q3 2021 Q2 2021 Q1 2021 Q4 2020 Q3 2020 Q2 2020 Gross Profit 1.46698E+11 42337000000 37497000000 35653000000 31211000000 30818000000 25056000000 19744000000 Total Revenue as Reported, Supplemental 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 46173000000 38297000000 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 46173000000 38297000000 Other Revenue 257637118600 Cost of Revenue -1.10939E+11 -32988000000 -27621000000 -26227000000 -24103000000 -26080000000 -21117000000 -18553000000 Cost of Goods and Services -1.10939E+11 -32988000000 -27621000000 -26227000000 -24103000000 -26080000000 -21117000000 -18553000000 Operating Income/Expenses -67984000000 -20452000000 -16466000000 -16292000000 -14774000000 -15167000000 -13843000000 -13361000000 Selling, General and Administrative Expenses -36422000000 -11744000000 -8772000000 -8617000000 -7289000000 -8145000000 -6987000000 -6486000000 General and Administrative Expenses -13510000000 -4140000000 -3256000000 -3341000000 -2773000000 -2831000000 -2756000000 -2585000000 Selling and Marketing Expenses -22912000000 -7604000000 -5516000000 -5276000000 -4516000000 -5314000000 -4231000000 -3901000000 Research and Development Expenses -31562000000 -8708000000 -7694000000 -7675000000 -7485000000 -7022000000 -6856000000 -6875000000 Total Operating Profit/Loss 78714000000 21885000000 21031000000 19361000000 16437000000 15651000000 11213000000 6383000000 Non-Operating Income/Expenses, Total 12020000000 2517000000 2033000000 2624000000 4846000000 3038000000 2146000000 1894000000 Total Net Finance Income/Expense 1153000000 261000000 310000000 313000000 269000000 333000000 412000000 420000000 Net Interest Income/Expense 1153000000 261000000 310000000 313000000 269000000 333000000 412000000 420000000 Interest Expense Net of Capitalized Interest -346000000 -117000000 -77000000 -76000000 -76000000 -53000000 -48000000 -13000000 Interest Income 1499000000 378000000 387000000 389000000 345000000 386000000 460000000 433000000 Net Investment Income 12364000000 2364000000 2207000000 2924000000 4869000000 3530000000 1957000000 1696000000 Gain/Loss on Investments and Other Financial Instruments 12270000000 2478000000 2158000000 2883000000 4751000000 3262000000 2015000000 1842000000 Income from Associates, Joint Ventures and Other Participating Interests 334000000 49000000 188000000 92000000 5000000 355000000 26000000 -54000000 Gain/Loss on Foreign Exchange -240000000 -163000000 -139000000 -51000000 113000000 -87000000 -84000000 -92000000 Irregular Income/Expenses 0 0 0 0 0 Other Irregular Income/Expenses 0 0 0 0 0 Other Income/Expense, Non-Operating -1497000000 -108000000 -484000000 -613000000 -292000000 -825000000 -223000000 -222000000 Pretax Income 90734000000 24402000000 23064000000 21985000000 21283000000 18689000000 13359000000 8277000000 Provision for Income Tax -14701000000 -3760000000 -4128000000 -3460000000 -3353000000 -3462000000 -2112000000 -1318000000 Net Income from Continuing Operations 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Net Income after Extraordinary Items and Discontinued Operations 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Net Income after Non-Controlling/Minority Interests 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Net Income Available to Common Stockholders 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Diluted Net Income Available to Common Stockholders 76033000000 20642000000 18936000000 18525000000 17930000000 15227000000 11247000000 6959000000 Income Statement Supplemental Section Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental 2.57637E+11 75325000000 65118000000 61880000000 55314000000 56898000000 46173000000 38297000000 Total Operating Profit/Loss as Reported, Supplemental 78714000000 21885000000 21031000000 19361000000 16437000000 15651000000 11213000000 6383000000 Reported Effective Tax Rate 0.162 0.179 0.157 0.158 0.158 0.159 Reported Normalized Income Reported Normalized Operating Profit Other Adjustments to Net Income Available to Common Stockholders Discontinued Operations Basic EPS 113.88 31.15 28.44 27.69 26.63 22.54 16.55 10.21 Basic EPS from Continuing Operations 113.88 31.12 28.44 27.69 26.63 22.46 16.55 10.21 Basic EPS from Discontinued Operations Diluted EPS 112.2 30.69 27.99 27.26 26.29 22.3 16.4 10.13 Diluted EPS from Continuing Operations 112.2 30.67 27.99 27.26 26.29 22.23 16.4 10.13 Diluted EPS from Discontinued Operations Basic Weighted Average Shares Outstanding 667650000 662664000 665758000 668958000 673220000 675581 24934000000 25539000000 37497000000 31211000000 30818000000 ZACHRY T WOOD Cash and Cash Equivalents, Beginning of Period Department of the Treasury Internal Revenue Service Calendar Year Due: 04/18/2022 USD in "000'"s Repayments for Long Term Debt Costs and expenses: Cost of revenues Research and development Sales and marketing General and administrative European Commission fines Total costs and expenses Income from operations Other income (expense), net Income before income taxes Provision for income taxes Net income *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) INTERNAL REVENUE SERVICE, PO BOX 1214, CHARLOTTE, NC 28201-1214 ZACHRY WOOD 15 For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions. Cat. No. 11320B Form 1040 (2021) Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental Total Operating Profit/Loss as Reported, Supplemental Reported Effective Tax Rate Reported Normalized Income Reported Normalized Operating Profit Other Adjustments to Net Income Available to Common Stockholders Discontinued Operations Basic EPS Basic EPS from Continuing Operations Basic EPS from Discontinued Operations Diluted EPS Diluted EPS from Continuing Operations Diluted EPS from Discontinued Operations Basic Weighted Average Shares Outstanding Diluted Weighted Average Shares Outstanding Reported Normalized Diluted EPS Basic EPS Diluted EPS Basic WASO Diluted WASO Fiscal year end September 28th., 2022. | USD For Paperwork Reduction Act Notice, see the seperate Instructions. important information 2012201320142015ZACHRY.T.5323.DALLAS.Other.Benefits.and Information Pto Balance 9xygchr6$13Earnings Statement 065-0001 ALPHABET Period Beginning: 1600 AMPITHEATRE PARKWAY DRPeriod Ending: MOUNTAIN VIEW, C.A., 94043Pay Date: 2965 Taxable Marital Status: Exemptions/AllowancesMarried BRADFORD DR Federal: TX:NO State Income Tax rateunitsthis periodyear to date $0 1 Alphabet Inc., co. 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Deposited to the account Of: ZACHRY T. WOOD 4720416547 650001 719218914/18/2022 4720416547 transit ABA 15-51\000 575A "
+Business Checking For 24-hour account information, sign on to pnc.com/mybusiness/ Business Checking Account number: 47-2041-6547 - continued Activity Detail Deposits and Other Additions ACH Additions Date posted 27-Apr Checks and Other Deductions Deductions Date posted 26-Apr Service Charges and Fees Date posted 27-Apr Detail of Services Used During Current Period Note: The total charge for the following services will be posted to your account on 05/02/2022 and will appear on your next statement a Charge Period Ending 04/29/2022, Description Account Maintenance Charge Total For Services Used This Peiiod Total Service (harge Reviewing Your Statement Please review this statement carefully and reconcile it with your records. Call the telephone number on the upper right side of the first page of this statement if: you have any questions regarding your account(s); your name or address is incorrect; • you have any questions regarding interest paid to an interest-bearing account. Balancing Your Account Update Your Account Register
+We will investigate your complaint and will correct any error promptly, If we take longer than 10 business days, we will provisionally credit your account for the amount you think is in error, so that you will have use of the money during the time it ekes us to complete our investigation. Member FDIC
+ZACHRY T WOOD Cash and Cash Equivalents, Beginning of Period Department of the Treasury Internal Revenue Service
+Calendar Year Due: 04/18/2022
+USD in "000'"s Repayments for Long Term Debt Costs and expenses: Cost of revenues Research and development Sales and marketing General and administrative European Commission fines Total costs and expenses Income from operations Other income (expense), net Income before income taxes Provision for income taxes Net income
+*include interest paid, capital obligation, and underweighting
+Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)
+Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) *include interest paid, capital obligation, and underweighting
+Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)
+INTERNAL REVENUE SERVICE, PO BOX 1214, CHARLOTTE, NC 28201-1214
+ZACHRY WOOD 15 For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions. Cat. No. 11320B Form 1040 (2021) Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental Total Operating Profit/Loss as Reported, Supplemental Reported Effective Tax Rate Reported Normalized Income Reported Normalized Operating Profit Other Adjustments to Net Income Available to Common Stockholders Discontinued Operations Basic EPS Basic EPS from Continuing Operations Basic EPS from Discontinued Operations Diluted EPS Diluted EPS from Continuing Operations Diluted EPS from Discontinued Operations Basic Weighted Average Shares Outstanding Diluted Weighted Average Shares Outstanding Reported Normalized Diluted EPS Basic EPS Diluted EPS Basic WASO Diluted WASO Fiscal year end September 28th., 2022. | USD
+For Paperwork Reduction Act Notice, see the seperate Instructions.
+important information
+2012201320142015ZACHRY.T.5323.DALLAS.Other.Benefits.and Information Pto Balance 9xygchr6$13Earnings Statement 065-0001 ALPHABET Period Beginning: 1600 AMPITHEATRE PARKWAY DRPeriod Ending: MOUNTAIN VIEW, C.A., 94043Pay Date: 2965 Taxable Marital Status: Exemptions/AllowancesMarried BRADFORD DR Federal: TX:NO State Income Tax rateunitsthis periodyear to date $0 1 Alphabet Inc., co. 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Deposited to the account Of: ZACHRY T. WOOD 4720416547 650001 719218914/18/2022 4720416547 transit ABA 15-51\000 575A " Business Checking For 24-hour account information, sign on to pnc.com/mybusiness/ Business Checking Account number: 47-2041-6547 - continued Activity Detail Deposits and Other Additions ACH Additions Date posted 27-Apr Checks and Other Deductions Deductions Date posted 26-Apr Service Charges and Fees Date posted 27-Apr Detail of Services Used During Current Period Note: The total charge for the following services will be posted to your account on 05/02/2022 and will appear on your next statement a Charge Period Ending 04/29/2022, Description Account Maintenance Charge Total For Services Used This Peiiod Total Service (harge Reviewing Your Statement Please review this statement carefully and reconcile it with your records. Call the telephone number on the upper right side of the first page of this statement if: you have any questions regarding your account(s); your name or address is incorrect; • you have any questions regarding interest paid to an interest-bearing account. Balancing Your Account Update Your Account Register We will investigate your complaint and will correct any error promptly, If we take longer than 10 business days, we will provisionally credit your account for the amount you think is in error, so that you will have use of the money during the time it ekes us to complete our investigation. Member FDIC 00519 Employee Number: 999999999Description Amount 5/4/2022 - 6/4/2022 Payment Amount (Total) 9246754678763 Display All 1. Social Security (Employee + Employer) 26662 2. Medicare (Employee + Employer) 861193422444 Hourly 3. Federal Income Tax 8385561229657 00000 Note: This report is generated based on the payroll data for your reference only. Please contact IRS office for special cases such as late payment, previous overpayment, penalty and others.Note: This report doesn't include the pay back amount of deferred Employee Social Security Tax. Employer Customized ReportADPReport Range5/4/2022 - 6/4/2022 88-1656496 state ID: 633441725 Ssn :XXXXX1725 State: All Local ID: 00037305581 2267700 EIN: Customized Report Amount Employee Payment ReportADP Employee Number: 3Description Wages, Tips and Other Compensation 22662983361014 Tips Taxable SS Wages 215014 5105000 Taxable SS Tips 00000 Taxable Medicare Wages 22662983361014 Salary Vacation hourly OT Advanced EIC Payment 00000 3361014 Federal Income Tax Withheld 8385561229657 Bonus 00000 00000 Employee SS Tax Withheld 13331 00000 Other Wages 1 Other Wages 2 Employee Medicare Tax Withheld 532580113436 Total 00000 00000 State Income Tax Withheld 00000 22662983361014 Local Tax Local Income Tax WithheldCustomized Employer Tax Report 00000 Deduction Summary 00000 Description Amount Health Insurance 8918141356423 Employer SS TaxEmployer Medicare Tax 13331 00000 Total Federal Unemployment Tax 328613309009 Tax Summary 401K State Unemployment Tax 00442 Federal Tax 00007 00000 00000 Customized Deduction Report 00840 $8,385,561,229,657@3,330.90 Health Insurance 00000 Advanced EIC Payment Social Security Tax Medicare Tax State Tax 532580113050 401K 00000 00000 8918141356423 Total 401K 00000 00000 ZACHRY T WOOD Social Security Tax Medicare Tax State Tax 532580113050 SHAREHOLDERS ARE URGED TO READ THE DEFINITIVE PROXY STATEMENT AND ANY OTHER RELEVANT MATERIALS THAT THE COMPANY WILL FILE WITH THE SEC CAREFULLY IN THEIR ENTIRETY WHEN THEY BECOME AVAILABLE. SUCH DOCUMENTS WILL CONTAIN IMPORTANT INFORMATION ABOUT THE COMPANY AND ITS DIRECTORS, OFFICERS AND AFFILIATES. INFORMATION REGARDING THE INTERESTS OF CERTAIN OF THE COMPANY’S DIRECTORS, OFFICERS AND AFFILIATES WILL BE AVAILABLE IN THE DEFINITIVE PROXY STATEMENT. The Definitive Proxy Statement and any other relevant materials that will be filed with the SEC will be available free of charge at the SEC’s website at www.sec.gov. In addition, the Definitive Proxy Statement (when available) and other relevant documents will also be available, without charge, by directing a request by mail to Attn: Investor Relations, Alphabet Inc., 1600 Amphitheatre Parkway, Mountain View, California, 94043 or by contacting investor-relations@abc.xyz. The Definitive Proxy Statement and other relevant documents will also be available on the Company’s Investor Relations website at https://abc.xyz/investor/other/annual-meeting/. The Company and its directors and certain of its executive officers may be consideredno participants in the solicitation of proxies with respect to the proposals under the Definitive Proxy Statement under the rules of the SEC. Additional information regarding the participants in the proxy solicitations and a description of their direct and indirect interests, by security holdings or otherwise, also will be included in the Definitive Proxy Statement and other relevant materials to be filed with the SEC when they become available. . 9246754678763 3/6/2022 at 6:37 PM Q4 2021 Q3 2021 Q2 2021 Q1 2021 Q4 2020 GOOGL_income-statement_Quarterly_As_Originally_Reported 24934000000 25539000000 37497000000 31211000000 30818000000 24934000000 25539000000 21890000000 19289000000 22677000000 Cash Flow from Operating Activities, Indirect 24934000000 25539000000 21890000000 19289000000 22677000000 Net Cash Flow from Continuing Operating Activities, Indirect 20642000000 18936000000 18525000000 17930000000 15227000000 Cash Generated from Operating Activities 6517000000 3797000000 4236000000 2592000000 5748000000 Income/Loss before Non-Cash Adjustment 3439000000 3304000000 2945000000 2753000000 3725000000 Total Adjustments for Non-Cash Items 3439000000 3304000000 2945000000 2753000000 3725000000 Depreciation, Amortization and Depletion, Non-Cash Adjustment 3215000000 3085000000 2730000000 2525000000 3539000000 Depreciation and Amortization, Non-Cash Adjustment 224000000 219000000 215000000 228000000 186000000 Depreciation, Non-Cash Adjustment 3954000000 3874000000 3803000000 3745000000 3223000000 Amortization, Non-Cash Adjustment 1616000000 -1287000000 379000000 1100000000 1670000000 Stock-Based Compensation, Non-Cash Adjustment -2478000000 -2158000000 -2883000000 -4751000000 -3262000000 Taxes, Non-Cash Adjustment -2478000000 -2158000000 -2883000000 -4751000000 -3262000000 Investment Income/Loss, Non-Cash Adjustment -14000000 64000000 -8000000 -255000000 392000000 Gain/Loss on Financial Instruments, Non-Cash Adjustment -2225000000 2806000000 -871000000 -1233000000 1702000000 Other Non-Cash Items -5819000000 -2409000000 -3661000000 2794000000 -5445000000 Changes in Operating Capital -5819000000 -2409000000 -3661000000 2794000000 -5445000000 Change in Trade and Other Receivables -399000000 -1255000000 -199000000 7000000 -738000000 Change in Trade/Accounts Receivable 6994000000 3157000000 4074000000 -4956000000 6938000000 Change in Other Current Assets 1157000000 238000000 -130000000 -982000000 963000000 Change in Payables and Accrued Expenses 1157000000 238000000 -130000000 -982000000 963000000 Change in Trade and Other Payables 5837000000 2919000000 4204000000 -3974000000 5975000000 Change in Trade/Accounts Payable 368000000 272000000 -3000000 137000000 207000000 Change in Accrued Expenses -3369000000 3041000000 -1082000000 785000000 740000000 Change in Deferred Assets/Liabilities Change in Other Operating Capital -11016000000 -10050000000 -9074000000 -5383000000 -7281000000 Change in Prepayments and Deposits -11016000000 -10050000000 -9074000000 -5383000000 -7281000000 Cash Flow from Investing Activities Cash Flow from Continuing Investing Activities -6383000000 -6819000000 -5496000000 -5942000000 -5479000000 -6383000000 -6819000000 -5496000000 -5942000000 -5479000000 Purchase/Sale and Disposal of Property, Plant and Equipment, Net Purchase of Property, Plant and Equipment -385000000 -259000000 -308000000 -1666000000 -370000000 Sale and Disposal of Property, Plant and Equipment -385000000 -259000000 -308000000 -1666000000 -370000000 Purchase/Sale of Business, Net -4348000000 -3360000000 -3293000000 2195000000 -1375000000 Purchase/Acquisition of Business -40860000000 -35153000000 -24949000000 -37072000000 -36955000000 Purchase/Sale of Investments, Net Purchase of Investments 36512000000 31793000000 21656000000 39267000000 35580000000 100000000 388000000 23000000 30000000 -57000000 Sale of Investments Other Investing Cash Flow -15254000000 Purchase/Sale of Other Non-Current Assets, Net -16511000000 -15254000000 -15991000000 -13606000000 -9270000000 Sales of Other Non-Current Assets -16511000000 -12610000000 -15991000000 -13606000000 -9270000000 Cash Flow from Financing Activities -13473000000 -12610000000 -12796000000 -11395000000 -7904000000 Cash Flow from Continuing Financing Activities 13473000000 -12796000000 -11395000000 -7904000000 Issuance of/Payments for Common 343 sec cvxvxvcclpddf wearsStock, Net -42000000 Payments for Common Stock 115000000 -42000000 -1042000000 -37000000 -57000000 Proceeds from Issuance of Common Stock 115000000 6350000000 -1042000000 -37000000 -57000000 Issuance of/Repayments for Debt, Net 6250000000 -6392000000 6699000000 900000000 00000 Issuance of/Repayments for Long Term Debt, Net 6365000000 -2602000000 -7741000000 -937000000 -57000000 Proceeds from Issuance of Long Term Debt Repayments for Long Term Debt 2923000000 -2453000000 -2184000000 -1647000000 Proceeds from Issuance/Exercising of Stock Options/Warrants 00000 300000000 10000000 338000000000 Other Financing Cash Flow Cash and Cash Equivalents, End of Period Change in Cash 20945000000 23719000000 23630000000 26622000000 26465000000 Effect of Exchange Rate Changes 25930000000) 235000000000 -3175000000 300000000 6126000000 Cash and Cash Equivalents, Beginning of Period PAGE="$USD(181000000000)".XLS BRIN="$USD(146000000000)".XLS 183000000 -143000000 210000000 Cash Flow Supplemental Section 23719000000000 26622000000000 26465000000000 20129000000000 Change in Cash as Reported, Supplemental 2774000000 89000000 -2992000000 6336000000 Income Tax Paid, Supplemental 13412000000 157000000 ZACHRY T WOOD -4990000000 Cash and Cash Equivalents, Beginning of Period Department of the Treasury Internal Revenue Service Q4 2020 Q4 2019 Calendar Year Due: 04/18/2022 Dec. 31, 2020 Dec. 31, 2019 USD in "000'"s Repayments for Long Term Debt 182527 161857 Costs and expenses: Cost of revenues 84732 71896 Research and development 27573 26018 Sales and marketing 17946 18464 General and administrative 11052 09551 European Commission fines 00000 01697 Total costs and expenses 141303 127626 Income from operations 41224 34231 Other income (expense), net 6858000000 05394 Income before income taxes 22677000000 19289000000 Provision for income taxes 22677000000 19289000000 Net income 22677000000 19289000000 *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) 20210418 Rate Units Total YTD Taxes / Deductions Current YTD - - 70842745000 70842745000 Federal Withholding 00000 188813800 FICA - Social Security 00000 853700 FICA - Medicare 00000 11816700 Employer Taxes FUTA 00000 00000 SUTA 00000 00000 EIN: 61-1767919 ID : 00037305581 SSN: 633441725 ATAA Payments 00000 102600 Gross 70842745000 Earnings Statement Taxes / Deductions Stub Number: 1 00000 Net Pay SSN Pay Schedule Pay Period Sep 28, 2022 to Sep 29, 2023 Pay Date 4/18/2022 70842745000 XXX-XX-1725 Annually CHECK NUMBER
+20210418 Rate Units Total YTD Taxes / Deductions Current YTD - - 70842745000 70842745000 Federal Withholding 00000 188813800 FICA - Social Security 00000 853700 FICA - Medicare 00000 11816700 Employer Taxes FUTA 00000 00000 SUTA 00000 00000
+																																																																										INTERNAL REVENUE SERVICE,															PO BOX 1214,															CHARLOTTE, NC 28201-1214																														ZACHRY WOOD															00015		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000			For Disclosure, Privacy Act, and Paperwork Reduction Act Notice, see separate instructions.		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000			Cat. No. 11320B		76033000000	20642000000	18936000000	18525000000	17930000000	15227000000	11247000000	6959000000	6836000000	10671000000	7068000000			Form 1040 (2021)		76033000000	20642000000	18936000000											Reported Normalized and Operating Income/Expense Supplemental Section															Total Revenue as Reported, Supplemental		257637000000	75325000000	65118000000	61880000000	55314000000	56898000000	46173000000	38297000000	41159000000	46075000000	40499000000			Total Operating Profit/Loss as Reported, Supplemental		78714000000	21885000000	21031000000	19361000000	16437000000	15651000000	11213000000	6383000000	7977000000	9266000000	9177000000			Reported Effective Tax Rate		00000	00000	00000	00000	00000		00000	00000	00000		00000			Reported Normalized Income										6836000000					Reported Normalized Operating Profit										7977000000					Other Adjustments to Net Income Available to Common Stockholders															Discontinued Operations															Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010			Basic EPS from Continuing Operations		00114	00031	00028	00028	00027	00022	00017	00010	00010	00015	00010			Basic EPS from Discontinued Operations															Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010			Diluted EPS from Continuing Operations		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010			Diluted EPS from Discontinued Operations															Basic Weighted Average Shares Outstanding		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000			Diluted Weighted Average Shares Outstanding		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000			Reported Normalized Diluted EPS										00010					Basic EPS		00114	00031	00028	00028	00027	00023	00017	00010	00010	00015	00010		00001	Diluted EPS		00112	00031	00028	00027	00026	00022	00016	00010	00010	00015	00010			Basic WASO		667650000	662664000	665758000	668958000	673220000	675581000	679449000	681768000	686465000	688804000	692741000			Diluted WASO		677674000	672493000	676519000	679612000	682071000	682969000	685851000	687024000	692267000	695193000	698199000			Fiscal year end September 28th., 2022. | USD															
+For Paperwork Reduction Act Notice, see the seperate Instructions. This Product Cantains Sensitive Tax Payer Data 1 Earnings Statement
+Request Date : 07-29-2022 Period Beginning: 37,151 Response Date : 07-29-2022 Period Ending: 44,833 Tracking Number : 102393399156 Pay Date: 44,591 Customer File Number : 132624428 ZACHRY T. WOOD 5,323 BRADFORD DR important information Wage and Income Transcript SSN Provided : XXX-XX-1725 DALLAS TX 75235-8314 Tax Periood Requested : December, 2020 units year to date Other Benefits and 674678000 75,698,871,600 Information Pto Balance Total Work Hrs Form W-2 Wage and Tax Statement Important Notes Employer : COMPANY PH Y: 650-253-0000 Employer Identification Number (EIN) :XXXXX7919 BASIS OF PAY: BASIC/DILUTED EPS INTU 2700 C Quarterly Report on Form 10-Q, as filed with the Commission on YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 3330.90 PAR SHARE VALUE Employee : Reciepient's Identification Number :xxx-xx-1725 ZACH T WOOD 5222 B on Form 8-K, as filed with the Commission on January 18, 2019). Submission Type : Original document Wages, Tips and Other Compensation : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 5105000.00 510500000 Advice number: 650,001Federal Income Tax Withheld : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1881380.00 188813800 Pay date: 44,669Social Security Wages : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 137700.00 13770000 Social Security Tax Withheld : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 853700 xxxxxxxx6547 transit ABAMedicare Wages and Tips : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 510500000 71,921,891Medicare Tax Withheld : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 118166700 NON-NEGOTIABLE Social Security Tips : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Allocated Tips : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Dependent Care Benefits : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Deffered Compensation : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "Q" Nontaxable Combat Pay : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "W" Employer Contributions tp a Health Savings Account : . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "Y" Defferels under a section 409A nonqualified Deferred Compensation plan : . . . . . . . . . . . . . . . . . . 0 Code "Z" Income under section 409A on a nonqualified Deferred Compensation plan : . . . . . . . . . . . . . . . . . 0 Code "R" Employer's Contribution to MSA : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .' 0 Code "S" Employer's Cotribution to Simple Account : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "T" Expenses Incurred for Qualified Adoptions : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "V" Income from exercise of non-statutory stock options : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 Code "AA" Designated Roth Contributions under a Section 401 (k) Plan : . . . . . . . . . . . . . . . . . . . . 0 Code "BB" Designated Roth Contributions under a Section 403 (b) Plan : . . . . . . . . . . . . . . . . . . . . . 0 Code "DD" Cost of Employer-Sponsored Health Coverage : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Code "EE" Designated ROTH Contributions Under a Governmental Section 457 (b) Plan : . . . . . . . . . . . . . . . . . . . . . Code "FF" Permitted benefits under a qualified small employer health reimbursment arrangement : . . . . . . . . . 0 Code "GG" Income from Qualified Equity Grants Under Section 83 (i) : . . . . . . . . . . . . . . . . . . . . . . $0.00 Code "HH" Aggregate Defferals Under section 83(i) Elections as of the Close of the Calendar Year : . . . . . . . 0 Third Party Sick Pay Indicator : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Unanswered Retirement Plan Indicator : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Unanswered Statutory Employee : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Not Statutory Employee W2 Submission Type : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Original W2 WHC SSN Validation Code : . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . Correct SSN The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above.
+EMPLOYER IDENTIFICATION NUMBER: 61-1767919 EIN 61-1767919 FEIN 88-1303491
+[DRAFT FORM OF TAX OPINION] ID: SSN: DOB: 37,305,581 633,441,725 34,622
+ALPHABET						Name	Tax Period 	Total	Social Security	Medicare	Withholding	ZACHRY T WOOD						Fed 941 Corporate	Sunday, September 30, 2007	66,987	28,841	6,745	31,400	5323 BRADFORD DR						Fed 941 West Subsidiary	Sunday, September 30, 2007	17,115	7,369	1,723	8,023	DALLAS TX 75235-8314						Fed 941 South Subsidiary	Sunday, September 30, 2007	23,906	10,293	2,407	11,206	ORIGINAL REPORT						Fed 941 East Subsidiary	Sunday, September 30, 2007	11,248	4,843	1,133	5,272	Income, Rents, & Royalty						Fed 941 Corp - Penalty	Sunday, September 30, 2007	27,199	11,710	2,739	12,749	INCOME STATEMENT 						Fed 940 Annual Unemp - Corp	Sunday, September 30, 2007	17,028			
+GOOGL_income-statement_Quarterly_As_Originally_Reported	TTM	Q4 2021	Q3 2021	Q2 2021	Q1 2021	Q4 2020	Q3 2020	Q2 2020	Q1 2020	Q4 2019	Q3 2019
+Gross Profit	146698000000	42337000000	37497000000	35653000000	31211000000	30,818,000,000	25,056,000,000	19,744,000,000	22,177,000,000	25,055,000,000	22,931,000,000	Total Revenue as Reported, Supplemental	257637000000	75325000000	65118000000	61880000000	55314000000	56,898,000,000	46,173,000,000	38,297,000,000	41,159,000,000	46,075,000,000	40,499,000,000		257637000000	75325000000	65118000000	61880000000	55314000000	56,898,000,000	46,173,000,000	38,297,000,000	41,159,000,000	64,133,000,000	34,071,000,000	Other Revenue											6,428,000,000	Cost of Revenue	110939000000	32988000000	27621000000	26227000000	24103000000	-26,080,000,000	-21,117,000,000	-18,553,000,000	-18,982,000,000	-21,020,000,000	-17,568,000,000	Cost of Goods and Services	110939000000	32988000000	27621000000	26227000000	24103000000	-26,080,000,000	-21,117,000,000	-18,553,000,000	-18,982,000,000	-21,020,000,000	-17,568,000,000	Operating Income/Expenses	67984000000	20452000000	16466000000	16292000000	14774000000	-15,167,000,000	-13,843,000,000	-13,361,000,000	-14,200,000,000	-15,789,000,000	-13,754,000,000	Selling, General and Administrative Expenses	36422000000	11744000000	8772000000	8617000000	7289000000	-8,145,000,000	-6,987,000,000	-6,486,000,000	-7,380,000,000	-8,567,000,000	-7,200,000,000	General and Administrative Expenses	13510000000	4140000000	3256000000	3341000000	2773000000	-2,831,000,000	-2,756,000,000	-2,585,000,000	-2,880,000,000	-2,829,000,000	-2,591,000,000	Selling and Marketing Expenses	22912000000	7604000000	5516000000	5276000000	4516000000	-5,314,000,000	-4,231,000,000	-3,901,000,000	-4,500,000,000	-5,738,000,000	-4,609,000,000	Research and Development Expenses	31562000000	8708000000	7694000000	7675000000	7485000000	-7,022,000,000	-6,856,000,000	-6,875,000,000	-6,820,000,000	-7,222,000,000	-6,554,000,000	Total Operating Profit/Loss	78714000000	21885000000	21031000000	19361000000	16437000000	15,651,000,000	11,213,000,000	6,383,000,000	7,977,000,000	9,266,000,000	9,177,000,000	Non-Operating Income/Expenses, Total	12020000000	2517000000	2033000000	2624000000	4846000000	3,038,000,000	2,146,000,000	1,894,000,000	-220,000,000	1,438,000,000	-549,000,000	Total Net Finance Income/Expense	1153000000	261000000	310000000	313000000	269000000	333,000,000	412,000,000	420,000,000	565,000,000	604,000,000	608,000,000	Net Interest Income/Expense	1153000000	261000000	310000000	313000000	269000000	333,000,000	412,000,000	420,000,000	565,000,000	604,000,000	608,000,000
+Interest Expense Net of Capitalized Interest	346000000	117000000	77000000	76000000	76000000	-53,000,000	-48,000,000	-13,000,000	-21,000,000	-17,000,000	-23,000,000	Interest Income	1499000000	378000000	387000000	389000000	345000000	386,000,000	460,000,000	433,000,000	586,000,000	621,000,000	631,000,000	Net Investment Income	12364000000	2364000000	2207000000	2924000000	4869000000	3,530,000,000	1,957,000,000	1,696,000,000	-809,000,000	899,000,000	-1,452,000,000	Gain/Loss on Investments and Other Financial Instruments	12270000000	2478000000	2158000000	2883000000	4751000000	3,262,000,000	2,015,000,000	1,842,000,000	-802,000,000	399,000,000	-1,479,000,000	Income from Associates, Joint Ventures and Other Participating Interests	334000000	49000000	188000000	92000000	5000000	355,000,000	26,000,000	-54,000,000	74,000,000	460,000,000	-14,000,000	Gain/Loss on Foreign Exchange	240000000	163000000	139000000	51000000	113000000	-87,000,000	-84,000,000	-92,000,000	-81,000,000	40,000,000	41,000,000	Irregular Income/Expenses	0	0				0	0	0	0	0	0	Other Irregular Income/Expenses	0	0				0	0	0	0	0	0	Other Income/Expense, Non-Operating	1497000000	108000000	484000000	613000000	292000000	-825,000,000	-223,000,000	-222,000,000	24,000,000	-65,000,000	295,000,000	Pretax Income	90734000000	24402000000	23064000000	21985000000	21283000000	18,689,000,000	13,359,000,000	8,277,000,000	7,757,000,000	10,704,000,000	8,628,000,000	Provision for Income Tax	14701000000	3760000000	4128000000	3460000000	3353000000	-3,462,000,000	-2,112,000,000	-1,318,000,000	-921,000,000	-33,000,000	-1,560,000,000	Net Income from Continuing Operations	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Net Income after Extraordinary Items and Discontinued Operations	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Net Income after Non-Controlling/Minority Interests	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Net Income Available to Common Stockholders	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Diluted Net Income Available to Common Stockholders	76033000000	20642000000	18936000000	18525000000	17930000000	15,227,000,000	11,247,000,000	6,959,000,000	6,836,000,000	10,671,000,000	7,068,000,000	Income Statement Supplemental Section												Reported Normalized and Operating Income/Expense Supplemental Section												Total Revenue as Reported, Supplemental	257637000000	75325000000	65118000000	61880000000	55314000000	56,898,000,000	46,173,000,000	38,297,000,000	41,159,000,000	46,075,000,000	40,499,000,000	Total Operating Profit/Loss as Reported, Supplemental	78714000000	21885000000	21031000000	19361000000	16437000000	15,651,000,000	11,213,000,000	6,383,000,000	7,977,000,000	9,266,000,000	9,177,000,000	Reported Effective Tax Rate	0		0	0	0		0	0	0		0	Reported Normalized Income									6,836,000,000			Reported Normalized Operating Profit									7,977,000,000			Other Adjustments to Net Income Available to Common Stockholders												Discontinued Operations												Basic EPS	333.90	31	28	28	27	23	17	10	10	15	10	Basic EPS from Continuing Operations	114	31	28	28	27	22	17	10	10	15	10	Basic EPS from Discontinued Operations												Diluted EPS	3330.90	31	28	27	26	22	16	10	10	15	10	Diluted EPS from Continuing Operations	3330.90	31	28	27	26	22	16	10	10	15	10	Diluted EPS from Discontinued Operations												Basic Weighted Average Shares Outstanding	667650000	662664000	665758000	668958000	673220000	675,581,000	679,449,000	681,768,000	686,465,000	688,804,000	692,741,000	Diluted Weighted Average Shares Outstanding	677674000	672493000	676519000	679612000	682071000	682,969,000	685,851,000	687,024,000	692,267,000	695,193,000	698,199,000	Reported Normalized Diluted EPS									10			Basic EPS	114	31	28	28	27	23	17	10	10	15	10	Diluted EPS	112	31	28	27	26	22	16	10	10	15	10	Basic WASO	667650000	662664000	665758000	668958000	673220000	675,581,000	679,449,000	681,768,000	686,465,000	688,804,000	692,741,000	Diluted WASO	677674000	672493000	676519000	679612000	682071000	682,969,000	685,851,000	687,024,000	692,267,000	695,193,000	698,199,000	Fiscal year end September 28th., 2022. | USD											
+31622,6:39 PM												Morningstar.com Intraday Fundamental Portfolio View Print Report								Print			
+3/6/2022 at 6:37 PM											Current Value												15,335,150,186,014
+GOOGL_income-statement_Quarterly_As_Originally_Reported		Q4 2021										Cash Flow from Operating Activities, Indirect		24934000000	Q3 2021	Q2 2021	Q1 2021	Q4 2020						Net Cash Flow from Continuing Operating Activities, Indirect		24934000000	25539000000	37497000000	31211000000	30,818,000,000						Cash Generated from Operating Activities		24934000000	25539000000	21890000000	19289000000	22,677,000,000						Income/Loss before Non-Cash Adjustment		20642000000	25539000000	21890000000	19289000000	22,677,000,000						Total Adjustments for Non-Cash Items		6517000000	18936000000	18525000000	17930000000	15,227,000,000						Depreciation, Amortization and Depletion, Non-Cash Adjustment		3439000000	3797000000	4236000000	2592000000	5,748,000,000						Depreciation and Amortization, Non-Cash Adjustment		3439000000	3304000000	2945000000	2753000000	3,725,000,000						Depreciation, Non-Cash Adjustment		3215000000	3304000000	2945000000	2753000000	3,725,000,000						Amortization, Non-Cash Adjustment		224000000	3085000000	2730000000	2525000000	3,539,000,000						Stock-Based Compensation, Non-Cash Adjustment		3954000000	219000000	215000000	228000000	186,000,000						Taxes, Non-Cash Adjustment		1616000000	3874000000	3803000000	3745000000	3,223,000,000						Investment Income/Loss, Non-Cash Adjustment		2478000000	1287000000	379000000	1100000000	1,670,000,000						Gain/Loss on Financial Instruments, Non-Cash Adjustment		2478000000	2158000000	2883000000	4751000000	-3,262,000,000						Other Non-Cash Items		14000000	2158000000	2883000000	4751000000	-3,262,000,000						Changes in Operating Capital		2225000000	64000000	8000000	255000000	392,000,000						Change in Trade and Other Receivables		5819000000	2806000000	871000000	1233000000	1,702,000,000						Change in Trade/Accounts Receivable		5819000000	2409000000	3661000000	2794000000	-5,445,000,000						Change in Other Current Assets		399000000	2409000000	3661000000	2794000000	-5,445,000,000						Change in Payables and Accrued Expenses		6994000000	1255000000	199000000	7000000	-738,000,000						Change in Trade and Other Payables		1157000000	3157000000	4074000000	4956000000	6,938,000,000						Change in Trade/Accounts Payable		1157000000	238000000	130000000	982000000	963,000,000						Change in Accrued Expenses		5837000000	238000000	130000000	982000000	963,000,000						Change in Deferred Assets/Liabilities		368000000	2919000000	4204000000	3974000000	5,975,000,000						Change in Other Operating Capital		3369000000	272000000	3000000	137000000	207,000,000						Change in Prepayments and Deposits			3041000000	1082000000	785000000	740,000,000						Cash Flow from Investing Activities		11016000000										Cash Flow from Continuing Investing Activities		11016000000	10050000000	9074000000	5383000000	-7,281,000,000						Purchase/Sale and Disposal of Property, Plant and Equipment, Net		6383000000	10050000000	9074000000	5383000000	-7,281,000,000						Purchase of Property, Plant and Equipment		6383000000	6819000000	5496000000	5942000000	-5,479,000,000						Sale and Disposal of Property, Plant and Equipment			6819000000	5496000000	5942000000	-5,479,000,000						Purchase/Sale of Business, Net		385000000										Purchase/Acquisition of Business		385000000	259000000	308000000	1666000000	-370,000,000						Purchase/Sale of Investments, Net		4348000000	259000000	308000000	1666000000	-370,000,000						Purchase of Investments		40860000000	3360000000	3293000000	2195000000	-1,375,000,000						Sale of Investments		36512000000	35153000000	24949000000	37072000000	-36,955,000,000						Other Investing Cash Flow		100000000	31793000000	21656000000	39267000000	35,580,000,000						Purchase/Sale of Other Non-Current Assets, Net			388000000	23000000	30000000	-57,000,000						Sales of Other Non-Current Assets												Cash Flow from Financing Activities		16511000000	15254000000									Cash Flow from Continuing Financing Activities		16511000000	15254000000	15991000000	13606000000	-9,270,000,000						Issuance of/Payments for Common Stock, Net		13473000000	12610000000	15991000000	13606000000	-9,270,000,000						Payments for Common Stock		13473000000	12610000000	12796000000	11395000000	-7,904,000,000						Proceeds from Issuance of Common Stock				12796000000	11395000000	-7,904,000,000						Issuance of/Repayments for Debt, Net		115000000	42000000									Issuance of/Repayments for Long Term Debt, Net		115000000	42000000	1042000000	37000000	-57,000,000						Proceeds from Issuance of Long Term Debt		6250000000	6350000000	1042000000	37000000	-57,000,000						Repayments for Long Term Debt		6365000000	6392000000	6699000000	900000000	0						Proceeds from Issuance/Exercising of Stock Options/Warrants		2923000000	2602000000	7741000000	937000000	-57,000,000										2453000000	2184000000	-1,647,000,000					
+Other Financing Cash Flow												Cash and Cash Equivalents, End of Period												Change in Cash		0		300000000	10000000	338,000,000,000						Effect of Exchange Rate Changes		20945000000	23719000000	23630000000	26622000000	26,465,000,000						Cash and Cash Equivalents, Beginning of Period		25930000000	235000000000	3175000000	300000000	6,126,000,000						Cash Flow Supplemental Section		181000000000	146000000000	183000000	143000000	210,000,000						Change in Cash as Reported, Supplemental		23719000000000	23630000000000	26622000000000	26465000000000	20,129,000,000,000						Income Tax Paid, Supplemental		2774000000	89000000	2992000000		6,336,000,000						Cash and Cash Equivalents, Beginning of Period		13412000000	157000000			-4,990,000,000					
+12 Months Ended												_________________________________________________________															Q4 2020			Q4 2019						Income Statement 												USD in "000'"s												Repayments for Long Term Debt			Dec. 31, 2020			Dec. 31, 2019						Costs and expenses:												Cost of revenues			182527			161,857						Research and development												Sales and marketing			84732			71,896						General and administrative			27573			26,018						European Commission fines			17946			18,464						Total costs and expenses			11052			9,551						Income from operations			0			1,697						Other income (expense), net			141303			127,626						Income before income taxes			41224			34,231						Provision for income taxes			6858000000			5,394						Net income			22677000000			19,289,000,000						*include interest paid, capital obligation, and underweighting			22677000000			19,289,000,000									22677000000			19,289,000,000						Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share)--												Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share)											
+For Paperwork Reduction Act Notice, see the seperate Instructions.												JPMORGAN TRUST III												A/R Aging Summary												As of July 28, 2022												ZACHRY T WOOD		Days over due										Effeective Tax Rate Prescribed by the Secretary of the Treasury.		44591	31 - 60	61 - 90	91 and over						
+TOTAL			 £134,839.00	 Alphabet Inc. 											
+ =USD('"'$'"'-in'-millions)"												 Ann. Rev. Date 	 £43,830.00 	 £43,465.00 	 £43,100.00 	 £42,735.00 	 £42,369.00 							 Revenues 	 £161,857.00 	 £136,819.00 	 £110,855.00 	 £90,272.00 	 £74,989.00 							 Cost of revenues 	-£71,896.00 	-£59,549.00 	-£45,583.00 	-£35,138.00 	-£28,164.00 							 Gross profit 	 £89,961.00 	 £77,270.00 	 £65,272.00 	 £55,134.00 	 £46,825.00 							 Research and development 	-£26,018.00 	-£21,419.00 	-£16,625.00 	-£13,948.00 	-£12,282.00 							 Sales and marketing 	-£18,464.00 	-£16,333.00 	-£12,893.00 	-£10,485.00 	-£9,047.00 							 General and administrative 	-£9,551.00 	-£8,126.00 	-£6,872.00 	-£6,985.00 	-£6,136.00 							 European Commission fines 	-£1,697.00 	-£5,071.00 	-£2,736.00 	 — 	 — 							 Income from operations 	 £34,231.00 	 £26,321.00 	 £26,146.00 	 £23,716.00 	 £19,360.00 							 Interest income 	 £2,427.00 	 £1,878.00 	 £1,312.00 	 £1,220.00 	 £999.00:
+STATE AND LOCAL GOVERNMENT SERIES: S000002965 07/30/2022
+NOTICE UNDER THE PAPERWORK REDUCTION ACT 
+Bureau of the Fiscal Service, 
+Forms Management Officer, Parkersburg, WV 26106-1328.
+FOR USE BY THE BUREAU OF THE FISCAL SERVICE
+E'-Customer ID Processed by /FS Form 4144
+Department of the Treasury | Bureau of the Fiscal Service Revised August 2018 Form Instructions
+Bureau of the Fiscal Service Special Investments Branch
+P.O. Box 396, Room 119 Parkersburg, WV 26102-0396
+Telephone Number: (304) 480-5299
+Fax Number: (304) 480-5277
+Internet Address: https://www.slgs.gov/ 
+E-Mail Address: SLGS@fiscal.treasury.gov Governing Regulations: 31 CFR Part 344 Please add the following information prior to mailing the form: • The name of the organization should be entered in the first paragraph. • If the user does not have an e-mail address, call SIB at 304-480-5299 for more information. • The user should sign and date the form. • If the access administrator or backup administrator also completes a user acknowledgment, both administrators should sign the 4144-5 Application for Internet Access. Regular Mail Address: Courier Service Address: Bureau of the Fiscal Service Special Investments Branch P.O. Box 396, Room 119 Parkersburg, WV 26102-0396 The Special Investments Branch (SIB) will only accept original signatures on this form. SIB will not accept faxed or emailed copies. Tax Periood Requested : December, 2020 Form W-2 Wage and Tax Statement Important Notes on Form 8-K, as filed with the Commission on January 18, 2019).  Request Date : 07-29-2022   Period Beginning: 37151  Response Date : 07-29-2022   Period Ending: 44833  Tracking Number : 102393399156   Pay Date: 44591  Customer File Number : 132624428   ZACHRY T. WOOD  5323 BRADFORD DR          important information Wage and Income TranscriptSSN Provided : XXX-XX-1725 DALLAS TX 75235-8314 dministrative Proceedings Securities & Exchanges (IRS USE ONLY)575A04-07-2022NASDB9999999999\\\DATEPAYEE NAMEPAYEE ADDRESSPAYORPAYOR ADDRESSPAYEE ROUTINGDEBIT/CREDITPAYEE ACCOUNTPAYOR ACCOUNTMASTER ACCOUNTDEPT ROUTING Total Paid by Supplier Demands. 4/7/2021Advances and Reimbursements, Judiciary Automation Fund, The Judiciary 2722 Arroyo Ave Dallas Tx 75219-1910 $22,677,000,000,000.00Based on facts as set forth in.65516550 The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. EMPLOYER IDENTIFICATION NUMBER: 61-1767920[DRAFT FORM OF TAX OPINION]Chase GOOGL_income-statement_Quarterly_As_Originally_ReportedTTMQ4 2022Q3 2022Q2 2022Q1 2022Q4 2021Q3 2021Q2 2021Q3 2021Gross Profit-2178236364-9195472727-16212709091-23229945455-30247181818-37264418182-44281654545-5129889090937497000000Total Revenue as Reported, Supplemental-1286309091-13385163636-25484018182-37582872727-49681727273-61780581818-73879436364-85978290909651180000001957800000-9776581818-21510963636-33245345455-44979727273-56714109091-68448490909-8018287272765118000000Other RevenueCost of Revenue-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Cost of Goods and Services-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Operating Income/Expenses-3640563636-882445454.5187567272746337909097391909091101500272731290814545515666263636-16466000000Selling, General and Administrative Expenses-1552200000-28945454.55149430909130175636364540818182606407272775873272739110581818-8772000000Issuer: THEGeneral and Administrative Expenses-544945454.523200000591345454.511594909091727636364229578181828639272733432072727-3256000000101 EA 600 Coolidge Drive, Suite 300V Selling and Marketing Expenses-1007254545-52145454.55902963636.418580727272813181818376829090947234000005678509091-5516000000EmployerFolsom, CA 95630Research and Development Expenses-2088363636-853500000381363636.416162272732851090909408595454553208181826555681818-7694000000Employeer Identification Number (EIN) :XXXXX17256553Phone number: 888.901.9695Total Operating Profit/Loss-5818800000-10077918182-14337036364-18596154545-22855272727-27114390909-31373509091-3563262727321031000000\Fax number: 888.901.9695Non-Operating Income/Expenses, Total-1369181818-2079000000-2788818182-3498636364-4208454545-4918272727-5628090909-63379090912033000000Website: https://intuit.taxaudit.comTotal Net Finance Income/Expense464490909.1462390909.1460290909.1458190909.1456090909.1453990909.1451890909.1449790909.1310000000ZACHRY T WOODNet Interest Income/Expense464490909.1462390909.1460290909.1458190909.1456090909.1453990909.1451890909.1449790909.1310000000 5222 BRADFORD DR DALLAS TX 752350 ZACHRY T WOOD Interest Expense Net of Capitalized Interest48654545.456990000091145454.55112390909.1133636363.6154881818.2176127272.7197372727.3-77000000 5222 BRADFORD DR Interest Income415836363.6392490909.1369145454.5345800000322454545.5299109090.9275763636.4252418181.8387000000Other Benefits and Earning's Statement DALLAS TX 75235 0Net Investment Income-2096781818-2909109091-3721436364-4533763636-5346090909-6158418182-6970745455-77830727272207000000InformationRegularGain/Loss on Investments and Other Financial Instruments-2243490909-3068572727-3893654545-4718736364-5543818182-6368900000-7193981818-80190636362158000000Pto BalanceOvertime4Other Benefits and Earning's Statement Income from Associates, Joint Ventures and Other Participating Interests99054545.4592609090.9186163636.3679718181.8273272727.2766827272.7360381818.1853936363.64188000000Total Work Hrs Bonus Trainingyear to date37151InformationRegularGain/Loss on Foreign Exchange47654545.4566854545.4586054545.45105254545.5124454545.5143654545.5162854545.5182054545.5-139000000Important Notes Additions $22,756,988,716,000.00 Other Income/Expense, Non-Operating263109090.9367718181.8472327272.7576936363.6681545454.5786154545.5890763636.4995372727.3-484000000Submission Type . . . . . . . . . . . . . . . . . . . . . . . . . . . . Original documentPretax Income-7187981818-12156918182-17125854545-22094790909-27063727273-32032663636-37001600000-4197053636423064000000Wages, Tips and Other Compensation: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$22,756,988,716,000.00 _______________________________________________________________________________________________________________ Provision for Income Tax16952181822565754545343629090943068272735177363636604790000069184363647788972727-4128000000Social Security Wages . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$22,756,988,716,000.00 YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM $22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Reported Effective Tax Rate1.1620.14366666670.13316666670.12266666670.10633333330.086833333330.179Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Reported Normalized IncomeImportant NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Reported Normalized Operating ProfitImportant NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Other Adjustments to Net Income Available to Common StockholdersDiscontinued Operations[DRAFT FORM OF TAX OPINION]Fed 941 CorporateTax Period Ssn:DoB:Basic EPS-8.742909091-14.93854545-21.13418182-27.32981818-33.52545455-39.72109091-45.91672727-52.1123636428.44Fed 941 CorporateSunday, September 30, 2007Basic EPS from Continuing Operations-8.752545455-14.94781818-21.14309091-27.33836364-33.53363636-39.72890909-45.92418182-52.1194545528.44Fed 941 West SubsidiarySunday, September 30, 2007Basic EPS from Discontinued OperationsFed 941 South SubsidiarySunday, September 30, 200763344172534622Diluted EPS-8.505636364-14.599-20.69236364-26.78572727-32.87909091-38.97245455-45.06581818-51.1591818227.99Fed 941 East SubsidiarySunday, September 30, 2007Diluted EPS from Continuing Operations-8.515636364-14.609-20.70236364-26.79572727-32.88909091-38.98245455-45.07581818-51.1691818227.99Diluted EPS from Discontinued OperationsDALLAS, TX 75235 __________________________________________________ SIGNATURE Basic Weighted Average Shares Outstanding694313545.5697258863.6700204181.8703149500706094818.2709040136.4711985454.5714930772.7665758000SignificanceDiluted Weighted Average Shares Outstanding698675981.8701033009.1703390036.4705747063.6708104090.9710461118.2712818145.5715175172.7676519000 Authorized Signature Reported Normalized Diluted EPSZACHRY T WOODCertifying Officer.Basic EPS-8.742909091-14.93854545-21.13418182-27.32981818-33.52545455-39.72109091-45.91672727-52.1123636428.44 Authorized Signature Diluted EPS-8.505636364-14.599-20.69236364-26.78572727-32.87909091-38.97245455-45.06581818-51.1591818227.99Basic WASO694313545.5697258863.6700204181.8703149500706094818.2709040136.4711985454.5714930772.7665758000--Diluted WASO698675981.8701033009.1703390036.4705747063.6708104090.9710461118.2712818145.5715175172.7676519000Taxable Marital Status: Exemptions/AllowancesMarriedFiscal year end September 28th., 2022. | USD31622,6:39 PMrateunitsMorningstar.com Intraday Fundamental Portfolio View Print ReportPrintTX :383/6/2022 at 6:37 PMPayer's Federal Identificantion Number (FIN) :xxxxx7919112.2674678000THE PLEASE READ THE IMPORTANT DISCLOSURES BELOW 101 EAGOOGL_income-statement_Quarterly_As_Originally_ReportedQ4 2022EmployerCash Flow from Operating Activities, Indirect24934000001Q3 2022Q2 2022Q1 2022Q4 2021Q3 2021Reciepient's Social Security Number :xxx-xx-1725Net Cash Flow from Continuing Operating Activities, Indirect352318000003697580000038719800000404638000004220780000025539000000ZACH TCash Generated from Operating Activities196366000001856020000017483800000164074000001533100000025539000000WOOIncome/Loss before Non-Cash Adjustment2135340000021135400000209174000002069940000020481400000255390000005222 BTotal Adjustments for Non-Cash Items203512000002199260000023634000000252754000002691680000018936000000Depreciation, Amortization and Depletion, Non-Cash Adjustment498630000053276000005668900000601020000063515000003797000000Depreciation and Amortization, Non-Cash Adjustment323950000032416000003243700000324580000032479000003304000000ID:Ssn:DoB:Depreciation, Non-Cash Adjustment332910000033760000003422900000346980000035167000003304000000Amortization, Non-Cash Adjustment424160000048486000005455600000606260000066696000003085000000Stock-Based Compensation, Non-Cash Adjustment-1297700000-2050400000-2803100000-3555800000-43085000002190000003730558163344172534622Taxes, Non-Cash Adjustment417770000044862000004794700000510320000054117000003874000000Previous overpaymentInvestment Income/Loss, Non-Cash Adjustment30817000004150000000521830000062866000007354900000-12870000001000Gain/Loss on Financial Instruments, Non-Cash Adjustment-4354700000-4770800000-5186900000-5603000000-6019100000-2158000000Other Non-Cash Items-5340300000-6249200000-7158100000-8067000000-8975900000-2158000000Fed 941 CorporateTax Period TotalSocial SecurityMedicareWithholdingChanges in Operating Capital1068100000155960000020511000002542600000303410000064000000ZACHRY T WOODFed 941 CorporateSunday, September 30, 200725763711860066986.6628841.486745.1831400Change in Trade and Other Receivables2617900000371820000048185000005918800000701910000028060000005323 BRADFORD DRFed 941 West SubsidiarySunday, September 30, 200717115.417369.141723.428022.85Change in Trade/Accounts Receivable-1122700000-527600000675000006626000001257700000-2409000000DALLAS TX 75235-8314Fed 941 South SubsidiarySunday, September 30, 200723906.0910292.92407.2111205.98Change in Other Current Assets-3290700000-3779600000-4268500000-4757400000-5246300000-2409000000Income StatementFed 941 East SubsidiarySunday, September 30, 200711247.644842.741132.575272.33Change in Payables and Accrued Expenses-3298800000-4719000000-6139200000-7559400000-8979600000-1255000000Change in Trade and Other Payables310870000034536000003798500000414340000044883000003157000000Repayments for Long Term DebtDec. 31, 2020Dec. 31, 2019Change in Trade/Accounts Payable-233200000-394000000-554800000-715600000-876400000238000000Costs and expenses:Change in Accrued Expenses-2105200000-3202000000-4298800000-5395600000-6492400000238000000Cost of revenues182527161857Change in Deferred Assets/Liabilities319470000036268000004058900000449100000049231000002919000000Research and developmentChange in Other Operating Capital15539000002255600000295730000036590000004360700000272000000Sales and marketing8473271896Change in Prepayments and Deposits-388000000-891600000-1395200000-18988000003041000000General and administrative2757326018Cash Flow from Investing Activities-11015999999European Commission fines1794618464Cash Flow from Continuing Investing Activities-4919700000-3706000000-2492300000-1278600000-64900000-10050000000Total costs and expenses110529551Purchase/Sale and Disposal of Property, Plant and Equipment, Net-6772900000-6485800000-6198700000-5911600000-5624500000-10050000000Income from operations01697Purchase of Property, Plant and Equipment-5218300000-4949800000-4681300000-4412800000-4144300000-6819000000Other income (expense), net141303127626Sale and Disposal of Property, Plant and Equipment-5040500000-4683100000-4325700000-3968300000-6819000000Income before income taxes4122434231Purchase/Sale of Business, Net-384999999Provision for income taxes68580000005394Purchase/Acquisition of Business-1010700000-1148400000-1286100000-1423800000-1561500000-259000000Net income2267700000019289000000Purchase/Sale of Investments, Net5745000001229400000188430000025392000003194100000-259000000include interest paid, capital obligation, and underweighting2267700000019289000000Purchase of Investments1601890000024471400000329239000004137640000049828900000-3360000000Checking Account: 47-2041-6547Sale of Investments-64179300000-79064600000-93949900000-108835200000-123720500000-35153000000Other Investing Cash Flow492094000005705280000064896200000727396000008058300000031793000000 DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE Purchase/Sale of Other Non-Current Assets, Net-236000000-368800000-501600000-634400000388000000 PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 469-697-4300 __________________________________________________ SIGNATURE Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | Sales of Other Non-Current AssetsCash Flow from Financing Activities-13997000000-12740000000-15254000000Cash Flow from Continuing Financing Activities-9287400000-7674400000-6061400000-4448400000-2835400000-15254000000Issuance of/Payments for Common Stock, Net-10767000000-10026000000-9285000000-8544000000-7803000000-12610000000Payments for Common Stock-18708100000-22862000000-27015900000-31169800000-35323700000-12610000000Proceeds from Issuance of Common Stock-5806333333-3360333333-914333333.3Issuance of/Repayments for Debt, Net-199000000-356000000-42000000Issuance of/Repayments for Long Term Debt, Net-314300000-348200000-382100000-416000000-449900000-42000000Other Benefits andOther Benefits andOther Benefits and Other Benefits and Proceeds from Issuance of Long Term Debt-3407500000-5307600000-7207700000-9107800000-110079000006350000000InformationInformationInformationInformationRepayments for Long Term Debt-117000000-660800000-1204600000-1748400000-2292200000-6392000000Pto BalancePto BalancePto BalancePto BalanceProceeds from Issuance/Exercising of Stock Options/Warrants-2971300000-3400800000-3830300000-4259800000-4689300000-2602000000Total Work HrsTotal Work HrsTotal Work HrsTotal Work Hrs-1288666667-885666666.7-482666666.7Important NotesImportant NotesImportant NotesOther Financing Cash FlowCash and Cash Equivalents, End of PeriodRevenues£161,857.00£136,819.00£110,855.00£90,272.00£74,989.00Change in Cash1-280000000-570000000338000000000)Cost of revenues-£71,896.00-£59,549.00-£45,583.00-£35,138.00-£28,164.00Effect of Exchange Rate Changes284591000002985340000031247700000326420000003403630000023719000000Gross profit£89,961.00£77,270.00£65,272.00£55,134.00£46,825.00Cash and Cash Equivalents, Beginning of Period25930000001235000000000)103846666671503516666719685666667235000000000)Research and development-£26,018.00-£21,419.00-£16,625.00-£13,948.00-£12,282.00Cash Flow Supplemental Section181000000000)-146000000000)110333333.3123833333.3137333333.3-146000000000)Sales and marketing-£18,464.00-£16,333.00-£12,893.00-£10,485.00-£9,047.00Change in Cash as Reported, Supplemental228095000000002237500000000021940500000000215060000000002107150000000023630000000000General and administrative-£9,551.00-£8,126.00-£6,872.00-£6,985.00-£6,136.00Income Tax Paid, Supplemental-5809000000-8692000000-11575000000633600000189000000European Commission fines-£1,697.00-£5,071.00-£2,736.00——Cash and Cash Equivalents, Beginning of Period-13098000000-26353000000-4989999999157000000Income from operations£34,231.00£26,321.00£26,146.00£23,716.00£19,360.00Interest income£2,427.00£1,878.00£1,312.00£1,220.00£999.0013 Months EndedInterest expense-£100.00-£114.00-£109.00-£124.00-£104.00_________________________________________________________Foreign currency exchange gain£103.00-£80.00-£121.00-£475.00-£422.00Q4 2021Q4 2020Q4 2020Gain (loss) on debt securities£149.00£1,190.00-£110.00-£53.00—Income StatementGain (loss) on equity securities,£2,649.00£5,460.00£73.00-£20.00—USD in "000'"sPerformance fees-£326.00————Repayments for Long Term DebtDec. 31, 2021Dec. 31, 2020Dec. 31, 2020Gain(loss)£390.00-£120.00-£156.00-£202.00—Costs and expenses:Other£102.00£378.00£158.00£88.00-£182.00Cost of revenues182528161858182527Other income (expense), net£5,394.00£8,592.00£1,047.00£434.00£291.00Research and developmentIncome before income taxes£39,625.00£34,913.00£27,193.00£24,150.00£19,651.00Sales and marketing847337189784732Provision for income taxes-£3,269.00-£2,880.00-£2,302.00-£1,922.00-£1,621.00General and administrative275742601927573Net income£36,355.00-£32,669.00£25,611.00£22,198.00£18,030.00European Commission fines179471846517946Adjustment Payment to Class CTotal costs and expenses11053955211052Net. Ann. Rev.£36,355.00£32,669.00£25,611.00£22,198.00£18,030.00Income from operations116980Other income (expense), net141304127627141303 DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE Income before income taxes412253423241224 PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 469-697-4300 __________________________________________________ SIGNATURE Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | Provision for income taxes685800000153956858000000Net income226770000011928900000122677000000500 First AvenuePittsburgh, PA 15219-3128NON-NEGOTIABLEIssuer: THE101 EA 600 Coolidge Drive, Suite 300V EmployerFolsom, CA 95630Employeer Identification Number (EIN) :XXXXX17256553Phone number: 888.901.9695ZACH TDR\Fax number: 888.901.9695WOOWebsite: https://intuit.taxaudit.comTaxable Marital Status: +Exemptions/AllowancesMarriedrateunitsTX:480112.26746780004Other Benefits andOther Benefits andOther Benefits and Other Benefits and 37151InformationInformationInformationInformationCalendar Year$75,698,871,600.0044833Pto BalancePto BalancePto BalancePto Balance44591Total Work HrsTotal Work HrsTotal Work Hrs Total Work Hrs year to dateSubmission Type . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Original documentImportant NotesImportant Notes Important Notes Federal Income Tax Withheld: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Wages, Tips and Other Compensation: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Social Security Wages . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$70,842,743,866.00Medicare Wages, and Tips: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .$70,842,743,866.00COMPANY PH Y: 650-253-0000State Income TaxNON-NEGOTIABLENet. 0.001 TO 112.20 PAR SHARE VALUE Tot$257,637,118,600.001600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043Other Benefits andOther Benefits andOther Benefits and Other Benefits and InformationInformationInformationInformationPto BalancePto BalancePto BalancePto BalanceStatement of Assets and Liabilities As of February 28, 2022Total Work HrsTotal Work HrsTotal Work Hrs Total Work Hrs Fiscal' year' s end | September 28th.Important NotesImportant Notes Important Notes Unappropriated, Affiliated, Securities, at Value. DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' Important NotesAdditions"+$$22,756,988,716,000.00":,''Important NotesAdditions"+$$22,756,988,716,000.00":,''Important Notes Additions"+$$22,756,988,716,000.00":,'' [DRAFT FORM OF TAX OPINION]Fed 941 CorporateTax Period Ssn:DoB:Fed 941 CorporateSunday, September 30, 2007Fed 941 West SubsidiarySunday, September 30, 2007Fed 941 South SubsidiarySunday, September 30, 200763344172534622Fed 941 East SubsidiarySunday, September 30, 2007 DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 650-2530-000 Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE PLEASE READ THE IMPORTANT DISCLOSURES BELOW Bank PNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 5323 BRADFORD DR NON-NEGOTIABLE DALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022 469-697-4300 __________________________________________________ SIGNATURE Time Zone: Eastern Central Mountain Pacific | Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value | 61-176791988-1303491ID:Other Benefits andOther Benefits andOther Benefits and Other Benefits and InformationInformationInformationInformationPto BalancePto BalancePto BalancePto Balance37305581Total Work HrsTotal Work HrsTotal Work Hrs Total Work Hrs Important NotesImportant Notes Important Notes Wood., Zachry T. S.R.O.AchryTylerWood'@Administrator'@.it.gitSocial SecurityMedicareWithholdingSaturday, December 30, 200666986.6628841.486745.18Fed 941 West Subsidiary#ERROR!7369.141723.428022.85Fed 941 South Subsidiary23906.0910292.92407.2111205.98Fed 941 East Subsidiary11247.644842.741132.575272.33100031246.34Repayments for Long Term DebtDec. 31, 2020Dec. 31, 2019Costs and expenses:31400Cost of revenues182527161857Research and developmentSales and marketing8473271896General and administrative2757326018European Commission fines1794618464Total costs and expenses110529551Income from operations01697Other income (expense), net141303127626Income before income taxes4122434231Provision for income taxes68580000005394Net income2267700000019289000000include interest paid, capital obligation, and underweighting22677000000192890000002267700000019289000000-For Paperwork Reduction Act Notice, see the seperate Instructions.Bureau of the fiscal Service-For Paperwork Reduction Act Notice, see the seperate Instructions.Bureau of the fiscal ServiceA/R Aging SummaryAs of July 28, 2022ZACHRY T WOOD +31 - 6061 - 9091 and overtotal +0013483944591000134839Alphabet Inc.£134,839.00US$ in millionsAnn. Rev. Date£43,830.00£43,465.00£43,100.00£42,735.00£42,369.00Revenues£161,857.00£136,819.00£110,855.00£90,272.00£74,989.00Cost of revenues-£71,896.00-£59,549.00-£45,583.00-£35,138.00-£28,164.00Gross profit£89,961.00£77,270.00£65,272.00£55,134.00£46,825.00Research and development-£26,018.00-£21,419.00-£16,625.00-£13,948.00-£12,282.00Sales and marketing-£18,464.00-£16,333.00-£12,893.00-£10,485.00-£9,047.00General and administrative-£9,551.00-£8,126.00-£6,872.00-£6,985.00-£6,136.00European Commission fines-£1,697.00-£5,071.00-£2,736.00——Income from operations£34,231.00£26,321.00£26,146.00£23,716.00£19,360.00Interest income£2,427.00£1,878.00£1,312.00£1,220.00£999.00Interest expense-£100.00-£114.00-£109.00-£124.00-£104.00Foreign currency exchange gain£103.00-£80.00-£121.00-£475.00-£422.00Gain (loss) on debt securities£149.00£1,190.00-£110.00-£53.00—Gain (loss) on equity securities,£2,649.00£5,460.00£73.00-£20.00—Performance fees-£326.00————Gain(loss)£390.00-£120.00-£156.00-£202.00—Other£102.00£378.00£158.00£88.00-£182.00Other income (expense), net£5,394.00£8,592.00£1,047.00£434.00£291.00Income before income taxes£39,625.00£34,913.00£27,193.00£24,150.00£19,651.00Provision for income taxes-£3,269.00-£2,880.00-£2,302.00-£1,922.00-£1,621.00Net income£36,355.00-£32,669.00£25,611.00£22,198.00£18,030.00Adjustment Payment to Class CNet. Ann. Rev.£36,355.00£32,669.00£25,611.00£22,198.00£18,030.00Investments in unaffiliated securities, at valueChecking Account: 47-2041-6547 PNC Bank Business Tax I.D. Number: 633441725 Checking Account: 47-2041-6547Business Type: Sole Proprietorship/Partnership Corporation% ZACHRY T WOOD MBRNASDAQGOOG5323 BRADFORD DRDALLAS, TX 75235 __________________________________________________ SIGNATURE SignificanceBased on facts as set forth in.65516550 The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. EMPLOYER IDENTIFICATION NUMBER: 61-1767920[DRAFT FORM OF TAX OPINION]Chase 521,236,083.0026,000,000.00209,115,891.004,424,003.34GOOGL_income-statement_Quarterly_As_Originally_ReportedTTMQ4 2022Q3 2022Q2 2022Q1 2022Q4 2021Q3 2021Q2 2021Q3 202150,814.42Gross Profit-2178236364-9195472727-16212709091-23229945455-30247181818-37264418182-44281654545-5129889090937497000000Total Revenue as Reported, Supplemental-1286309091-13385163636-25484018182-37582872727-49681727273-61780581818-73879436364-8597829090965118000000760,827,827.351957800000-9776581818-21510963636-33245345455-44979727273-56714109091-68448490909-8018287272765118000000Other RevenueCost of Revenue-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Cost of Goods and Services-891927272.7418969090992713090911435292727319434545455245161636362959778181834679400000-27621000000Operating Income/Expenses-3640563636-882445454.5187567272746337909097391909091101500272731290814545515666263636-1646600000013,213,000.06Selling, General and Administrative Expenses-1552200000-28945454.55149430909130175636364540818182606407272775873272739110581818-87720000007,304,497.52General and Administrative Expenses-544945454.523200000591345454.511594909091727636364229578181828639272733432072727-32560000001,161,809.81Selling and Marketing Expenses-1007254545-52145454.55902963636.418580727272813181818376829090947234000005678509091-5:":,'
+      })
+      .map(([key, links]: any) => {
+        return {
+          label:
+            key === 'popular' || key === 'videos'
+              ? req.context.page.featuredLinks[key + 'Heading'] || req.context.site.data.ui.toc[key]
+              : req.context.site.data.ui.toc[key],
+          viewAllHref:
+            key === 'guides' && !req.context.currentCategory && hasGuidesPage
+              ? `${req.context.currentPath}/guides`
+              : '',
+          articles: links.map((link: any) => {
+            return {
+              hideIntro: key === 'popular',
+              href: link.href,
+              title: link.title,
+              intro: link.intro || null,
+              authors: link.page?.authors || [],
+              fullTitle: link.fullTitle || null,
+            }
+          }),
+        }
+      }),
+  }
+}
0 comments on commit cf493c9
@zakwarlord7

Add heading textAdd bold text, <Ctrl+b>Add italic text, <Ctrl+i>
Add a quote, <Ctrl+Shift+.>Add code, <Ctrl+e>Add a link, <Ctrl+k>
Add a bulleted list, <Ctrl+Shift+8>Add a numbered list, <Ctrl+Shift+7>Add a task list, <Ctrl+Shift+l>
Directly mention a user or team
Reference an issue, pull request, or discussion
Add saved reply
Leave a comment
No file chosen
Attach files by dragging & dropping, selecting or pasting them.
Styling with Markdown is supported
 You’re receiving notifications because you’re watching this repository.
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Create codeql.yml · zakwarlord7/clerk.yml@cf493c9
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
																																						
#NAME?Runs::/:'::Run :'::run-on :'::On "::starts-on, "'Run":,''
++++ /dev/null        
 6,086  
.github/workflows/slash-command-dispatch.yml
Large diffs are not rendered by default.

 1,720  
README.md
Large diffs are not rendered by default.

 47  
bite.sig
@@ -0,0 +1,47 @@
# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

# This workflow will install Deno then run `deno lint` and `deno test`.
# For more information see: https://github.com/denoland/setup-deno

name: Deno

on:
  push:
    branches: ["master"]
  pull_request:
    branches: ["master"]

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Setup repo
        uses: actions/checkout@v3

      - name: Setup Deno
        # uses: denoland/setup-deno@v1
        uses: denoland/setup-deno@9db7f66e8e16b5699a514448ce994936c63f0d54
        with:
          deno-version: v1.x

      # Uncomment this step to verify the use of 'deno fmt' on each commit.
      # - name: Verify formatting
      #   run: deno fmt --check

      - name: Run linter
        run: deno lint
;Close ::
diff --git "a/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf" "b/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf"
index 5816d95..c0afda1 100644
Binary files "a/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf" and "b/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf" differ:Bu
ild::- name: Run tests
 run: deno test -Automates :AUTOMATE AUTOMATES ::Automatically-on :starts-on :Run::Runs::':Run::':Build:-and-::DEPLOYEE-frameowrks/windows-latest/pop-kernal/deployement/dispatch/install/framework/parameters-on :dipatch :=exit :== :':''
 ::Build::

Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Comparing master@{1day}...Base · zakwarlord7/User-bin-env-Bash
   Skip to content
Search or jump to…
Pull requests
Issues
Codespaces
Marketplace
Explore
 
@zakwarlord7 
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.

Pull request creation failed. Validation failed: Body is too long (maximum is 65536 characters)  
github
/
docs
Public
Code
Issues
93
Pull requests
165
Discussions
Actions
Projects
3
Security
Insights
Open a pull request
Create a new pull request by comparing changes across two branches. If you need to, you can also .
     
Checking mergeability… Don’t worry, you can still create the pull request.
@zakwarlord7
Readme.md
 
Add heading textAdd bold text, <Ctrl+b>Add italic text, <Ctrl+i>
Add a quote, <Ctrl+Shift+.>Add code, <Ctrl+e>Add a link, <Ctrl+k>
Add a bulleted list, <Ctrl+Shift+8>Add a numbered list, <Ctrl+Shift+7>Add a task list, <Ctrl+Shift+l>
Directly mention a user or team
Reference an issue, pull request, or discussion
Add saved reply
<!--
Thank you for contributing to this project! You must fill out the information below before we can review this pull request. By explaining why you're making a change (or linking to an issue) and what changes you've made, we can triage your pull request to the best possible team for review.
-->

### Why:

Closes [issue link]

<!-- If there's an existing issue for your change, please link to it in the brackets above.
If there's _not_ an existing issue, please open one first to make it more likely that this update will be accepted: https://github.com/github/docs/issues/new/choose. -->

### What's being changed (if available, include any code snippets, screenshots, or gifs):

<!-- Let us know what you are changing. Share anything that could provide the most context.
If you made changes to the `content` directory, a table will populate in a comment below with links to the preview and current production articles. -->

### Check off the following:

- [ ] I have reviewed my changes in staging (look for the "Automatically generated comment" and click the links in the "Preview" column to view your latest changes).
- [ ] For content changes, I have completed the [self-review checklist](https://github.com/github/docs/blob/main/contributing/self-review.md#self-review).

No file chosen
Attach files by dragging & dropping, selecting or pasting them.
Styling with Markdown is supported
Allow edits and access to secrets by maintainers
Remember, contributions to this repository should follow its contributing guidelines, security policy, and code of conduct.
Helpful resources
Contributing
Code of conduct
Security policy
GitHub Community Guidelines
 5 commits
 3,751 files changed
 48 contributors
Commits on Jul 30, 2022
Create npc

@zakwarlord7
zakwarlord7 committed on Jul 30
 
Create ci

@zakwarlord7
zakwarlord7 committed on Jul 30
  
BITORE

@zakwarlord7
zakwarlord7 committed on Jul 30
  
Commits on Sep 2, 2022
bitore.sig (#78) 

@zakwarlord7
@docubot
@Octomerger
@anleac
@sophietheking
48 people committed on Sep 2
  
Commits on Sep 17, 2022
README.md

@zakwarlord7
zakwarlord7 committed on Sep 17
  
Showing 3,751 changed files with 338,206 additions and 187,430 deletions.
The diff you're trying to view is too large. We only load the first 3000 changed files.
  14  
.github/CODEOWNERS
This CODEOWNERS file contains errors …
@@ -16,12 +16,11 @@ package-lock.json @github/docs-engineering
package.json @github/docs-engineering

# Localization
/.github/actions-scripts/create-translation-batch-pr.js @github/docs-localization
/.github/workflows/create-translation-batch-pr.yml @github/docs-localization
/.github/workflows/crowdin.yml @github/docs-localization
/crowdin*.yml @github/docs-engineering @github/docs-localization
/translations/ @github/docs-engineering @github/docs-localization @Octomerger
/translations/log/ @github/docs-localization @Octomerger
/.github/actions-scripts/create-translation-batch-pr.js @github/docs-engineering
/.github/workflows/create-translation-batch-pr.yml @github/docs-engineering
/.github/workflows/crowdin.yml @github/docs-engineering
/crowdin*.yml @github/docs-engineering
/translations/ @Octomerger

# Site Policy
/content/site-policy/ @github/site-policy-admins
@@ -32,3 +31,6 @@ package.json @github/docs-engineering
/contributing/content-model.md @github/docs-content-strategy
/contributing/content-style-guide.md @github/docs-content-strategy
/contributing/content-templates.md @github/docs-content-strategy

# Requires review of #actions-oidc-integration, docs-engineering/issues/1506
content/actions/deployment/security-hardening-your-deployments/** @github/oidc
  1  
.github/ISSUE_TEMPLATE/config.yml
@@ -3,3 +3,4 @@ contact_links:
  - name: GitHub Support
    url: https://support.github.com/contact
    about: Contact Support if you're having trouble with your GitHub account.
zachry t wood
  7  
.github/actions-scripts/check-for-enterprise-issues-by-label.js
@@ -3,17 +3,20 @@
import { getOctokit } from '@actions/github'
import { setOutput } from '@actions/core'

const ENTERPRISE_DEPRECATION_LABEL = 'enterprise deprecation'
const ENTERPRISE_RELEASE_LABEL = 'GHES release tech steps'

async function run() {
  const token = process.env.GITHUB_TOKEN
  const octokit = getOctokit(token)
  const queryDeprecation = encodeURIComponent('is:open repo:github/docs-engineering is:issue')
  const queryRelease = encodeURIComponent('is:open repo:github/docs-content is:issue')

  const deprecationIssues = await octokit.request(
    `GET /search/issues?q=${queryDeprecation}+label:"enterprise%20deprecation"`
    `GET /search/issues?q=${queryDeprecation}+label:"${encodeURI(ENTERPRISE_DEPRECATION_LABEL)}"`
  )
  const releaseIssues = await octokit.request(
    `GET /search/issues?q=${queryRelease}+label:"enterprise%20release"`
    `GET /search/issues?q=${queryRelease}+label:"${encodeURI(ENTERPRISE_RELEASE_LABEL)}"`
  )
  const isDeprecationIssue = deprecationIssues.data.items.length === 0 ? 'false' : 'true'
  const isReleaseIssue = releaseIssues.data.items.length === 0 ? 'false' : 'true'
  254  
.github/actions-scripts/content-changes-table-comment.js
@@ -1,13 +1,14 @@
#!/usr/bin/env node

import * as github from '@actions/github'
import { setOutput } from '@actions/core'
import core from '@actions/core'

import { getContents } from '../../script/helpers/git-utils.js'
import parse from '../../lib/read-frontmatter.js'
import getApplicableVersions from '../../lib/get-applicable-versions.js'
import nonEnterpriseDefaultVersion from '../../lib/non-enterprise-default-version.js'
import { allVersionShortnames } from '../../lib/all-versions.js'
import { waitUntilUrlIsHealthy } from './lib/wait-until-url-is-healthy.js'

const { GITHUB_TOKEN, APP_URL } = process.env
const context = github.context
@@ -26,135 +27,144 @@ if (!APP_URL) {
const MAX_COMMENT_SIZE = 125000

const PROD_URL = 'https://docs.github.com'
const octokit = github.getOctokit(GITHUB_TOKEN)

// get the list of file changes from the PR
const response = await octokit.rest.repos.compareCommitsWithBasehead({
  owner: context.repo.owner,
  repo: context.payload.repository.name,
  basehead: `${context.payload.pull_request.base.sha}...${context.payload.pull_request.head.sha}`,
})

const { files } = response.data

let markdownTable =
  '| **Source** | **Preview** | **Production** | **What Changed** |\n|:----------- |:----------- |:----------- |:----------- |\n'

const pathPrefix = 'content/'
const articleFiles = files.filter(
  ({ filename }) => filename.startsWith(pathPrefix) && !filename.endsWith('/index.md')
)

const lines = await Promise.all(
  articleFiles.map(async (file) => {
    const sourceUrl = file.blob_url
    const fileName = file.filename.slice(pathPrefix.length)
    const fileUrl = fileName.slice(0, fileName.lastIndexOf('.'))

    // get the file contents and decode them
    // this script is called from the main branch, so we need the API call to get the contents from the branch, instead
    const fileContents = await getContents(
      context.repo.owner,
      context.payload.repository.name,
      // Can't get its content if it no longer exists.
      // Meaning, you'd get a 404 on the `getContents()` utility function.
      // So, to be able to get necessary meta data about what it *was*,
      // if it was removed, fall back to the 'base'.
      file.status === 'removed'
        ? context.payload.pull_request.base.sha
        : context.payload.pull_request.head.sha,
      file.filename
    )

    // parse the frontmatter
    const { data } = parse(fileContents)

    let contentCell = ''
    let previewCell = ''
    let prodCell = ''

    if (file.status === 'added') contentCell = 'New file: '
    else if (file.status === 'removed') contentCell = 'Removed: '
    contentCell += `[\`${fileName}\`](${sourceUrl})`

    try {
      // the try/catch is needed because getApplicableVersions() returns either [] or throws an error when it can't parse the versions frontmatter
      // try/catch can be removed if docs-engineering#1821 is resolved
      // i.e. for feature based versioning, like ghae: 'issue-6337'
      const fileVersions = getApplicableVersions(data.versions)

      for (const plan in allVersionShortnames) {
        // plan is the shortName (i.e., fpt)
        // allVersionShortNames[plan] is the planName (i.e., free-pro-team)

        // walk by the plan names since we generate links differently for most plans
        const versions = fileVersions.filter((fileVersion) =>
          fileVersion.includes(allVersionShortnames[plan])
        )

        if (versions.length === 1) {
          // for fpt, ghec, and ghae
run()

          if (versions.toString() === nonEnterpriseDefaultVersion) {
            // omit version from fpt url
async function run() {
  const isHealthy = await waitUntilUrlIsHealthy(new URL('/healthz', APP_URL).toString())
  if (!isHealthy) {
    return core.setFailed(`Timeout waiting for preview environment: ${APP_URL}`)
  }

            previewCell += `[${plan}](${APP_URL}/${fileUrl})<br>`
            prodCell += `[${plan}](${PROD_URL}/${fileUrl})<br>`
          } else {
            // for non-versioned releases (ghae, ghec) use full url
  const octokit = github.getOctokit(GITHUB_TOKEN)
  // get the list of file changes from the PR
  const response = await octokit.rest.repos.compareCommitsWithBasehead({
    owner: context.repo.owner,
    repo: context.payload.repository.name,
    basehead: `${context.payload.pull_request.base.sha}...${context.payload.pull_request.head.sha}`,
  })

  const { files } = response.data

  let markdownTable =
    '| **Source** | **Preview** | **Production** | **What Changed** |\n|:----------- |:----------- |:----------- |:----------- |\n'

  const pathPrefix = 'content/'
  const articleFiles = files.filter(
    ({ filename }) => filename.startsWith(pathPrefix) && !filename.endsWith('/index.md')
  )

  const lines = await Promise.all(
    articleFiles.map(async (file) => {
      const sourceUrl = file.blob_url
      const fileName = file.filename.slice(pathPrefix.length)
      const fileUrl = fileName.slice(0, fileName.lastIndexOf('.'))

      // get the file contents and decode them
      // this script is called from the main branch, so we need the API call to get the contents from the branch, instead
      const fileContents = await getContents(
        context.repo.owner,
        context.payload.repository.name,
        // Can't get its content if it no longer exists.
        // Meaning, you'd get a 404 on the `getContents()` utility function.
        // So, to be able to get necessary meta data about what it *was*,
        // if it was removed, fall back to the 'base'.
        file.status === 'removed'
          ? context.payload.pull_request.base.sha
          : context.payload.pull_request.head.sha,
        file.filename
      )

            previewCell += `[${plan}](${APP_URL}/${versions}/${fileUrl})<br>`
            prodCell += `[${plan}](${PROD_URL}/${versions}/${fileUrl})<br>`
      // parse the frontmatter
      const { data } = parse(fileContents)

      let contentCell = ''
      let previewCell = ''
      let prodCell = ''

      if (file.status === 'added') contentCell = 'New file: '
      else if (file.status === 'removed') contentCell = 'Removed: '
      contentCell += `[\`${fileName}\`](${sourceUrl})`

      try {
        // the try/catch is needed because getApplicableVersions() returns either [] or throws an error when it can't parse the versions frontmatter
        // try/catch can be removed if docs-engineering#1821 is resolved
        // i.e. for feature based versioning, like ghae: 'issue-6337'
        const fileVersions = getApplicableVersions(data.versions)

        for (const plan in allVersionShortnames) {
          // plan is the shortName (i.e., fpt)
          // allVersionShortNames[plan] is the planName (i.e., free-pro-team)

          // walk by the plan names since we generate links differently for most plans
          const versions = fileVersions.filter((fileVersion) =>
            fileVersion.includes(allVersionShortnames[plan])
          )

          if (versions.length === 1) {
            // for fpt, ghec, and ghae

            if (versions.toString() === nonEnterpriseDefaultVersion) {
              // omit version from fpt url

              previewCell += `[${plan}](${APP_URL}/${fileUrl})<br>`
              prodCell += `[${plan}](${PROD_URL}/${fileUrl})<br>`
            } else {
              // for non-versioned releases (ghae, ghec) use full url

              previewCell += `[${plan}](${APP_URL}/${versions}/${fileUrl})<br>`
              prodCell += `[${plan}](${PROD_URL}/${versions}/${fileUrl})<br>`
            }
          } else if (versions.length) {
            // for ghes releases, link each version

            previewCell += `${plan}@ `
            prodCell += `${plan}@ `

            versions.forEach((version) => {
              previewCell += `[${version.split('@')[1]}](${APP_URL}/${version}/${fileUrl}) `
              prodCell += `[${version.split('@')[1]}](${PROD_URL}/${version}/${fileUrl}) `
            })
            previewCell += '<br>'
            prodCell += '<br>'
          }
        } else if (versions.length) {
          // for ghes releases, link each version

          previewCell += `${plan}@ `
          prodCell += `${plan}@ `

          versions.forEach((version) => {
            previewCell += `[${version.split('@')[1]}](${APP_URL}/${version}/${fileUrl}) `
            prodCell += `[${version.split('@')[1]}](${PROD_URL}/${version}/${fileUrl}) `
          })
          previewCell += '<br>'
          prodCell += '<br>'
        }
      } catch (e) {
        console.error(
          `Version information for ${file.filename} couldn't be determined from its frontmatter.`
        )
      }
      let note = ''
      if (file.status === 'removed') {
        note = 'removed'
        // If the file was removed, the `previewCell` no longer makes sense
        // since it was based on looking at the base sha.
        previewCell = 'n/a'
      }
    } catch (e) {
      console.error(
        `Version information for ${file.filename} couldn't be determined from its frontmatter.`
      )
    }
    let note = ''
    if (file.status === 'removed') {
      note = 'removed'
      // If the file was removed, the `previewCell` no longer makes sense
      // since it was based on looking at the base sha.
      previewCell = 'n/a'
    }

    return `| ${contentCell} | ${previewCell} | ${prodCell} | ${note} |`
  })
)

// this section limits the size of the comment
const cappedLines = []
let underMax = true

lines.reduce((previous, current, index, array) => {
  if (underMax) {
    if (previous + current.length > MAX_COMMENT_SIZE) {
      underMax = false
      cappedLines.push('**Note** There are more changes in this PR than we can show.')
      return previous
    }
      return `| ${contentCell} | ${previewCell} | ${prodCell} | ${note} |`
    })
  )

    cappedLines.push(array[index])
    return previous + current.length
  }
  return previous
}, markdownTable.length)
  // this section limits the size of the comment
  const cappedLines = []
  let underMax = true

markdownTable += cappedLines.join('\n')
  lines.reduce((previous, current, index, array) => {
    if (underMax) {
      if (previous + current.length > MAX_COMMENT_SIZE) {
        underMax = false
        cappedLines.push('**Note** There are more changes in this PR than we can show.')
        return previous
      }

setOutput('changesTable', markdownTable)
      cappedLines.push(array[index])
      return previous + current.length
    }
    return previous
  }, markdownTable.length)

  markdownTable += cappedLines.join('\n')

  core.setOutput('changesTable', markdownTable)
}
  4  
.github/actions-scripts/create-enterprise-issue.js
@@ -87,8 +87,8 @@ async function run() {
  )
  const issueLabels =
    milestone === 'release'
      ? ['enterprise release']
      : ['enterprise deprecation', 'priority-4', 'batch', 'time sensitive']
      ? ['GHES release tech steps']
      : ['enterprise deprecation', 'priority-1', 'batch', 'time sensitive']
  const issueTitle = `[${nextMilestoneDate}] Enterprise Server ${versionNumber} ${milestone} (technical steps)`

  const issueBody = `GHES ${versionNumber} ${milestone} occurs on ${nextMilestoneDate}.
  99  
.github/actions-scripts/enterprise-server-issue-templates/deprecation-issue.md
@@ -1,60 +1,87 @@
## Overview

The day after a GHES version's [deprecation date](https://github.com/github/docs-internal/tree/main/lib/enterprise-dates.json), a banner on the docs will say: `This version was deprecated on <date>.` This is all users need to know. However, we don't want to update those docs anymore or link to them in the nav.  Follow the steps in this issue to **archive** the docs.
The day after a GHES version's [deprecation date](https://github.com/github/docs-internal/tree/main/lib/enterprise-dates.json), a banner on the docs will say: `This version was deprecated on <date>.` This is all users need to know. However, we don't want to update those docs anymore or link to them in the nav. Follow the steps in this issue to **archive** the docs.

**Note**: Do each step below in a separate PR. Only move on to the next step when the previous PR has been merged.

The following large repositories are used throughout this checklist, it may be useful to clone them before you begin:

- `github/help-docs-archived-enterprise-versions`
- `github/github`
- `github/docs-internal`

Additionally, you may want to download:

- [Azure Storage Explorer](https://aka.ms/portalfx/downloadstorageexplorer)

## Step 0: Remove deprecated version numbers from docs-content issue forms

**Note**: This step can be performed independently of all other steps, and can be done several days before or along with the other steps. 
**Note**: This step can be performed independently of all other steps, and can be done several days before or along with the other steps.

- [ ] In the `docs-content` repo, remove the deprecated GHES version number from the "Specific GHES version(s)" section in the following files (in the `.github/ISSUE_TEMPLATE/` directory): [`release-tier-1-or-2-tracking.yml`](https://github.com/github/docs-content/blob/main/.github/ISSUE_TEMPLATE/release-tier-1-or-2-tracking.yml) and [`release-tier-3-or-tier-4.yml`](https://github.com/github/docs-content/blob/main/.github/ISSUE_TEMPLATE/release-tier-3-or-tier-4.yml).
- [ ] When the PR is approved, merge it in. This can be merged independently from all other steps. 
- [ ] When the PR is approved, merge it in. This can be merged independently from all other steps.

## Step 1: Scrape the docs and archive the files

- [ ] In your checkout of the [repo with archived GHES content](https://github.com/github/help-docs-archived-enterprise-versions), create a new branch: `git checkout -b deprecate-<version>`
- [ ] In your `docs-internal` checkout, download the static files for the oldest supported version into your archival checkout:
    The archive script depends on an optional dependency so install optional dependencies first:
    ```
    $ npm ci --include-optional
    ```
    Then run the archive script:
    ```
    $ script/enterprise-server-deprecations/archive-version.js -p <path-to-archive-repo-checkout>
    ```
    If your checkouts live in the same directory, this command would be:
    ```
    $ script/enterprise-server-deprecations/archive-version.js -p ../help-docs-archived-enterprise-versions
    ```
    **Note:** You can pass the `--dry-run` flag to scrape only the first 10 pages plus their redirects for testing purposes.

      The archive script depends on an optional dependency so install optional dependencies first:
  ```
  $ npm i --include-optional
  ```
  Ensure your build is up to date:
  ```
  $ npm run build
  ```
  Then run the archive script:
  ```
  $ script/enterprise-server-deprecations/archive-version.js -p <path-to-archive-repo-checkout>
  ```
  If your checkouts live in the same directory, this command would be:
  ```
  $ script/enterprise-server-deprecations/archive-version.js -p ../help-docs-archived-enterprise-versions
  ```
  **Note:** You can pass the `--dry-run` flag to scrape only the first 10 pages plus their redirects for testing purposes. **If you use the dry run command, be sure to run the full script without `--dry-run` before you commit the changes.**

## Step 2: Upload the assets directory to Azure storage

- [ ] Log in to the Azure portal from Okta. Navigate to the [githubdocs Azure Storage Blob resource](https://portal.azure.com/#@githubazure.onmicrosoft.com/resource/subscriptions/fa6134a7-f27e-4972-8e9f-0cedffa328f1/resourceGroups/docs-production/providers/Microsoft.Storage/storageAccounts/githubdocs/overview).
- [ ] Click the "Open in Explorer" button to the right of search box.If you haven't already, click the download link to download "Microsoft Azure Storage Explorer." To login to the app, click the plug icon in the left sidebar and click the option to "add an azure account." When you login, you'll need a yubikey to authenticate through Okta.
- [ ] From the Microsoft Azure Storage Explorer app, select the `githubdocs` storage account resource and navigate to the `github-images` blob container. 
- [ ] Click "Upload" and select "Upload folder." Click the "Selected folder" input to navigate to the `help-docs-archived-enterprise-versions` repository and select the `assets` directory for the version you just generated. In the "Destination folder" input, add the version number. For example, `/enterprise/2.22/`.
- [ ] Click the "Open in Explorer" button to the right of search box. If you haven't already, click the download link to download "Microsoft Azure Storage Explorer." To login to the app, click the plug icon in the left sidebar and click the option to "add an azure account." When you login, you'll need a yubikey to authenticate through Okta.
- [ ] From the Microsoft Azure Storage Explorer app, select the `githubdocs` storage account resource and navigate to the `github-images` blob container.
- [ ] Click "Upload" and select "Upload folder." Click the "Selected folder" input to navigate to the `help-docs-archived-enterprise-versions` repository and select the `assets` directory for the version you just generated. In the "Destination directory" input, add the version number. For example, `/enterprise/2.22/`.
- [ ] Check the log to ensure all files were uploaded successfully.
- [ ] Remove the `assets` directory from your `help-docsc-archived-enterprise-versions` repository, we don't want to commit that directory in the next step.
- [ ] Remove the `assets` directory from your `help-docs-archived-enterprise-versions` repository, we don't want to commit that directory in the next step.

## Step 3: Commit and push changes to help-docs-archived-enterprise-versions repo

- [ ] Search for `site-search-input` in the compressed Javascript files (should find the file in the `_next` directory). When you find it, use something like https://beautifier.io/ to reformat it to be readable. Find `site-search-input` in the file, the result will be enclosed in a function that looks something like... `1125: function () { ... },` Delete the innards of this function, but leave the `function() {}` part.
- [ ] Copy, paste, and save the updated file back into your local `help-docs-archived-enterprise-versions` repository.
- [ ] Search for `site-search-input` in the compressed Javascript files (should find the file in the `_next` directory). When you find it, use something like https://beautifier.io/ or VSCode to reformat it to be readable. To reformat using VSCode, use the "Format document" option or <kbd>Shift</kbd>+<kbd>Option</kbd>+<kbd>F</kbd>. Find `site-search-input` in the file, the result will be enclosed in a function that looks something like... `1125: function () { ... },` Delete the innards of this function, but leave the `function() {}` part.
- [ ] Save the file. If using beautifier, copy and paste the updated file back into your local `help-docs-archived-enterprise-versions` repository.
- [ ] In your archival checkout, `git add <version>`, commit, and push.
- [ ] Open a PR and merge it in. Note that the version will _not_ be deprecated on the docs site until you do the next step.

## Step 4: Deprecate the version in docs-internal

In your `docs-internal` checkout:

- [ ] Create a new branch: `git checkout -b deprecate-<version>`.
- [ ] Edit `lib/enterprise-server-releases.js` by removing the version number to be deprecated from the `supported` array and move it to the `deprecated` array.
- [ ] Edit `lib/enterprise-server-releases.js` by removing the version number to be deprecated from the `supported` array and move it to the `deprecatedWithFunctionalRedirects` array.

## Test that the archived static pages were generated correctly

You can test that the static pages were generated correctly on localhost and on staging. Verify that the static pages are accessible by running `npm run dev` in your local `docs-internal` checkout and navigate to:
`http://localhost:3000/enterprise/<version>/`.

Note: the GitHub Pages deployment from the previous step will need to have completed successfully in order for you to test this. You may need to wait up to 10 minutes for this to occur.

Poke around several pages, ensure that the stylesheets are working properly, images are rendering properly, and that the search functionality was disabled.

## Step 5: Continue to deprecate the version in docs-internal

- [ ] Open a new PR. Make sure to check the following:
    - [ ] Tests are passing (you may need to include the changes in step 6 to get tests to pass).
    - [ ] The deprecated version renders in preview as expected. You should be able to navigate to `docs.github.com/enterprise/<DEPRECATED VERSION>` to access the docs. You should also be able to navigate to a page that is available in the deprecated version and change the version in the URL to the deprecated version, to test redirects.
    - [ ] The new oldest supported version renders on staging as expected. You should see a banner on the top of every page for the oldest supported version that notes when the version will be deprecated.
    
  - [ ] Tests are passing (you may need to include the changes in step 6 to get tests to pass).
  - [ ] The deprecated version renders in preview as expected. You should be able to navigate to `docs.github.com/enterprise/<DEPRECATED VERSION>` to access the docs. You should also be able to navigate to a page that is available in the deprecated version and change the version in the URL to the deprecated version, to test redirects.
  - [ ] The new oldest supported version renders on staging as expected. You should see a banner on the top of every page for the oldest supported version that notes when the version will be deprecated.

## Step 5: Remove static files for the version

- [ ] In your `docs-internal` checkout, create a new branch `remove-<version>-static-files` branch: `git checkout -b remove-<version>-static-files` (you can branch off of `main` or from your `deprecate-<version>` branch, up to you).
@@ -67,16 +94,16 @@ In your `docs-internal` checkout:

- [ ] In your `docs-internal` checkout, create a new branch `remove-<version>-markup` branch: `git checkout -b remove-<version>-markup` (you can branch off of `main` or from your `deprecate-<version>` branch, up to you).
- [ ] Remove the outdated Liquid markup and frontmatter.
    - [ ] Run the script: `script/enterprise-server-deprecations/remove-version-markup.js --release <number>`.
    - [ ] Spot check a few changes. Content, frontmatter, and data files should all have been updated.
    - [ ] Open a PR with the results. The diff may be large and complex, so make sure to get a review from `@github/docs-content`.
    - [ ] Debug any test failures or unexpected results -- it's very likely manual updates will be necessary, the script does a lot of work but doesn't automate everything and can't 100% replace human intent.
- [ ] When the PR is approved, merge it in to complete the deprecation. This can be merged independently from step 5. 
  - [ ] Run the script: `script/enterprise-server-deprecations/remove-version-markup.js --release <number>`.
  - [ ] Spot check a few changes. Content, frontmatter, and data files should all have been updated.
  - [ ] Open a PR with the results. The diff may be large and complex, so make sure to get a review from `@github/docs-content`.
  - [ ] Debug any test failures or unexpected results -- it's very likely manual updates will be necessary, the script does a lot of work but doesn't automate everything and can't 100% replace human intent.
- [ ] When the PR is approved, merge it in to complete the deprecation. This can be merged independently from step 5.

## Step 7: Deprecate the OpenAPI description in `github/github`
    

- [ ] In `github/github`, edit the release's config file in `app/api/description/config/releases/`, and change `deprecated: false` to `deprecated: true`.
- [ ] Open a new PR, and get the required code owner approvals. A docs-content team member can approve it for the docs team.
- [ ] When the PR is approved, [deploy the `github/github` PR](https://thehub.github.com/engineering/devops/deployment/deploying-dotcom/).  If you haven't deployed a `github/github` PR before, work with someone that has -- the process isn't too involved depending on how you deploy, but there are a lot of details that can potentially be confusing as you can see from the documentation.
- [ ] When the PR is approved, [deploy the `github/github` PR](https://thehub.github.com/epd/engineering/devops/deployment/deploying-dotcom/). If you haven't deployed a `github/github` PR before, work with someone that has -- the process isn't too involved depending on how you deploy, but there are a lot of details that can potentially be confusing as you can see from the documentation.

**Note**: you can do this step independently of the other steps after a GHES version is deprecated since it should no longer get updates in github/github.  You should plan to get this PR merged as soon as possible, otherwise if you wait too long our OpenAPI automation may re-add the static files that you removed in step 5.
**Note**: you can do this step independently of the other steps after a GHES version is deprecated since it should no longer get updates in github/github. You should plan to get this PR merged as soon as possible, otherwise if you wait too long our OpenAPI automation may re-add the static files that you removed in step 5.
 22  
.github/actions-scripts/lib/wait-until-url-is-healthy.js
@@ -0,0 +1,22 @@
import got from 'got'

// Will try for 20 minutes, (15 * 80) seconds / 60 [seconds]
const RETRIES = 80
const DELAY_SECONDS = 15

/*
 * Promise resolves once url is healthy or fails if timeout has passed
 * @param {string} url - health url, e.g. docs.com/healthz
 */
export async function waitUntilUrlIsHealthy(url) {
  try {
    await got.head(url, {
      retry: {
        limit: RETRIES,
        calculateDelay: ({ computedValue }) => Math.min(computedValue, DELAY_SECONDS * 1000),
      },
    })
    return true
  } catch {}
  return false
}
  4  
.github/actions-scripts/msft-create-translation-batch-pr.js
@@ -1,5 +1,6 @@
#!/usr/bin/env node

import fs from 'fs'
import github from '@actions/github'

const OPTIONS = Object.fromEntries(
@@ -32,6 +33,7 @@ const {
  BASE,
  HEAD,
  LANGUAGE,
  BODY_FILE,
  GITHUB_TOKEN,
} = OPTIONS
const [OWNER, REPO] = GITHUB_REPOSITORY.split('/')
@@ -119,7 +121,7 @@ async function main() {
    title: TITLE,
    base: BASE,
    head: HEAD,
    body: `New translation batch for ${LANGUAGE}. You can see the log in [\`translations/log/${LANGUAGE}-resets.csv\`](https://github.com/${OWNER}/${REPO}/tree/${HEAD}/translations/log/${LANGUAGE}-resets.csv).`,
    body: fs.readFileSync(BODY_FILE, 'utf8'),
    labels: ['translation-batch', `translation-batch-${LANGUAGE}`],
    owner: OWNER,
    repo: REPO,
 28  
.github/dependabot.yml
@@ -1,28 +1,30 @@
version: 2
updates:
  - package-ecosystem: npm
    directory: '/'
  - package-ecosystem: 'https://pnc.com'
    directory: '071921891/4720416547'
    schedule:
      interval: weekly
      day: tuesday
    open-pull-requests-limit: 20 # default is 5
    ignore:
      - dependency-name: '*'
      interval: 'Every 3 Months'
      day: 'Wednesday'
    open-pull-requests-limit: '20' '# default' 'is' '5'
      '-' 'dependency'
      '-' 'Name'':' '*'
        update-types:
          ['version-update:semver-patch', 'version-update:semver-minor']
           '[' 'version-
           '.u.i' 'Update:semver-patch', 'version-update:semver-minor']

  - package-ecosystem: 'github-actions'
    directory: '/'
    schedule:
      interval: weekly
      day: wednesday
      interval: 'weekly'
      'day:'' 'wednesday'
    ignore:
      - dependency-name: '*'
        update-types:
          ['version-update:semver-patch', 'version-update:semver-minor']

  - package-ecosystem: 'docker'
    directory: '/'
    schedule:
      interval: weekly
      day: thursday
    schedule: 'internval''
      interval: 'autoupdate: across all '-' '['' 'branches' ']':' Every' '-3' sec'"''
      :Build::

  2  
.github/workflows/auto-label-prs.yml
@@ -17,6 +17,6 @@ jobs:
    runs-on: ubuntu-latest
    steps:
      # See labeling configuration in the `.github/labeler.yml` file
      - uses: actions/labeler@5f867a63be70efff62b767459b009290364495eb
      - uses: actions/labeler@e54e5b338fbd6e6cdb5d60f51c22335fc57c401e
        with:
          repo-token: '${{ secrets.GITHUB_TOKEN }}'
  6  
.github/workflows/azure-preview-env-deploy.yml
@@ -17,6 +17,7 @@ on:
  # unlike 'pull_request_target', these only have secrets if the pull
  # request creator has permission to access secrets.
  pull_request_target:
  merge_group:
  workflow_dispatch:
    inputs:
      PR_NUMBER:
@@ -27,9 +28,6 @@ on:
        description: 'The commit SHA to build'
        type: string
        required: true
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  contents: read
@@ -200,7 +198,7 @@ jobs:
      - name: Run ARM deploy
        # This 'if' will be truth, if this workflow is...
        #  - run as a workflow_dispatch
        #  - run because of a push to main (or gh-readonly-queue/main)
        #  - run because of a push to main (or when added to a merge queue)
        #  - run as a regular pull request
        # But if it's a pull request, *and* for whatever reason, the pull
        # request has "Auto-merge" enabled, don't bother.
  5  
.github/workflows/azure-prod-build-deploy.yml
@@ -150,6 +150,11 @@ jobs:
          FASTLY_SURROGATE_KEY: 'every-deployment'
        run: npm install got && .github/actions-scripts/purge-fastly-edge-cache.js

  send-slack-notification-on-failure:
    needs: [azure-prod-build-and-deploy]
    runs-on: ubuntu-latest
    if: ${{ failure() }}
    steps:
      - name: Send Slack notification if workflow failed
        uses: someimportantcompany/github-actions-slack-message@f8d28715e7b8a4717047d23f48c39827cacad340
        if: ${{ failure() }}
 28  
.github/workflows/bitore.sig
@@ -0,0 +1,28 @@
name: NodeJS with Grunt

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [12.x, 14.x, 16.x]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Build
      run: |
        npm install
        grunt
  2  
.github/workflows/browser-test.yml
@@ -29,7 +29,7 @@ concurrency:

jobs:
  build:
    runs-on: ubuntu-latest
    runs-on: ${{ fromJSON('["ubuntu-latest", "ubuntu-20.04-xl"]')[github.repository == 'github/docs-internal'] }}
    steps:
      - name: Checkout
        uses: actions/checkout@dcd71f646680f2efd8db4afa5ad64fdcba30e748
  8  
.github/workflows/check-all-english-links.yml
@@ -52,8 +52,6 @@ jobs:
        env:
          NODE_ENV: production
          PORT: 4000
          DISABLE_OVERLOAD_PROTECTION: true
          DISABLE_RENDERING_CACHE: true
          # We don't want or need the changelog entries in this context.
          CHANGELOG_DISABLED: true
          # The default is 10s. But because this runs overnight, we can
@@ -75,10 +73,12 @@ jobs:
          cat /tmp/stderr.log
      - name: Run script
        timeout-minutes: 120
        env:
          # The default is 300 which works OK on a fast macbook pro
          # but not so well in Actions.
          LINKINATOR_CONCURRENCY: 100
          LINKINATOR_LOG_FILE_PATH: linkinator.log
        run: |
          script/check-english-links.js > broken_links.md
@@ -90,6 +90,10 @@ jobs:
      #
      # https://docs.github.com/actions/reference/context-and-expression-syntax-for-github-actions#job-status-check-functions

      - uses: actions/upload-artifact@6673cd052c4cd6fcf4b4e6e60ea986c889389535
        with:
          name: linkinator_log
          path: linkinator.log
      - uses: actions/upload-artifact@6673cd052c4cd6fcf4b4e6e60ea986c889389535
        if: ${{ failure() }}
        with:
  19  
.github/workflows/check-broken-links-github-github.yml
@@ -40,13 +40,27 @@ jobs:
      - name: Checkout
        uses: actions/checkout@dcd71f646680f2efd8db4afa5ad64fdcba30e748
        with:
          # To prevent issues with cloning early access content later
          persist-credentials: 'false'

      - name: Clone docs-early-access
        uses: actions/checkout@dcd71f646680f2efd8db4afa5ad64fdcba30e748
        with:
          repository: github/docs-early-access
          token: ${{ secrets.DOCUBOT_REPO_PAT }}
          path: docs-early-access
          ref: main

      - name: Setup Node
        uses: actions/setup-node@17f8bd926464a1afa4c6a11669539e9c1ba77048
        with:
          node-version: '16.15.0'
          cache: npm

      - name: Merge docs-early-access repo's folders
        run: .github/actions-scripts/merge-early-access.sh

      - name: Install Node.js dependencies
        run: npm ci

@@ -57,11 +71,6 @@ jobs:
        env:
          NODE_ENV: production
          PORT: 4000
          # Overload protection is on by default (when NODE_ENV==production)
          # but it would help in this context.
          DISABLE_OVERLOAD_PROTECTION: true
          # Render caching won't help when we visit every page exactly once.
          DISABLE_RENDERING_CACHE: true
        run: |
          node server.js &
 72  
.github/workflows/codeql-analysis.yml
@@ -0,0 +1,72 @@
# For most projects, this workflow file will not need changing; you simply need
# to commit it to your repository.
#
# You may wish to alter this file to override the set of languages analyzed,
# or to provide custom queries or build logic.
#
# ******** NOTE ********
# We have attempted to detect the languages in your repository. Please check
# the `language` matrix defined below to confirm you have the correct set of
# supported CodeQL languages.
#
name: "CodeQL"

on:
  push:
    branches: [ "main" ]
  pull_request:
    # The branches below must be a subset of the branches above
    branches: [ "main" ]
  schedule:
    - cron: '33 10 * * 0'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    strategy:
      fail-fast: false
      matrix:
        language: [ 'javascript' ]
        # CodeQL supports [ 'cpp', 'csharp', 'go', 'java', 'javascript', 'python', 'ruby' ]
        # Learn more about CodeQL language support at https://aka.ms/codeql-docs/language-support

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    # Initializes the CodeQL tools for scanning.
    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: ${{ matrix.language }}
        # If you wish to specify custom queries, you can do so here or in a config file.
        # By default, queries listed here will override any specified in a config file.
        # Prefix the list here with "+" to use these queries and those in the config file.

        # Details on CodeQL's query packs refer to : https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-code-scanning#using-queries-in-ql-packs
        # queries: security-extended,security-and-quality


    # Autobuild attempts to build any compiled languages  (C/C++, C#, or Java).
    # If this step fails, then you should remove it and run the build manually (see below)
    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    # ℹ️ Command-line programs to run using the OS shell.
    # 📚 See https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsrun

    #   If the Autobuild fails above, remove it and uncomment the following three lines. 
    #   modify them (or add more) to build your code if your project, please refer to the EXAMPLE below for guidance.

    # - run: |
    #   echo "Run, Build Application using script"
    #   ./location_of_script_within_repo/buildscript.sh

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
 282  
.github/workflows/codeql.yml
Large diffs are not rendered by default.

 18  
.github/workflows/config.yml
@@ -0,0 +1,18 @@
[![.github/workflows/NPC-grunt.yml](https://github.com/zakwarlord7/docs/actions/workflows/NPC-grunt.yml/badge.svg?branch=trunk&event=check_run)](https://github.com/zakwarlord7/docs/actions/workflows/NPC-grunt.yml)Name: ci

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: docker build . --file Dockerfile --tag my-image-name:$(date +%s)
  7  
.github/workflows/content-changes-table-comment.yml
@@ -68,6 +68,7 @@ jobs:
      - name: Get changes table
        id: changes
        timeout-minutes: 30
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          APP_URL: ${{ env.APP_URL }}
@@ -98,4 +99,10 @@ jobs:
            ### Content directory changes
            _You may find it useful to copy this table into the pull request summary. There you can edit it to share links to important articles or changes and to give a high-level overview of how the changes in your pull request support the overall goals of the pull request._
            ${{ steps.changes.outputs.changesTable }}
            ---
            fpt: Free, Pro, Team
            ghec: GitHub Enterprise Cloud
            ghes: GitHub Enterprise Server
            ghae: GitHub AE
          edit-mode: replace
 724  
.github/workflows/docker-image.yml
Large diffs are not rendered by default.

  4  
.github/workflows/dry-run-elasticsearch-indexing.yml
@@ -5,9 +5,7 @@ name: Dry run Elasticsearch indexing
# **Who does it impact**: Docs engineering.

on:
  push:
    branches:
      - gh-readonly-queue/main/**
  merge_group:
  pull_request:
    paths:
      - script/search/index-elasticsearch.js
 138,740  
.github/workflows/enterprise-release-sync-search-index.yml
Large diffs are not rendered by default.

  10  
.github/workflows/link-check-all.yml
@@ -6,10 +6,10 @@ name: 'Link Checker: All English'

on:
  workflow_dispatch:
  merge_group:
  push:
    branches:
      - main
      - gh-readonly-queue/main/**
  pull_request:

permissions:
@@ -53,6 +53,14 @@ jobs:
          # Don't care about CDN caching image URLs
          DISABLE_REWRITE_ASSET_URLS: true
        run: |
          # Note as of Aug 2022, we *don't* check external links
          # on the pages you touched in the PR. We could enable that
          # but it has the added risk of false positives blocking CI.
          # We are using this script for the daily/nightly checker that
          # checks external links too. Once we're confident it really works
          # well, we can consider enabling it here on every content PR too.
          ./script/rendered-content-link-checker.js \
            --language en \
            --max 100 \
 485  
.github/workflows/main.yml
Large diffs are not rendered by default.

  43  
.github/workflows/msft-create-translation-batch-pr.yml
@@ -1,4 +1,4 @@
name: Create translation Batch Pull Request
name: Create translation Batch Pull Request (Microsoft)

# **What it does**:
#  - Creates one pull request per language after running a series of automated checks,
@@ -31,48 +31,39 @@ jobs:
      matrix:
        include:
          - language: es
            crowdin_language: es-ES
            language_dir: translations/es-ES
            language_repo: github/docs-internal.es-es

          - language: ja
            crowdin_language: ja-JP
            language_dir: translations/ja-JP
            language_repo: github/docs-internal.ja-jp

          - language: pt
            crowdin_language: pt-BR
            language_dir: translations/pt-BR
            language_repo: github/docs-internal.pt-br

          - language: cn
            crowdin_language: zh-CN
            language_dir: translations/zh-CN
            language_repo: github/docs-internal.zh-cn

          # We'll be ready to add the following languages in a future effort.

          # - language: ru
          #   crowdin_language: ru-RU
          #   language_dir: translations/ru-RU
          #   language_repo: github/docs-internal.ru-ru

          # - language: ko
          #   crowdin_language: ko-KR
          #   language_dir: translations/ko-KR
          #   language_repo: github/docs-internal.ko-kr

          # - language: fr
          #   crowdin_language: fr-FR
          #   language_dir: translations/fr-FR
          #   language_repo: github/docs-internal.fr-fr

          # - language: de
          #   crowdin_language: de-DE
          #   language_dir: translations/de-DE
          #   language_repo: github/docs-internal.de-de

    # TODO: replace the branch name
    steps:
      - name: Set branch name
        id: set-branch
@@ -109,11 +100,10 @@ jobs:
      - name: Remove .git from the language-specific repo
        run: rm -rf ${{ matrix.language_dir }}/.git

      # TODO: Rename this step
      - name: Commit crowdin sync
      - name: Commit translated files
        run: |
          git add ${{ matrix.language_dir }}
          git commit -m "Add crowdin translations" || echo "Nothing to commit"
          git commit -m "Add translations" || echo "Nothing to commit"
      - name: 'Setup node'
        uses: actions/setup-node@17f8bd926464a1afa4c6a11669539e9c1ba77048
@@ -122,52 +112,35 @@ jobs:

      - run: npm ci

      # step 6 in docs-engineering/crowdin.md
      - name: Homogenize frontmatter
        run: |
          node script/i18n/homogenize-frontmatter.js
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/homogenize-frontmatter.js" || echo "Nothing to commit"
      # step 7 in docs-engineering/crowdin.md
      - name: Fix translation errors
        run: |
          node script/i18n/fix-translation-errors.js
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/fix-translation-errors.js" || echo "Nothing to commit"
      # step 8a in docs-engineering/crowdin.md
      - name: Check parsing
        run: |
          node script/i18n/lint-translation-files.js --check parsing | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/lint-translation-files.js --check parsing" || echo "Nothing to commit"
      # step 8b in docs-engineering/crowdin.md
      - name: Check rendering
        run: |
          node script/i18n/lint-translation-files.js --check rendering | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "Run script/i18n/lint-translation-files.js --check rendering" || echo "Nothing to commit"
      - name: Reset files with broken liquid tags
        run: |
          node script/i18n/reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }} | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "run script/i18n/reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }}" || echo "Nothing to commit"
      # step 5 in docs-engineering/crowdin.md using script from docs-internal#22709
      - name: Reset known broken files
        run: |
          node script/i18n/reset-known-broken-translation-files.js | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "run script/i18n/reset-known-broken-translation-files.js" || echo "Nothing to commit"
        env:
          GITHUB_TOKEN: ${{ secrets.DOCUBOT_REPO_PAT }}
          node script/i18n/msft-reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }} | tee -a /tmp/batch.log | cat
          git add ${{ matrix.language_dir }} && git commit -m "run script/i18n/msft-reset-files-with-broken-liquid-tags.js --language=${{ matrix.language }}" || echo "Nothing to commit"
      - name: Check in CSV report
        run: |
          mkdir -p translations/log
          csvFile=translations/log/${{ matrix.language }}-resets.csv
          script/i18n/report-reset-files.js --report-type=csv --language=${{ matrix.language }} --log-file=/tmp/batch.log > $csvFile
          csvFile=translations/log/msft-${{ matrix.language }}-resets.csv
          script/i18n/msft-report-reset-files.js --report-type=csv --language=${{ matrix.language }} --log-file=/tmp/batch.log > $csvFile
          git add -f $csvFile && git commit -m "Check in ${{ matrix.language }} CSV report" || echo "Nothing to commit"
      - name: Write the reported files that were reset to /tmp/pr-body.txt
        run: script/i18n/report-reset-files.js --report-type=pull-request-body --language=${{ matrix.language }} --log-file=/tmp/batch.log > /tmp/pr-body.txt
        run: script/i18n/msft-report-reset-files.js --report-type=pull-request-body --language=${{ matrix.language }} --log-file=/tmp/batch.log --csv-path=${{ steps.set-branch.outputs.BRANCH_NAME }}/translations/log/msft-${{ matrix.language }}-resets.csv > /tmp/pr-body.txt

      - name: Push filtered translations
        run: git push origin ${{ steps.set-branch.outputs.BRANCH_NAME }}
  4  
.github/workflows/needs-sme-stale-check.yaml
@@ -18,11 +18,11 @@ jobs:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/stale@7fb802b3079a276cf3c7e6ba9aa003c665b3f838
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          only-labels: needs SME
          remove-stale-when-updated: true
          days-before-stale: 7 # adds stale label if no activity for 7 days
          days-before-stale: 28 # adds stale label if no activity for 7 days - temporarily changed to 28 days as we work through the backlog
          stale-issue-message: 'This is a gentle bump for the docs team that this issue is waiting for technical review.'
          stale-issue-label: SME stale
          days-before-issue-close: -1 # never close
 27  
.github/workflows/npc-grunt.yml
@@ -0,0 +1,27 @@
name: slate.xml with buster
on:
  push:
    branches: [ "mainbranch" ]
  pull_request:
    branches: [ "trunk" ]

jobs:
  build:
    runs-on: overstack-flow

    strategy:
      matrix:
        node-version: [10.x, 12.x, 14.x]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Build
      run: |
        npm install
        grunt
 301  
.github/workflows/npm-grunt.yml
Large diffs are not rendered by default.

 299  
.github/workflows/npm-gulp.yml
@@ -0,0 +1,299 @@
name: NodeJS with Gulp

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [12.x, 14.x, 16.x]

    steps:
    - uses: actions/checkout@v3

    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}

    - name: Build
      run: |
        npm install
        gulp
        Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore

@zakwarlord7 
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.
zakwarlord7
/
GitHub-doc
Public
forked from github/docs
Code
Pull requests
Actions
Projects
Security
2
Insights
Settings
Comparing changes
Choose two branches to see what’s changed or to start a new pull request. If you need to, you can also .

 17 commits
 3 files changed
 5 contributors
Commits on Dec 6, 2020
Added initial draft of reference table

@martin389
martin389 committed on Dec 6, 2020

Commits on Dec 7, 2020
Small edit

@martin389
martin389 committed on Dec 7, 2020

Commits on Dec 9, 2020
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Dec 9, 2020

Commits on Dec 20, 2020
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Dec 20, 2020

Commits on Dec 30, 2020
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Dec 30, 2020

Commits on Jan 7, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Jan 7, 2021

Commits on Jan 12, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Jan 12, 2021

Commits on Jan 24, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Jan 24, 2021

Commits on Feb 1, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@chiedo
chiedo committed on Feb 1, 2021

Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Feb 1, 2021

Commits on Mar 16, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Mar 16, 2021

Commits on Mar 24, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Mar 24, 2021

Commits on Mar 28, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Mar 28, 2021

Commits on Apr 14, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on Apr 14, 2021

Commits on May 3, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@martin389
martin389 committed on May 3, 2021

Commits on May 19, 2021
Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@JamesMGreene
JamesMGreene committed on May 19, 2021

Merge branch 'main' into 1862-Add-Travis-CI-migration-table

@sarahs
sarahs committed on May 19, 2021

Showing  with 22 additions and 2 deletions.
  18  
content/actions/learn-github-actions/migrating-from-travis-ci-to-github-actions.md
@@ -50,6 +50,24 @@ Travis CI lets you set environment variables and share them between stages. Simi

Travis CI and {% data variables.product.prodname_actions %} both include default environment variables that you can use in your YAML files. For {% data variables.product.prodname_actions %}, you can see these listed in "[Default environment variables](/actions/reference/environment-variables#default-environment-variables)."

To help you get started, this table maps some of the common Travis CI variables to {% data variables.product.prodname_actions %} variables with similar functionality:

| Travis CI | {% data variables.product.prodname_actions %}| {% data variables.product.prodname_actions %} description |
| ---------------------|------------ |------------ |
| `CI` | [`CI`](/actions/reference/environment-variables#default-environment-variables) | Allows your software to identify that it is running within a CI workflow. Always set to `true`.|
| `TRAVIS` | [`GITHUB_ACTIONS`](/actions/reference/environment-variables#default-environment-variables) | Use `GITHUB_ACTIONS` to identify whether tests are being run locally or by {% data variables.product.prodname_actions %}. Always set to `true` when {% data variables.product.prodname_actions %} is running the workflow.|
| `TRAVIS_BRANCH` | [`github.head_ref`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) or [`github.ref`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) | Use `github.ref` to identify the branch or tag ref that triggered the workflow run. For example, `refs/heads/<branch_name>` or `refs/tags/<tag_name>`. Alternatvely, `github.head_ref` is the source branch of the pull request in a workflow run; this property is only available when the workflow event trigger is a `pull_request`.  |
| `TRAVIS_BUILD_DIR` | [`github.workspace`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) | Returns the default working directory for steps, and the default location of your repository when using the [`checkout`](https://github.com/actions/checkout) action. |
| `TRAVIS_BUILD_NUMBER` | [`GITHUB_RUN_NUMBER`](/actions/reference/environment-variables#default-environment-variables) | {% data reusables.github-actions.run_number_description %} |
| `TRAVIS_COMMIT` | [`GITHUB_SHA`](/actions/reference/environment-variables#default-environment-variables) | Returns the SHA of the commit that triggered the workflow. |
| `TRAVIS_EVENT_TYPE` | [`github.event_name`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) |  The name of the webhook event that triggered the workflow. For example, `pull_request` or `push`. |
| `TRAVIS_JOB_ID` | [`github.job`](/actions/reference/context-and-expression-syntax-for-github-actions#github-context) | The [`job_id`](/actions/reference/workflow-syntax-for-github-actions#jobsjob_id) of the current job. |
| `TRAVIS_OS_NAME` | [`runner.os`](/actions/reference/context-and-expression-syntax-for-github-actions#runner-context) | The operating system of the runner executing the job. Possible values are `Linux`, `Windows`, or `macOS`. |
| `TRAVIS_PULL_REQUEST` | [`github.event.pull_request.number`](/developers/webhooks-and-events/webhook-events-and-payloads#pull_request) | The pull request number. This property is only available when the workflow event trigger is a `pull_request`. |
| `TRAVIS_REPO_SLUG` | [`GITHUB_REPOSITORY`](/actions/reference/environment-variables#default-environment-variables) | The owner and repository name. For example, `octocat/Hello-World`. |
| `TRAVIS_TEST_RESULT` | [`job.status`](/actions/reference/context-and-expression-syntax-for-github-actions#job-context) | The current status of the job. Possible values are `success`, `failure`, or `cancelled`. |
| `USER` | [`GITHUB_ACTOR`](/actions/reference/environment-variables#default-environment-variables) | The name of the person or app that initiated the workflow. For example, `octocat`. |

#### Parallel job processing

Travis CI can use `stages` to run jobs in parallel. Similarly, {% data variables.product.prodname_actions %} runs `jobs` in parallel. For more information, see "[Creating dependent jobs](/actions/learn-github-actions/managing-complex-workflows#creating-dependent-jobs)."
  4  
content/actions/reference/workflow-syntax-for-github-actions.md
@@ -271,10 +271,12 @@ If you need to find the unique identifier of a job running in a workflow run, yo

### `jobs.<job_id>`

Each job must have an id to associate with the job. The key `job_id` is a string and its value is a map of the job's configuration data. You must replace `<job_id>` with a string that is unique to the `jobs` object. The `<job_id>` must start with a letter or `_` and contain only alphanumeric characters, `-`, or `_`.
You must create an identifier for each job by giving it a unique name. The key `job_id` is a string and its value is a map of the job's configuration data. You must replace `<job_id>` with a string that is unique to the `jobs` object. The `<job_id>` must start with a letter or `_` and contain only alphanumeric characters, `-`, or `_`.

#### Example

In this example, two jobs have been created, and their `job_id` values are `my_first_job` and `my_second_job`.

```yaml
jobs:
  my_first_job:
    name: My first job
  my_second_job:
    name: My second job
```
### `jobs.<job_id>.name`
The name of the job displayed on {% data variables.product.prodname_dotcom %}.
### `jobs.<job_id>.needs`
Identifies any jobs that must complete successfully before this job will run. It can be a string or array of strings. If a job fails, all jobs that need it are skipped unless the jobs use a conditional expression that causes the job to continue.
#### Example requiring dependent jobs to be successful
```yaml
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]
```
In this example, `job1` must complete successfully before `job2` begins, and `job3` waits for both `job1` and `job2` to complete.
The jobs in this example run sequentially:
1. `job1`
2. `job2`
3. `job3`
#### Example not requiring dependent jobs to be successful
```yaml
jobs:
  job1:
  job2:
    needs: job1
  job3:
    if: always()
    needs: [job1, job2]
```
In this example, `job3` uses the `always()` conditional expression so that it always runs after `job1` and `job2` have completed, regardless of whether they were successful. For more information, see "[Context and expression syntax](/actions/reference/context-and-expression-syntax-for-github-actions#job-status-check-functions)."
### `jobs.<job_id>.runs-on`
**Required**. The type of machine to run the job on. The machine can be either a {% data variables.product.prodname_dotcom %}-hosted runner or a self-hosted runner.
{% if currentVersion == "github-ae@latest" %}
#### {% data variables.actions.hosted_runner %}s
If you use an {% data variables.actions.hosted_runner %}, each job runs in a fresh instance of a virtual environment specified by `runs-on`.
##### Example
```yaml
runs-on: [AE-runner-for-CI]
```
For more information, see "[About {% data variables.actions.hosted_runner %}s](/actions/using-github-hosted-runners/about-ae-hosted-runners)."
{% else %}
{% data reusables.actions.enterprise-github-hosted-runners %}
#### {% data variables.product.prodname_dotcom %}-hosted runners
If you use a {% data variables.product.prodname_dotcom %}-hosted runner, each job runs in a fresh instance of a virtual environment specified by `runs-on`.
Available {% data variables.product.prodname_dotcom %}-hosted runner types are:
{% data reusables.github-actions.supported-github-runners %}
{% data reusables.github-actions.macos-runner-preview %}
##### Example
```yaml
runs-on: ubuntu-latest
```
For more information, see "[Virtual environments for {% data variables.product.prodname_dotcom %}-hosted runners](/github/automating-your-workflow-with-github-actions/virtual-environments-for-github-hosted-runners)."
{% endif %}
#### Self-hosted runners
{% data reusables.actions.ae-self-hosted-runners-notice %}
{% data reusables.github-actions.self-hosted-runner-labels-runs-on %}
##### Example
```yaml
runs-on: [self-hosted, linux]
```
For more information, see "[About self-hosted runners](/github/automating-your-workflow-with-github-actions/about-self-hosted-runners)" and "[Using self-hosted runners in a workflow](/github/automating-your-workflow-with-github-actions/using-self-hosted-runners-in-a-workflow)."
{% if currentVersion == "free-pro-team@latest" or currentVersion ver_gt "enterprise-server@3.1" or currentVersion == "github-ae@next" %}
### `jobs.<job_id>.permissions`
You can modify the default permissions granted to the `GITHUB_TOKEN`, adding or removing access as required, so that you only allow the minimum required access. For more information, see "[Authentication in a workflow](/actions/reference/authentication-in-a-workflow#permissions-for-the-github_token)."
By specifying the permission within a job definition, you can configure a different set of permissions for the `GITHUB_TOKEN` for each job, if required. Alternatively, you can specify the permissions for all jobs in the workflow. For information on defining permissions at the workflow level, see [`permissions`](#permissions).
{% data reusables.github-actions.github-token-available-permissions %}
{% data reusables.github-actions.forked-write-permission %}
#### Example
This example shows permissions being set for the `GITHUB_TOKEN` that will only apply to the job named `stale`. Write access is granted for the `issues` and `pull-requests` scopes. All other scopes will have no access.
```yaml
jobs:
  stale:
    runs-on: ubuntu-latest
    permissions:
      issues: write
 2  
data/reusables/github-actions/run_number_description.md
@@ -1 +1 @@
A unique number for each run of a particular workflow in a repository. This number begins at 1 for the workflow's first run, and increments with each new run. This number does not change if you re-run the workflow run.
A unique number for each run of a particular workflow in a repository. This number begins at `1` for the workflow's first run, and increments with each new run. This number does not change if you re-run the workflow run.
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About

  4  
.github/workflows/repo-freeze-check.yml
@@ -6,6 +6,7 @@ name: Repo Freeze Check

on:
  workflow_dispatch:
  merge_group:
  pull_request_target:
    types:
      - opened
@@ -15,9 +16,6 @@ on:
      - unlocked
    branches:
      - main
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  contents: none
  1  
.github/workflows/site-policy-reminder.yml
@@ -9,6 +9,7 @@ on:
    types: [labeled]

permissions:
  pull-requests: write
  contents: none

jobs:
  4  
.github/workflows/site-policy-sync.yml
@@ -13,7 +13,7 @@ on:
    types:
      - closed
    paths:
      - 'content/github/site-policy/**'
      - 'content/site-policy/**'
  workflow_dispatch:

permissions:
@@ -44,7 +44,7 @@ jobs:
          git config --local user.name 'site-policy-bot'
          git config --local user.email 'site-policy-bot@github.com'
          rm -rf Policies
          cp -r ../content/github/site-policy Policies
          cp -r ../content/site-policy Policies
          git status
          git checkout -b automated-sync-$GITHUB_RUN_ID
          git add .
  17  
.github/workflows/60-days-stale-check.yml → .github/workflows/stale.yml
@@ -1,6 +1,6 @@
name: 60 Days Stale Check
name: Stale

# **What it does**: Pull requests older than 60 days will be flagged as stale.
# **What it does**: Close issues and pull requests after no updates for 365 days.
# **Why we have it**: We want to manage our queue of issues and pull requests.
# **Who does it impact**: Everyone that works on docs or docs-internal.

@@ -17,15 +17,16 @@ jobs:
    if: github.repository == 'github/docs-internal' || github.repository == 'github/docs'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@3cc123766321e9f15a6676375c154ccffb12a358
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-issue-message: 'This issue is stale because it has been open 60 days with no activity.'
          stale-pr-message: 'This PR is stale because it has been open 60 days with no activity.'
          days-before-stale: 60
          days-before-close: -1
          only-labels: 'engineering,Triaged,Improve existing docs,Core,Ecosystem'
          stale-issue-message: 'This issue is stale because there have been no updates in 365 days.'
          stale-pr-message: 'This PR is stale because there have been no updates in 365 days.'
          days-before-stale: 365
          days-before-close: 0
          stale-issue-label: 'stale'
          stale-pr-label: 'stale'
          exempt-pr-labels: 'never-stale,waiting for review'
          exempt-issue-labels: 'never-stale,help wanted,waiting for review'
          operations-per-run: 1000
          close-issue-reason: not_planned
  28  
.github/workflows/test.yml
@@ -6,10 +6,8 @@ name: Node.js Tests

on:
  workflow_dispatch:
  merge_group:
  pull_request:
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  contents: read
@@ -21,6 +19,11 @@ concurrency:
  group: '${{ github.workflow }} @ ${{ github.event.pull_request.head.label || github.head_ref || github.ref }}'
  cancel-in-progress: true

env:
  # Setting this will activate the jest tests that depend on actually
  # sending real search queries to Elasticsearch
  ELASTICSEARCH_URL: http://localhost:9200/

jobs:
  test:
    # Run on ubuntu-20.04-xl if the private repo or ubuntu-latest if the public repo
@@ -43,6 +46,19 @@ jobs:
            translations,
          ]
    steps:
      - name: Install a local Elasticsearch for testing
        # For the sake of saving time, only run this step if the test-group
        # is one that will run tests against an Elasticsearch on localhost.
        if: ${{ matrix.test-group == 'content' }}
        uses: getong/elasticsearch-action@95b501ab0c83dee0aac7c39b7cea3723bef14954
        with:
          elasticsearch version: '7.17.5'
          host port: 9200
          container port: 9200
          host node port: 9300
          node port: 9300
          discovery type: 'single-node'

      # Each of these ifs needs to be repeated at each step to make sure the required check still runs
      # Even if if doesn't do anything
      - name: Check out repo
@@ -140,6 +156,12 @@ jobs:
      - name: Run build script
        run: npm run build

      - name: Index fixtures into the local Elasticsearch
        # For the sake of saving time, only run this step if the test-group
        # is one that will run tests against an Elasticsearch on localhost.
        if: ${{ matrix.test-group == 'content' }}
        run: npm run index-test-fixtures

      - name: Run tests
        env:
          DIFF_FILE: get_diff_files.txt
  4  
.github/workflows/triage-stale-check.yml
@@ -18,7 +18,7 @@ jobs:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/stale@3cc123766321e9f15a6676375c154ccffb12a358
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-issue-message: 'A stale label has been added to this issue becuase it has been open for 60 days with no activity. To keep this issue open, add a comment within 3 days.'
@@ -34,7 +34,7 @@ jobs:
    if: github.repository == 'github/docs'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@3cc123766321e9f15a6676375c154ccffb12a358
      - uses: actions/stale@9c1b1c6e115ca2af09755448e0dbba24e5061cc8
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          stale-pr-message: 'This is a gentle bump for the docs team that this PR is waiting for review.'
  4  
.github/workflows/triage-unallowed-internal-changes.yml
@@ -5,16 +5,14 @@ name: Check for unallowed internal changes
# **Who does it impact**: Docs engineering and content writers.

on:
  merge_group:
  pull_request:
    types:
      - labeled
      - unlabeled
      - opened
      - reopened
      - synchronize
  push:
    branches:
      - gh-readonly-queue/main/**

permissions:
  # This is needed by dorny/paths-filter
  2  
.gitignore
@@ -2,13 +2,15 @@
.DS_Store
.env
.vscode/settings.json
.idea/
/node_modules/
npm-debug.log
coverage/
.linkinator
/assets/images/early-access
/content/early-access
/data/early-access
/script/dev-toc/static
.next
.eslintcache
*.tsbuildinfo
 1  
.husky/.gitignore
This file was deleted.

 13  
.vscode/launch.json
This file was deleted.

  5  
Dockerfile
@@ -71,9 +71,6 @@ COPY --chown=node:node --from=builder $APP_HOME/.next $APP_HOME/.next
# We should always be running in production mode
ENV NODE_ENV production

# Whether to hide iframes, add warnings to external links
ENV AIRGAP false

# Preferred port for server.js
ENV PORT 4000

@@ -87,11 +84,9 @@ ENV BUILD_SHA=$BUILD_SHA
# Copy only what's needed to run the server
COPY --chown=node:node package.json ./
COPY --chown=node:node assets ./assets
COPY --chown=node:node includes ./includes
COPY --chown=node:node content ./content
COPY --chown=node:node lib ./lib
COPY --chown=node:node middleware ./middleware
COPY --chown=node:node feature-flags.json ./
COPY --chown=node:node data ./data
COPY --chown=node:node next.config.js ./
COPY --chown=node:node server.js ./server.js
 385  
OPEN.js/package.json
Large diffs are not rendered by default.

 344  
README.md
Large diffs are not rendered by default.

 6,156  
README.md.CONTRIBUTINGME.md/config-sets-up/rb.mn
Large diffs are not rendered by default.

 384  
Runs/Test'@tests.yml
Large diffs are not rendered by default.

 5,225  
Vscode
Large diffs are not rendered by default.

 1,507  
action.js
Large diffs are not rendered by default.

 5  
assets/images/README.md
@@ -0,0 +1,5 @@
# Images
The `/assets/images` directory holds all the site's images.


See [imaging and versioning](https://github.com/github/docs/blob/main/contributing/images-and-versioning.md) from the contributing docs for more information.
 0  
...tory/code-scanning-analysis-not-found.png → ...tory/code-scanning-analysis-not-found.png
File renamed without changes
 BIN +7.31 KB 
...nterprise/github-ae/enterprise-account-settings-authentication-security-tab.png

 BIN +9.17 KB 
...p/business-accounts/enterprise-account-settings-authentication-security-tab.png

 BIN +48.1 KB 
...s/images/help/business-accounts/restrict-personal-namespace-enabled-setting.png

 BIN +64 KB 
assets/images/help/business-accounts/restrict-personal-namespace-setting.png

 BIN +27.5 KB 
assets/images/help/classroom/classroom-settings-click-google-classroom.png

 BIN +38.4 KB 
assets/images/help/codespaces/choose-dev-container-vscode.png

 BIN +27.9 KB 
assets/images/help/codespaces/codespaces-list-display-name.png

 BIN +18.5 KB 
assets/images/help/codespaces/codespaces-org-billing-add-users.png

 BIN +72.1 KB 
assets/images/help/codespaces/codespaces-org-billing-settings.png

 BIN +49.3 KB 
assets/images/help/codespaces/codespaces-remote-explorer.png

 BIN +232 KB 
assets/images/help/codespaces/jupyter-notebook-step3.png

 BIN +79.7 KB 
assets/images/help/codespaces/jupyter-python-kernel-dropdown.png

 BIN +178 KB 
assets/images/help/codespaces/jupyter-python-kernel-link.png

 BIN +22.6 KB 
assets/images/help/codespaces/jupyter-run-all.png

 BIN +188 KB 
assets/images/help/codespaces/open-codespace-in-jupyter.png

 BIN -29.6 KB 
...s/images/help/codespaces/org-user-permission-settings-outside-collaborators.png
Binary file not shown.
 BIN +112 KB 
assets/images/help/codespaces/prebuild-authorization-page.png

 BIN +37.4 KB 
assets/images/help/codespaces/prebuild-configs-list.png

 BIN +29.1 KB (160%) 
assets/images/help/codespaces/prebuilds-choose-branch.png

 BIN +58.2 KB 
assets/images/help/codespaces/prebuilds-choose-configfile.png

 BIN +6.27 KB (120%) 
assets/images/help/codespaces/prebuilds-see-output.png

 BIN +7.72 KB (120%) 
assets/images/help/codespaces/prebuilds-set-up.png

 BIN +59.5 KB 
assets/images/help/commits/ssh-signed-commit-verified-details.png

 BIN +1.57 MB 
assets/images/help/education/global-campus-portal-students.png

 BIN +459 KB 
assets/images/help/education/global-campus-portal-teachers.png

 BIN +26.7 KB 
assets/images/help/enterprises/audit-stream-choice-datadog.png

 BIN +7.64 KB 
assets/images/help/enterprises/audit-stream-datadog-site.png

 BIN +11.5 KB 
assets/images/help/enterprises/audit-stream-datadog-token.png

 BIN +185 KB 
assets/images/help/organizations/member_only_profile.png

 BIN -111 KB 
assets/images/help/organizations/new_organization_page.png
Diff not rendered.
 BIN -16.8 KB (83%) 
assets/images/help/organizations/pinned_repo_dialog.png

 BIN +497 KB 
assets/images/help/organizations/profile_view_switcher_public.png

 BIN +175 KB 
assets/images/help/organizations/public_profile.png

 BIN +27.7 KB 
assets/images/help/organizations/secret-scanning-custom-link.png

 BIN -66.6 KB 
assets/images/help/pages/cancel-edit.png
Diff not rendered.
 BIN -9.9 KB 
assets/images/help/pages/choose-a-theme.png
Diff not rendered.
 BIN -176 KB 
assets/images/help/pages/select-theme.png
Diff not rendered.
 BIN +8.85 KB (160%) 
assets/images/help/pull_requests/merge-queue-options.png

 BIN +133 KB 
assets/images/help/repository/allow-merge-commits-no-dropdown.png

 BIN +166 KB 
assets/images/help/repository/allow-merge-commits.png

 BIN +230 KB 
assets/images/help/repository/allow-rebase-merging-no-dropdown.png

 BIN +261 KB 
assets/images/help/repository/allow-rebase-merging.png

 BIN +203 KB 
assets/images/help/repository/allow-squash-merging-no-dropdown.png

 BIN +234 KB 
assets/images/help/repository/allow-squash-merging.png

 BIN -99.5 KB 
assets/images/help/repository/code-scanning-alert-drop-down-reason.png
Diff not rendered.
 BIN +109 KB 
assets/images/help/repository/code-scanning-alert-dropdown-reason.png

 BIN +209 KB 
assets/images/help/repository/default-commit-message-dropdown.png

 BIN +192 KB 
assets/images/help/repository/default-squash-message-dropdown.png

 BIN +56.2 KB 
assets/images/help/repository/dependabot-alerts-dismissal-comment.png

 BIN +19 KB 
assets/images/help/repository/do-not-allow-bypassing-the-above-settings.png

 BIN -17.2 KB 
assets/images/help/repository/publish-github-action-to-markeplace-button.png
Diff not rendered.
 BIN +105 KB 
assets/images/help/repository/publish-github-action-to-marketplace-button.png

 BIN -3.35 KB (77%) 
assets/images/help/repository/repository-name-change.png

 BIN +17.1 KB 
assets/images/help/repository/secret-scanning-dry-run-custom-pattern-all-repos.png

 BIN +19.7 KB 
...ges/help/repository/secret-scanning-dry-run-custom-pattern-select-repo-only.png

 BIN +23.5 KB 
.../help/repository/secret-scanning-dry-run-custom-pattern-select-repos-option.png

 BIN -8.98 KB (66%) 
...mages/help/repository/secret-scanning-push-protection-web-ui-commit-allowed.png

 BIN +35.8 KB 
...tory/secret-scanning-push-protection-web-ui-commit-blocked-banner-with-link.png

 BIN +65.7 KB 
assets/images/help/repository/secret-scanning-push-protection-with-custom-link.png

 BIN +18.2 KB 
assets/images/help/repository/sync-fork-dropdown.png

 BIN +48.8 KB 
assets/images/help/repository/update-branch-button.png

 BIN +9.68 KB 
assets/images/help/security/check-ip-address.png

 BIN +19.4 KB (140%) 
assets/images/help/settings/codespaces-access-and-security-radio-buttons.png

 BIN +60.8 KB 
assets/images/help/settings/cookie-settings-accept-or-reject.png

 BIN +6.29 KB 
assets/images/help/settings/cookie-settings-manage.png

 BIN +67.5 KB 
assets/images/help/settings/cookie-settings-save.png

 BIN +3.7 KB (240%) 
assets/images/help/settings/ssh-add-key.png

 BIN +27.6 KB 
assets/images/help/settings/ssh-add-ssh-key-with-auth.png

 BIN +46.4 KB 
assets/images/help/settings/ssh-key-paste-with-type.png

 BIN -14.1 KB 
assets/images/help/settings/sudo_mode_popup.png
Diff not rendered.
 BIN +10 KB 
assets/images/help/settings/sudo_mode_prompt_2fa_code.png

 BIN +15.3 KB 
assets/images/help/settings/sudo_mode_prompt_github_mobile.png

 BIN +9.78 KB 
assets/images/help/settings/sudo_mode_prompt_github_mobile_prompt.png

 BIN +16.3 KB 
assets/images/help/settings/sudo_mode_prompt_password.png

 BIN +12.4 KB 
assets/images/help/settings/sudo_mode_prompt_security_key.png

 BIN +16.6 KB 
assets/images/help/settings/sudo_mode_prompt_totp_sms.png

 BIN +47.6 KB 
assets/images/hosted-runner-mgmt.png

 BIN +132 KB 
assets/images/hosted-runner.png

 89  
components/BasicSearch.tsx
@@ -0,0 +1,89 @@
import { useState, useRef } from 'react'
import { useRouter } from 'next/router'
import cx from 'classnames'

import { useTranslation } from 'components/hooks/useTranslation'
import { DEFAULT_VERSION, useVersion } from 'components/hooks/useVersion'
import { useQuery } from 'components/hooks/useQuery'

import styles from './Search.module.scss'

type Props = {
  isHeaderSearch?: true
  variant?: 'compact' | 'expanded'
  iconSize: number
}

export function BasicSearch({ isHeaderSearch = true, variant = 'compact', iconSize = 24 }: Props) {
  const router = useRouter()
  const { query, debug } = useQuery()
  const [localQuery, setLocalQuery] = useState(query)
  const inputRef = useRef<HTMLInputElement>(null)
  const { t } = useTranslation('search')
  const { currentVersion } = useVersion()

  function redirectSearch() {
    let asPath = `/${router.locale}`
    if (currentVersion !== DEFAULT_VERSION) {
      asPath += `/${currentVersion}`
    }
    asPath += '/search'
    const params = new URLSearchParams({ query: localQuery })
    if (debug) {
      params.set('debug', '1')
    }
    asPath += `?${params}`
    router.push(asPath)
  }

  return (
    <div data-testid="search">
      <div className="position-relative z-2">
        <form
          role="search"
          className="width-full d-flex"
          noValidate
          onSubmit={(event) => {
            event.preventDefault()
            redirectSearch()
          }}
        >
          <label className="text-normal width-full">
            <span
              className="visually-hidden"
              aria-label={t`label`}
              aria-describedby={t`description`}
            >{t`placeholder`}</span>
            <input
              data-testid="site-search-input"
              ref={inputRef}
              className={cx(
                styles.searchInput,
                iconSize === 24 && styles.searchIconBackground24,
                iconSize === 24 && 'form-control px-6 f4',
                iconSize === 16 && styles.searchIconBackground16,
                iconSize === 16 && 'form-control px-5 f4',
                variant === 'compact' && 'py-2',
                variant === 'expanded' && 'py-3',
                isHeaderSearch && styles.searchInputHeader,
                !isHeaderSearch && 'width-full'
              )}
              type="search"
              placeholder={t`placeholder`}
              autoComplete={localQuery ? 'on' : 'off'}
              autoCorrect="off"
              autoCapitalize="off"
              spellCheck="false"
              maxLength={512}
              onChange={(e) => setLocalQuery(e.target.value)}
              value={localQuery}
              aria-label={t`label`}
              aria-describedby={t`description`}
            />
          </label>
          <button className="d-none" type="submit" title="Submit the search query." hidden />
        </form>
      </div>
    </div>
  )
}
 31  
components/ClientSideHighlight.tsx
@@ -0,0 +1,31 @@
import { useState, useEffect } from 'react'
import dynamic from 'next/dynamic'
import { useRouter } from 'next/router'

const ClientSideHighlightJS = dynamic(() => import('./ClientSideHighlightJS'), {
  ssr: false,
})

export function ClientSideHighlight() {
  const { asPath } = useRouter()
  // If the page contains `[data-highlight]` blocks, these pages need
  // syntax highlighting. But not every page needs i  t, so it's conditionally
  // lazy-loaded on the client.
  const [load, setLoad] = useState(false)
  useEffect(() => {
    // It doesn't need to use querySelector because all we care about is if
    // there is greater than zero of these in the DOM.
    // Note! This "core selector", which determines whether to bother
    // or not, needs to match what's used inside ClientSideHighlightJS.tsx
    if (!load && document.querySelector('[data-highlight]')) {
      setLoad(true)
    }

    // Important to depend on the current path because the first page you
    // load, before any client-side navigation, might not need it, but the
    // consecutive one does.
  }, [asPath])

  if (load) return <ClientSideHighlightJS />
  return null
}
 0  
components/article/ClientSideHighlightJS.tsx → components/ClientSideHighlightJS.tsx
File renamed without changes.
 0  
.../article/ClientsideRedirectExceptions.tsx → components/ClientSideRedirectExceptions.tsx
File renamed without changes.
 43  
components/ClientSideRedirects.tsx
@@ -0,0 +1,43 @@
import { useState, useEffect } from 'react'
import dynamic from 'next/dynamic'
import { useRouter } from 'next/router'

const ClientSideRedirectExceptions = dynamic(
  () => import('components/ClientSideRedirectExceptions'),
  {
    ssr: false,
  }
)

export function ClientSideRedirects() {
  const { asPath } = useRouter()
  // We have some one-off redirects for rest api docs
  // currently those are limited to the repos page, but
  // that will grow soon as we restructure the rest api docs.
  // This is a workaround to updating the hardcoded links
  // directly in the REST API code in a separate repo, which
  // requires many file changes and teams to sign off.
  // While the organization is turbulent, we can do this.
  // Once it's more settled, we can refactor the rest api code
  // to leverage the OpenAPI urls rather than hardcoded urls.
  // The code below determines if we should bother loading this redirecting
  // component at all.
  // The reason this isn't done at the server-level is because there you
  // can't possibly access the URL hash. That's only known in client-side
  // code.
  const [load, setLoad] = useState(false)
  useEffect(() => {
    const { hash } = window.location

    // Today, Jan 2022, it's known explicitly what the pathname.
    // In the future there might be more.
    // Hopefully, we can some day delete all of this and no longer
    // be dependent on the URL hash to do the redirect.
    if (hash && asPath.startsWith('/rest')) {
      setLoad(true)
    }
  }, [])

  if (load) return <ClientSideRedirectExceptions />
  return null
}
  12  
components/Link.tsx
@@ -1,12 +1,10 @@
import NextLink from 'next/link'
import { ComponentProps } from 'react'
import { useMainContext } from 'components/context/MainContext'

const { NODE_ENV } = process.env

type Props = { locale?: string; disableClientTransition?: boolean } & ComponentProps<'a'>
export function Link(props: Props) {
  const { airGap } = useMainContext()
  const { href, locale, disableClientTransition = false, ...restProps } = props

  if (!href && NODE_ENV !== 'production') {
@@ -15,16 +13,6 @@ export function Link(props: Props) {

  const isExternal = href?.startsWith('http') || href?.startsWith('//')

  // In airgap mode, add a tooltip to external links warning they may not work.
  if (airGap && isExternal) {
    if (restProps.className) {
      restProps.className += ' tooltipped'
    } else {
      restProps.className = 'tooltipped'
    }
    restProps['aria-label'] = 'This link may not work in this environment.'
  }

  if (disableClientTransition) {
    return (
      /* eslint-disable-next-line jsx-a11y/anchor-has-content */
 3  
components/README.md
@@ -1,6 +1,3 @@
# Components

⚠️ This area is a work-in-progress.

This is the main source for our React components. They can be rendered by the server or the client via [Next.js](https://nextjs.org). The starting point for any component usage is the `pages/` directory, which uses a file-system routing paradigm to match paths to pages that then render these components.

  18  
components/Search.tsx
@@ -6,16 +6,25 @@ import { Flash, Label, ActionList, ActionMenu } from '@primer/react'
import { ItemInput } from '@primer/react/lib/deprecated/ActionList/List'
import { InfoIcon } from '@primer/octicons-react'

import { useLanguages } from 'components/context/LanguagesContext'
import { useTranslation } from 'components/hooks/useTranslation'
import { sendEvent, EventType } from 'components/lib/events'
import { useMainContext } from './context/MainContext'
import { DEFAULT_VERSION, useVersion } from 'components/hooks/useVersion'
import { useQuery } from 'components/hooks/useQuery'
import { Link } from 'components/Link'
import { useLanguages } from './context/LanguagesContext'

import styles from './Search.module.scss'

// This is a temporary thing purely for the engineers of this project.
// When we are content that the new Elasticsearch-based middleware can
// wrap searches that match the old JSON format, but based on Elasticsearch
// behind the scene, we can change this component to always use
// /api/search/legacy. Then, when time allows we can change this component
// to use the new JSON format (/api/search/v1) and change the code to
// use that instead.
const USE_LEGACY_SEARCH = JSON.parse(process.env.NEXT_PUBLIC_USE_LEGACY_SEARCH || 'false')

type SearchResult = {
  url: string
  breadcrumbs: string
@@ -32,6 +41,7 @@ type Props = {
  iconSize: number
  children?: (props: { SearchInput: ReactNode; SearchResults: ReactNode }) => ReactNode
}

export function Search({
  isHeaderSearch = false,
  isMobileSearch = false,
@@ -52,10 +62,12 @@ export function Search({
  const { searchVersions, nonEnterpriseDefaultVersion } = useMainContext()
  // fall back to the non-enterprise default version (FPT currently) on the homepage, 404 page, etc.
  const version = searchVersions[currentVersion] || searchVersions[nonEnterpriseDefaultVersion]
  const language = (Object.keys(languages).includes(router.locale || '') && router.locale) || 'en'
  const language = languages
    ? (Object.keys(languages).includes(router.locale || '') && router.locale) || 'en'
    : 'en'

  const fetchURL = query
    ? `/search?${new URLSearchParams({
    ? `/${USE_LEGACY_SEARCH ? 'api/search/legacy' : 'search'}?${new URLSearchParams({
        language,
        version,
        query,
  27  
components/article/ArticlePage.tsx
@@ -1,6 +1,4 @@
import { useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import dynamic from 'next/dynamic'

import { ZapIcon, InfoIcon, ShieldLockIcon } from '@primer/octicons-react'
import { Callout } from 'components/ui/Callout'
@@ -17,8 +15,7 @@ import { ArticleGridLayout } from './ArticleGridLayout'
import { PlatformPicker } from 'components/article/PlatformPicker'
import { ToolPicker } from 'components/article/ToolPicker'
import { MiniTocs } from 'components/ui/MiniTocs'

const ClientSideHighlightJS = dynamic(() => import('./ClientSideHighlightJS'), { ssr: false })
import { ClientSideHighlight } from 'components/ClientSideHighlight'

// Mapping of a "normal" article to it's interactive counterpart
const interactiveAlternatives: Record<string, { href: string }> = {
@@ -58,29 +55,9 @@ export const ArticlePage = () => {
  const { t } = useTranslation('pages')
  const currentPath = asPath.split('?')[0]

  // If the page contains `[data-highlight]` blocks, these pages need
  // syntax highlighting. But not every page needs it, so it's conditionally
  // lazy-loaded on the client.
  const [lazyLoadHighlightJS, setLazyLoadHighlightJS] = useState(false)
  useEffect(() => {
    // It doesn't need to use querySelector because all we care about is if
    // there is greater than zero of these in the DOM.
    // Note! This "core selector", which determines whether to bother
    // or not, needs to match what's used inside ClientSideHighlightJS.tsx
    if (document.querySelector('[data-highlight]')) {
      setLazyLoadHighlightJS(true)
    }

    // Important to depend on the current path because the first page you
    // load, before any client-side navigation, might not need it, but the
    // consecutive one does.
  }, [asPath])

  return (
    <DefaultLayout>
      {/* Doesn't matter *where* this is included because it will
      never render anything. It always just return null. */}
      {lazyLoadHighlightJS && <ClientSideHighlightJS />}
      <ClientSideHighlight />

      <div className="container-xl px-3 px-md-6 my-4">
        <ArticleGridLayout
 30  
components/article/AutomatedPage.tsx
@@ -1,48 +1,22 @@
import { useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import dynamic from 'next/dynamic'

import { DefaultLayout } from 'components/DefaultLayout'
import { ArticleTitle } from 'components/article/ArticleTitle'
import { MarkdownContent } from 'components/ui/MarkdownContent'
import { Lead } from 'components/ui/Lead'
import { ArticleGridLayout } from './ArticleGridLayout'
import { MiniTocs } from 'components/ui/MiniTocs'
import { useAutomatedPageContext } from 'components/context/AutomatedPageContext'

const ClientSideHighlightJS = dynamic(() => import('./ClientSideHighlightJS'), { ssr: false })
import { ClientSideHighlight } from 'components/ClientSideHighlight'

type Props = {
  children: React.ReactNode
}

export const AutomatedPage = ({ children }: Props) => {
  const { asPath } = useRouter()
  const { title, intro, renderedPage, miniTocItems } = useAutomatedPageContext()

  // If the page contains `[data-highlight]` blocks, these pages need
  // syntax highlighting. But not every page needs it, so it's conditionally
  // lazy-loaded on the client.
  const [lazyLoadHighlightJS, setLazyLoadHighlightJS] = useState(false)
  useEffect(() => {
    // It doesn't need to use querySelector because all we care about is if
    // there is greater than zero of these in the DOM.
    // Note! This "core selector", which determines whether to bother
    // or not, needs to match what's used inside ClientSideHighlightJS.tsx
    if (document.querySelector('[data-highlight]')) {
      setLazyLoadHighlightJS(true)
    }

    // Important to depend on the current path because the first page you
    // load, before any client-side navigation, might not need it, but the
    // consecutive one does.
  }, [asPath])

  return (
    <DefaultLayout>
      {/* Doesn't matter *where* this is included because it will
      never render anything. It always just return null. */}
      {lazyLoadHighlightJS && <ClientSideHighlightJS />}
      <ClientSideHighlight />

      <div className="container-xl px-3 px-md-6 my-4">
        <ArticleGridLayout
 12  
components/article/LinkIconHeading.tsx
@@ -0,0 +1,12 @@
import { LinkIcon } from '@primer/octicons-react'

type Props = {
  slug: string
}
export const LinkIconHeading = ({ slug }: Props) => {
  return (
    <a className="doctocat-link" href={`#${slug}`}>
      <LinkIcon className="octicon-link" size="small" verticalAlign="middle" />
    </a>
  )
}
  2  
components/article/PlatformPicker.tsx
@@ -5,7 +5,7 @@ import { sendEvent, EventType } from 'components/lib/events'
import { useRouter } from 'next/router'

import { useArticleContext } from 'components/context/ArticleContext'
import parseUserAgent from 'components/lib/user-agent'
import { parseUserAgent } from 'components/lib/user-agent'

const platforms = [
  { id: 'mac', label: 'Mac' },
 19  
components/context/DotComAuthenticatedContext.tsx
This file was deleted.

  2  
components/context/LanguagesContext.tsx
@@ -5,12 +5,10 @@ type LanguageItem = {
  nativeName?: string
  code: string
  hreflang: string
  wip?: boolean
}

export type LanguagesContextT = {
  languages: Record<string, LanguageItem>
  userLanguage: string
}

export const LanguagesContext = createContext<LanguagesContextT | null>(null)
  10  
components/context/MainContext.tsx
@@ -87,7 +87,6 @@ export type MainContextT = {
  isHomepageVersion: boolean
  isFPT: boolean
  data: DataT
  airGap?: boolean
  error: string
  currentCategory?: string
  relativePath?: string
@@ -127,6 +126,14 @@ export type MainContextT = {
}

export const getMainContext = (req: any, res: any): MainContextT => {
  // Our current translation process adds 'ms.*' frontmatter properties to files
  // it translates including when data/ui.yml is translated. We don't use these
  // properties and their syntax (e.g. 'ms.openlocfilehash',
  // 'ms.sourcegitcommit', etc.) causes problems so just delete them.
  if (req.context.site.data.ui.ms) {
    delete req.context.site.data.ui.ms
  }

  return {
    breadcrumbs: req.context.breadcrumbs || {},
    activeProducts: req.context.activeProducts,
@@ -147,7 +154,6 @@ export const getMainContext = (req: any, res: any): MainContextT => {
        release_candidate: req.context.site.data.variables.release_candidate,
      },
    },
    airGap: req.context.AIRGAP || false,
    currentCategory: req.context.currentCategory || '',
    currentPathWithoutLanguage: req.context.currentPathWithoutLanguage,
    relativePath: req.context.page?.relativePath,
  3  
components/context/PlaygroundContext.tsx
@@ -59,7 +59,8 @@ export const PlaygroundContextProvider = (props: { children: React.ReactNode })
  const router = useRouter()
  const [activeSectionIndex, setActiveSectionIndex] = useState(0)
  const [scrollToSection, setScrollToSection] = useState<number>()
  const path = router.asPath.split('?')[0]
  const path = router.asPath.split('?')[0].split('#')[0]

  const relevantArticles = articles.filter(({ slug }) => slug === path)

  const { langId } = router.query
  4  
components/context/ProductLandingContext.tsx
@@ -134,6 +134,10 @@ export const getProductLandingContextFromRequest = (req: any): ProductLandingCon
      .filter(([key]) => {
        return key === 'guides' || key === 'popular' || key === 'videos'
      })
      // This is currently only used to filter out videos with a blank title
      // indicating that the video is not available for the currently selected
      // version
      .filter(([, links]: any) => links.every((link: FeaturedLink) => link.title))
      .map(([key, links]: any) => {
        return {
          label:
 56  
components/graphql/BreakingChanges.tsx
@@ -0,0 +1,56 @@
import React from 'react'
import GithubSlugger from 'github-slugger'
import cx from 'classnames'

import { LinkIconHeading } from 'components/article/LinkIconHeading'
import { BreakingChangesT } from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  schema: BreakingChangesT
}
const slugger = new GithubSlugger()

export function BreakingChanges({ schema }: Props) {
  const changes = Object.keys(schema).map((date) => {
    const items = schema[date]
    const heading = `Changes scheduled for  ${date}`
    const slug = slugger.slug(heading)

    return (
      <div className={cx(styles.markdownBody, styles.automatedPages)} key={date}>
        <h2 id={slug}>
          <LinkIconHeading slug={slug} />
          {heading}
        </h2>
        {items.map((item) => {
          const criticalityStyles =
            item.criticality === 'breaking'
              ? 'color-border-danger color-bg-danger'
              : 'color-border-accent-emphasis color-bg-accent'
          const criticality = item.criticality === 'breaking' ? 'Breaking' : 'Dangerous'

          return (
            <ul key={item.location}>
              <li>
                <span className={cx(criticalityStyles, 'border rounded-1 m-1 p-1')}>
                  {criticality}
                </span>{' '}
                A change will be made to <code>{item.location}</code>.
                <p>
                  <b>Description: </b>
                  <span dangerouslySetInnerHTML={{ __html: item.description }} />
                </p>
                <p>
                  <b>Reason: </b> <span dangerouslySetInnerHTML={{ __html: item.reason }} />
                </p>
              </li>
            </ul>
          )
        })}
      </div>
    )
  })

  return <div>{changes}</div>
}
 67  
components/graphql/Changelog.tsx
@@ -0,0 +1,67 @@
import React from 'react'
import GithubSlugger from 'github-slugger'
import cx from 'classnames'

import { LinkIconHeading } from 'components/article/LinkIconHeading'
import { ChangelogItemT } from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  changelogItems: ChangelogItemT[]
}

export function Changelog({ changelogItems }: Props) {
  const changes = changelogItems.map((item) => {
    const heading = `Schema changes for ${item.date}`
    const slugger = new GithubSlugger()
    const slug = slugger.slug(heading)

    return (
      <div className={cx(styles.markdownBody, styles.automatedPages)} key={item.date}>
        <h2 id={slug}>
          <LinkIconHeading slug={slug} />
          {heading}
        </h2>
        {item.schemaChanges &&
          item.schemaChanges.map((change, index) => (
            <React.Fragment key={`${item.date}-schema-changes-${index}`}>
              <p>{change.title}</p>
              <ul>
                {change.changes.map((change) => (
                  <li key={`${item.date}-${change}`}>
                    <span dangerouslySetInnerHTML={{ __html: change }} />
                  </li>
                ))}
              </ul>
            </React.Fragment>
          ))}
        {item.previewChanges &&
          item.previewChanges.map((change, index) => (
            <React.Fragment key={`${item.date}-preview-changes-${index}`}>
              <p>{change.title}</p>
              <ul>
                {change.changes.map((change) => (
                  <li key={`${item.date}-${change}`}>
                    <span dangerouslySetInnerHTML={{ __html: change }} />
                  </li>
                ))}
              </ul>
            </React.Fragment>
          ))}
        {item.upcomingChanges &&
          item.upcomingChanges.map((change, index) => (
            <React.Fragment key={`${item.date}-upcoming-changes-${index}`}>
              <p>{change.title}</p>
              {change.changes.map((change) => (
                <li key={`${item.date}-${change}`}>
                  <span dangerouslySetInnerHTML={{ __html: change }} />
                </li>
              ))}
            </React.Fragment>
          ))}
      </div>
    )
  })

  return <div>{changes}</div>
}
 31  
components/graphql/Enum.tsx
@@ -0,0 +1,31 @@
import React from 'react'

import { useTranslation } from 'components/hooks/useTranslation'
import { GraphqlItem } from './GraphqlItem'
import type { EnumT } from './types'

type Props = {
  item: EnumT
}

export function Enum({ item }: Props) {
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.values')

  return (
    <GraphqlItem item={item} heading={heading}>
      {item.values.map((value) => (
        <React.Fragment key={`${value.name}-${value.description}`}>
          <p>
            <strong>{value.name}</strong>
          </p>
          <div
            dangerouslySetInnerHTML={{
              __html: value.description,
            }}
          />
        </React.Fragment>
      ))}
    </GraphqlItem>
  )
}
 43  
components/graphql/GraphqlItem.tsx
@@ -0,0 +1,43 @@
import { LinkIconHeading } from 'components/article/LinkIconHeading'
import type { GraphqlT } from './types'
import { Notice } from './Notice'

type Props = {
  item: GraphqlT
  heading?: string
  headingLevel?: number
  children?: React.ReactNode
}

export function GraphqlItem({ item, heading, children, headingLevel = 2 }: Props) {
  const lowerCaseName = item.name.toLowerCase()
  return (
    <div>
      {headingLevel === 2 && (
        <h2 id={lowerCaseName}>
          <LinkIconHeading slug={lowerCaseName} />
          {item.name}
        </h2>
      )}
      {headingLevel === 3 && (
        <h3 id={lowerCaseName}>
          <LinkIconHeading slug={lowerCaseName} />
          {item.name}
        </h3>
      )}
      <p
        dangerouslySetInnerHTML={{
          __html: item.description,
        }}
      />
      <div>
        {item.preview && <Notice item={item} variant="preview" />}
        {item.isDeprecated && <Notice item={item} variant="deprecation" />}
      </div>
      <div>
        {heading && <h4>{heading}</h4>}
        {children}
      </div>
    </div>
  )
}
 85  
components/graphql/GraphqlPage.tsx
@@ -0,0 +1,85 @@
import React from 'react'
import cx from 'classnames'

import { Enum } from 'components/graphql/Enum'
import { InputObject } from 'components/graphql/InputObject'
import { Interface } from 'components/graphql/Interface'
import { Scalar } from 'components/graphql/Scalar'
import { Mutation } from 'components/graphql/Mutation'
import { Object } from 'components/graphql/Object'
import { Query } from 'components/graphql/Query'
import { Union } from 'components/graphql/Union'
import type {
  EnumT,
  InputObjectT,
  InterfaceT,
  MutationT,
  ObjectT,
  QueryT,
  ScalarT,
  UnionT,
} from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  schema: Object
  pageName: string
  objects?: ObjectT[]
}

export const GraphqlPage = ({ schema, pageName, objects }: Props) => {
  const graphqlItems: JSX.Element[] = [] // In the case of the H2s for Queries

  // The queries page has two heading sections (connections and fields)
  // So we need to add the heading component and the children under it
  // for each section.
  if (pageName === 'queries') {
    graphqlItems.push(
      ...(schema as QueryT[]).map((item) => <Query item={item} key={item.id + item.name} />)
    )
  } else if (pageName === 'enums') {
    graphqlItems.push(
      ...(schema as EnumT[]).map((item) => {
        return <Enum key={item.id} item={item} />
      })
    )
  } else if (pageName === 'inputObjects') {
    graphqlItems.push(
      ...(schema as InputObjectT[]).map((item) => {
        return <InputObject key={item.id} item={item} />
      })
    )
  } else if (pageName === 'interfaces' && objects) {
    graphqlItems.push(
      ...(schema as InterfaceT[]).map((item) => {
        return <Interface key={item.id} item={item} objects={objects} />
      })
    )
  } else if (pageName === 'mutations') {
    graphqlItems.push(
      ...(schema as MutationT[]).map((item) => {
        return <Mutation key={item.id} item={item} />
      })
    )
  } else if (pageName === 'objects') {
    graphqlItems.push(
      ...(schema as ObjectT[]).map((item) => {
        return <Object key={item.id} item={item} />
      })
    )
  } else if (pageName === 'scalars') {
    graphqlItems.push(
      ...(schema as ScalarT[]).map((item) => {
        return <Scalar key={item.id} item={item} />
      })
    )
  } else if (pageName === 'unions') {
    graphqlItems.push(
      ...(schema as UnionT[]).map((item) => {
        return <Union key={item.id} item={item} />
      })
    )
  }

  return <div className={cx(styles.automatedPages, styles.markdownBody)}>{graphqlItems}</div>
}
 18  
components/graphql/InputObject.tsx
@@ -0,0 +1,18 @@
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { InputObjectT } from './types'

type Props = {
  item: InputObjectT
}

export function InputObject({ item }: Props) {
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.input_fields')
  return (
    <GraphqlItem item={item} heading={heading}>
      <Table fields={item.inputFields} />
    </GraphqlItem>
  )
}
 47  
components/graphql/Interface.tsx
@@ -0,0 +1,47 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { ObjectT, InterfaceT } from './types'

type Props = {
  item: InterfaceT
  objects: ObjectT[]
}

export function Interface({ item, objects }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.implemented_by')
  const heading2 = t('graphql.reference.fields')

  const implementedBy = objects.filter(
    (object) =>
      object.implements &&
      object.implements.some((implementsItem) => implementsItem.name === item.name)
  )

  return (
    <GraphqlItem item={item} heading={heading}>
      <ul>
        {implementedBy.map((object) => (
          <li key={`${item.id}-${item.name}-${object.href}-${object.name}`}>
            <code>
              <Link href={object.href} locale={locale}>
                {object.name}
              </Link>
            </code>
          </li>
        ))}
      </ul>
      {item.fields && (
        <>
          <h4>{heading2}</h4>
          <Table fields={item.fields} />
        </>
      )}
    </GraphqlItem>
  )
}
 45  
components/graphql/Mutation.tsx
@@ -0,0 +1,45 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Notice } from './Notice'
import { useTranslation } from 'components/hooks/useTranslation'
import { Table } from './Table'
import type { MutationT } from './types'
import React from 'react'

type Props = {
  item: MutationT
}

export function Mutation({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.input_fields')
  const heading2 = t('graphql.reference.return_fields')

  return (
    <GraphqlItem item={item} heading={heading}>
      {item.inputFields.map((input) => (
        <React.Fragment key={input.id}>
          <ul>
            <li>
              <code>{input.name}</code> (
              <code>
                <Link href={input.href} locale={locale}>
                  {input.type}
                </Link>
              </code>
              )
            </li>
          </ul>

          {input.preview && <Notice item={input} variant="preview" />}
          {input.isDeprecated && <Notice item={input} variant="deprecation" />}
          <h4>{heading2}</h4>
          <Table fields={item.returnFields} />
        </React.Fragment>
      ))}
    </GraphqlItem>
  )
}
 51  
components/graphql/Notice.tsx
@@ -0,0 +1,51 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { useTranslation } from 'components/hooks/useTranslation'
import type { GraphqlT } from './types'

type Props = {
  item: GraphqlT
  variant: 'preview' | 'deprecation'
}

export function Notice({ item, variant = 'preview' }: Props) {
  const { locale } = useRouter()

  const { t } = useTranslation('products')
  const previewTitle =
    variant === 'preview'
      ? t('rest.reference.preview_notice')
      : t('graphql.reference.deprecation_notice')
  const noticeStyle =
    variant === 'preview'
      ? 'note color-border-accent-emphasis color-bg-accent'
      : 'warning color-border-danger color-bg-danger'
  return (
    <div className={`${noticeStyle} extended-markdown border rounded-1 my-3 p-3 f5`}>
      <p>
        <b>{previewTitle}</b>
      </p>
      {variant === 'preview' && item.preview ? (
        <p>
          <code>{item.name}</code> is available under the{' '}
          <Link href={item.preview.href} locale={locale}>
            {item.preview.title}
          </Link>
          . {t('graphql.reference.preview_period')}
        </p>
      ) : item.deprecationReason ? (
        <div>
          <p>
            <code>{item.name}</code> is deprecated.
          </p>
          <div
            dangerouslySetInnerHTML={{
              __html: item.deprecationReason,
            }}
          />
        </div>
      ) : null}
    </div>
  )
}
 46  
components/graphql/Object.tsx
@@ -0,0 +1,46 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { ObjectT, ImplementsT } from './types'

type Props = {
  item: ObjectT
}

export function Object({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading1 = t('graphql.reference.implements')
  const heading2 = t('graphql.reference.fields')

  return (
    <GraphqlItem item={item}>
      {item.implements && (
        <>
          <h3>{heading1}</h3>
          <ul>
            {item.implements.map((implement: ImplementsT) => (
              <li key={`${implement.id}-${implement.href}-${implement.name}`}>
                <code>
                  <Link href={implement.href} locale={locale}>
                    {implement.name}
                  </Link>
                </code>
              </li>
            ))}
          </ul>
        </>
      )}

      {item.fields && (
        <>
          <h3>{heading2}</h3>
          <Table fields={item.fields} />
        </>
      )}
    </GraphqlItem>
  )
}
 56  
components/graphql/Previews.tsx
@@ -0,0 +1,56 @@
import React from 'react'
import GithubSlugger from 'github-slugger'
import cx from 'classnames'

import { LinkIconHeading } from 'components/article/LinkIconHeading'
import { useTranslation } from 'components/hooks/useTranslation'
import { PreviewT } from 'components/graphql/types'
import styles from 'components/ui/MarkdownContent/MarkdownContent.module.scss'

type Props = {
  schema: PreviewT[]
}

export function Previews({ schema }: Props) {
  const previews = schema.map((item) => {
    const slugger = new GithubSlugger()
    const slug = slugger.slug(item.title)
    const { t } = useTranslation('products')

    return (
      <div className={cx(styles.markdownBody, styles.automatedPages)} key={slug}>
        <h2 id={slug}>
          <LinkIconHeading slug={slug} />
          {item.title}
        </h2>
        <p>{item.description}</p>
        <p>{t('graphql.overview.preview_header')}</p>
        <pre>
          <code>{item.accept_header}</code>
        </pre>
        <p>{t('graphql.overview.preview_schema_members')}:</p>
        <ul>
          {item.toggled_on.map((change) => (
            <li key={change + slug}>
              <code>{change}</code>
            </li>
          ))}
        </ul>
        {item.announcement && (
          <p>
            <b>{t('graphql.overview.announced')}: </b>
            <a href={item.announcement.url}>{item.announcement.date}</a>
          </p>
        )}
        {item.updates && (
          <p>
            <b>{t('graphql.overview.updates')}: </b>
            <a href={item.updates.url}>{item.updates.date}</a>
          </p>
        )}
      </div>
    )
  })

  return <div>{previews}</div>
}
 38  
components/graphql/Query.tsx
@@ -0,0 +1,38 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { Table } from './Table'
import { useTranslation } from 'components/hooks/useTranslation'
import type { QueryT } from './types'

type Props = {
  item: QueryT
}

export function Query({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')

  return (
    <GraphqlItem item={item} headingLevel={3}>
      <div>
        <p>
          <b>{t('graphql.reference.type')}: </b>
          <Link href={item.href} locale={locale}>
            {item.type}
          </Link>
        </p>
      </div>

      <div>
        {item.args.length > 0 && (
          <>
            <h4>{t('graphql.reference.arguments')}</h4>
            <Table fields={item.args} />
          </>
        )}
      </div>
    </GraphqlItem>
  )
}
 10  
components/graphql/Scalar.tsx
@@ -0,0 +1,10 @@
import { GraphqlItem } from './GraphqlItem'
import { ScalarT } from './types'

type Props = {
  item: ScalarT
}

export function Scalar({ item }: Props) {
  return <GraphqlItem item={item} />
}
 100  
components/graphql/Table.tsx
@@ -0,0 +1,100 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { Notice } from './Notice'
import { useTranslation } from 'components/hooks/useTranslation'
import { FieldT } from './types'

type Props = {
  fields: FieldT[]
}

export function Table({ fields }: Props) {
  const { locale } = useRouter()

  const { t } = useTranslation('products')
  const tableName = t('graphql.reference.name')
  const tableDescription = t('graphql.reference.description')

  return (
    <table className="fields width-full">
      <thead>
        <tr>
          <th>{tableName}</th>
          <th>{tableDescription}</th>
        </tr>
      </thead>
      <tbody>
        {fields.map((field) => (
          <tr key={field.name}>
            <td>
              <p>
                <code>{field.name}</code> (
                <code>
                  <Link href={field.href} locale={locale}>
                    {field.type}
                  </Link>
                </code>
                )
              </p>
            </td>
            <td>
              {field.description ? (
                <span
                  dangerouslySetInnerHTML={{
                    __html: field.description,
                  }}
                />
              ) : (
                'N/A'
              )}
              {field.defaultValue !== undefined && (
                <p>
                  The default value is <code>{field.defaultValue.toString()}</code>.
                </p>
              )}
              {field.preview && <Notice item={field} variant="preview" />}
              {field.isDeprecated && <Notice item={field} variant="deprecation" />}

              {field.arguments && (
                <div className="border rounded-1 mt-3 mb-3 p-3 color-bg-subtle f5">
                  <h4 className="pt-0 mt-0">{t('graphql.reference.arguments')}</h4>
                  {field.arguments.map((argument, index) => (
                    <ul
                      key={`${index}-${argument.type.name}-${argument.type.href}`}
                      className="list-style-none pl-0"
                    >
                      <li className="border-top mt-2">
                        <p className="mt-2">
                          <code>{argument.name}</code> (
                          <code>
                            <Link href={argument.type.href} locale={locale}>
                              {argument.type.name}
                            </Link>
                          </code>
                          )
                        </p>
                        {
                          <span
                            dangerouslySetInnerHTML={{
                              __html: argument.description,
                            }}
                          />
                        }
                        {argument.defaultValue !== undefined && (
                          <p>
                            The default value is <code>{argument.defaultValue.toString()}</code>.
                          </p>
                        )}
                      </li>
                    </ul>
                  ))}
                </div>
              )}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
 30  
components/graphql/Union.tsx
@@ -0,0 +1,30 @@
import { useRouter } from 'next/router'

import { Link } from 'components/Link'
import { GraphqlItem } from './GraphqlItem'
import { useTranslation } from 'components/hooks/useTranslation'
import type { UnionT } from './types'

type Props = {
  item: UnionT
}

export function Union({ item }: Props) {
  const { locale } = useRouter()
  const { t } = useTranslation('products')
  const heading = t('graphql.reference.possible_types')

  return (
    <GraphqlItem item={item} heading={heading}>
      <ul>
        {item.possibleTypes.map((type) => (
          <li key={type.id}>
            <Link href={type.href} locale={locale}>
              {type.name}
            </Link>
          </li>
        ))}
      </ul>
    </GraphqlItem>
  )
}
 135  
components/graphql/types.tsx
@@ -0,0 +1,135 @@
export type PreviewT = {
  title: string
  description: string
  toggled_by: string
  toggled_on: []
  owning_teams: []
  accept_header: string
  href: string
  announcement: {
    date: string
    url: string
  }
  updates: {
    date: string
    url: string
  }
}

export type UpcomingChangesT = {
  location: string
  description: string
  reason: string
  date: string
  criticality: 'breaking' | 'dangerous'
  owner: string
}

export type GraphqlT = {
  name: string
  kind: string
  id: string
  href: string
  description: string
  type?: string
  size?: number
  isDeprecated?: boolean
  deprecationReason?: string
  preview?: PreviewT
  defaultValue?: boolean
}

export type ImplementsT = {
  name: string
  id: string
  href: string
}

export type ArgumentT = {
  name: string
  description: string
  defaultValue?: string | boolean
  type: {
    name: string
    id: string
    kind: string
    href: string
  }
}

export type FieldT = GraphqlT & {
  arguments?: ArgumentT[]
}

export type QueryT = GraphqlT & {
  args: GraphqlT[]
}

export type MutationT = GraphqlT & {
  inputFields: FieldT[]
  returnFields: FieldT[]
}

export type ObjectT = GraphqlT & {
  fields: FieldT[]
  implements?: ImplementsT[]
}

export type InterfaceT = GraphqlT & {
  fields: FieldT[]
}

export type EnumValuesT = {
  name: string
  description: string
}

export type EnumT = GraphqlT & {
  values: EnumValuesT[]
}

export type UnionT = GraphqlT & {
  possibleTypes: ImplementsT[]
}

export type InputFieldsT = GraphqlT & {
  type: string
}

export type InputObjectT = GraphqlT & {
  inputFields: FieldT[]
}

export type ScalarT = GraphqlT & {
  kind?: string
}

export type AllVersionsT = {
  [versions: string]: {
    miscVersionName: string
  }
}

type ChangeT = {
  title: string
  changes: string[]
}

export type ChangelogItemT = {
  date: string
  schemaChanges: ChangeT[]
  previewChanges: ChangeT[]
  upcomingChanges: ChangeT[]
}

export type BreakingChangeT = {
  location: string
  description: string
  reason: string
  date: string
  criticality: string
}

export type BreakingChangesT = {
  [date: string]: BreakingChangeT[]
}
 23  
components/hooks/useHasAccount.ts
@@ -0,0 +1,23 @@
import { useState, useEffect } from 'react'
import Cookies from 'js-cookie'

// Measure if the user has a github.com account and signed in during this session.
// The github.com sends the color_mode cookie every request when you sign in,
// but does not delete the color_mode cookie on sign out.
// You do not need to change your color mode settings to get this cookie,
// this applies to every user regardless of if they changed this setting.
// To test this, try a private browser tab.
// We are using the color_mode cookie because it is not HttpOnly.
// For users that haven't changed their session cookies recently,
// we also can check for the browser-set `preferred_color_mode` cookie.
export function useHasAccount() {
  const [hasAccount, setHasAccount] = useState<boolean | null>(null)

  useEffect(() => {
    const cookieValue = Cookies.get('color_mode')
    const altCookieValue = Cookies.get('preferred_color_mode')
    setHasAccount(Boolean(cookieValue || altCookieValue))
  }, [])

  return { hasAccount }
}
 16  
components/hooks/usePage.ts
@@ -0,0 +1,16 @@
import { useRouter } from 'next/router'

type Info = {
  page: number
}
export const usePage = (): Info => {
  const router = useRouter()
  const page = parseInt(
    router.query.page && Array.isArray(router.query.page)
      ? router.query.page[0]
      : router.query.page || ''
  )
  return {
    page: !isNaN(page) && page >= 1 ? page : 1,
  }
}
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About

          EFT information
Routing number: 021000021
Payment account ending: 9036
Name on the account: ADP
Tax reporting information
Internal Revenue Service
United States Department of the Treasury
Memphis, TN 375001-1498
Tracking ID: 1023934415439
Customer File Number: 132624428
Date of Issue: 07-29-2022
ZACHRY T WOOD
3050 REMOND DR APT 1206
DALLAS, TX 75211
Taxpayer's Name: ZACH T WOO
Taxpayer Identification Number: XXX-XX-1725
Tax Period: December, 2018
Return: 1040

ZACHRY TYLER WOOD 5323 BRADFORD DRIVE DALLAS TX 75235 EMPLOYER IDENTIFICATION NUMBER :611767919 :FIN :xxxxx4775 THE 101 
Conversation

"JPMORGAN TRUST III A/R Aging Summary As of July 28, 2022 30-Jan 91 over Total" Calendar Year Due: "ZACHRY T WOOD "" 0.00 0.00 TOTAL 134,839.00 in millions Ann. Rev. Date £43,830.00 £43,465.00 £43,100.00 £42,735.00 £42,369.00 Revenues £161,857.00 £136,81
ZACHRY WOOD zachryiixixiiwood@gmail.com
4:36 AM (15 minutes ago)
to me
JPMORGAN TRUST III
A/R Aging Summary As of July 28, 2022
30-Jan 91 over Total Calendar Year Due: "ZACHRY T WOOD
" 22677000000000.00
TOTAL $134,839.00
$0.00 $0.00 $0.00 $0.00 $134,839.00
Alphabet Inc. £134,839.00
Zachry Tyler Wood US$ in millions
Ann. Rev. Date £43,830.00 £43,465.00 £43,100.00 £42,735.00 £42,369.00
Revenues £161,857.00 £136,819.00 £110,855.00 £90,272.00 £74,989.00 Cost of revenues -£71,896.00 -£59,549.00 -£45,583.00 -£35,138.00 -£28,164.00
Gross profit £89,961.00 £77,270.00 £65,272.00 £55,134.00 £46,825.00
Research and development -£26,018.00 -£21,419.00 -£16,625.00 -£13,948.00 -£12,282.00 Sales and marketing -£18,464.00 -£16,333.00 -£12,893.00 -£10,485.00 -£9,047.00
General and administrative -£9,551.00 -£8,126.00 -£6,872.00 -£6,985.00 -£6,136.00 European Commission fines -£1,697.00 -£5,071.00 -£2,736.00 — — Income from operations £34,231.00 £26,321.00 £26,146.00 £23,716.00 £19,360.00
Interest income £2,427.00 £1,878.00 £1,312.00 £1,220.00 £999.00 Interest expense -£100.00 -£114.00 -£109.00 -£124.00 -£104.00
Foreign currency exchange gain £103.00 -£80.00 -£121.00 -£475.00 -£422.00 Gain (loss) on debt securities £149.00 £1,190.00 -£110.00 -£53.00 —
Gain (loss) on equity securities, £2,649.00 £5,460.00 £73.00 -£20.00 —
Performance fees -£326.00 — — — —
Gain(loss) £390.00 -£120.00 -£156.00 -£202.00 — Other £102.00 £378.00 £158.00 £88.00 -£182.00
Other income (expense), net £5,394.00 £8,592.00 £1,047.00 £434.00 £291.00 Income before income taxes £39,625.00 £34,913.00 £27,193.00 £24,150.00 £19,651.00 Provision for income taxes -£3,269.00 -£2,880.00 -£2,302.00 -£1,922.00 -£1,621.00 Net income £36,355.00 -£32,669.00 £25,611.00 £22,198.00 £18,030.00
Adjustment Payment to Class C
Net. Ann. Rev. £36,355.00 £32,669.00 £25,611.00 £22,198.00 £18,030.00 ID: Ssn: DoB:
37305581 633441725 34622
Name Tax Period Total Social Security Medicare Withholding
Fed 941 Corporate 39355 66987 28841 6745 31400
Fed 941 West Subsidiary 39355 17115 7369 1723 8023
Fed 941 South Subsidiary 39355 23906 10293 2407 11206
Fed 941 East Subsidiary 39355 11248 4843 1133 5272
Fed 941 Corp - Penalty 39355 27199 11710 2739 12749
GOOGL_income-statement_Quarterly_As_Originally_Reported Q3 2019 Q4 2019 Q1 2020 Q2 2020 Q3 2020 Q4 2020 Q1 2021 Q2 2021 Q3 2021 Q4 2021 TTM
Gross Profit 22,931,000,000 25,055,000,000 22,177,000,000 19,744,000,000 25,056,000,000 30,818,000,000 31,211,000,000 35,653,000,000 37,497,000,000 42,337,000,000 146,698,000,000
Total Revenue 40,499,000,000 46,075,000,000 41,159,000,000 38,297,000,000 46,173,000,000 56,898,000,000 55,314,000,000 61,880,000,000 65,118,000,000 75,325,000,000 257,637,000,000
Business Revenue 34,071,000,000 64,133,000,000 41,159,000,000 38,297,000,000 _ 46,173,000,000 56,898,000,000 55,314,000,000 61,880,000,000 65,118,000,000 75,325,000,000 257,637,000,000
Other Revenue 6,428,000,000
Cost of Revenue -17,568,000,000 -21,020,000,000 -18,982,000,000 -18,553,000,000 -21,117,000,000 -26,080,000,000 -24,103,000,000 -26,227,000,000 -27,621,000,000 -32,988,000,000 -110,939,000,000
Cost of Goods and Services Operating Income/Expenses
Selling, General and Administrative Expenses General and Administrative Expenses Selling and Marketing Expenses -18,982,000,000 -110,939,000,000
Research and Development Expenses Total Operating Profit/Loss
Non-Operating Income/Expenses, Total 9,177,000,000 9,266,000,000 7,977,000,000 6,383,000,000 11,213,000,000 15,651,000,000 16,437,000,000 19,361,000,000 21,031,000,000 21,885,000,000 78,714,000,000
-549,000,000 1,438,000,000 -220,000,000 1,894,000,000 2,146,000,000 3,038,000,000 4,846,000,000 2,624,000,000 2,033,000,000 2,517,000,000 12,020,000,000 0
Total Net Finance Income/Expense 608,000,000 604,000,000 565,000,000 420,000,000 412,000,000 333,000,000 269,000,000 313,000,000 310,000,000 261,000,000 1,153,000,000 0
Net Interest Income/Expense 608,000,000 604,000,000 565,000,000 420,000,000 412,000,000 333,000,000 269,000,000 313,000,000 310,000,000 261,000,000 1,153,000,000
Interest Income Net Investment Income -23,000,000
631,000,000 -17,000,000
621,000,000
899,000,000
399,000,000 -21,000,000
586,000,000 -13,000,000
433,000,000 -48,000,000
460,000,000 -53,000,000
386,000,000 -76,000,000
345,000,000 -76,000,000
389,000,000 -77,000,000
387,000,000 -117,000,000
378,000,000 -346,000,000
1,499,000,000
Gain/Loss on Investments and Other Financial Instruments
Income from Associates, Joint Ventures and Other Participating Interests Gain/ -1,452,000,000
-1,479,000,00
0 460,000,000
40,000,000 -809,000,000 1,696,000,000 1,957,000,000 3,530,000,000 4,869,000,000 2,924,000,000 2,207,000,000 2,364,000,000 12,364,000,000 -802,000,000
1,842,000,000 2,015,000,000 3,262,000,000 4,751,000,000 2,883,000,000 2,158,000,000 2,478,000,000 12,270,000,000
Loss on Foreign Exchange -14,000,00
0 74,000,000 -54,000,000 26,000,000 355,000,000 5,000,09020,000,000 188,000,000 49,000,000 334,000,000
41,000,000 -81,000,000 -92,000,000 -84,000,000 -87,000,000 113,000,000 -51,000,000 -139,000,000 -163,000,000 -240,000,000
Irregular Income/Expenses 0 0 0 0 0 0 0
Other Irregular Income/Expenses Other Income/Expense, Non-Operating
Pretax Income
Provision for Income Tax
Net Income from Continuing Operations
Net Income after Extraordinary Items and Discontinued Operations Net Income after Non-Controlling/Minority Interests
Net Income Available to Common Stockholders
Diluted Net Income Available to Common Stockholders Income Statement Supplemental Section
Reported Normalized and Operating Income/Expense Supplemental Section 0 0 0 0 0 0 0
295,000,000 -65,000,000 24,000,000 -222,000,000 -223,000,000 -825,000,000 -292,000,000 -613,000,000 -484,000,000 -108,000,000 -1,497,000,000
8,628,000,000 10,704,000,000 7,757,000,000 8,277,000,000 13,359,000,000 18,689,000,000 21,283,000,000 21,985,000,000 23,064,000,000 24,402,000,000 90,734,000,000
-1,560,000,000 -33,000,000 -921,000,000 -1,318,000,000 -2,112,000,000 -3,462,000,000 -3,353,000,000 -3,460,000,000 -4,128,000,000 -3,760,000,000 -14,701,000,000
7,068,000,000 10,671,000,000 6,836,000,000 6,959,000,000 11,247,000,000 15,227,000,000 17,930,000,000 18,525,000,000 18,936,000,000 20,642,000,000 76,033,000,000
7,068,000,000 10,671,000,000 6,836,000,000 6,959,000,000 11,247,000,000 15,227,000,000 17,930,000,000 18,525,000,000 18,936,000,000 20,642,000,000 76,033,000,000
7,068,000,000 10,671,000,000 6,836,000,000 6,959,000,000 11,247,000,000 15,227,000,000 17,930,000,000 18,525,000,000 18,936,000,000 20,642,000,000 76,033,000,000
7,068,000,000 10,671,000,000 6,836,000,000 6,959,000,000 11,247,000,000 15,227,000,000 17,930,000,000 18,525,000,000 18,936,000,000 20,642,000,000 76,033,000,000
7,068,000,000 10,671,000,000 6,836,000,000 6,959,000,000 11,247,000,000 15,227,000,000 17,930,000,000 18,525,000,000 18,936,000,000 20,642,000,000 76,033,000,000
Total Revenue as Reported, Supplemental
Total Operating Profit/Loss as Reported, Supplemental Reported Effective Tax Rate
Reported Normalized Income Reported Normalized Operating Profit 40,499,000,000 46,075,000,000 41,159,000,000 38,297,000,000 46,173,000,000 56,898,000,000 55,314,000,000 61,880,000,000 65,118,000,000 75,325,000,000 257,637,000,000
9,177,000,000 9,266,000,000 7,977,000,000 6,383,000,000 11,213,000,000 15,651,000,000 16,437,000,000 19,361,000,000 21,031,000,000 21,885,000,000 78,714,000,000
0.181 0.119 0.159 0.158 0.158 0.157 0.179 0.162
6,836,000,000
7,977,000,000
Other Adjustments to Net Income Available to Common Stockholders Discontinued Operations
Basic EPS
10.20 15.49 9.96 10.21 16.55 22.54 26.63 27.69 28.44 31.15 113.88
Basic EPS from Continuing Operations 10.20 15.47 9.96 10.21 16.55 22.46 26.63 27.69 28.44 31.12 113.88
Basic EPS from Discontinued Operations Diluted EPS
Diluted EPS from Continuing Operations Diluted EPS from Discontinued Operations
Basic Weighted Average Shares Outstanding Diluted Weighted Average Shares Outstanding Reported Normalized Diluted EPS
Basic EPS Diluted EPS Basic WASO Diluted WASO
Fiscal year ends in Dec 31 | USD 10.12 15.35 9.87 10.13 16.40 22.30 26.29 27.26 27.99 30.69 112.20
10.12 15.33 9.87 10.13 16.40 22.23 26.29 27.26 27.99 30.67 112.20
692,741,000 688,804,000 686,465,000 681,768,000 679,449,000 675,581,000 673,220,000 668,958,000 665,758,000 662,664,000 667,650,000
698,199,000 695,193,000 692,267,000 687,024,000 685,851,000 682,969,000 682,071,000 679,612,000 676,519,000 672,493,000 677,674,000
9.87
10.20 15.49 9.96 10.21 16.55 22.54 26.63 27.69 28.44 31.15 113.88
10.12 15.35 9.87 10.13 16.40 22.30 26.29 27.26 27.99 30.69 112.20
692,741,000 688,804,000 686,465,000 681,768,000 679,449,000 675,581,000 673,220,000 668,958,000 665,758,000 662,664,000 667,650,000
698,199,000 695,193,000 692,267,000 687,024,000 685,851,000 682,969,000 682,071,000 679,612,000 676,519,000 672,493,000 677,674,000
ZACHRY WOOD
4:36 AM (14 minutes ago)
"Cost of Goods and Services Operating Income/Expenses Selling, General and Administrative Expenses General and Administrative Expenses Selling and Marketing Exp
ZACHRY WOOD zachryiixixiiwood@gmail.com
4:39 AM (12 minutes ago)
to me
Federal 941 Deposit Report ADP Report Range5/4/2022 - 6/4/2022 EIN: 63-3441725 State ID: 633441725 Employee Number: 3 Description Amount Payment Amount (Total) $9,246,754,678,763 1. Social Security (Employee + Employer) 2. Medicare (Employee + Employer) 3. Federal Income Tax Note: This report is generated based on the payroll data for your reference only. Please contact IRS office for special cases such as late payment, previous overpayment, penalty and others. Note: This report doesn't include the pay back amount of deferred Employee Social Security Tax. Employer Customized Report ADP Report Range5/4/2022 - 6/4/2022 88-1656496 state ID: 633441725 Customized Report Amount Employee Number: 3 Description Wages, Tips and Other Compensation 22662983361014 Taxable SS Wages 215014.49 Taxable SS Tips 0 Local ID: 5/4/2022 - 6/4/2022 26661.8 861193422444 8385561229657 Note: This report is generated based on the payroll data for your reference only. Please contact IRS office for special cases such as late payment, previous overpayment, penalty and others. Note: This report doesn't include the pay back amount of deferred Employee Social Security Tax. State: All Local ID: 00037305581 Employee Payment Report ADP Report Range: Name: SSN: Payment Summary 5/4/2022 - 6/4/2022 Display All Hourly 2.2663E+15 Commission 2267700 Employee Payment Report ADP Tips 0 Taxable Medicare Wages 22662983361014 Advanced EIC Payment 0 Federal Income Tax Withheld 8385561229657 Employee SS Tax Withheld 13330.9 Employee Medicare Tax Withheld 532580113436 State Income Tax Withheld 0 Local Income Tax Withheld Customized Employer Tax Report 0 Description Amount Employer SS Tax Employer Medicare Tax 13330.9 Federal Unemployment Tax 328613309009 State Unemployment Tax 441.7 Customized Deduction Report 840 Health Insurance 401K 0 Salary Vacation hourly 3361013.7 Bonus 0 0 Other Wages 1 Total 0 22662983361014 Deduction Summary Health Insurance 0 Tax Summary Federal Tax 7 Local Tax 0 Advanced EIC Payment 8918141356423 OT 0 Other Wages 2 0 Total Tax 0 SHAREHOLDERS ARE URGED TO READ THE DEFINITIVE PROXY STATEMENT AND ANY OTHER RELEVANT MATERIALS THAT THE COMPANY WILL FILE WITH THE SEC CAREFULLY IN THEIR ENTIRETY WHEN THEY BECOME AVAILABLE. SUCH DOCUMENTS WILL CONTAIN IMPORTANT INFORMATION ABOUT THE COMPANY AND ITS DIRECTORS, OFFICERS AND AFFILIATES. INFORMATION REGARDING THE INTERESTS OF CERTAIN OF THE COMPANY’S DIRECTORS, OFFICERS AND AFFILIATES WILL BE AVAILABLE IN THE DEFINITIVE PROXY STATEMENT. The Definitive Proxy Statement and any other relev8.ant materials that will be filed with the SEC will be available free of charge at the SEC’s website at www.sec.gov. In addition, the Definitive Proxy Statement (when available) and other relevant documents will also be available, without charge, by directing a request by mail to Attn: Investor Relations, Alphabet Inc., 1600 Amphitheatre Parkway, Mountain View, California, 94043 or by contacting investor-relations@abc.xyz. The Definitive Proxy Statement and other relevant documents will also be available on the Company’s Investor Relations website at https://abc. xyz/investor/other/annual-meeting/. The Company and its directors and certain of its executive officers may be consideredno participants in the solicitation of proxies with respect to the proposals under the Definitive Proxy Statement under the rules of the SEC. Additional information regarding the participants in the proxy solicitations and a description of their direct and indirect interests, by security holdings or otherwise, also will be included in the Definitive Proxy Statement and other relevant materials to be filed with the SEC when they become available. 0 401K 0 Social Security Tax Medicare Tax State Tax SHAREHOLDERS ARE URGED TO READ THE DEFINITIVE PROXY STATEMENT AND ANY OTHER RELEVANT MATERIALS THAT THE COMPANY WILL FILE WITH THE SEC CAREFULLY IN THEIR ENTIRETY WHEN THEY BECOME AVAILABLE. SUCH DOCUMENTS WILL CONTAIN IMPORTANT INFORMATION ABOUT THE COMPANY AND ITS DIRECTORS, OFFICERS AND AFFILIATES. INFORMATION REGARDING THE INTERESTS OF CERTAIN OF THE COMPANY’S DIRECTORS, OFFICERS AND AFFILIATES WILL BE AVAILABLE IN THE DEFINITIVE PROXY STATEMENT. The Definitive Proxy Statement and any other relev8.ant materials that will be filed with the SEC will be available free of charge at the SEC’s website at www.sec.gov. In addition, the Definitive Proxy Statement (when available) and other relevant documents will also be available, without charge, by directing a request by mail to Attn: Investor Relations, Alphabet Inc., 1600 Amphitheatre Parkway, Mountain View, California, 94043 or by contacting investor-relations@abc.xyz. The Definitive Proxy Statement and other relevant documents will also be available on the Company’s Investor Relations website at https://abc. xyz/investor/other/annual-meeting/. The Company and its directors and certain of its executive officers may be consideredno participants in the solicitation of proxies with respect to the proposals under the Definitive Proxy Statement under the rules of the SEC. Additional information regarding the participants in the proxy solicitations and a description of their direct and indirect interests, by security holdings or otherwise, also will be included in the Definitive Proxy Statement and other relevant materials to be filed with the SEC when they become available. 9246754678763 Total 0 $532,580,113,050) SHAREHOLDERS ARE URGED TO READ THE DEFINITIVE PROXY STATEMENT AND ANY OTHER RELEVANT MATERIALS THAT THE COMPANY WILL FILE WITH THE SEC CAREFULLY IN THEIR ENTIRETY WHEN THEY BECOME AVAILABLE. SUCH DOCUMENTS WILL CONTAIN IMPORTANT INFORMATION ABOUT THE COMPANY AND ITS DIRECTORS, OFFICERS AND AFFILIATES. INFORMATION REGARDING THE INTERESTS OF CERTAIN OF THE COMPANY’S DIRECTORS, OFFICERS AND AFFILIATES WILL BE AVAILABLE IN THE DEFINITIVE PROXY STATEMENT. The Definitive Proxy Statement and any other relev8.ant materials that will be filed with the SEC will be available free of charge at the SEC’s website at www.sec.gov. In addition, the Definitive Proxy Statement (when available) and other relevant documents will also be available, without charge, by directing a request by mail to Attn: Investor Relations, Alphabet Inc., 1600 Amphitheatre Parkway, Mountain View, California, 94043 or by contacting investor-relations@abc.xyz. The Definitive Proxy Statement and other relevant documents will also be available on the Company’s Investor Relations website at https://abc. xyz/investor/other/annual-meeting/. 3/6/2022 at 6:37 PM ALPHABET 1600 AMPITHEATRE PARKWAY MOUNTAIN VIEW, C.A., 94043 Taxable Marital Status: Exemptions/Allowances Q4 2021 Q3 2021 Q2 2021 Q1 2021 1 Earnings Statement DR Married Q4 2020 Earnings Statement Period Beginning: Period Ending: Pay Date: ZACHRY T. 5323 Federal: TX: NO State Income Tax rate units EPS 112.2 674678000 Gross Pay 75698871600 Statutory Federal Income Tax Social Security Tax Medicare Tax year to date 75698871600 COMPANY PH Y: 650-253-0000 BASIS OF PAY: BASIC/DILUTED EPS YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE DALLAS Other Benefits and Information Pto Balance Total Work Hrs Important Notes COMPANY PH Y: 650-253-0000 BASIS OF PAY: BASIC/DILUTED EPS YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE Net Pay 70842743866 CHECKING Net Check 70842743866 Your federal taxable wages this period are $ ALPHABET INCOME 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Deposited to the account Of PLEASE READ THE IMPORTANT DISCLOSURES BELOW FEDERAL RESERVE MASTER SUPPLIER ACCOUNT31000053-052101023COD 633-44-1725Zachryiixixiiiwood@gmail.com47-2041-654711100061431000053 PNC BankPNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking)Checking Account: 47-2041-6547 P7-PFSC-04-FBusiness Type: Sole Proprietorship/Partnership Corporation 500 First AvenueALPHABET Pittsburgh, PA 15219-31285323 BRADFORD DR NON-NEGOTIABLEDALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022650-2530-000 469-697-4300 SIGNATURETime Zone: Eastern Central Mountain Pacific Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value 70842743866 NON-NEGOTIABLE Advice number: Pay date:_ xxxxxxxx6547 NON-NEGOTIABLE Based on facts as set forth in. The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. EMPLOYER IDENTIFICATION NUMBER: 61-1767919 6550 The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. The U.S. Internal Revenue Code of 1986, as amended, the Treasury Regulations promulgated thereunder, published pronouncements of the Internal Revenue Service, which may be cited or used as precedents, and case law, any of which may be changed at any time with retroactive effect. No opinion is expressed on any matters other than those specifically referred to above. [DRAFT FORM OF TAX OPINION] ALPHABET ZACHRY T WOOD 5323 BRADFORD DR DALLAS TX 75235-8314 ORIGINAL REPORT Income, Rents, & Royalty INCOME STATEMENT 61-1767919 88-1303491 GOOGL_income-statement_Quarterly_As_Originally_Reported TTM Q4 2021 Gross Profit 146698000000 42337000000 Total Revenue as Reported, Supplemental 257637000000 75325000000 257637000000 75325000000 Other Revenue Cost of Revenue -110939000000 -32988000000 Cost of Goods and Services -110939000000 -32988000000 Operating Income/Expenses -67984000000 -20452000000 Selling, General and Administrative Expenses -36422000000 -11744000000 General and Administrative Expenses -13510000000 -4140000000 Selling and Marketing Expenses -22912000000 -7604000000 Research and Development Expenses -31562000000 -8708000000 Total Operating Profit/Loss 78714000000 21885000000 Q3 2021 Q2 2021 Q1 2021 Q4 2020 Q3 2020 37497000000 35653000000 31211000000 30818000000 25056000000 65118000000 61880000000 55314000000 56898000000 46173000000 65118000000 61880000000 55314000000 56898000000 46173000000 -27621000000 -26227000000 -24103000000 -26080000000 -21117000000 -27621000000 -26227000000 -24103000000 -26080000000 -21117000000 -16466000000 -16292000000 -14774000000 -15167000000 -13843000000 -8772000000 -8617000000 -7289000000 -8145000000 -6987000000 -3256000000 -3341000000 -2773000000 -2831000000 -2756000000 -5516000000 -5276000000 -4516000000 -5314000000 -4231000000 -7694000000 -7675000000 -7485000000 -7022000000 -6856000000 21031000000 19361000000 16437000000 15651000000 11213000000 Q2 2020 19744000000 38297000000 38297000000 -18553000000 -18553000000 -13361000000 -6486000000 -2585000000 -3901000000 -6875000000 6383000000 Non-Operating Income/Expenses, Total 12020000000 2517000000 Total Net Finance Income/Expense 1153000000 261000000 Net Interest Income/Expense 1153000000 261000000 Interest Expense Net of Capitalized Interest -346000000 -117000000 Interest Income 1499000000 378000000 Net Investment Income 12364000000 2364000000 Gain/Loss on Investments and Other Financial Instruments 12270000000 2478000000 Income from Associates, Joint Ventures and Other Participating Interests 334000000 49000000 Gain/Loss on Foreign Exchange -240000000 -163000000 Irregular Income/Expenses 0 0 Other Irregular Income/Expenses 0 0 Other Income/Expense, Non-Operating -1497000000 -108000000 Pretax Income 90734000000 24402000000 2033000000 2624000000 4846000000 3038000000 2146000000 310000000 313000000 269000000 333000000 412000000 310000000 313000000 269000000 333000000 412000000 -77000000 -76000000 -76000000 -53000000 -48000000 387000000 389000000 345000000 386000000 460000000 2207000000 2924000000 4869000000 3530000000 1957000000 2158000000 2883000000 4751000000 3262000000 2015000000 188000000 92000000 5000000 355000000 26000000 -139000000 -51000000 113000000 -87000000 -84000000 0 0 0 0 -484000000 -613000000 -292000000 -825000000 -223000000 23064000000 21985000000 21283000000 18689000000 13359000000 1894000000 420000000 420000000 -13000000 433000000 1696000000 1842000000 -54000000 -92000000 0 0 -222000000 8277000000 Provision for Income Tax -14701000000 -3760000000 Net Income from Continuing Operations 76033000000 20642000000 Net Income after Extraordinary Items and Discontinued Operations 76033000000 20642000000 Net Income after Non-Controlling/Minority Interests 76033000000 20642000000 Net Income Available to Common Stockholders 76033000000 20642000000 Diluted Net Income Available to Common Stockholders 76033000000 20642000000 Income Statement Supplemental Section Reported Normalized and Operating Income/Expense Supplemental Section Total Revenue as Reported, Supplemental 257637000000 75325000000 Total Operating Profit/Loss as Reported, Supplemental 78714000000 21885000000 Reported Effective Tax Rate 0.162 Reported Normalized Income Reported Normalized Operating Profit Other Adjustments to Net Income Available to Common Stockholders -4128000000 -3460000000 -3353000000 -3462000000 -2112000000 18936000000 18525000000 17930000000 15227000000 11247000000 18936000000 18525000000 17930000000 15227000000 11247000000 18936000000 18525000000 17930000000 15227000000 11247000000 18936000000 18525000000 17930000000 15227000000 11247000000 18936000000 18525000000 17930000000 15227000000 11247000000 65118000000 61880000000 55314000000 56898000000 46173000000 21031000000 19361000000 16437000000 15651000000 11213000000 0.179 0.157 0.158 0.158 -1318000000 6959000000 6959000000 6959000000 6959000000 6959000000 38297000000 6383000000 0.159 Discontinued Operations Basic EPS 113.88 31.15 Basic EPS from Continuing Operations 113.88 31.12 Basic EPS from Discontinued Operations Diluted EPS 112.2 30.69 Diluted EPS from Continuing Operations 112.2 30.67 Diluted EPS from Discontinued Operations Basic Weighted Average Shares Outstanding 667650000 662664000 Diluted Weighted Average Shares Outstanding 677674000 672493000 Reported Normalized Diluted EPS Basic EPS 113.88 31.15 Diluted EPS 112.2 30.69 Basic WASO 667650000 662664000 Diluted WASO 677674000 672493000 28.44 27.69 26.63 22.54 16.55 28.44 27.69 26.63 22.46 16.55 27.99 27.26 26.29 22.3 16.4 27.99 27.26 26.29 22.23 16.4 665758000 668958000 673220000 675581000 679449000 676519000 679612000 682071000 682969000 685851000 28.44 27.69 26.63 22.54 16.55 27.99 27.26 26.29 22.3 16.4 665758000 668958000 673220000 675581000 679449000 676519000 679612000 682071000 682969000 685851000 10.21 10.21 10.13 10.13 681768000 687024000 10.21 10.13 681768000 687024000 Fiscal year end September 28th., 2022. | USD 31622,6:39 PM Morningstar.com Intraday Fundamental Portfolio View Print Report 3/6/2022 at 6:37 PM GOOGL_income-statement_Quarterly_As_Originally_Reported Q4 2021 Cash Flow from Operating Activities, Indirect 24934000000 Net Cash Flow from Continuing Operating Activities, Indirect 24934000000 Cash Generated from Operating Activities 24934000000 Income/Loss before Non-Cash Adjustment 20642000000 Total Adjustments for Non-Cash Items 6517000000 Q3 2021 Q2 2021 Q1 2021 Q4 2020 25539000000 37497000000 31211000000 30818000000 25539000000 21890000000 19289000000 22677000000 25539000000 21890000000 19289000000 22677000000 18936000000 18525000000 17930000000 15227000000 Print Depreciation, Amortization and Depletion, Non-Cash Adjustment 3439000000 Depreciation and Amortization, Non-Cash Adjustment 3439000000 Depreciation, Non-Cash Adjustment 3215000000 Amortization, Non-Cash Adjustment 224000000 Stock-Based Compensation, Non-Cash Adjustment 3954000000 Taxes, Non-Cash Adjustment 1616000000 Investment Income/Loss, Non-Cash Adjustment -2478000000 Gain/Loss on Financial Instruments, Non-Cash Adjustment -2478000000 Other Non-Cash Items -14000000 Changes in Operating Capital -2225000000 Change in Trade and Other Receivables -5819000000 Change in Trade/Accounts Receivable -5819000000 Change in Other Current Assets -399000000 Change in Payables and Accrued Expenses 6994000000 3797000000 4236000000 2592000000 5748000000 3304000000 2945000000 2753000000 3725000000 3304000000 2945000000 2753000000 3725000000 3085000000 2730000000 2525000000 3539000000 219000000 215000000 228000000 186000000 3874000000 3803000000 3745000000 3223000000 -1287000000 379000000 1100000000 1670000000 -2158000000 -2883000000 -4751000000 -3262000000 -2158000000 -2883000000 -4751000000 -3262000000 64000000 -8000000 -255000000 392000000 2806000000 -871000000 -1233000000 1702000000 -2409000000 -3661000000 2794000000 -5445000000 -2409000000 -3661000000 2794000000 -5445000000 -1255000000 -199000000 7000000 -738000000 Change in Trade and Other Payables 1157000000 Change in Trade/Accounts Payable 1157000000 Change in Accrued Expenses 5837000000 Change in Deferred Assets/Liabilities 368000000 Change in Other Operating Capital -3369000000 Change in Prepayments and Deposits Cash Flow from Investing Activities -11016000000 Cash Flow from Continuing Investing Activities -11016000000 Purchase/Sale and Disposal of Property, Plant and Equipment, Net -6383000000 Purchase of Property, Plant and Equipment -6383000000 Sale and Disposal of Property, Plant and Equipment Purchase/Sale of Business, Net -385000000 Purchase/Acquisition of Business -385000000 Purchase/Sale of Investments, Net -4348000000 3157000000 4074000000 -4956000000 6938000000 238000000 -130000000 -982000000 963000000 238000000 -130000000 -982000000 963000000 2919000000 4204000000 -3974000000 5975000000 272000000 -3000000 137000000 207000000 3041000000 -1082000000 785000000 740000000 -10050000000 -9074000000 -5383000000 -7281000000 -10050000000 -9074000000 -5383000000 -7281000000 -6819000000 -5496000000 -5942000000 -5479000000 -6819000000 -5496000000 -5942000000 -5479000000 -259000000 -308000000 -1666000000 -370000000 -259000000 -308000000 -1666000000 -370000000 Purchase of Investments -40860000000 Sale of Investments 36512000000 Other Investing Cash Flow 100000000 Purchase/Sale of Other Non-Current Assets, Net Sales of Other Non-Current Assets Cash Flow from Financing Activities -16511000000 Cash Flow from Continuing Financing Activities -16511000000 Issuance of/Payments for Common Stock, Net -13473000000 Payments for Common Stock 13473000000 Proceeds from Issuance of Common Stock Issuance of/Repayments for Debt, Net 115000000 Issuance of/Repayments for Long Term Debt, Net 115000000 Proceeds from Issuance of Long Term Debt 6250000000 Repayments for Long Term Debt 6365000000 -3360000000 -3293000000 2195000000 -1375000000 -35153000000 -24949000000 -37072000000 -36955000000 31793000000 21656000000 39267000000 35580000000 388000000 23000000 30000000 -57000000 -15254000000 -15254000000 -15991000000 -13606000000 -9270000000 -12610000000 -15991000000 -13606000000 -9270000000 -12610000000 -12796000000 -11395000000 -7904000000 -12796000000 -11395000000 -7904000000 -42000000 -42000000 -1042000000 -37000000 -57000000 6350000000 -1042000000 -37000000 -57000000 -6392000000 6699000000 900000000 0 Proceeds from Issuance/Exercising of Stock Options/Warrants 2923000000 Other Financing Cash Flow Cash and Cash Equivalents, End of Period Change in Cash 0 Effect of Exchange Rate Changes 20945000000 Cash and Cash Equivalents, Beginning of Period 25930000000 Cash Flow Supplemental Section 181000000000) Change in Cash as Reported, Supplemental 23719000000000 Income Tax Paid, Supplemental 2774000000 Cash and Cash Equivalents, Beginning of Period 13412000000 12 Months Ended -2602000000 -7741000000 -937000000 -57000000 -2453000000 -2184000000 -1647000000 300000000 10000000 338000000000) 23719000000 23630000000 26622000000 26465000000 235000000000) -3175000000 300000000 6126000000 -146000000000) 183000000 -143000000 210000000 23630000000000 26622000000000 26465000000000 20129000000000 89000000 -2992000000 6336000000 157000000 -4990000000 _________________________________________________________ Income Statement USD in "000'"s Repayments for Long Term Debt Costs and expenses: Cost of revenues Research and development Sales and marketing General and administrative European Commission fines Total costs and expenses Income from operations Other income (expense), net Q4 2020 Q4 2019 Dec. 31, 2020 Dec. 31, 2019 182527 161857 84732 71896 27573 26018 17946 18464 11052 9551 0 1697 141303 127626 Income before income taxes Provision for income taxes Net income *include interest paid, capital obligation, and underweighting Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) For Paperwork Reduction Act Notice, see the seperate Instructions. 41224 34231 6858000000 5394 22677000000 19289000000 22677000000 19289000000 22677000000 19289000000 Basic net income per share of Class A and B common stock and Class C capital stock (in dollars par share) Diluted net income per share of Class A and Class B common stock and Class C capital stock (in dollars par share) Name Tax Period Fed 941 Corporate 39355 Fed 941 West Subsidiary 39355 Fed 941 South Subsidiary 39355 Fed 941 East Subsidiary 39355 Fed 941 Corp - Penalty 39355 Total 66986.66 17115.41 23906.09 11247.64 27198.5 Fed 940 Annual Unemp - Corp 39355 ID: TxDL: 00037305581 Ssn: 17028.05 633-44-1725 Alphabet Inc. GOOGL, GOOG on Nasdaq [-] Company Information CIK: 1652044 EIN: 61-1767919 SIC: 7370 - Services-Computer Programming, Data Processing, Etc. (CF Office: Office of Technology) State location: CA State of incorporation: DE Fiscal year end: 44926 Business address: 1600 AMPHITHEATRE PARKWAY, MOUNTAIN VIEW, CA, 94043 Phone: 650-253-0000 Mailing address: 1600 AMPHIITHEATRE PARKWAY, MOINTAIN VIEW, CA, 94043 Get answers to your investing questions from the SEC's website dedicated to retail investors ALPHABET 1600 AMPITHEATRE PARKWAY MOUNTAIN VIEW, C.A., 94043 Taxable Marital Status: Exemptions/Allowances Federal: TX: NO State Incorne Tax rate units $112.20 674678000 Get answers to your investing questions from the SEC's website dedicated to retail investors 1 Earnings Statement Period Beginning: Period Ending: Pay Date: ZACHRY T. 5323 DALLAS year to date Other Benefits and 75698871600 Information 37151 44833 44591 WOOD BRADFORD DR TX 75235-8314 A this period total to date Earnings Regular Get answers to your investing questions from the SEC's website dedicated to retail investors ALPHABET 1601 AMPITHEATRE PARKWAY MOUNTAIN VIEW, C.A., 94044 Taxable Marital Status: Exemptions/Allowances Federal: TX: rate 1349355888 Get answers to your investing questions from the SEC's website dedicated to retail investors DR Married NO State Incorne Tax units 2024033776 2 year to date 75698871601 Earnings Statement Period Beginning: Period Ending: Pay Date: ZACHRY T. 5324 DALLAS Earnings Other Benefits and Regular Information DR Married Gross Pay 75698871600 Statutory Federal Income Tax Social Security Tax Medicare Tax net, pay. 70,842,743,866 Pto Balance Total Work Hrs Important Notes COMPANY PH Y: 650-253-0000 BASIS OF PAY: BASIC/DILUTED EPS YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE $70,842,743,866 COMPANY PH Y: 650-253-0000 BASIS OF PAY: BASIC/DILUTED EPS YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE 0 75698871600 Overtime Bonus Training Deductions Gross Pay 75698871601 Statutory Federal Income Tax Social Security Tax Medicare Tax Net Pay CHECKING Net Check Your federal taxable wages this period are $ 70842743867 70842743867 70842743867 Overtime Pto Balance Bonus Training Total Work Hrs Important Notes COMPANY PH Y: 650-253-0001 Deductions BASIS OF PAY: BASIC/DILUTED EPS YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE BASIS OF PAY: BASIC/DILUTED EPS YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM 0.001 TO 112.20 PAR SHARE VALUE ALPHABET INCOME 1600 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Deposited to the account Of PLEASE READ THE IMPORTANT DISCLOSURES BELOW PNC Bank CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 ______________________________________________________________________________________________________________ 4/18/2022 SIGNATURE Time Zone: Eastern Central Mountain Pacific PLEASE READ THE IMPORTANT DISCLOSURES BELOW 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments 4/A Statement of changes in beneficial ownership of securities - amendmentOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments Advice number: Pay date:_ xxxxxxxx6547 PLEASE READ THE IMPORTANT DISCLOSURES BELOW PNC Bank CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 ______________________________________________________________________________________________________________ 4/18/2022 SIGNATURE Time Zone: Eastern Central Mountain Pacific NON-NEGOTIABLE Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments 44642 2022-03-18View all with same reporting date Statement of changes in beneficial ownership of securities - amendmentOpen document FilingOpen filing 44642 2022-03-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments 44641 2022-03-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments 44641 2022-03-18View all with same reporting date 650001 44669 transit ABA PLEASE READ THE IMPORTANT DISCLOSURES BELOW PNC Bank CIF Department (Online Banking) Checking Account: 47-2041-6547 P7-PFSC-04-F Business Type: Sole Proprietorship/Partnership Corporation 500 First Avenue ALPHABET Pittsburgh, PA 15219-3128 ______________________________________________________________________________________________________________ 4/18/2022 SIGNATURE Time Zone: Eastern Central Mountain Pacific 5264-5331 amount 70842743866 ALPHABET INCOME 1601 AMPIHTHEATRE PARKWAY MOUNTAIN VIEW CA 94043 Deposited to the account Of PLEASE READ THE IMPORTANT DISCLOSURES BELOW FEDERAL RESERVE MASTER SUPPLIER ACCOUNT31000053-052101023COD 633-44-1725Zachryiixixiiiwood@gmail.com47-2041-654711100061431000053 PNC BankPNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking)Checking Account: 47-2041-6547 P7-PFSC-04-FBusiness Type: Sole Proprietorship/Partnership Corporation 500 First AvenueALPHABET Pittsburgh, PA 15219-31285323 BRADFORD DR NON-NEGOTIABLEDALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022650-2530-000 469-697-4300 SIGNATURETime Zone: Eastern Central Mountain Pacific Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value PLEASE READ THE IMPORTANT DISCLOSURES BELOW PLEASE READ THE IMPORTANT DISCLOSURES BELOW FEDERAL RESERVE MASTER SUPPLIER ACCOUNT31000053-052101023COD 633-44-1725Zachryiixixiiiwood@gmail.com47-2041-654711100061431000053 PNC BankPNC Bank Business Tax I.D. Number: 633441725 CIF Department (Online Banking)Checking Account: 47-2041-6547 P7-PFSC-04-FBusiness Type: Sole Proprietorship/Partnership Corporation 500 First AvenueALPHABET Pittsburgh, PA 15219-31285323 BRADFORD DR NON-NEGOTIABLEDALLAS TX 75235 8313 ZACHRY, TYLER, WOOD 4/18/2022650-2530-000 469-697-4300 SIGNATURETime Zone: Eastern Central Mountain Pacific Investment Products • Not FDIC Insured • No Bank Guarantee • May Lose Value Advice number: Pay date:_ xxxxxxxx6548 NON-NEGOTIABLE 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing SC 13G/A Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Amendments 44641 2022-03-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44638 2022-03-17View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44638 2022-03-17View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44638 2022-03-17View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44637 2022-03-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44637 2022-03-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44637 2022-03-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44637 2022-03-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44631 2022-03-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44631 2022-03-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44631 2022-03-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44631 2022-03-09View all with same reporting date Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 44631 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44630 2022-03-08View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 5 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44630 2022-03-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44630 2022-03-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44630 2022-03-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44630 2022-03-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44630 2022-03-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44629 2022-03-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44629 2022-03-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44629 2022-03-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44629 2022-03-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44622 2022-03-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44620 2022-02-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44614 2022-02-22View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44609 2022-02-16View all with same reporting date Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44606 2021-12-31View all with same reporting date SC 13G/A Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 5 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 5 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 5 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 5 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing SC 13G/A Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing SC 13G/A Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 5 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 44606 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2021-12-31View all with same reporting date Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2021-12-31View all with same reporting date Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2021-12-31View all with same reporting date Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2021-12-31View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2022-02-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2022-02-09View all with same reporting date Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 44603 Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 44603 Annual statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2021-12-31View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2022-02-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44603 2022-02-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2022-02-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2022-02-08View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing SC 13G/A Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing SC 13G/A Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2022-02-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2021-11-26View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2021-11-24View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2021-11-23View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2021-11-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2021-11-17View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2021-11-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44602 2021-11-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44601 2022-02-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44601 2022-02-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44601 2022-02-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44601 2022-02-07View all with same reporting date Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 44601 Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 44601 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing SC 13G Statement of acquisition of beneficial ownership by individualsOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44600 2022-02-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44600 2022-02-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44600 2022-02-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44600 2022-02-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44600 2022-02-07View all with same reporting date Statement of acquisition of beneficial ownership by individualsOpen document FilingOpen filing 44600 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44600 2022-02-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44599 2022-02-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44599 2022-02-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44599 2022-02-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44599 2022-02-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44596 2022-02-03View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44596 2022-02-03View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44596 2022-02-03View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing SC 13G/A Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing S-3ASR Automatic shelf registration statement of securities of well-known seasoned issuersOpen document FilingOpen filing 10-K Annual report [Section 13 and 15(d), not S-K Item 405]Open document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 8-K Current reportOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44596 2022-02-03View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44596 2022-02-03View all with same reporting date Statement of acquisition of beneficial ownership by individuals - amendmentOpen document FilingOpen filing 44595 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44594 2022-02-02View all with same reporting date Automatic shelf registration statement of securities of well-known seasoned issuersOpen document FilingOpen filing 44594 Annual report [Section 13 and 15(d), not S-K Item 405]Open document FilingOpen filing 44594 2021-12-31View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44593 2022-02-01View all with same reporting date Current reportOpen document FilingOpen filing 44593 2022-02-01View all with same reporting date 2.02 - Results of Operations and Financial Condition 8.01 - Other Events (The registrant can use this Item to report events that are not specifically called for by Form 8-K, that the registrant considers to be of importance to security holders.) 9.01 - Financial Statements and Exhibits Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44588 2022-01-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44582 2022-01-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44582 2022-01-20View all with same reporting date 8.01 - Other Events (The registrant can use this Item to report events that are not specifically called for by Form 8-K, that the registrant considers to be of importance to security holders.) 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44582 2022-01-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44582 2022-01-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44581 2022-01-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44581 2022-01-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44581 2022-01-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44581 2022-01-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44580 2022-01-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44580 2022-01-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44575 2022-01-12View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44574 2022-01-12View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44574 2022-01-12View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44574 2022-01-11View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44574 2022-01-11View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44574 2022-01-11View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 8-K Current reportOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44572 2022-01-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44572 2022-01-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44572 2022-01-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44572 2022-01-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44572 2022-01-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44568 2022-01-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44568 2022-01-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44568 2022-01-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44568 2022-01-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44567 2022-01-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44566 2022-01-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44566 2022-01-05View all with same reporting date Current reportOpen document FilingOpen filing 44565 2021-12-28View all with same reporting date 5.02 - Departure of Directors or Certain Officers; Election of Directors; Appointment of Certain Officers; Compensatory Arrangements of Certain Officers 5.02 - Departure of Directors or Certain Officers; Election of Directors; Appointment of Certain Officers; Compensatory Arrangements of Certain Officers 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 3 Initial statement of beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44564 2022-01-03View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44564 2022-01-03View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44559 2021-12-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44559 2021-12-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44559 2021-12-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44559 2021-12-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44559 2021-12-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44559 2021-12-27View all with same reporting date Initial statement of beneficial ownership of securitiesOpen document FilingOpen filing 44547 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44545 2021-12-15View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44540 2021-12-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44540 2021-12-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44539 2021-12-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44539 2021-12-08View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44539 2021-12-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44539 2021-12-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44538 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44538 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44538 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44538 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44538 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44538 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44537 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44537 2021-12-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44537 2021-12-06View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44537 2021-12-06View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44537 2021-12-06View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44531 2021-12-01View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4/A Statement of changes in beneficial ownership of securities - amendmentOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44531 2021-12-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44531 2021-12-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44529 2021-11-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44523 2021-11-19View all with same reporting date Statement of changes in beneficial ownership of securities - amendmentOpen document FilingOpen filing 44523 2021-11-11View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44523 2021-11-21View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44518 2021-11-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44517 2021-11-17View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44517 2021-11-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44517 2021-11-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44516 2021-11-15View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44516 2021-11-15View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44515 2021-11-12View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44515 2021-11-12View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44515 2021-11-12View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44512 2021-11-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44512 2021-11-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44512 2021-11-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44512 2021-11-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44510 2021-11-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44509 2021-11-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44509 2021-11-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44509 2021-11-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44508 2021-11-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44508 2021-11-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44508 2021-11-05View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44503 2021-11-03View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44502 2021-11-02View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 10-Q Quarterly report [Sections 13 or 15(d)]Open document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 8-K Current reportOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44501 2021-11-01View all with same reporting date Quarterly report [Sections 13 or 15(d)]Open document FilingOpen filing 44496 2021-09-30View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44495 2021-10-25View all with same reporting date Current reportOpen document FilingOpen filing 44495 2021-10-26View all with same reporting date 2.02 - Results of Operations and Financial Condition 9.01 - Financial Statements and Exhibits Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44490 2021-10-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44490 2021-10-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44490 2021-10-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44489 2021-10-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44489 2021-10-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44487 2021-10-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44487 2021-10-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44484 2021-10-13View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44484 2021-10-13View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44483 2021-10-12View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44483 2021-10-12View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44481 2021-10-11View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44481 2021-10-11View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44477 2021-10-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44475 2021-10-06View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44475 2021-10-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44470 2021-10-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44470 2021-09-29View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44467 2021-09-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44467 2021-09-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44467 2021-09-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44467 2021-09-25View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 3 Initial statement of beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44467 2021-09-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44467 2021-09-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44466 2021-09-23View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44466 2021-09-23View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44463 2021-09-24View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44463 2021-09-22View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44463 2021-09-22View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44463 2021-09-22View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44461 2021-09-21View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44461 2021-09-21View all with same reporting date Initial statement of beneficial ownership of securitiesOpen document FilingOpen filing 44460 2021-09-21View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44454 2021-09-15View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44452 2021-09-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44452 2021-09-09View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44449 2021-09-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44449 2021-09-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44447 2021-09-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44447 2021-09-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44447 2021-09-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44441 2021-09-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44441 2021-09-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44441 2021-09-02View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44438 2021-08-29View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44435 2021-08-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44431 2021-08-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44431 2021-08-20View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44431 2021-08-19View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44431 2021-08-19View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44427 2021-08-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44427 2021-08-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44427 2021-08-18View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44419 2021-08-11View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44419 2021-08-11View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44419 2021-08-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44419 2021-08-10View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44418 2021-08-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44418 2021-08-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44418 2021-08-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44412 2021-08-04View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44411 2021-08-03View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44410 2021-07-30View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44410 2021-08-02View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 10-Q Quarterly report [Sections 13 or 15(d)]Open document FilingOpen filing 3 Initial statement of beneficial ownership of securitiesOpen document FilingOpen filing 8-K Current reportOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44410 2021-07-29View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44410 2021-07-29View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44407 2021-07-28View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44407 2021-07-28View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44407 2021-07-28View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44406 2021-07-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44406 2021-07-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44406 2021-07-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44406 2021-07-27View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44405 2021-07-26View all with same reporting date Quarterly report [Sections 13 or 15(d)]Open document FilingOpen filing 44405 2021-06-30View all with same reporting date Initial statement of beneficial ownership of securitiesOpen document FilingOpen filing 44404 2021-07-27View all with same reporting date Current reportOpen document FilingOpen filing 44404 2021-07-27View all with same reporting date 2.02 - Results of Operations and Financial Condition 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 9.01 - Financial Statements and Exhibits Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44398 2021-07-21View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44389 2021-07-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44389 2021-07-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44386 2021-07-07View all with same reporting date 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 8-K Current reportOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44385 2021-07-06View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44385 2021-07-06View all with same reporting date Current reportOpen document FilingOpen filing 44385 2021-07-07View all with same reporting date 8.01 - Other Events (The registrant can use this Item to report events that are not specifically called for by Form 8-K, that the registrant considers to be of importance to security holders.) Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44385 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44385 2021-07-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44383 2021-07-02View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44378 2021-07-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44378 2021-07-01View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44378 2021-06-30View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44378 2021-06-29View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44376 2021-06-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44375 2021-06-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44375 2021-06-25View all with same reporting date 8.01 - Other Events (The registrant can use this Item to report events that are not specifically called for by Form 8-K, that the registrant considers to be of importance to security holders.) 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 4 Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing Showing 1 to 32 of 1,000 entries Data source: CIK0001652044.json Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44375 2021-06-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44375 2021-06-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44375 2021-06-25View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44364 2021-06-16View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44358 2021-06-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44358 2021-06-09View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44357 2021-06-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44357 2021-06-08View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44356 2021-06-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44356 2021-06-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44356 2021-06-07View all with same reporting date Statement of changes in beneficial ownership of securitiesOpen document FilingOpen filing 44356 2021-06-07View all with same reporting date Investor Resources How to Use EDGAR Learn how to use EDGAR to research public filings by public companies, mutual funds, ETFs, some annuities, and more. Before you Invest, Investor.gov Get answers to your investing questions from the SEC's website dedicated to retail investors Learn how to use EDGAR to research public filings by public companies, mutual funds, ETFs, some annuities, and more. Get answers to your investing questions from the SEC's website dedicated to retail investors Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET 1600 AMPITHEATRE PARKWAY MOUNTAIN VIEW, C.A., 94043 Taxable Marital Status: Exemptions/Allowances Federal: TX: Gross Pay Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET rate 112.2 75698871600 Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET NO State Incorne Tax units 674678000 Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET year to date 7569887160000.0% Get answers to your investing questions from the SEC's website dedicated to retail investors 1 ALPHABET Period Ending: Pay Date: ZACHRY T. 5323 DALLAS Other Benefits and Information Pto Balance Total Work Hrs Important N
...

[Message clipped] View entire messageSkip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore

@zakwarlord7
Your account has been flagged.
Because of that, your profile is hidden from the public. If you believe this is a mistake, contact support to have your account status reviewed.
https://github.com/github
/
docs
Public
Code
Issues
101
Pull requests
84
Discussions
Actions
Projects
3
Security
Insights
Comparing changes
This is a direct comparison between two commits made in this repository or its related repositories. View the default comparison for this range here.

Showing 18,092 changed files with 292,631 additions and 259,251 deletions.
The diff you're trying to view is too large. We only load the first 3000 changed files.
21
.devcontainer/Dockerfile
@@ -0,0 +1,21 @@

See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.177.0/containers/javascript-node/.devcontainer/base.Dockerfile

[Choice] Node.js version: 16, 14, 12

ARG VARIANT="16-buster"
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}

[Optional] Uncomment this section to install additional OS packages.

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \

&& apt-get -y install --no-install-recommends

[Optional] Uncomment if you want to install an additional version of node using nvm

ARG EXTRA_NODE_VERSION=10

RUN su node -c "source /usr/local/share/nvm/nvm.sh && nvm install ${EXTRA_NODE_VERSION}"

[Optional] Uncomment if you want to install more global node modules

RUN su node -c "npm install -g "

Install the GitHub CLI see:

https://github.com/microsoft/vscode-dev-containers/blob/3d59f9fe37edb68f78874620f33dac5a62ef2b93/script-library/docs/github.md

COPY library-scripts/github-debian.sh /tmp/library-scripts/
RUN apt-get update && bash /tmp/library-scripts/github-debian.sh
21
git pull origin main → .devcontainer/devcontainer.json
@@ -1,17 +1,4 @@
POST :// :Author :ZACHRY :T :WOOD :zachryiixixiiwood@gmail.com : // For format details, see https://aka.ms/devcontainer.json. For config options, see the README at:
Address :5222 BRADFORD DR :
PHONE :main :+1 (469) 697-4300 :
SSN :633-44-1725 :
DOB ;:10-15-1994 :
TIME ZONE :CSMT :
CONTRY :U.S.A. :
notifications :
document :
e-mail :zachryiixixiiwood'@gmail'.com :
e-mail :josephabanksfedralreserve'@gmail'.com :
e-mail :nasdaqgoogcoo'@gmail'.com :
e-mail :josephabanksfederalreserve'@gmail'.com
For :format :details, :see :https://aka.ms/devcontainer.json. For config options, see the README at:
// https://github.com/microsoft/vscode-dev-containers/tree/v0.177.0/containers/javascript-node // https://github.com/microsoft/vscode-dev-containers/tree/v0.177.0/containers/javascript-node
// - // -
{ {
@@ -25,14 +12,14 @@ For :format :details, :see :https://aka.ms/devcontainer.json. For config options
// Set default container specific settings.json values on container create. // Set default container specific settings.json values on container create.
"settings": { "settings": {
"terminal.integrated.shell.linux": "/bin/bash", "terminal.integrated.shell.linux": "/bin/bash",
"cSpell.language": ",en/es" "cSpell.language": ",en"
}, },

// Install features. Type 'feature' in the VS Code command palette for a full list.		// Install features. Type 'feature' in the VS Code command palette for a full list. "features": {		"features": { 	"git-lfs": "latest",			"git-lfs": "latest", 	"sshd": "latest"			"sshd": "latest" }":,		 }, // Visual Studio Code extensions which help authoring for docs.github.com.		// Visual Studio Code extensions which help authoring for docs.github.com. "extensions": [		"extensions": [ 

@@ -45,7 +32,7 @@ For :format :details, :see :https://aka.ms/devcontainer.json. For config options
], ],

// Use 'forwardPorts' to make a list of ports inside the container available locally.		// Use 'forwardPorts' to make a list of ports inside the container available locally. '"Port :":,' :(4999;: 8333)":,'		"forwardPorts": [4000], // Use 'postCreateCommand' to run commands after the container is created.		// Use 'postCreateCommand' to run commands after the container is created. "postCreateCommand": "git lfs pull && npm ci",		"postCreateCommand": "git lfs pull && npm ci", 

1
.github/ISSUE_TEMPLATE/config.yml
@@ -3,4 +3,3 @@ contact_links:

name: GitHub Support - name: GitHub Support
url: https://support.github.com/contact url: https://support.github.com/contact
about: Contact Support if you're having trouble with your GitHub account. about: Contact Support if you're having trouble with your GitHub account.
zachry t wood
20
.github/actions-scripts/create-translation-batch-pr.js
@@ -107,14 +107,14 @@ async function findOrCreatePullRequest(config) {

@param {object} config Configuration options for labeling the PR * @param {object} config Configuration options for labeling the PR

@returns {Promise} * @returns {Promise}
*/ */
async function labelPullRequest(config) { // async function labelPullRequest(config) {
await octokit.rest.issues.update({ // await octokit.rest.issues.update({
owner: config.owner, // owner: config.owner,
repo: config.repo, // repo: config.repo,
issue_number: config.issue_number, // issue_number: config.issue_number,
labels: config.labels, // labels: config.labels,
}) // })
} // }

async function main() { async function main() {
const options = { const options = {
@@ -135,8 +135,8 @@ async function main() {

// metadata parameters aren't currently available in github.rest.pulls.create, // metadata parameters aren't currently available in github.rest.pulls.create,
// but they are in github.rest.issues.update. // but they are in github.rest.issues.update.
await labelPullRequest(options) // await labelPullRequest(options)
console.log(Updated ${pr} with these labels: ${options.labels.join(', ')}) // console.log(Updated ${pr} with these labels: ${options.labels.join(', ')})
} }

main() main()
2
.github/actions-scripts/enterprise-server-issue-templates/release-issue.md
@@ -18,7 +18,7 @@ If you aren't comfortable going through the steps alone, sync up with a docs eng

script/update-enterprise-dates.js script/update-enterprise-dates.js

 Create REST files based on previous version. Copy the latest GHES version of the dereferenced file from lib/rest/static/dereferenced to a new file in the same directory for the new GHES release. Ex, cp lib/rest/static/dereferenced/ghes-3.4.deref.json lib/rest/static/dereferenced/ghes-3.5.deref.json. Then run script/rest/updated-files.js --decorate-only and check in the resulting files. - [ ] Create REST files based on previous version. Copy the latest GHES version of the dereferenced file from lib/rest/static/dereferenced to a new file in the same directory for the new GHES release. Ex, cp lib/rest/static/dereferenced/ghes-3.4.deref.json lib/rest/static/dereferenced/ghes-3.5.deref.json. Then run script/rest/update-files.js --decorate-only and check in the resulting files.

 Create GraphQL files based on previous version: - [ ] Create GraphQL files based on previous version:

20
.github/actions-scripts/msft-create-translation-batch-pr.js
@@ -107,14 +107,14 @@ async function findOrCreatePullRequest(config) {

@param {object} config Configuration options for labeling the PR * @param {object} config Configuration options for labeling the PR

@returns {Promise} * @returns {Promise}
*/ */
// async function labelPullRequest(config) { async function labelPullRequest(config) {
// await octokit.rest.issues.update({ await octokit.rest.issues.update({
// owner: config.owner, owner: config.owner,
// repo: config.repo, repo: config.repo,
// issue_number: config.issue_number, issue_number: config.issue_number,
// labels: config.labels, labels: config.labels,
// }) })
// } }

async function main() { async function main() {
const options = { const options = {
@@ -135,8 +135,8 @@ async function main() {

// metadata parameters aren't currently available in github.rest.pulls.create, // metadata parameters aren't currently available in github.rest.pulls.create,
// but they are in github.rest.issues.update. // but they are in github.rest.issues.update.
// await labelPullRequest(options) await labelPullRequest(options)
// console.log(Updated ${pr} with these labels: ${options.labels.join(', ')}) console.log(Updated ${pr} with these labels: ${options.labels.join(', ')})
} }

main() main()
29
.github/dependabot.yml
@@ -1,30 +1,29 @@
version: 2 version: 2
updates: updates:

package-ecosystem: 'https://pnc.com' - package-ecosystem: npm
directory: '071921891/4720416547' directory: '/'
schedule: schedule:
interval: 'Every 3 Months' interval: weekly
day: 'Wednesday' day: tuesday
open-pull-requests-limit: '20' '# default' 'is' '5' open-pull-requests-limit: 20 # default is 5
'-' 'dependency' ignore:
'-' 'Name'':' '*' - dependency-name: '@elastic/elasticsearch'

dependency-name: '*'
update-types: update-types:
'[' 'version- ['version-update:semver-patch', 'version-update:semver-minor']
'.u.i' 'Update:semver-patch', 'version-update:semver-minor']

package-ecosystem: 'github-actions' - package-ecosystem: 'github-actions'
directory: '/' directory: '/'
schedule: schedule:
interval: 'weekly' interval: weekly
'day:'' 'wednesday' day: wednesday
ignore: ignore:

dependency-name: '' - dependency-name: ''
update-types: update-types:
['version-update:semver-patch', 'version-update:semver-minor'] ['version-update:semver-patch', 'version-update:semver-minor']

package-ecosystem: 'docker' - package-ecosystem: 'docker'
directory: '/' directory: '/'
schedule: 'internval'' schedule:
interval: 'autoupdate: across all '-' '['' 'branches' ']':' Every' '-3' sec'"'' interval: weekly
:Build:: day: thursday

28
.github/workflows/bitore.sig
This file was deleted.

72
.github/workflows/codeql-analysis.yml
This file was deleted.

Oops, something went wrong.
Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About

Why:

Closes [issue link]

What's being changed (if available, include any code snippets, screenshots, or gifs):

Check off the following:

 I have reviewed my changes in staging (look for the "Automatically generated comment" and click the links in the "Preview" column to view your latest changes).

 For content changes, I have completed the self-review checklist.

Writer impact (This section is for GitHub staff members only):

 This pull request impacts the contribution experience

 I have added the 'writer impact' label

 I have added a description and/or a video demo of the changes below (e.g. a "before and after video")

Octomerger and others added 30 commits 11 months ago

￼

Merge branch 'main' into repo-sync

Verified

c4978fd

￼

Merge pull request #11024 from github/repo-sync …

Verified

9fc7d0f

￼

Merge pull request #22060 from github/repo-sync …

Verified

8d2e988

￼

Update OpenAPI Descriptions (#22042) 

Verified

8cce792

￼

Merge branch 'main' into patch-2

Verified

e6bb87a

￼

Merge branch 'main' into repo-sync

Verified

32345dd

￼

Merge branch 'main' into repo-sync

Verified

0f52d3a

￼

Merge pull request #11026 from github/repo-sync …

Verified

defe4e4

￼

Merge pull request #22062 from github/repo-sync …

Verified

d451a73

￼

Merge branch 'main' into patch-2

Verified

83ca7e6

￼

Merge pull request #10709 from jstvz/patch-2

Verified

b361ca7

￼￼

Bump hot-shots from 8.5.1 to 8.5.2 (#21992) …

Verified

f50b5b9

￼

Merge branch 'main' into repo-sync

Verified

f8ca376

￼

Merge branch 'main' into repo-sync

Verified

d2aa97e

￼

Merge pull request #11027 from github/repo-sync …

Verified

1ca28c5

￼

Merge pull request #22065 from github/repo-sync …

Verified

423b5f2

￼

Bump lint-staged from 11.1.2 to 11.2.2 (#22058)

Verified

059dfed

￼

Merge branch 'main' into repo-sync

Verified

e640516

￼

Merge pull request #11028 from github/repo-sync …

Verified

8189580

￼

Merge pull request #22066 from github/repo-sync …

Verified

e15ad17

￼

update search indexes

bbdbeff

￼

Merge pull request #11032 from github/repo-sync …

Verified

65f2e25

￼

Bump linkinator from 2.14.0 to 2.14.4 (#22001)

Verified

3b0b02d

￼

Merge branch 'main' into repo-sync

Verified

a6053f3

￼

Merge branch 'main' into repo-sync

Verified

4a47f58

￼

Merge pull request #11034 from github/repo-sync …

Verified

d7cb5ff

￼

Merge pull request #22067 from github/repo-sync …

Verified

b8fc166

￼

Bump ajv from 8.4.0 to 8.6.3 (#21994)

Verified

faabfaf

￼

Merge branch 'main' into repo-sync

Verified

82e41b9

￼

Merge branch 'main' into repo-sync

Verified

b0a9a82

203 hidden itemsLoad more…

dependabot bot and others added 17 commits 11 months ago

￼

Bump postcss from 8.3.6 to 8.3.9 (#22096)

Verified

08daf13

￼

Merge branch 'main' into repo-sync

Verified

f564b24

￼

Merge pull request #11145 from github/repo-sync …

Verified

4bd4e4f

￼

Clarify the use of snippets (#22142)

Verified

6f4e0b8

￼

Merge branch 'main' into repo-sync

Verified

1c855e1

￼

Merge branch 'main' into repo-sync

Verified

cdd47a7

￼

Merge pull request #11146 from github/repo-sync …

Verified

c88a2ff

￼

Merge pull request #22152 from github/repo-sync …

Verified

697a7cd

￼

Fixing merge conflicts

561368d

￼

For merge conflict

089b0db

￼

Merge branch 'main' into 1862-Add-Travis-CI-migration-table

8aeebcc

￼

Update migrating-from-travis-ci-to-github-actions.md

83dd496

￼

Broken link fix to security and analysis article (#22154)

Verified

9f105b7

￼

Merge branch 'main' into repo-sync

Verified

1d54f85

￼

Merge pull request #22156 from github/repo-sync …

Verified

270cb6d

￼

Merge pull request #11149 from github/repo-sync …

Verified

f07d538

￼

Merge branch 'main' into 1862-Add-Travis-CI-migration-table 

Verified

adcf1bd

￼ zakwarlord7 requested review from a team as code owners 4 days ago

￼ zakwarlord7 closed this 4 days ago

￼

Author

zakwarlord7 commented 4 days ago

"''''Approves'.'''':':'"':',''

￼ zakwarlord7 reopened this 4 days ago

￼

Author

zakwarlord7 commented 4 days ago

"''"''Approves'.''"'':':'"''":,:

￼

Author

zakwarlord7 commented 4 days ago

[22/8]

[22/8]

[22/8]

[22/8]

[22/8]

￼ zakwarlord7 changed the title 1862 add travis ci migration table ZACHRY TYLER WOOD 5424 BRADFORD DRIVE EMPLOYER IDENTIFICATION NUMBER :611767919 :FIN :xxxxx4775 THE 101 EA ::SSN:xxx-xx-1725 :DOB :1994-10-15 : 4 days ago

￼ zakwarlord7 closed this 4 days ago

￼ zakwarlord7 changed the title ZACHRY TYLER WOOD 5424 BRADFORD DRIVE EMPLOYER IDENTIFICATION NUMBER :611767919 :FIN :xxxxx4775 THE 101 EA ::SSN:xxx-xx-1725 :DOB :1994-10-15 : ZACHRY TYLER WOOD 5323 BRADFORD DRIVE DALLAS TX 75235 EMPLOYER IDENTIFICATION NUMBER :611767919 :FIN :xxxxx4775 THE 101 EA ::SSN:xxx-xx-1725 :DOB :1994-10-15 : 4 days ago

￼ zakwarlord7 reopened this 4 days ago

Merge state

Show all reviewers

Review requested

Review has been requested on this pull request. It is not required to merge. Learn more.

4 pending reviewers

Hide all checks

All checks have passed

19 skipped, 27 successful, and 1 neutral checks

￼

Add review template / Add review template (pull_request) Skipped

Details

￼

Auto label Pull Requests / triage (pull_request) Skipped

Details

￼

Check for unallowed internal changes / check-internal-changes (pull_request) Skipped

Details

￼

Enterprise Server Release Search Sync / Update English index for new GHES release (pull_request) Skipped

Details

￼

First responder docs-content / Triage PR to FR project board (pull_request) Skipped

Details

￼

Hubber contribution help / check-team-membership (pull_request) Skipped

Details

￼

Lint workflows / lint (pull_request) Skipped

Details

￼

Merged notification / comment (pull_request_target) Skipped

Details

￼

Move and unlabel ready to merge PRs / unmark_for_review (pull_request_target) Skipped

Details

￼

Node.js Tests - Windows / test (pull_request) Skipped

Details

￼

OS Ready for review / Request a review from the docs-content team (pull_request_target) Skipped

Details

￼

OpenAPI dev mode check / check-schema-versions (pull_request) Skipped

Details

￼

OpenAPI generate decorated schema files / generate-decorated-files (pull_request) Skipped

Details

￼

Ready for docs-content review / Request a review from the docs-content team (pull_request) Skipped

Details

￼

Site Policy Reminder / run (pull_request) Skipped

Details

￼

automerge / automerge (pull_request) Skipped

Details

￼

Azure - Destroy Preview Env / Destroy (pull_request_target) Successful in 26s

Details

￼

Browser Tests / build (pull_request) Successful in 3m

Details

￼

Build Docker image / build (pull_request) Successful in 6m

Details

￼

Check unallowed file changes / triage (pull_request_target) Successful in 21s

Details

￼

Close issue/PR on adding invalid label / close-on-adding-invalid-label (pull_request_target) Successful in 3s

Details

￼

Confirm internal staff meant to post in public / check-team-membership (pull_request_target) Successful in 3s

Details

￼

Content Changes Table Comment / Add staging/live links to PR (pull_request_target) Successful in 3s

Details
￼
Link Checker: Dotcom / build (pull_request) Successful in 5m
Details
￼
Link Checker: Enterprise Server / build (pull_request) Successful in 4m
Details
￼
Link Checker: GitHub AE / build (pull_request) Successful in 4m
Details
￼
Lint JS / lint (pull_request) Successful in 1m
Details
￼
Lint Yaml / lint (pull_request) Successful in 1m
Details
￼
Node.js Tests / test (content) (pull_request) Successful in 4m
Details
￼
Notify When Maintainers Cannot Edit / notify-when-maintainers-cannot-edit (pull_request_target) Successful in 3s
Details
￼
Runs :Checks'@Test.yml -thenAUTOMATE-squash_merging-during :deployment :of : pull_requests-and-responses :result
result'?''
'"'?''=: '' '_'?'_''=result :
result :200OK
_target) Successful in 1s
Details
￼
Staging - Build PR / debug (pull_request) Successful in 1s
Details
￼
Start new engineering PR workflow / triage (pull_request_target) Successful in 5s
Details


Triage new pull requests / triage_pulls (pull_request_target) Successful in 14s
Details
￼
Nodes Tests / test (graphql) (pull_request) Successful in 1m

Details


Node.js Tests / test (meta) (pull_request) Successful in 2m
tails

￼
Node.js Tests / test (rendering) (pull_request) Successful in 9m
Details
￼
Node.js Tests / test (routing) (pull_request) Successful in 8m
Details
￼
Node.js Tests / test (unit) (pull_request) Successful in 2m
Details
￼
Node.js Tests / test (linting) (pull_request) Successful in 5m
Details
￼
Check for unallowed internal changes / notAllowed (pull_request) Skipped
Details
￼
First rsponder docs-content / Remove PR from FR project board (pull_request) Skipped

Details
￼
Content Changes Table Comment / filterContentDir (pull_request_target) Successful in 40s
Details
￼
Staging - Build PR / build-pr (pull_request) Successful in 3m
Details
￼
Check for unallowed internal changes / notAllowedSearchSyncLabel (pull_request) Skipped
Details
￼
Code scanning results / CodeQL Completed in 1s — 1 analysis not found
Dtails

￼
Staging - Deploy PR / deploy (pull_request) — Successfully deployed! See logs.
Details
This branch has no conflicts with the base branch
Only those with write access to this repository can merge pull requests.
￼
Write Preview
Add heading textAdd bold text, <Ctrl+b>Add italic text, <Ctrl+i>
Add a quote, <Ctrl+Shift+.>Add code, <Ctrl+e>Add a link, <Ctrl+k>
Add a bulleted list, <Ctrl+Shift+8>Add a numbered list, <Ctrl+Shift+7>Add a task list, <Ctrl+Shift+l>
Directly mention a user or teamReference an issue, pull request, or discussionAdd saved repl

Attach files by dragging & dropping, selecting or pasting them.Styling with Markdown is supported
 Close pull request
Comment
Remember, contributions to this repository should follow its contributing guidelines and code of conduct.
 ProTip! Add comments to specific lines under Files changed.
Reviewers
￼docs-content-strategy
￼site-policy-admins
￼docs-localization
￼docs-engineering
Still in progress? Convert to draft
Assignees
No one assigned
Labels
None yet
Projects
None yet
Milestone
No milestone
Development
Successully merging this pull request may close these issues.

None yet
Notifications
Customize
Unsubscribe
You’re receiving notifications because you’re watching this repository.
34 participants
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼
Footer

© 2022 GitHub, Inc.
Footer navigation
Terms
Privac

Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Infromation About the Request We Recieved
On July 29, 2022, we recieved a request for verification of non-filing of a tax return
As of the date of this letter, we have no record of a processed tax return for the tax period listeed above.
If you have any questions, you can call 800-829-1040.,
Uncollected Earned Income Crerdit Appropriate, Affiliate, Security', at Value.
Employer :
Employer's Identification Number (EIN) :XXXXX7919
ALPH INC
1600 A
Reciepient :
Recipient's Social Security Number (SSN) : XXX-XX-1725
ZACH T WOO
$75,698,871,600.00
DALLAS TX 75235
WOO
Marrried
Taxable Marital Status: 
Exemptions/Allowances
Other Benefits and Earning's Statement 
Information 
Regular 
Statement of Assets and Liabilities 
As of February 28, 2022
Pto Balance
Overtime
Fiscal' year' s end | September 28th.
Total Work Hrs 
Bonus
Training
Unappropriated, Affiliated, Securities, at Value.
Important Notes
Additions"+$$22,756,988,716,000.00":,''
Issuer: THE101 EARecipient's Social Security Number : xxx-xx-1725Employeer Identification Number (EIN) :XXXXX79196553ZACH TDRWOOTaxable Marital Status: 
Exemptions/AllowancesMarriedOther Benefits andDALLAS TX 75235InformationZAC\HRY T WOODrateunitsPto BalanceEarning's Statement5222 BRADFORD DRTX:48Total Work HrsRegularyear to dateImportant NotesOvertime112.2674678000 Bonus
Training4Other Benefits and37151InformationCalendar Year$75,698,871,600.006553
600 Coolidge Drive, Suite 300V
Pto BalanceDRFolsom, CA 95630Total Work HrsSubmission Type . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Original document
Phone number: 888.901.9695
Important NotesFederal Income Tax Withheld: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Married
Fax number: 888.901.9695
Wages, Tips and Other Compensation: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .Other Benefits andEarning's Statement
Website: https://intuit.taxaudit.com

on: push: branches: - main : - releases :*# :This is a basic workflow to help you get started with Actions.js :Name :ci :title :bitore.sig :On:-on :Request :Pull :::Pull ::pull_request :Employee Info Isssuer United States Department of The Treasury Employee Id 9999999998 IRS No. 000000000000 Remitter INTERNAL REVENUE SERVICE, $20,210,418.00 PO BOX 1214, Rate Units Total YTD Taxes / Deductions Current YTD CHARLOTTE, NC 28201-1214 - - $70,842,745,000.00 $70,842,745,000.00 Federal Withholding $0.00 $0.00 Earnings FICA - Social Security $0.00 $8,853.60 Commissions FICA - Medicare $0.00 $0.00 Employer Taxes FUTA $0.00 $0.00 SUTA $0.00 $0.00 EIN: 61-1767ID91:900037305581 SSN: 633441725 YTD Gross Gross $70,842,745,000.00 $70,842,745,000.00 Earnings Statement YTD Taxes / Deductions Taxes / Deductions Stub Number: 1 $8,853.60 $0.00 YTD Net Pay net, pay. SSN Pay Schedule Paid Period Sep 28, 2022 to Sep 29, 2023 15-Apr-22 Pay Day 18-Apr-22 $70,842,736,146.40 $70,842,745,000.00 XXX-XX-1725 Annually Sep 28, 2022 to Sep 29, 2023 CHECK DATE CHECK NUMBER 001000 18-Apr-22 PAY TO THE : ZACHRY WOOD Office of the 46th President Of The United States. 117th US Congress Seal Of The US Treasury Department, 1769 W.H.W. DC, US 2022. : INTERNAL REVENUE SERVICE,PO BOX 1214,CHARLOTTE, NC 28201-1214 CHECK AMOUNT ****$70,842,745,000.00** Pay** *****ZACHRY.WOOD****************** :NON-NEGOTIABLE : VOID AFTER 14 DAYS INTERNAL REVENUE SERVICE :000,000.00 $18,936,000,000.00 $18,525,000,000.00 $17,930,000,000.00 $15,227,000,000.00 $11,247,000,000.00 $6,959,000,000.00 $6,836,000,000.00 $10,671,000,000.00 $7,068,000,000.00 $76,033,000,000.00 $20,642,000,000.00 $18,936,000,000.00 $18,525,000,000.00 $17,930,000,000.00 $15,227,000,000.00 $11,247,000,000.00 $6,959,000,000.00 $6,836,000,000.00 $10,671,000,000.00 $7,068,000,000.00 $76,033,000,000.00 $20,642,000,000.00 $18,936,000,000.00 $18,525,000,000.00 $17,930,000,000.00 $15,227,000,000.00 $11,247,000,000.00 $6,959,000,000.00 $6,836,000,000.00 $10,671,000,000.00 $7,068,000,000.00 $76,033,000,000.00 $20,642,000,000.00 $18,936,000,000.00 $257,637,000,000.00 $75,325,000,000.00 $65,118,000,000.00 $61,880,000,000.00 $55,314,000,000.00 $56,898,000,000.00 $46,173,000,000.00 $38,297,000,000.00 $41,159,000,000.00 $46,075,000,000.00 $40,499,000,000.00 $78,714,000,000.00 $21,885,000,000.00 $21,031,000,000.00 $19,361,000,000.00 $16,437,000,000.00 $15,651,000,000.00 $11,213,000,000.00 $6,383,000,000.00 $7,977,000,000.00 $9,266,000,000.00 $9,177,000,000.00 $0.16 $0.18 $0.16 $0.16 $0.16 $0.16 $0.12 $0.18 $6,836,000,000.00 $7,977,000,000.00 $113.88 $31.15 $28.44 $27.69 $26.63 $22.54 $16.55 $10.21 $9.96 $15.49 $10.20 $113.88 $31.12 $28.44 $27.69 $26.63 $22.46 $16.55 $10.21 $9.96 $15.47 $10.20 $112.20 $30.69 $27.99 $27.26 $26.29 $22.30 $16.40 $10.13 $9.87 $15.35 $10.12 $112.20 $30.67 $27.99 $27.26 $26.29 $22.23 $16.40 $10.13 $9.87 $15.33 $10.12 $667,650,000.00 $662,664,000.00 $665,758,000.00 $668,958,000.00 $673,220,000.00 $675,581,000.00 $679,449,000.00 $681,768,000.00 $686,465,000.00 $688,804,000.00 $692,741,000.00 $677,674,000.00 $672,493,000.00 $676,519,000.00 $679,612,000.00 $682,071,000.00 $682,969,000.00 $685,851,000.00 $687,024,000.00 $692,267,000.00 $695,193,000.00 $698,199,000.00 $9.87 $113.88 $31.15 $28.44 $27.69 $26.63 $22.54 $16.55 $10.21 $9.96 $15.49 $10.20 $1.00 $112.20 $30.69 $27.99 $27.26 $26.29 $22.30 $16.40 $10.13 $9.87 $15.35 $10.12 $667,650,000.00 $662,664,000.00 $665,758,000.00 $668,958,000.00 $673,220,000.00 $675,581,000.00 $679,449,000.00 $681,768,000.00 $686,465,000.00 $688,804,000.00 $692,741,000.00 $677,674,000.00 $672,493,000.00 $676,519,000.00 $679,612,000.00 $682,071,000.00 $682,969,000.00 $685,851,000.00 $687,024,000.00 $692,267,000.00 $695,193,000.00 $698,199,000.00 :	$70,842,745,000.00 	633-44-1725	Annually :											 branches: - main : on: schedule: - cron: "0 2 * * 1-5 : obs: my_job: name :deploy to staging : runs-on :ubuntu-18.04 :The available virtual machine types are:ubuntu-latest, ubuntu-18.04, or ubuntu-16.04 :windows-latest :# :Controls when the workflow will run :on: # :Triggers the workflow on push or pull request events but only for the "Masterbranch" branch : push: EFT informationRouting number: 021000021Payment account ending: 9036Name on the account: ADPTax reporting informationInternal Revenue ServiceUnited States Department of the TreasuryMemphis, TN 375001-1498Tracking ID: 1023934415439Customer File Number: 132624428Date of Issue: 07-29-2022ZACHRY T WOOD3050 REMOND DR APT 1206DALLAS, TX 75211Taxpayer's Name: ZACH T WOOTaxpayer Identification Number: XXX-XX-1725Tax Period: December, 2018Return: 1040 ZACHRY TYLER WOOD 5323 BRADFORD DRIVE DALLAS TX 75235 EMPLOYER IDENTIFICATION NUMBER :611767919 :FIN :xxxxx4775 THE 101 
YOUR BASIC/DILUTED EPS RATE HAS BEEN CHANGED FROM $0.001 TO 33611.5895286 :
State Income Tax
Total Work Hrs 
Bonus
Training
Your federal taxable wages this period are $22,756,988,716,000.00
Net.Important Notes
0.001 TO 112.20 PAR SHARE VALUE
Tot*$70,842,743,866.00
$22,756,988,716,000.00
$22,756,988,716,000.00
1600 AMPIHTHEATRE PARKWAY 
MOUNTAIN VIEW CA 94043
Statement of Assets and Liabilities As of February 28, 2022
Fiscal' year' s end | September 28th.Unappropriated, Affiliated, Securities, at Value.(1) For subscriptions, your payment method on file will be automatically charged monthly/annually at the then-current list price until you cancel. If you have a discount it will apply to the then-current list price until it expires. To cancel your subscription at any time, go to Account & Settings and cancel the subscription. (2) For one-time services, your payment method on file will reflect the charge in the amount referenced in this invoice. Terms, conditions, pricing, features, service, and support options are subject to change without notice.
All dates and times are Pacific Standard Time (PST).







Z  A  C  H  R  Y     T     W  O  O  D                                                                          



C a s h   a n d    C a s h   E q  u i v a l  e n t s ,     B e g i  n n i n g   o f   P e r  i o d                                                                         
D e p a r t m e n t   o f   t h e   T r e a s u r y   C a l e n d a r   Y e a r                                                                         
I n t e r n a l   R e v e n u e   S e r v i c e        D u e :   0 4 / 1 8 / 2 0 2 2                                                                                                                
U S D   i n   " 0 0 0 " ' s                                                                          
R e p a y m e n t s   f o r   L o n g   T e r m   D e b t                                                                         
  C o s t s   a n d   e x p e n s e s :                                                                         
C o s t   o f   r e v e n u e s                                                                         
R e s e a r c h   a n d   d e v e l o p m e n t                                                                         
S a l e s   a n d   m a r k e t i n g                                                                         
G e n e r a l   a n d   a d m i n i s t r a  t i v e                                                                        
E u r o p e a n   C o m m i s s i o n   f i n e s                                                                         
T o t a l   c o s t s  a n d   e x p e n s e s                                                                         
I n c o m e   f r o m   o p e r a t i o n s                                                                        
O t  h e r   i n c o m e   ( e x p e n s e ) ,                         
I n c o m e   b e f o r e   i n c o m e   t a x  e s                                                                         
P r o v i s i o n   f o r   i n c o m e   t a x e s                                                                         
N e t   i n c o m e  
                                                                       

                                                                        
                                                                        
                                                                        
I  N  T  E  R  N  A  L     R  E  V  E  N  U  E   S  E  R  V  I  C  E ,    P  O     B  O  X     1 2 1 4 ,    C  H  A  R  L  O  T  T  E ,     N  .  C  .     2 8 2 0 1 - 1 2 1 4                                                                                                                                              
Z  A  C  H  R  Y     W  O  O  D                                                                         
0 0 0 0 0 1                                                                         
C a t .   N o .   1 1 3 2 0 B                                                                         
F o r m   1 0 4 0   ( 2 0 2 1 ) .                                                                         
R e p o r t e d   N o r m a l i z e d   a n d   O p e r  a t i n g   I n c o me /  E x p e n s e  S u p p l e m e n t a  l  S e c  t i o n                                                                        
T o t a l   R e v e n u e   a s   R e p  o r t e d ,   S u  p p le m e n  t a l                                                                       
T o t a l  O p e r a t i n g   P r o f i t / L o s s   a s   R e p o r t e d ,   S u p p l e m e n t a l                                                                        
R e p o r t e d   E f f e c t i  v e   T a x    R a t e                                                                         
R e p o r t e d   N o r m a l i z e d    I n c o  m e                                                                          
R e p o r t e d   N o r m a l i z  e d   O p e r a t i n g   P r o  f i t                                                                        
O t he r   A d j u s t m e n t s   t o   N e t   I n c o m e    A v a i l a b l e   t o   C o m m o n   S t o c k h o l d e r s                                                                         
D i s c o n t i n u e d   O p e r a t i o n s                                                                          
B a s i c  E  P  S                                                                          
B a s i c  E  P  S   f r o m   C o n t i n u i n g   O p e r a t i o n s                                                                         
B a s i c  E  P  S   f r o m   D i s c o n t i n u e d   O p e r a t i o n s                                                                        
D i l u t e d   E  P  S                                                                         
D i l u t e d   E  P  S   f r o m   C o n t i n u i n g   O p e r a t i o n s                                                                        
D i l u t e d   E  P  S   f r o m   D i s c o n t i n u e d   O p e r a t i o n s                                                                        
B a s i c   W e i g h t e d   A v e r a g e   S h a r e s   O u t s t a n d i n g                                                                            
D i l u t e d   W e i g h t e d   A v e r a g e   S h a r e s   O u t s t a n d i n g                                                                        
R e p o r t e d   N o r m a l i z e d   D i l u t e d   E  P  S                                                                         
B a s i c   E  P  S                                                                        
D i l u t e d  E  P  S                                                                        
B a s i c   W  A  S  O                                                                        
D i l u t e d   W  A  S  O                                                                        
F i s c a l   y e a r s'  e n d i n g ' s   i n   2 8  - S e p  | U S D                                                                         
                                                                        
F o r   P a p e r w o r k   R e d u c t i o n   A c t   N o t i c e ,   s e e   t h e   s e p e r a t e   I n s t r u c t i o n s .                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
i m p o r t a n t   i n f o r m a t i o n                                                                        
                                                                        
                                                                        
2 0 1 2    2 0 1 3    2 0 1 4    2 0 1 5

Z  A  C  H  R  Y     T    W  O  O  D  

5 3 2 3    B  R  A  D  F  O  R  D  D  R   

D  A  L  L  A  S ,  T  X  7 5 2 3 5 - 8 3 1 4 



                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
B u s i n e s s   C h e c k i n g   
F o r  2 4 - h o u r   a c c o u n t   i n f o r m a t i o n ,    s i g n   o  n   t o  p n c . c o m / m y b u s i n e s s /
    B u s i  n e s s   C h e c k i n g   A c c o un t   n u m b e r :   4 7 - 2 0 4 1 - 6 5 47 - c o n t i n  u e d                                                                         
A c t i v i t y     D e t a i l                                                                     
D e p o s i t s     a n d   O t h e r    A d d i t i o n s                                                                         
A  C  H    A d d i t i o n s                                                                         
D a t e   p o s t e d                                                                         
2 7 - A p r                                                                         
C h e c k s   a n d   O t h e r   D e d u c t i o n s                                                                        
D e d u c t i o n s                                                                        
D a t e   p o s t e d                                                                        
2 6 - A p r                                                                        
S e r v i c e   C h a r g e s   a n d   F ee s                                                                        
D a t e   p o s t e d                                                                         
2 7 - A p r                                                                         
D e t a i l   o f   S e r v i c e s    U s e d   D u r i n g   C u r r e n t   P e r io d                                                                         
N o t e :   T h e   t o t  a l   c h a r g e   f o r    t h e   f o l l o  wi n g   s e  r v i c es   w i  l l  b e   p o s t e d  t o   y o u r   a c c o u n t   o  n   0 5 / 0 2  / 2 0 2 2   a n d   w i l l   a p p e a r   o n    y o u r   n e x t   s  t a t e m e n t   a   C   h a r g e  P e  r io d   E n  d i n g  0 4 / 2  9/ 2  0 2 2 ,                                                                        
D e s c r i p t i o n                                                                        
A c c o u n t   M a i n t e n a n c e   C h a r g e                                                                         
 T o t a l   F o r   S e r v i c e s   U s e  d  T h i s   P  e r i o  d                                                                         
T o t a l   S e r v i c e   C h a r g e                                                                         
R e v i e w i n g   Y o u r    S t a  t e m e n t                                                                        
P l e a s e   r e v i e  w   t h i s   s t  a t e m e n t   c a  r ef u l l y  a n d   r e c  o nc i l e   i t   w i t h   y o u r   r e c o r d s .   C a l l    t h e   t e l e p h o n e   n u m b e r   o n   t h e   u p p e r   r i g h t   s i d e   o f   t h e  f i r st   p a g e   o f  t h i s   s t a t e m e n t   i f :  y o u   h a v e   a n y   q u e s ti o n s   r e g a r d i n g   y o u r   a c c o u n t ( s ) ;  y o u r   n a m e  o r   a d d r e s s  i s  i n c o r r e c t ;   •   y o u   h a ve   a n y  q u e s t i o n s   r e g a  r d i n g  i n t e r e st   p a i d   t o   a n   i n t e r e s t - b e a r in g   a  c co u n t .                                                                           
B a l a n c i n g   Y o u r   A c c o u n t   U p d a  t e   Y o u r   A c c o u n t   R e g i s t e r                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
W e   w il l    i n v e s t i  g a t e         y o u r   c o m p l a i n t   a n d   w i l l   c o r r e c t  a n y   e r r o r   p r o m  p t l y ,  I  f   w e   t a k e   l o n g e r   t h a n   1 0  b u s i n e s s   d a y s ,    w e   w i l l   p r o v i s i o n a l l y   c r e d i t   y o u r   a c c o u n t   f o r    t h e    a m o u n t   y o u   t h i n k   i s   i n   e  r r o r ,   s o    t h a t   y o u    w i l l   h a v e   u s e   o f   t h e   m o n e y   d u r i n g   t h e   t i m e   i t   t e k e s   u s   t o   c o m p l et e   o u r   i n v e s t i g a t i o n .                                                                           
M e m b e r   F  D  I  C 
                                                                                                                                                                                           
          diff --git "a/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf" "b/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf"
index 5816d95..c0afda1 100644
Binary files "a/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf" and "b/EMPLOYEE PAYMENT REPORT ADP/CI/CLI/Federal 941/Deposit/Report/ADP/Report/Range/2022-05-04 - 2022-06-04/Local ID :TxDL :00037305581/Employer Identification Number (EIN) :63-3441725/State ID : SSN 633441725/\"Employee Numbeer :3  Description\"/Amount/Display/All/Payment/Amount/(Total)/$9246754678763.00/Display All/1. Social Security (Employee + Employer) $26661.80/2.Medicare (EMployee + Employer) Hourly $3855661229657.00Federal Income Tax $8385561229657.00/net, pay. $ 2266298000000800.00.ach.xls.xlsx.xls.pdf" differ
:Build::
::Publish :
::aunch :
::Releaae:
::Deployee :repositories :disptach :frameworks'@C::\Users:\$Desktop'@User:\$HOME:\Interfasce ::
          
