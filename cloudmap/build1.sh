TOKEN=`curl -s  \169.\254.\169.\254/latest/meta-data/local-ipv4`

sed "s/dynamic-ip/$TOKEN/g" template.json >>map.json

aws servicediscovery register-instance --cli-input-json file://map.json

