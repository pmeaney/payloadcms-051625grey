
# Setup Notes -- Blue Green Deploy setup

**These are just my initial notes to myself**

## Overview of creation

Copy original template to become Grey Template
- Duplicate https://github.com/pmeaney/template-payloadcms-portfolio2025
- Fix its names of things to include 'grey' and make things names' cleaner/better.
- Make it so all we have to do is change out the datacode & colorcode.
  
Copy Grey template to become Blue Template
Copy Grey template to become Green Template


### Step 0: Create Grey Template
Setup the summary CICD file with variable names to make it easy to regenerate the project.

Let's assume a best practice of calling the repo: `topicname-dateColor`

And the containers (DB & CMS) named: `topicname-dateColor-app`

e.g.
- repo: payloadcms-051625grey
- containers:
  - payloadcms-051625grey-cms
  - payloadcms-051625grey-db
- published docker package:
  - payloadcms-051625grey-cms:latest

Note: Only the CMS is built & published as a docker image.   
This is because we'll be editing the CMS's code, for example, if we want to add a new type of content, we would add in a CMS schema and new frontend formatting to host & display that content.
Whereas the DB is deployed directly to the server as a docker container from the official postgresql image.