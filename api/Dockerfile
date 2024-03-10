FROM mcr.microsoft.com/dotnet/sdk:8.0

ENV ASPNETCORE_URLS http://+:80
ENV ASPNETCORE_ENVIRONMENT Development

WORKDIR /api

COPY . .

RUN dotnet restore
RUN dotnet build
RUN dotnet publish -o /publish

WORKDIR /publish

ENTRYPOINT ["dotnet", "/publish/api.dll"]