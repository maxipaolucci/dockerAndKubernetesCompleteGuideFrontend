#build phase
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

RUN npm run build


#run phase
FROM nginx

# elasticbeanstalk is going to read this port and create a mapping like the one we do when we run container with -p xxxx:xxxx
EXPOSE 80

# check https://hub.docker.com/_/nginx > Hosting some simple static content section
COPY --from=builder /app/build /usr/share/nginx/html

# we don't need a CMD to start nginx, we use the default one in the nginx image that starts the server
## And that's it. We have a production server runing nginx instead of a nodejs server with all the development code
## just the built code in the Build phase. This way of multi phase leaves us with a much smaller image, almost the 
## same as the nginx image size
