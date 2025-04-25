# Use official nginx image
FROM nginx:alpine

# Copy static files to nginx html folder
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/

# Expose port 80
EXPOSE 80
