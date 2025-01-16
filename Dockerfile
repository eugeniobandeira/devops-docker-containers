# Etapa de build
FROM node:20 AS build

WORKDIR /usr/src/app

# Copiar apenas os arquivos necessários para a instalação das dependências
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar o restante do código
COPY . .

# Construir o projeto
RUN npm run build

# Remover dependências de desenvolvimento e preparar a produção
RUN npm prune --production

# Etapa de produção
FROM node:20-alpine AS production

WORKDIR /usr/src/app

# Copiar arquivos necessários da etapa de build
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./
COPY --from=build /usr/src/app/dist ./dist

EXPOSE 3000

# Iniciar a aplicação
CMD ["npm", "run", "start:prod"]
