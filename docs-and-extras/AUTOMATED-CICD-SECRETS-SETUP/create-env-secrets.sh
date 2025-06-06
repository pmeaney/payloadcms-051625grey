# Create a new environment named "production"
gh api -X PUT /repos/pmeaney/payloadcms-051625grey/environments/production

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

# NOTE:
# If you see "cat: stdin: Input/output error" it's actually misleading.
# You should see this-- the checkmark indicating the secret was created successfully.
# However, if you want to test whether they're accessible on CICD, just add the secrets-test.yml into a .github/workflows directory so that it runs.
# cat: stdin: Input/output error
# ✓ Set Actions secret POSTGRES__SECRET_ENV_FILE for pmeaney/payloadcms-051625grey
# cat: stdin: Input/output error
# ✓ Set Actions secret PAYLOAD__SECRET_ENV_FILE for pmeaney/payloadcms-051625grey

# Next, we pull 4 general repo secrets from 1pass.

# Define the name of the 1Password item (secure note) which contains the secrets.
ITEM_1P="May 2025 Debian Server - 051425grey"

# Set LINUX_BOTCICDGHA_USERNAME as a repository secret
LINUX_BOTCICDGHA_USERNAME=$(op item get "${ITEM_1P}" --fields label=LINUX_BOTCICDGHA_USERNAME)
gh secret set LINUX_BOTCICDGHA_USERNAME --body "${LINUX_BOTCICDGHA_USERNAME}"

# Set LINUX_SERVER_IPADDRESS as a repository secret
LINUX_SERVER_IPADDRESS=$(op item get "${ITEM_1P}" --fields label=LINUX_SERVER_IPADDRESS)
gh secret set LINUX_SERVER_IPADDRESS --body "${LINUX_SERVER_IPADDRESS}"

# Set LINUX_SSH_PRIVATE_KEY_CICD as a repository secret (reading from file)
gh secret set LINUX_SSH_PRIVATE_KEY_CICD --body "$(cat ~/.ssh/id_ed25519_051425_gh_cicd_np)"

# Set GHPATCICD_RPOWKFLO_WRDPCKGS_051425 as a repository secret
GHPATCICD_TOKEN=$(op item get "${ITEM_1P}" --fields label=GHPATCICD_RpoWkflo_WRDpckgs_051425)
gh secret set GHPATCICD_RPOWKFLO_WRDPCKGS_051425 --body "${GHPATCICD_TOKEN}"