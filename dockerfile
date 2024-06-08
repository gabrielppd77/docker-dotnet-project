FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
RUN apt-get update && apt-get install -y git

ARG CLONE_URL
ARG INTERNAL_PORT

WORKDIR /app

RUN git clone ${CLONE_URL} .

RUN rm -rf .git

RUN dotnet restore

COPY appsettings.json .

RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

EXPOSE ${INTERNAL_PORT}

ENTRYPOINT ["dotnet", "stock-control-api.dll"]