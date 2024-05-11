restart_minion_service:
  service.running:
    - name: salt-minion
    - enable: True
    - onchanges:
        - cmd: ufw
    - require:
        - cmd: ufw
