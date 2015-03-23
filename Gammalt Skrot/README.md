# lr222gw_Webbramwek

Körinstruktioner (Peer Review 2):
- Inga konstigheter.
- 1. ladda ner repot
- 2. kör bundle install 
- 3. kör rake db:migrate version=0
- 4. kör rake db:migrate
- 5. kör rake db:seed
- 6. kör rails s
- 7. Navigera till 127.0.0.1:3000  (Vid error vänligen navigera till 127.0.0.1:3000/logout)
- 8. Logga in med email: test@test.se   och lösen: 123
- 9. Markera och Kopiera en av API-nycklarna (behövs i postman) (OBS: INTE AccessToken)
- 10. Navigera till POSTMAN och ladda in filen Backup.postman_dump, Backup.postman_dump.txt eller POSTMAN_peerreview.json (JAG VET INTE VILKEN SOM FUNGERAR, kunde inte testa på min dator...)
- 11. När testerna kommit upp får du byta ut värdet i "apikey" till det du hämtade i steg 9. Upprepa för varje test du går igenom (Använd api-nyckeln på alla test)
- 12. Det var allt. (Api-nyckeln genereras på nytt varje gång man kör "db:migrate version=0", därför måste man byta ut api-nyckeln...)

#### Notering (EJ FÖR PEER REVIEW 2!!!!!!) 
För att komma åt adminbackend (där admin kan ta bort/redigera Apinycklar/projekt) 
Gå in på:
- 127.0.0.1:3000/adminlogin
- (Detta för att adminlogin inte brukar vara på samma sida som vanligt login... Tänkte på wordpress...)

###Om någon konstighet skulle inträffa, kan ni nå mig på:
- mail: lowe.raivio@gmail.com 
- skype: lowe.raivio
