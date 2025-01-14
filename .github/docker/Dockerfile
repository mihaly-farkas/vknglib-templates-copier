FROM ubuntu:24.10

# Install dependencies
RUN apt update --yes
RUN apt upgrade --yes
RUN apt install git --yes
RUN apt install npm --yes
RUN apt install python3 --yes
RUN apt install python3-pip --yes

# Define build arguments
ARG GIT_REPO_OWNER=mihaly-farkas
ARG GIT_REPO_NAME=vknglib-templates-copier
ARG GIT_REPO_URL=https://github.com/$GIT_REPO_OWNER/$GIT_REPO_NAME.git

# Make the build arguments available as environment variables as well
ENV GIT_REPO_OWNER=$GIT_REPO_OWNER
ENV GIT_REPO_NAME=$GIT_REPO_NAME

# Add the github.com to the list of known hosts
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Clone the repository
WORKDIR /workdir
RUN git clone "$GIT_REPO_URL" . --origin origin-https
RUN git remote remove origin-https

# Pre-install the required python packages
RUN pip3 install --requirement requirements.txt --break-system-packages --root-user-action=ignore

# Copy the local files to the container's workspace.
COPY usr/local /usr/local
RUN ln -s /usr/local/lib/devops/build.sh /usr/local/bin/build
RUN ln -s /usr/local/lib/devops/init.sh /usr/local/bin/init

# Define the runtime environment variables
ENV SERVICE_USER_NAME="Mihaly Farkas (bot)"
ENV SERVICE_USER_EMAIL="194427384+mihaly-farkas-bot@users.noreply.github.com"
ENV SERVICE_USER_PAT=""
ENV GIT_CHECKOUT_REF="main"
