base:
  '*':
    - ufw
    - user

  'webadmin':
    - usrApps

  'webserver':
    - serverApps
    - nginx  
