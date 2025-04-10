# context is the root of the project
# /projects/nopCommerce
# this devcontainer dockerfile in the ./.devcontainer folder

# create the build instance 
FROM mcr.microsoft.com/dotnet/sdk:9.0-noble AS build
USER root
RUN dotnet workload update && \
    apt-get update && \
    apt-get install -y \
        sudo \
        openssh-client \
        rsync && rm -rf /var/lib/apt/lists/* \
        zsh

# Ensure the .zshrc file exists in the build context before uncommenting the next line
# COPY .zshrc /root/.zshrc

# Accept build arguments for username, UID, and GID from docker-compose
ARG IDE_USER
ARG IDE_UID
ARG IDE_GID

RUN echo "the passed arg IDE-USER= ${IDE_USER}" && \
    echo "the passed arg IDE-UID= ${IDE_UID}" && \
    echo "the passed arg IDE-GID= ${IDE_GID}"

# #  remove user and group if they use id 1000
# RUN set -eux && \
#     echo "Verifying current user..." && \
#     whoami && \
#     echo "Deleting user with UID 1000 if it exists..." && \
#     if id -u 1000 &>/dev/null; then \
#         USER_NAME=$(getent passwd 1000 | cut -d: -f1) && \
#         userdel --force -r "${USER_NAME}" 2>/dev/null || true && \
#         if id -u 1000 &>/dev/null; then \
#             echo "Error: Failed to delete user with UID 1000 (${USER_NAME}). Ensure you have sufficient permissions." && exit 1; \
#         fi; \
#     else \
#         echo "No user with UID 1000 exists."; \
#     fi && \
#     echo "Deleting group with GID 1000 if it exists..." && \
#     if getent group 1000 &>/dev/null; then \
#         GROUP_NAME=$(getent group 1000 | cut -d: -f1) && \
#         if [ -n "${GROUP_NAME}" ]; then \
#             groupdel "${GROUP_NAME}"; \
#         else \
#             echo "No group name found for GID 1000."; \
#         fi; \
#     else \
#         echo "No group with GID 1000 exists."; \
#     fi


# Remove container image user and group if they conflict with the remoteUser from docker-compose/devcontainer.json
# This is important to avoid conflicts with the user and group IDs
RUN set -eux && \
    echo "Terminating processes owned by user 'ubuntu'..." && \
    pkill -u "ubuntu" || true && \
    echo "Deleting user 'ubuntu' and group 'ubuntu'..." && \
    userdel --force -r "ubuntu" 2>/dev/null || true && \
    groupdel "ubuntu" 2>/dev/null || true && \
    echo "Successfully deleted user 'ubuntu' and group 'ubuntu'."

# Create the docker-compose/devcontainer.json user and add to the sudo group
RUN set -eux && \
    echo "Creating group if it does not exist..." && \
    if ! getent group "${IDE_GID}" >/dev/null; then \
        groupadd --gid "${IDE_GID}" "${IDE_USER}" || (echo "Error: Failed to create group with GID ${IDE_GID}" && exit 1); \
    else \
        echo "Group with GID ${IDE_GID} already exists."; \
    fi && \
    echo "Creating user if it does not exist..." && \
    if ! id -u "${IDE_USER}" >/dev/null 2>&1; then \
        useradd --uid "${IDE_UID}" --gid "${IDE_GID}" -m "${IDE_USER}" || (echo "Error: Failed to create user ${IDE_USER} with UID ${IDE_UID} and GID ${IDE_GID}" && exit 1); \
    else \
        echo "User ${IDE_USER} already exists."; \
    fi && \
    echo "Adding user to sudoers..." && \
    SUDO_FILE="/etc/sudoers.d/${IDE_USER}" && \
    SUDO_LINE="${IDE_USER} ALL=(ALL) NOPASSWD:ALL" && \
    touch "${SUDO_FILE}" && \
    grep -qF -- "${SUDO_LINE}" "${SUDO_FILE}" || echo "${SUDO_LINE}" >> "${SUDO_FILE}" && \
    chmod 0440 "${SUDO_FILE}" && \
    echo "Verifying user creation..." && \
    getent passwd "${IDE_USER}" || (echo "Error: User ${IDE_USER} was not created!" && exit 1)
   

# Set the workspace directory
WORKDIR /workspace


# Copy the solution and project files
# if USER does not have permission to access the files on the host, the files will not be copied
COPY ./src ./src

# Ensure the IDE_USER has ownership of the workspace directory - dont know if this works. copilot says it cannot be done
RUN set -eux && \
    echo "Fixing ownership and permissions for /workspace..." && \
    chown -R ${IDE_USER}:${IDE_USER} /workspace && \
    if [ $? -eq 0 ]; then \
        echo "Ownership successfully changed for /workspace to ${IDE_USER}:${IDE_USER}"; \
    else \
        echo "Failed to change ownership for /workspace"; \
    fi && \
    chmod -R u+rw /workspace

# Restore and clean the solution - commented out to save time when rebuilding the image while debugging dockerfile
# This cleans any previous builds and restores the dependencies
# It prepares the project for building
# The --disable-parallel option is used to avoid issues with parallel restores
#RUN dotnet restore ./src/NopCommerce.sln --disable-parallel && \
#    dotnet clean ./src/NopCommerce.sln


# Switch to the non-root user running vscode
# This is important for security and to avoid permission issues
# The user should have the same UID and GID as the host user
# This allows the container to access files on the host without permission issues
USER ${IDE_USER}

# Build the solution in Debug mode
# The --no-incremental option is used to force a full rebuild
#    This is useful when you want to ensure that all projects are built from scratch
# The -c Debug option specifies the configuration to use (Debug or Release)
RUN dotnet build ./src/NopCommerce.sln --no-incremental -c Debug

# Build the projects separately to avoid dependency issues (only if needed for debugging)
# Note: The --no-incremental flag is used to force a full rebuild
# This is useful when you want to ensure that all projects are built from scratch
# Build the projects in the correct order to avoid dependency issues
# leave commented out until needed for debugging
#RUN dotnet build ./src/Presentation/Nop.Web.Framework/Themes/Nop.Web.Framework.Themes.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web.Framework.Themes
#RUN do/net build ./sr//Presentation//op.Web.Framewo/k/Themes/Nop.W/b.Framework.Th/mes.Libraries/Nop.Web.Framework.Themes.Libraries.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web.Framework.Themes/Nop.Web.Framework.Themes.Libraries
#RUN dotnet build ./src/Presentation/Nop.Web.Framework/Nop.Web.Framework.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web.Framework
#RUN dotnet build ./src/Presentation/Nop.Web/Nop.Web.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web
#RUN dotnet build ./src/Libraries/Nop.Services/Nop.Services.csproj --no-incremental -c Debug -o ./bin/Libraries/Nop.Services
#RUN dotnet build ./src/Libraries/Nop.Core/Nop.Core.csproj --no-incremental -c Debug -o ./bin/Libraries/Nop.Core
#RUN dotnet build ./src/Libraries/Nop.Data/Nop.Data.csproj --no-incremental -c Debug -o ./bin/Libraries/Nop.Data

# Ensure ./bin does not exist, then copy the contents of ./src to ./bin as root
USER root
RUN rm -rf ./bin 
USER ${IDE_USER}
# Copy the contents of ./src to ./bin as the non-root user
# This is important to avoid permission issues when removing this folder using the entrypoint script which runs under the IDE_USER
RUN mkdir ./bin && cp -r ./src/* ./bin/

# Switch back to the non-root user
USER ${IDE_USER}
CMD ["./.devcontainer/entrypoint.sh"]
