FROM public.ecr.aws/debian/debian:latest as getter

RUN apt-get -y update && \
    apt-get -y install curl && \
    mkdir -p /tmpdir/log && \
    mkdir -p /tmpdir/tmp

WORKDIR /tmpdir

RUN curl -O https://github.com/sventorben/keycloak-home-idp-discovery/releases/download/v23.0.0/keycloak-home-idp-discovery.jar && \
    curl -O https://github.com/aerogear/keycloak-metrics-spi/releases/download/5.0.0/keycloak-metrics-spi-5.0.0.jar && \
    chmod +rx /tmpdir/*.jar && \
    chmod +rwx /tmpdir/log && \
    chmod +rwx /tmpdir/tmp


FROM public.ecr.aws/docker/library/busybox as dest

WORKDIR /
COPY --from=getter /tmpdir /tmpproviders

COPY script.sh /

CMD ["sh", "-c", "script.sh"]
