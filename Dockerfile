FROM ubuntu:latest as base

RUN apt update && apt install -y --no-install-recommends ca-certificates

FROM base as wget

RUN apt update && apt install -y --no-install-recommends wget

ARG VERSION="1.99.3"

RUN wget --no-hsts -qO- https://update.code.visualstudio.com/${VERSION}/cli-linux-x64/stable | tar xvz -C /usr/bin/

FROM base

COPY --from=wget /usr/bin/code /usr/bin/code
RUN chmod +x /usr/bin/code

USER ubuntu

ENTRYPOINT [ "/usr/bin/code", "serve-web", "--without-connection-token", "--accept-server-license-terms" ]

CMD [ "--host", "0.0.0.0", "--port", "8000", "--cli-data-dir", "/vscode/cli-data", "--server-data-dir", "/vscode/server-data" ]
