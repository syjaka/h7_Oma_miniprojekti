# Kesken
# h7_Oma_miniprojekti
h7_Oma_miniprojekti

## Tarkoitus
Projektini tavoitteena oli rakentaa yksityinen verkko käyttäen SaltStack-konfiguraatiohallintatyökalua. Verkossa on keskeisenä toimintona web-palvelin, joka hostaa verkkosivuja. Lisäksi verkossa on webadmin-käyttäjä, jolla on tavalliset käyttöoikeudet ja joka hallinnoi näitä verkkosivustoja. 

Verkkosivut luodaan ja hostataan nginx:llä ja webserverille luodaan public_html hakemisto josta sivut vastaavat. Tänne sijoitetaan alustava sivusto index.html tiedostoon ja se vastaa sekä `curl localhost` sekä `curl testi.com` kutsuun. Selaimella samat localhost sekä testi.com vastaavat.

Projektiin kuuluu kolmen eri käyttäjätason luominen: admin-käyttäjä, joka suorittaa ylläpitotehtäviä ilman root-oikeuksia, webadmin jolla on muokkausoikeudet webserverin verkkosivujen sisältöön sekä tavallinen käyttäjä, jonka avulla voidaan testata järjestelmän toimintaa käyttäjän näkökulmasta. 

---

## Vaatimukset

Projekti on toteutettunkokonaisuudessan vagrantilla luoduilla virtuaalikoneella. Näin ollen koneeella tulee olla vagrant asennettuna.
Mikäli käytät oheista vagrantfileä virtuaalikoneiden luontiin, asentaa se muut tarvittavat lisäosat.

Mikäli testaat tätä muutta ympäristössä tulee käytössä olla kolme virtuaalikonetta. Salt-master ja 2 x salt minion eli nämä tulrr myös ola asennettu ja konfiguroitu. Lisäksi webadmin tarvitsee työpöydän, nettisivujen testaamiseen selaimella.

- Kone jolla moduuli on toteutettu on MacBook Retina 12-inch, koneella jossa, host OS on Ventura 13.6.1 käyttöjärjestelmä Suomen maa-asetuksilla ja suomen kielellä. Koneessa on 1,3GHz kaksiytiminen Intel Core i5 prosessori ja 8Gt 1867 MHz LPDDR3 muistia. Näytönohjain on Intel HD Graphics 615 jossa VRAM 1536 Mt.
- Koneeseen asennettu Vagrant versio on 2.4.1.

---

### Ohjeet:

- Mikäli käytät vagrantfileä koneiden luomiseen korjaa gitin confic-komentoihin oma nimesi ja meilisi.
- Kopioi tämä repo kokonaisuudessaan `git clone https://github.com/syjaka/h7_Oma_miniprojekti.git`.

1. Testaa ensin että minionit kuuntelevat masteria `sudo salt-key`
2. Hyväksi avaimet `sudo salt-key -A`
3. Kopioi tämän repon salt-hakemisto masterin /srv hakemistoon ja siirry kopioituun hakemistoon.
4. Suorita `sudo salt '*' state.apply`.
5. Testaa verkkosivujen muokkausta webadminina `su webadmin`ja anna salasana `User One`.

Webserverin hakemistorakenne verkkosivuille.
:vag

# Lähteet:
https://serverfault.com/questions/424452/nginx-enable-site-command 
https://gist.github.com/xameeramir/a5cb675fb6a6a64098365e89a239541d
curl localhost error https://stackoverflow.com/questions/22952676/curl-failed-to-connect-to-localhost-port-80
