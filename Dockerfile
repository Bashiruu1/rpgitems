# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy solution and project files
COPY *.sln .
COPY src/*.csproj ./src/

# Restore packages
RUN dotnet restore

# Copy all project files
COPY . .
WORKDIR /app/
RUN dotnet build -c Release

# Test stage
#FROM build AS testrunner
#WORKDIR /app/tests/unit/RpgItems.Api.Tests
# Run unit tests
#RUN dotnet test --collect "XPlat Code Coverage" --results-directory:/testresults/unit /p:CoverletOutputFormat=opencover /p:Threshold=80 /p:ThresholdType=line+method

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy published output
COPY --from=build /app/src/bin/Release/net8.0/ ./

# Set the entry point to the web API project
ENTRYPOINT ["dotnet", "RpgItems.Api.dll"]
