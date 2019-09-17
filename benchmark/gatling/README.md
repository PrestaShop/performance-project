docker build -t prestashop/performance-gatling -f gatling/Dockerfile gatling

docker run -it --rm \
    -v $dir/results:/opt/gatling/results \
    -e JAVA_OPTS="-DusersCount=10
                  -DcustomersCount=2
                  -DadminsCount=2
                  -DrampDurationInSeconds=60
                  -DhttpBaseUrlFO=http://sandbox.prestashop.com/
                  -DhttpBaseUrlBO=http://sandbox.prestashop.com/admin1234
                  -DadminUser=thomas.leviandier@prestashop.com
                  -DadminPassword=prestashop" \
    --add-host=sandbox.prestashop.com:192.168.0.4 \
    prestashop/performance-gatling \
    -s LoadSimulation
