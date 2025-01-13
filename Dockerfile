#Stage1 - Build Artifact on base image
FROM golang:1.21.10 AS buildstage
WORKDIR /app
COPY go.mod .
RUN go mod download
COPY . .
RUN go build -o main .

#Stage2 - Run application on distroless image
FROM gcr.io/distroless/base
COPY --from=buildstage /app/main .
COPY --from=buildstage /app/static ./static
EXPOSE 8080
CMD [ "./main" ]
