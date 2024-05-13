server {
    listen 80;  
    server_name localhost testi.com;

    root /home/vagrant/nginx/public_html;  
    index index.html;  

    location / {
        try_files $uri $uri/ =404;  
    }
}
