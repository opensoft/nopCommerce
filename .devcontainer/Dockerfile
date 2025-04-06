# context is the root of the project
# /projects/nopCommerce
# this devcontainer dockerfile in the ./.devcontainer folder

# create the build instance 
FROM mcr.microsoft.com/dotnet/sdk:9.0-noble AS build
RUN apt-get update && apt-get install -y rsync

WORKDIR /workspace

# Copy the solution and project files
COPY ./src ./src

# Update .NET workloads to ensure compatibility, restore and clean the solution
RUN dotnet workload update && \
    dotnet restore ./src/NopCommerce.sln --disable-parallel && \
    dotnet clean ./src/NopCommerce.sln

# Ensure correct ownership and permissions for the ./src directory
#RUN chmod -R 775 ./src && chown -R vscode:vscode ./src
# Switch to non-root user for the build process
#USER vscode
RUN dotnet build ./src/NopCommerce.sln --no-incremental -c Debug

# Build the projects
# Note: The --no-incremental flag is used to force a full rebuild
# This is useful when you want to ensure that all projects are built from scratch
# Build the projects in the correct order to avoid dependency issues
#RUN dotnet build ./src/Presentation/Nop.Web.Framework/Themes/Nop.Web.Framework.Themes.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web.Framework/Themes
#RUN dotnet build ./src/Presentation/Nop.Web.Framework/Themes/Nop.Web.Framework.Themes.Libraries/Nop.Web.Framework.Themes.Libraries.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web.Framework/Themes/Nop.Web.Framework.Themes.Libraries
# RUN dotnet build ./src/Presentation/Nop.Web.Framework/Nop.Web.Framework.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web.Framework
# RUN dotnet build ./src/Presentation/Nop.Web/Nop.Web.csproj --no-incremental -c Debug -o ./bin/Presentation/Nop.Web
# RUN dotnet build ./src/Libraries/Nop.Services/Nop.Services.csproj --no-incremental -c Debug -o ./bin/Libraries/Nop.Services
# RUN dotnet build ./src/Libraries/Nop.Core/Nop.Core.csproj --no-incremental -c Debug -o ./bin/Libraries/Nop.Core
#RUN dotnet build ./src/Libraries/Nop.Data/Nop.Data.csproj --no-incremental -c Debug -o ./bin/Libraries/Nop.Data

# Ensure ./bin does not exist, then rename ./src to ./bin
RUN rm -rf ./bin && mv ./src ./bin

# keep the container running
CMD ["tail", "-f", "/dev/null"]