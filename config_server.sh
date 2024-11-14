#!/bin/bash

echo -e "Eureka Server End Point"

# spring:boot

#Countdown execute yaptım
chmod +x countdown.sh

eureka_server_curl(){
  echo -e "Eureka"
   ./countdown.sh
  curl http://localhost:8761/
   ./countdown.sh
  curl http://localhost:8761/eureka/apps
   ./countdown.sh
  curl http://localhost:8761/eureka/apps/address-service
   ./countdown.sh
  curl http://localhost:8761/actuator/health
  ./countdown.sh


    echo -e "Config Server"
    curl http://localhost:8761/eureka/apps/address-service
    ./countdown.sh
    curl https://github.com/hamitmizrak/config-repo
    ./countdown.sh
    curl http://localhost:1111/api/address
    ./countdown.sh
    curl http://localhost:8888/actuator/health/
    ./countdown.sh
    curl http://localhost:8888/health/check
    ./countdown.sh
    curl http://localhost:8888/config-client/default/master
    ./countdown.sh
    curl http://localhost:8888/address-service/default
    ./countdown.sh

}

eureka_server_curl