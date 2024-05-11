create_groups:
  group.present:
    - names:
      - users
      - sudo
      - webserver

create_users:
  user.present:
    - name: A001
    - fullname: Admin
    - uid: 1001
    - groups:
      - users
      - sudo
      - webserver
    - home: /home/A001
    - password: $1$bTZqB.KC$M1Silm8xtymp4nhSyRa0x0   # Admin

    - name: U001
    - fullname: User One
    - uid: 2001
    - groups:
      - users
      - webserver
    - home: /home/U001
    - password: $1$m61LQpa5$KICoJcAk7O.XWzu3/YcYB1    # User One

    - name: U002
    - fullname: User Two
    - uid: 2002
    - groups:
      - users
    - home: /home/U002
    - password: $1$z6y5IghC$sgtr0efVyO1aF9MP443On/    # User Two
