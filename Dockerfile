FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY about.html /usr/share/nginx/html/about.html
COPY blog.html /usr/share/nginx/html/blog.html
COPY contact.html /usr/share/nginx/html/contact.html
