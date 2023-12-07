ARG HYDRA_VERSION
ARG KRATOS_VERSION

FROM oryd/hydra:$HYDRA_VERSION as hydra
FROM oryd/kratos:$KRATOS_VERSION as kratos
FROM oryd/kratos-selfservice-ui-node:$KRATOS_VERSION as kratos-selfservice-ui-node
FROM oryd/hydra-login-consent-node:$HYDRA_VERSION as hydra-login-consent-node

FROM node:18.12.1-alpine

# HYDRA ####################################################
COPY --from=hydra /usr/bin/hydra /usr/bin/hydra
RUN mkdir -p /app/hydra
COPY .docker/hydra /app/hydra
# Declare the standard ports used by hydra (4444 for public service endpoint, 4445 for admin service endpoint)
EXPOSE 4444 4445
############################################################

VOLUME /var/lib/sqlite/

# KRATOS ####################################################
COPY --from=kratos /usr/bin/kratos /usr/bin/kratos
RUN mkdir -p /app/kratos
COPY .docker/kratos /app/kratos
COPY .docker/kratos/env.sh /app/kratos/env.sh
# Declare the standard ports used by kratos (4433 for public service endpoint, 4434 for admin service endpoint)
EXPOSE 4433 4434
############################################################

# kratos-self-service ####################################################
RUN mkdir -p /app/ui/self-service/
COPY --from=kratos-selfservice-ui-node /usr/src/app/ /app/ui/self-service/
COPY .docker/self-service/env.sh /app/ui/self-service/env.sh
EXPOSE 4455
##########################################################################

# hydra-consent ##########################################################
RUN mkdir -p /app/ui/consent/
COPY --from=hydra-login-consent-node /usr/src/app/ /app/ui/consent/
COPY .docker/self-service/env-consent.sh /app/ui/consent/env.sh
EXPOSE 5050
#########################################################################


RUN apk add curl jq

COPY .docker/init.sh /usr/bin/init
RUN chmod +x /usr/bin/init

RUN mkdir -p /init
COPY .docker/tester.sh /init/tester.sh
RUN chmod +x /init/tester.sh

RUN mkdir -p /logs
WORKDIR /logs
