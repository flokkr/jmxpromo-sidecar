FROM frolvlad/alpine-oraclejdk8
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && chmod +x /usr/local/bin/dumb-init
RUN apk add --update --no-cache bash
RUN mkdir -p /opt
WORKDIR /opt
RUN wget https://github.com/flokkr/jmxpromo/releases/download/0.11/jmx_prometheus_javaagent-0.11.jar -O /opt/jmxpromo.jar
ADD attacher.sh /opt/attacher.sh
ADD Test.java /opt/
RUN javac Test.java
RUN adduser -D jmxpromo
USER jmxpromo
ENTRYPOINT ["/usr/local/bin/dumb-init","--","/opt/attacher.sh"]
