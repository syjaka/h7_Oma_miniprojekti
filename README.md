
# h7_Oma_miniprojekti

## Tarkoitus 

Projektini tavoitteena oli luoda yksityinen ympäristö käyttäen Salttia. Ympäristössä on keskeisenä toimintona web-palvelin, joka hostaa verkkosivuja. Lisäksi verkossa on webadmin-käyttäjä, joka on tavallisten käyttöoikeuksien lisäksi kuuluu webserver-ryhmään. Ryhmällä on oikeus hallinnoida webserverillä sijaitsevaa public_html hakemistoa ja sen sisältöä. 

Moduulin lisenssi: [GNU General Public License v3.0](https://github.com/syjaka/h7_Oma_miniprojekti/tree/main#)

---

## Kuvaus

Suoritettava moduuli sisältää seuraavat tilat:
1. **nginx** - asentaa ja konfiguroi Nginx:än vastaamaan verkkosivujen kutsuun. Lisäksi se luo webserverille public_html hakemiston sisältöineen johon webserver ryhmään kuuluvilla on hallinta ja muokkausoikeudet.
2. **serverApps** - ajaa webserverille hyödyllisiä ohjelmia.
3. **user** luo kolmen eri käyttäjätason käyttäjät sekä webserver käyttäjäryhmän. Admin voi hallinnoida koneita sudo-oikeuksin. Webadmin ja basic ovat tavallisia käyttäjiä, mutta webadmin liitetään webserver käyttäjäryhmään jolloin sillä on oikeus hallinnoida verkkosivuja.
4. **usrApps** asentaa webadmin koneeseen hyödylliset ohjelmat.
5. **topfile** joka ajaa ym tilat.

Jatkoa ajatellen seikkoja jotka jäivät projektin ulkopuolelle ajan loppuessa:
1. **ufw** tilan käyttöönotto koska se ei nyt onnistunut (salt hakemistossa myös ufv ja minion_restart tilat tähän liittyen)
2. shh yhteyksien konfigurointi siten että webadmin saa yhteyden suoraan koneeltaan webserveriin
3. rootin salasanakirjautumisen lukitseminen kaikilta koneilta.

---

## Vaatimukset

Projekti on toteutettu kokonaisuudessan vagrantilla luoduilla virtuaalikoneella. Näin ollen koneella tulee olla vagrant asennettuna.
Mikäli käytät oheista vagrantfileä virtuaalikoneiden luontiin, asentaa se muut tarvittavat lisäosat.

Mikäli testaat tätä muussa ympäristössä tulee käytössä olla kolme virtuaalikonetta. Salt-master ja 2 x salt minion ja nämä tulee myös ola asennettu ja konfiguroitu toimintaan. Lisäksi webadmin tarvitsee työpöydän, nettisivujen testaamiseen selaimella.

- Kone jolla moduuli on toteutettu on MacBook Retina 12-inch, koneella jossa, host OS on Ventura 13.6.1 käyttöjärjestelmä Suomen maa-asetuksilla ja suomen kielellä. Koneessa on 1,3GHz kaksiytiminen Intel Core i5 prosessori ja 8Gt 1867 MHz LPDDR3 muistia. Näytönohjain on Intel HD Graphics 615 jossa VRAM 1536 Mt.
- Koneeseen asennettu Vagrant versio on 2.4.1.

---

### Ohjeet:

- Mikäli käytät vagrantfileä koneiden luomiseen korjaa tarvittaessa gitin confic-komentoihin oma nimesi ja meilisi. Testatessa moduulien luomista työpöytä ei aina automaattisesti käynnistynyt. Lisäksi työpöydälle ei voi kirjautua nollaamatta salasanaa. Itse nollasin salasanan webadmin terminaalissa `sudo passwd vagrant`, jonka jälkeen kirjauduin guihin. Siellä potkase työpöytä käyntiin `startxfce4`.
    <details>
    <summary>Vagrantfile tästä</summary>
      
      # -*- mode: ruby -*-
      # vi: set ft=ruby :
      
      
      $tscript_master = <<TSCRIPT
      set -o verbose
      apt-get update
      apt-get -y install ufw curl micro bash-completion git ssh salt-master
      sudo systemctl restart salt-master
      echo "Master done"
      TSCRIPT
      
      $tscript_ufw = <<TSCRIPT
      ufw allow 22/tcp
      ufw allow 80/tcp
      ufw allow 4505/tcp
      ufw allow 4506/tcp
      echo "y" | ufw enable
      echo "Ufw config done and enabled"
      TSCRIPT
      
      $tscript_github = <<TSCRIPT
      set -o verbose
      git config --global user.email "kadriye.syrja@myy.haaga-helia.fi"
      git config --global user.name "saltmaster"
      echo "Git config done"
      TSCRIPT
      
      $tscript_webadmin = <<TSCRIPT
      set -o verbose
      apt-get update
      apt-get -y install salt-minion tasksel
      echo "master: 192.168.88.101" > /etc/salt/minion
      echo "id: webadmin" >> /etc/salt/minion
      echo "master_alive_interval: 30" >> /etc/salt/minion
      sudo systemctl restart salt-minion
      #install XFCE
      sudo tasksel install xfce-desktop
      echo "Webadmin done"
      TSCRIPT
      
      $tscript_webserver = <<TSCRIPT
      set -o verbose
      apt-get update
      apt-get -y install salt-minion
      echo "master: 192.168.88.101" > /etc/salt/minion
      echo "id: webserver" >> /etc/salt/minion
      echo "master_alive_interval: 30" >> /etc/salt/minion
      sudo systemctl restart salt-minion
      echo "Webserver done"
      TSCRIPT
      
      Vagrant.configure("2") do |config|
      	config.vm.synced_folder ".", "/vagrant", disabled: true
      	config.vm.synced_folder "shared/", "/home/vagrant/shared", create: true
      	config.vm.box = "debian/bullseye64"
      	
      	config.vm.define "saltmaster" do |saltmaster|
      		saltmaster.vm.hostname = "saltmaster"
      		saltmaster.vm.network "private_network", ip: "192.168.88.101"
      		saltmaster.vm.provision "shell", inline: $tscript_master
      		saltmaster.vm.provision "shell", inline: $tscript_ufw
      		saltmaster.vm.provision "shell", inline: $tscript_github
      	end
      	
      	config.vm.define "webadmin", primary: true do |webadmin|
      	     webadmin.vm.hostname = "webadmin"
      	     webadmin.vm.network "private_network", ip: "192.168.88.102"
      	     webadmin.vm.provision "shell", inline: $tscript_ufw
      	     webadmin.vm.provision "shell", inline: $tscript_webadmin
      	     webadmin.vm.provider "virtualbox" do |vb|
      		vb.gui = true
      		vb.memory = "2048"
      	     end	
      	end
      	
      	config.vm.define "webserver", primary: true do |webserver|
      	      webserver.vm.hostname = "webserver"
      	      webserver.vm.network "private_network", ip: "192.168.88.103"
      	      webserver.vm.provision "shell", inline: $tscript_ufw
      	      webserver.vm.provision "shell", inline: $tscript_webserver
      			 webserver.vm.provider "virtualbox" do |vb|
      		 vb.gui = false
      		 vb.memory = "1024"
      	      end
      	end
      
      end
    </details>  


1. Hyväksy avaimet `sudo salt-key -A`.
2. Kopioi tämän repon salt-hakemisto masterin /srv hakemistoon ja siirry kopioituun hakemistoon.
3. Suorita `sudo salt '*' state.apply`.
    - Lopputuloksena onnistunut suoritus:
      ![o7-001](https://github.com/syjaka/h7_Oma_miniprojekti/assets/123550796/1ff3b2de-fce3-4328-bc98-ab20e716f6e9)
      ![o7-002](https://github.com/syjaka/h7_Oma_miniprojekti/assets/123550796/345c521e-9db5-4ebb-a8b8-b13dd4eb4fcd)

7. Testaa verkkosivujen muokkausta webadminina `su webadmin`ja anna salasana `User One`.
![!h7-004](https://github.com/syjaka/h7_Oma_miniprojekti/assets/123550796/34d8e0e7-db57-47bf-95c4-fd288c405549)



### Lähteet:

Karvinen, T. 2024. Infra as Code - Palvelinten hallinta 2024. Luettavissa:https://terokarvinen.com/2024/configuration-management-2024-spring/. Luettu: 14.5.2024.

