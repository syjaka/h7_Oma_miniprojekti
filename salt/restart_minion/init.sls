restart_minion:
  cmd.run:
    - name: 'systemctl restart salt-minion'
    - onchanges:
      - cmd: 'ufw allow 22/tcp'
      - cmd: 'ufw allow 80/tcp'
      - cmd: 'ufw allow 4505/tcp'
      - cmd: 'ufw allow 4506/tcp'
