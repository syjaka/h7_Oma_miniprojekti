base:
  '*':
    - ufw
    - restart
    - user

  'webadmin':
    - usrApps

  'webserver':
    - nginx  
