FROM public.ecr.aws/debian/debian:latest as getter

RUN apt-get -y update && \
    apt-get -y install wget

WORKDIR /tmpdir

RUN wget https://github.com/sventorben/keycloak-home-idp-discovery/releases/download/v23.0.0/keycloak-home-idp-discovery.jar && \
    wget https://github.com/aerogear/keycloak-metrics-spi/releases/download/5.0.0/keycloak-metrics-spi-5.0.0.jar && \
    chmod +r /tmpdir/*.jar


FROM public.ecr.aws/docker/library/busybox as dest

WORKDIR /
COPY --from=getter /tmpdir /tmpproviders

COPY script.sh /script.sh

CMD ["sh", "-c", "/script.sh"]
