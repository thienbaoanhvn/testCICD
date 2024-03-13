# Sử dụng base image golang 1.22
FROM golang:1.22.0 AS builder

# Thiết lập workspace
WORKDIR /app

# Sao chép mã nguồn vào container
COPY . .

# Tải về các dependency (nếu có)
RUN go mod download

# Build ứng dụng
RUN CGO_ENABLED=0 GOOS=linux go build -o /main

# Sử dụng base image nhẹ để chạy ứng dụng
FROM alpine:latest  
RUN apk --no-cache add ca-certificates

WORKDIR /

# Sao chép executable từ builder stage
COPY --from=builder /main .

# Sao chép .env vào trong image, nếu bạn sử dụng
COPY .env .

# Expose port 8081
EXPOSE 8081

# Chạy ứng dụng
CMD ["./main"]
