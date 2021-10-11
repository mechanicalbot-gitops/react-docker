# https://scotch.io/tutorials/react-docker-with-security-in-10-minutes
# 
FROM node:14-alpine AS dependencies
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

FROM dependencies AS build
COPY . ./
RUN yarn build

# from https://github.com/dotnet/dotnet-docker/blob/83dc7edc9fc9e132dc86c6078c6dc1a7e6da8067/samples/complexapp/Dockerfile#L23
FROM dependencies AS test
COPY . ./
ENTRYPOINT ["yarn", "test"]

FROM nginx:1.21-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
