#Stage:1 Build Base Image using Golang version 1.21.10
FROM golang:1.21.10 AS buildstage
#Setup workdir inside container
WORKDIR /app
#Copy requirement file to workdir
COPY go.mod ./
#Download dependencies
RUN go mod download
#Copy all source files to workdir
COPY . .
#Build the application
RUN go build -o main .

#Stage:2 Deploy the build image onto distroless image to reduce image size and improve security
FROM gcr.io/distroless/base
#Copy binary from stage 1 to stage 2 
COPY --from=buildstage /app/main .
#Copy all static files from stage 1 to stage 2
COPY --from=buildstage /app/static ./static
#Expose app on port 8080 on which the application runs
EXPOSE 8080
#Start the application
CMD ["./main"]