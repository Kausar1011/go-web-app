

# Use Golang base image for building
FROM golang:1.22.5 AS base

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum, then download dependencies
COPY go.mod . 
RUN go mod download

# Copy source files and build the app
COPY . .
RUN go build -o main .

# Final stage - Distroless image
FROM gcr.io/distroless/base

# Copy the built app binary and static files from the build stage
COPY --from=base /app/main /
COPY --from=base /app/static /static

EXPOSE 8080

# Set entrypoint to the compiled binary
ENTRYPOINT ["/main"]