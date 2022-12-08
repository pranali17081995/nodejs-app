#Base Image node:12.18.4-alpine
FROM node:12.18.4-alpine


#Set working directory to /app
WORKDIR /app


#Set PATH /app/node_modules/.bin
ENV PATH /app/node_modules/.bin:$PATH


#Copy package.json in the image
COPY package.json ./


#Run npm install command
RUN apk add --no-cache ffmpeg opus pixman cairo pango giflib ca-certificates \
    && apk add --no-cache --virtual .build-deps python g++ make gcc .build-deps curl git pixman-dev cairo-dev pangomm-dev libjpeg-turbo-dev giflib-dev \
    && npm install \
    && apk del .build-deps



#Copy the app
COPY . ./

EXPOSE 3000

#Start the app
CMD ["node", "./src/server.js"]
