FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
WORKDIR /src
COPY WalletWasabi .
RUN dotnet restore "WalletWasabi.Backend/WalletWasabi.Backend.csproj"
WORKDIR "/src/WalletWasabi.Backend"
RUN dotnet build "WalletWasabi.Backend.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WalletWasabi.Backend.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
WORKDIR /app
COPY --from=publish /app/publish .

# add local files
COPY /root /
COPY --chmod=a+x ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh

# ports and volumes
EXPOSE 80
VOLUME /home/app
