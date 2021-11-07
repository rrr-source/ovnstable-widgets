#!/bin/bash


token=$1
url=$2
tag=1

cd polybor || exit
npm run build

cd ..
find polybor/dist/js/ -type f -name '*.js' -exec sh -c 'x="{}"; mv "$x" "polybor/dist/js/polybor.js"' \;


cd rate || exit
npm run build

cd ..
find rate/dist/js/ -type f -name '*.js' -exec sh -c 'x="{}"; mv "$x" "rate/dist/js/rate.js"' \;

docker build . -t cr.yandex/crpg11k469bhc8lch9gm/overnight/widget:$tag


docker login \
         --username oauth \
         --password $token \
        cr.yandex

docker push  cr.yandex/crpg11k469bhc8lch9gm/overnight/widget:$tag

ssh $url docker login \
         --username oauth \
         --password $token \
        cr.yandex

ssh $url docker pull cr.yandex/crpg11k469bhc8lch9gm/overnight/widget:$tag
ssh $url docker-compose -f /root/docker/docker-compose.yaml up -d --no-deps ovn-widget


ssh $url docker logs ovn-widget -f


