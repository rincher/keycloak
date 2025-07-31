FROM quay.io/keycloak/keycloak:latest AS builder

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build --health-enabled true \
                                  --metrics-enabled true \
                                  --db postgres \
                                  --features preview \
                                  --metrics-enabled=true

RUN keytool -genkeypair -storepass password \
            -storetype PKCS12 -keyalg RSA \
            -keysize 2048 -dname "CN=server" \
            -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" \
            -keystore /opt/keycloak/conf/server.keystore

FROM quay.io/keycloak/keycloak:latest

USER root

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER keycloak

COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/docker-entrypoint.sh"]
