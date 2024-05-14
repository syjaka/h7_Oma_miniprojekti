ufw:
  pkg.installed

ufw.service:
  service.running:
    - require:
      - pkg: ufw
    - cmd.run:
      - name: 'ufw enable'
      - unless: 'ufw status | grep active'

'ufw allow 22/tcp':
  cmd.run:
    - unless: "ufw status verbose | grep '^22/tcp'"

'ufw allow 80/tcp':
  cmd.run:
    - unless: "ufw status verbose | grep '^80/tcp'"

'ufw allow 4505/tcp':
  cmd.run:
    - unless: "ufw status verbose | grep '^4505/tcp'"

'ufw allow 4506/tcp':
  cmd.run:
    - unless: "ufw status verbose | grep '^4506/tcp'"

restart_minion:
  cmd.run:
    - name: 'systemctl restart salt-minion'
    - onchanges:
      - cmd: 'ufw allow 22/tcp'
      - cmd: 'ufw allow 80/tcp'
      - cmd: 'ufw allow 4505/tcp'
      - cmd: 'ufw allow 4506/tcp'
