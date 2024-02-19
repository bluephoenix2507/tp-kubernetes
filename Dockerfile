# Étape de construction: Utilisez l'image officielle Go comme image de base pour la compilation
FROM golang:alpine as builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers du module Go dans le conteneur
COPY go.mod ./

# Télécharger les dépendances du module Go
RUN go mod download

# Copier le reste des fichiers sources dans le conteneur
COPY . .

# Compiler l'application statiquement pour l'exécuter dans un conteneur alpine minimal
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o motd-api .

# Étape finale: Utilisez une image Docker alpine pour un conteneur minimal
FROM alpine:latest  

# Ajouter le certificat CA pour les appels HTTPS
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copier l'exécutable depuis l'étape de construction
COPY --from=builder /app/motd-api .

# Exposer le port sur lequel le service s'exécute
EXPOSE 8080

# Commande pour exécuter l'application
CMD ["./motd-api"]
