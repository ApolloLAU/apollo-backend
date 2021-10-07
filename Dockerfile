FROM node:14

RUN mkdir parse

ADD . /parse
WORKDIR /parse
RUN npm install -ddd --verbose

ENV APP_ID frsAppID
ENV MASTER_KEY frsMasterKey

# Optional (default : 'parse/cloud/main.js')
# ENV CLOUD_CODE_MAIN cloudCodePath

# Optional (default : '/parse')
# ENV PARSE_MOUNT mountPath

EXPOSE 1337

# Uncomment if you want to access cloud code outside of your container
# A main.js file must be present, if not Parse will not start

# VOLUME /parse/cloud               

CMD [ "npm", "start" ]
