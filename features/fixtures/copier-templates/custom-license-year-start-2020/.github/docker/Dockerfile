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
ARG GIT_REPO_SSH=git@github.com:$GIT_REPO_OWNER/$GIT_REPO_NAME.git

# Make the build arguments available as environment variables as well
ENV GIT_REPO_OWNER=$GIT_REPO_OWNER
ENV GIT_REPO_NAME=$GIT_REPO_NAME
ENV GIT_REPO_URL=$GIT_REPO_URL

# Add the github.com to the list of known hosts
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Clone the repository
WORKDIR /workdir
RUN git clone "$GIT_REPO_URL" . --origin origin-https
RUN git remote add origin "$GIT_REPO_SSH"
RUN git remote remove origin-https

# Pre-install the required python packages
RUN pip3 install --requirement requirements.txt --break-system-packages --root-user-action=ignore

# Copy the local files to the container's workspace.
COPY usr/local /usr/local
RUN ln -s /usr/local/lib/devops/build.sh /usr/local/bin/build

# Define the runtime environment variables
ENV SERVICE_USER_NAME="Mihaly Farkas (bot)"
ENV SERVICE_USER_EMAIL="194427384+mihaly-farkas-bot@users.noreply.github.com"
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPypAJ+T1aRJUzeq4KJw/JQgzjJnTsYXn2zktAp6KlK
ENV SERVICE_USER_SSH_PRIVAT_KEY_BASE64="LS0tLS1CRUdJTiBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0KYjNCbGJuTnphQzFyWlhrdGRqRUFBQUFBQkc1dmJtVUFBQUFFYm05dVpRQUFBQUFBQUFBQkFBQUFNd0FBQUF0emMyZ3RaVwpReU5UVXhPUUFBQUNEejhxUUNmazlXa1NWTTNxdUNpY1B5VUlNNHlaMDdHRjU5czVMUUtlaXBTZ0FBQUpoQmpXQi9RWTFnCmZ3QUFBQXR6YzJndFpXUXlOVFV4T1FBQUFDRHo4cVFDZms5V2tTVk0zcXVDaWNQeVVJTTR5WjA3R0Y1OXM1TFFLZWlwU2cKQUFBRUR5QlpaenNwMGlXb25xOGxEOUJuVFAyczNpVnZpS0ZlMVh4K3c2QnBrTkhQUHlwQUorVDFhUkpVemVxNEtKdy9KUQpnempKblRzWVhuMnprdEFwNktsS0FBQUFFWEp2YjNSQU5HVm1PVGN6TkdZNFlURTNBUUlEQkE9PQotLS0tLUVORCBPUEVOU1NIIFBSSVZBVEUgS0VZLS0tLS0K"
ENV GIT_CHECKOUT_REF="main"

