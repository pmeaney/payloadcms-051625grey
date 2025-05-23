# PayloadCMS Deployment Configuration Guide

This guide outlines the configuration details for the current grey deployment template. When using this template, you should create a new repo for each deployment - whether it's grey, blue, green, or any color code you choose. 

> **Note:** This template is designed with "one repo per deployment" in mind. If you need multiple environments (like blue/green deployment), you would create separate repositories for each color. If you only need one instance, you can keep grey or rename it to your preferred color, but ensure you update the date portion for clarity.

The purpose of this guide is basically to point out that you need to change: `051625grey` to `<someDate><someColor>`, e.g. `123199purple`. 

**When I mention "update 051625grey to 123199purple, or see this checkbox below, consider that your cue to update the relevant file config**

- [ ] *051625grey -> 123199purple*

It will also point out things you need to manually do-- such as setup the Github Repo, and its secrets, as listed below. The github repo secrets you'll add will essentially be your production secrets. CICD pulls them from github and injects them into your containers when they're created on the remote server. **As a template for the prod secrets to add to the github repo secrets, use the ./github/defaults/env-defaults.yml** file's sections for the pertinent app (payload or postgresql-- just be sure to scramble them as appropriate.)

## Repository Setup for Grey Deployment

To set up the grey deployment repository:

1. **Create a GitHub repository** with the naming pattern.

- [ ] *051625grey -> 123199purple*
- `payloadcms-051625grey`

2. **Set up repository secrets** in the repo:
   - `LINUX_SSH_PRIVATE_KEY_CICD`: SSH key for deployment server access
   - `LINUX_BOTCICDGHA_USERNAME`: Username for SSH access
   - `LINUX_SERVER_IPADDRESS`: IP address of deployment server
   - `POSTGRES__SECRET_ENV_FILE`: Database environment variables
   - `PAYLOAD__SECRET_ENV_FILE`: CMS environment variables
   - `GHPATCICD_RpoWkflo_WRDpckgs_051425`: GitHub Personal Access Token with repository, workflow, and package read/write permissions

## Configuration Files for Grey Deployment

### 1. Main Workflow File (z-main.yml)

The workflow file is configured with hardcoded values:

- [ ] *051625grey -> 123199purple*

```yaml
# In database job:
with:
  environment: production
  topic_name: payloadcms
  deployment_date: 051625
  deployment_color: grey
  db_container_name: payloadcms-db-051625grey

# In cms-fe job:
with:
  environment: production
  topic_name: payloadcms
  deployment_date: 051625
  deployment_color: grey
  cms_dir_name: payloadcms-cms
  cms_container_name: payloadcms-051625grey-cms
  cms_image_name: ghcr.io/${{ github.actor }}/payloadcms-051625grey-cms:latest
```

### 2. Local Development Docker Compose File (docker-compose.local.yml)

Ensure service names, container names, and network name use the grey color code:

- [ ] *051625grey -> 123199purple*

```yaml
services:
  payloadcms-db-051625grey:
    image: postgres:17
    container_name: payloadcms-db-051625grey
    # ...other settings...
    networks:
      - dockernet-payloadcms-grey

  payloadcms-cms-051625grey:
    image: node:20-alpine
    container_name: payloadcms-cms-051625grey
    # ...other settings...
    networks:
      - dockernet-payloadcms-grey
    depends_on:
      - payloadcms-db-051625grey

networks:
  dockernet-payloadcms-grey:
    name: dockernet-payloadcms-grey
```

### 3. Environment Variables Files

**Four** different environment files need to maintain the grey naming convention:

- [ ] *051625grey -> 123199purple*

#### a. `.github/defaults/env-defaults.yml`
```yaml
postgres_defaults: |
  POSTGRES_DB=payloadcms-db-051625grey
  POSTGRES_USER=payloadcms-051625grey-user
  POSTGRES_PASSWORD=payloadcmsPass

payloadcms_defaults: |
  DATABASE_URI=postgres://payloadcms-051625grey-user:payloadcmsPass@payloadcms-db-051625grey:5432/payloadcms-db-051625grey
  PAYLOAD_SECRET=0505d1e544a564c8730e83fb
  NEXT_PUBLIC_SERVER_URL=http://localhost:3000
  CRON_SECRET=YOUR_CRON_SECRET_HERE
  PREVIEW_SECRET=YOUR_SECRET_HERE
  PAYLOAD_SKIP_MIGRATION=true
  NEXT_SKIP_DB_CONNECT=true
```

#### b. CMS `.env` (development)
```
DATABASE_URI=postgres://payloadcms-051625grey-user:payloadcmsPass@payloadcms-db-051625grey:5432/payloadcms-db-051625grey
PAYLOAD_SECRET=7596b4a8fcc3d8086f8f5001
NEXT_PUBLIC_SERVER_URL=http://localhost:3000
CRON_SECRET=YOUR_CRON_SECRET_HERE
PREVIEW_SECRET=YOUR_SECRET_HERE
```

#### c. DB `.env`
```
POSTGRES_DB=payloadcms-db-051625grey
POSTGRES_USER=payloadcms-051625grey-user
POSTGRES_PASSWORD=payloadcmsPass
```

#### d. `example-postgres-env.env`
```
POSTGRES_DB=payloadcms-db-051625grey
POSTGRES_USER=payloadcms-051625grey-user
POSTGRES_PASSWORD=payloadcmsPass
```

### 4. Database and CMS Workflow Files

No changes needed to the individual workflow files (`a-db-init.yml` and `b-cms-fe-check-deploy.yml`) because they accept parameters from the main workflow file.

# ALL DONE with updates! Below shows the resources which will be created.

## Resources Created By Grey Deployment

The grey deployment will create the following resources:

### Docker Images
- **Grey Deployment Image**: `ghcr.io/[username]/payloadcms-051625grey-cms:latest`

### Docker Containers
- **Grey Database**: `payloadcms-db-051625grey`
- **Grey CMS**: `payloadcms-051625grey-cms`

### Docker Networks
- **Grey Network**: `private-payloadcms-grey-dockernet`
- Also connects to: `main-network--npm020325` (shared)

### Docker Volumes
- **Grey Database Data**: `payloadcms-db-051625grey-data`
- **Grey Database Init Scripts**: `payloadcms-db-051625grey-init-scripts`

### Host Directories (on Deployment Server)
- **Grey CMS Migrations**: `~/payloadcms-051625grey-cms__migrations`
- **Grey CMS Media**: `~/payloadcms-051625grey-cms__media`

## Verification Checklist

After setup, verify:

- [ ] Both containers are running on the deployment server (`docker ps | grep payloadcms`)
- [ ] Database is properly configured (`docker volume ls | grep payloadcms`)
- [ ] Volume mounts exist for migrations and media (`ls -la ~/ | grep payloadcms`)
- [ ] Network configuration is correct (`docker network ls | grep payloadcms`)
- [ ] CMS instance can connect to its database
- [ ] Web access works

---

> # ALL DONE WITH CONFIG!

>**Extra info Below -- on Blue/Green Deployment**

## Blue/Green Deployment Strategy 

If you decide to implement a blue/green deployment approach, you would create two separate repositories based on this grey template - one for blue and one for green. Here's a summary of the basic strategy:

### Creating Blue/Green Deployment

1. Create two repositories from this template:
   - `payloadcms-051625blue`
   - `payloadcms-051625green`

2. Configure each with its respective color in all files mentioned above

3. Deploy both environments initially

4. Configure traffic routing:
   - Both Blue and Green CMS instances will attempt to use port 3000 by default
   - Configure a reverse proxy (like Nginx) to route production traffic to the active deployment
   - Assign different ports for direct access (e.g., 3000 for Blue, 3001 for Green)

### Deployment Process

1. Direct traffic to the initial active environment (e.g., Blue)
2. For updates:
   - Deploy changes to the inactive environment (e.g., Green)
   - Test the changes in the inactive environment
   - Switch traffic to the newly updated environment
   - The previously active environment becomes inactive

This approach allows zero-downtime deployments and easy rollback if issues are discovered after deployment.