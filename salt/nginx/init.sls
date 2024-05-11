nginx:
  pkg.installed

/etc/nginx/sites-available/testi.com:
  file.managed:
    - source: "salt://nginx/tmp/testi.com"
 
/etc/nginx/sites-enabled/default:
   file.absent

/etc/nginx/sites-enabled/testi.com:
  file.symlink:
    - target: "/etc/nginx/sites-enabled/testi.com"
    - require:
      - file: /etc/nginx/sites-available/testi.com
 
/home/vagrant/nginx:
   file.directory:
     - name: /home/vagrant/nginx/
     - group: webserver
     - dir_mode: 775

/home/vagrant/nginx/public_html:
   file.directory:
     - name: /home/vagrant/nginx/public_html/
     - group: webserver
     - dir_mode: 775

/home/vagrant/nginx/public_html/index.html:
   file.managed:
     - source: "salt://nginx/tmp/index.html"
     - group: webserver
     - mode: 664

nginx.service:
  service.running:
    - name: nginx
    - enable: True
    - restart: True
    - watch:
      - file: /etc/nginx/sites-available/testi.com
      - file: /etc/nginx/sites-enabled/testi.com
      - file: /home/vagrant/nginx/public_html/index.html
  
