ufw:
  pkg.installed

ufw.service:
  service.running:
    - cmd.run: 'ufw enable'
    - unless: 'ufw enable | grep active'

'ufw enable':
  cmd.run:
    - unless: "ufw status verbose |grep 'Status: active'"

'ufw allow 22/tcp':
  cmd.run:
    - unless: "ufw status verbose |grep '^22/tcp' "

'ufw allow 80/tcp':
  cmd.run:
    - unless: "ufw status verbose |grep '^80/tcp' "
    
'ufw allow 4505/tcp':
  cmd.run:
    - unless: "ufw status verbose |grep '^4505/tcp' "

'ufw allow 4506/tcp':
  cmd.run:
    - unless: "ufw status verbose |grep '^4506/tcp' "

ufw.service:
  service.running
