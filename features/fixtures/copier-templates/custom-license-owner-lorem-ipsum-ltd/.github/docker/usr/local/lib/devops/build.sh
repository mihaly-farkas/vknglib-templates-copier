#!/usr/bin/env bash

set -e

source /usr/local/lib/devops/common.sh

echo -e "${CYAN}Building the ${GREEN}${GIT_REPO_NAME}${CYAN} component...${NC}"

#######################################################################################################################
# Install the Python dependencies
#######################################################################################################################
echo -e "${CYAN}Installing the Python dependencies...${NC}"

set -x
pip3 install \
  --requirement requirements.txt \
  --break-system-packages \
  --root-user-action=ignore
{ set +x; } 2>/dev/null

#######################################################################################################################
# Execute the Behave tests
#######################################################################################################################
echo -e "${CYAN}Executing the tests...${NC}"

# Set the latest tag for the tests
set -x
git tag -f "@latest"
{ set +x; } 2>/dev/null

# Execute the tests
set -x
behave \
  --exclude features/fixtures/.* \
  --stop
{ set +x; } 2>/dev/null
