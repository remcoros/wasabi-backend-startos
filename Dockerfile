# build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
WORKDIR /src
COPY WalletWasabi .
RUN dotnet restore "WalletWasabi.Backend/WalletWasabi.Backend.csproj"
WORKDIR "/src/WalletWasabi.Backend"
RUN dotnet build "WalletWasabi.Backend.csproj" -c Release -o /app/build

# publish
FROM build AS publish
RUN dotnet publish "WalletWasabi.Backend.csproj" -c Release -o /app/publish

# final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

ARG ARCH
ARG PLATFORM

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
WORKDIR /app

COPY --from=publish /app/publish .

# add local files
COPY /root /
COPY --chmod=a+x ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
COPY --chmod=0755 ./tmp/yq_linux_${PLATFORM} /usr/local/bin/yq

ENV WASABI_BIND=http://+:80/

# ports and volumes
EXPOSE 80
VOLUME /root

ENTRYPOINT [ "dotnet", "WalletWasabi.Backend.dll" ]
