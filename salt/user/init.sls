create_groups:
  group.present:
    - names:
      - webserver

admin:
  user.present:
    - name: admin
    - fullname: Admin
    - shell: /bin/bash
    - uid: 1001
    - groups:
      - users
      - sudo
      - webserver
    - home: /home/admin
    - password: $1$bTZqB.KC$M1Silm8xtymp4nhSyRa0x0   # Admin

webadmin:
  user.present:
    - name: webadmin
    - fullname: User One
    - shell: /bin/bash
    - uid: 2001
    - groups:
      - users
      - webserver
    - home: /home/webadmin
    - password: $1$m61LQpa5$KICoJcAk7O.XWzu3/YcYB1    # User One

basic:
  user.present:
    - name: basic
    - fullname: User Two
    - shell: /bin/bash
    - uid: 3001
    - groups:
      - users
    - home: /home/basic
    - password: $1$z6y5IghC$sgtr0efVyO1aF9MP443On/    # User Two
