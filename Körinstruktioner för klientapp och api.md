###Körinstruktioner för API och Klientapp!

#Starta Apiet. 

1. Börja med att öppna upp filerna i PositionProjekt mappen i din Ruby miljö.

2. I Ruby consolen ska du se till att vara inne i PositionProject mappen, Kör Följande kommand:

- bundle install

- rake db:migrate version=0

- rake db:migrate

- rake db:seed

- rails s

- navigera till 127.0.0.1:3000, logga in med denna användare:

email: test@test.se

password : 123

- Från sidan, gör en ny app med "Regga app", ge den ett namn och spara

- Ta nyckeln från din applikation som du skapat, den ska du använda när du sätter upp klientapplikationen.

- Låt den lokala ruby servern vara på i bakgrunden och börja på nästa steg.

#Starta klientappen

1. Börja med att öppna upp filerna i klientsideProjekt mappen i din angular miljö. (själv har jag kört WebStorm 9).

2. Öppna upp konsolen i webstorm (eller vilket IDE du nu kör) och skriv in följande kommandon:

npm install

3. Nu ska vi ta din api nyckel som du fick tag på i förra delen (steg 5) och klistra in den i koden. 

Navigera till KlientsideProjekt&gt;app&gt;app.js 

I app.js filen så ska du gå längst ner, där hittar du konstanter. 

Manipulera denna kod:              

`app.constant("API", {             

    'apikey' : "apikey=XXXX",              

    'baseUrl' : "http://127.0.0.1:3000/api/v1/"              

});`              

Där det står XXXX ska du klistra in nyckeln som du hämtade. 

4. Nu är allt förberett och du kan starta angular appen, det gör du med detta kommando:

npm start

5. navigera till http://127.0.0.1:8000/app/

6. Sådär nu är allt klart för att prova appen, den är lite "rough" men det går :) 

För att logga in använd uppgifterna:

email: test@test.se

lösen: 123
