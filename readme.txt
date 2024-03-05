dotnet publish -c Debug

docker run --rm -it -v ${PWD}:/api -p 8080:8080 -e 'ASPNETCORE_ENVIRONMENT=Development' mcr.microsoft.com/dotnet/aspnet:8.0

dotnet api/bin/Debug/net8.0/api.dll

docker run mplatform/manifest-tool inspect mplatform/manifest-tool:latest

docker build -t aspnetcore/generator .