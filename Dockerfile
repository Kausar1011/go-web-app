# Build stage
FROM golang:1.22.5 as base

# Set the working directory
WORKDIR /app

# Copy the Go module files
COPY go.mod . 
COPY go.sum . 

# Install dependencies
RUN go mod download

# Copy the rest of the application
COPY . . 

# Build the Go application
RUN go build -o main .

# Final stage: Distroless image
FROM gcr.io/distroless/base

# Copy the binary and static files from the build stage
COPY --from=base /app/main /app/main
COPY --from=base /app/static /app/static

# Expose the port the app will listen on
EXPOSE 8080

# Command to run the app
CMD ["/app/main"]

