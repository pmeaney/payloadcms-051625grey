# Create a new environment named "production"
gh api -X PUT /repos/pmeaney/payloadcms-051625grey/environments/production

# Add a secret to the "production" environment
gh secret set POSTGRES__SECRET_ENV_FILE --env production --body "POSTGRES_DB=payloadcms-051625grey-db
POSTGRES_USER=payloadcms-051625grey-user
POSTGRES_PASSWORD=payloadcmsPass"

# install yq:
# brew install yq

# Preview what would be in POSTGRES__SECRET_ENV_FILE
yq '.postgres_defaults' .github/defaults/env-defaults.yml
# Preview what would be in PAYLOAD__SECRET_ENV_FILE (excluding SKIP items)
yq '.payloadcms_defaults' .github/defaults/env-defaults.yml | grep -v "SKIP"

# Setup the secrets files on Github - environment: production
# For POSTGRES__SECRET_ENV_FILE (lines 12-14)
yq '.postgres_defaults' .github/defaults/env-defaults.yml | gh secret set POSTGRES__SECRET_ENV_FILE --env production --body "$(cat)"
# For PAYLOAD__SECRET_ENV_FILE (lines 20-26, excluding the last two items with "SKIP")
yq '.payloadcms_defaults' .github/defaults/env-defaults.yml | grep -v "SKIP" | gh secret set PAYLOAD__SECRET_ENV_FILE --env production --body "$(cat)"