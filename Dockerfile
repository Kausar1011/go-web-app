# Stage 1: Build the Go application
FROM golang:1.22.5 AS base

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the application with executable permissions
RUN go build -o main . && chmod +x main

# Final Stage: Distroless Image
FROM gcr.io/distroless/base

# Copy the compiled binary and static files from the build stage
COPY --from=base /app/main /app/main
COPY --from=base /app/static /app/static

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["/app/main"]
#kasar