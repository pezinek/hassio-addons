ARG BUILD_FROM
FROM $BUILD_FROM

WORKDIR /usr/src/node-red

USER root

RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/* && apt-get clean
RUN cd /data && npm install node-red-contrib-home-assistant

# Expose tcp/1880
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json

COPY settings.js /
COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
