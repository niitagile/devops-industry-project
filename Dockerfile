
# Start from a lightweight Nginx web server image
FROM nginx:alpine

# Copy our website into Nginx's web directory
COPY app/ /usr/share/nginx/html/

# Document the port Nginx listens on
EXPOSE 80
