restart_minion_service:
  service.running:
    - name: salt-minion
    - enable: True
    - onchanges:
        - cmd: enable_ufw
    - require:
        - cmd: ufw.service
