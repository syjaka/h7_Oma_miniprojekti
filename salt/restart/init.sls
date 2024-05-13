restart_webadmin_service:
  service.running:
    - name: webadmin
    - enable: True
    - onchanges:
        - cmd: enable_ufw
    - require:
        - cmd: ufw.service

restart_webserver_service:
  service.running:
    - name: webserver
    - enable: True
    - onchanges:
        - cmd: enable_ufw
    - require:
        - cmd: ufw.service
