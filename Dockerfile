FROM node:20 AS build

WORKDIR /usr/src/app

COPY  package*.json yarn.lock ./
COPY .yarn ./.yarn

RUN yarn

COPY . .

RUN yarn run build

# Second stage

FROM node:current-alpine

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "run", "start"]