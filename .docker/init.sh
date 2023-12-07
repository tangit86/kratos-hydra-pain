#!/bin/sh

echo "KRATOS_VERSION $KRATOS_VERSION"
echo "HYDRA_VERSION $HYDRA_VERSION"

#hydra migration
cd /app/hydra || exit
(. env.sh ; /usr/bin/hydra migrate sql -e --yes ; /usr/bin/hydra serve all --dev >> /logs/hydra.log 2>&1 &)
#hydra run

###############kratos################################################################
cd /app/kratos || exit
#####################################################################################
(. env.sh; /usr/bin/kratos -c /app/kratos/kratos.yml migrate sql -e --yes ; /usr/bin/kratos serve -c /app/kratos/kratos.yml --dev >> /logs/kratos.log 2>&1 &)

###self-service#####################################################################
cd /app/ui/self-service || exit
(. env.sh; node ./lib/index.js >> /logs/self-service.log 2>&1 &)
#####################################################################################

###consent###########################################################################
cd /app/ui/consent || exit
(. env.sh; node ./lib/app.js >> /logs/consent.log 2>&1 &)
#####################################################################################

touch /logs/client.log
(sleep 5 && /init/./tester.sh > /logs/client.log) &

cd /logs || exit
tail -f ./*