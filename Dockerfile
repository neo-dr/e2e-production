FROM golang:1.16-buster as builder


# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN make e2e

# # Command to run the executable
# #CMD ["./e2e"]

# ######## Start a new stage from scratch #######
FROM ubuntu:latest  

RUN apt-get update; apt-get -y install wget curl jq

RUN wget $(curl -s https://api.github.com/repos/ovrclk/akash/releases/latest | jq -r ".assets[] | select(.name | test(\"linux_amd64.deb\")) | .browser_download_url") -O akash.deb; \
    dpkg -i akash.deb

WORKDIR /app

# # Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/e2e .

# RUN mv e2e /usr/local/bin/

# COPY entrypoint.sh .

# CMD ["sh"]
# # Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["./entrypoint.sh"]