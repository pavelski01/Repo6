# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /api
COPY api.csproj .
RUN dotnet restore

COPY . .
RUN dotnet build
RUN dotnet publish -o /publish -c Release

#Runtime Image Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
ENV ASPNETCORE_URLS http://+:80
ENV ASPNETCORE_ENVIRONMENT Development
WORKDIR /publish
COPY --from=build-env /publish .
ENTRYPOINT ["dotnet", "api.dll"]
