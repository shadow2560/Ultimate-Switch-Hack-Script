# TeleNVDA #

* Forfattere: Asociación Comunidad Hispanohablante de NVDA og andre
  bidragydere. Oprindeligt udviklet af Tyler Spivey og Christopher Toth
* NVDA-kompatibilitet: 2019.3 og nyere
* Download [stabil version][1]

Bemærk: For at gøre download lettere for brugere, der har brug for hjælp
eller træning og har begrænsede computerfærdigheder, giver vi et alternativt
link til den seneste stabile version, som er nem at huske og dele. Du kan gå
til [nvda.es/tele](https://nvda.es/tele) og downloade tilføjelsen direkte
uden mellemliggende websider.

Velkommen til TeleNVDA-tilføjelsen, som giver dig mulighed for at oprette
forbindelse til en anden computer, der kører den gratis NVDA-skærmlæser. Med
denne tilføjelse kan du oprette forbindelse til en anden persons computer
eller tillade en betroet person at oprette forbindelse til dit system for at
udføre rutinemæssig vedligeholdelse, diagnosticere et problem eller give
undervisning. Denne tilføjelse er en modificeret version af [NVDA
Remote-tilføjelsen](https://nvdaremote.com) og vedligeholdes af det spanske
NVDA-fællesskab. Den er fuldt ud kompatibel med NVDA Fjernsupport (NVDA
Remote). Dette er de nuværende forskelle:

* En indstilling gør det muligt at blokere eksterne talekommandoer, der er
  forskellige fra tekst.
* Forbedret understøttelse af proxyservere og skjulte TOR-tjenester
  ([Proxy-supporttilføjelse](https://addons.nvda-project.org/addons/proxy.en.html)
  er påkrævet).
* Mulighed for at ændre f11-tasten til en anden kommando. Nu fungerer dette
  som et almindeligt script, så du kan tildele en anden tastaturkommando i
  dialogen "Håndter kommandoer"".
* Indstil værten til at ignorere og videresend den næste kommando direkte
  til gæsten. Dette er praktisk, når du vil sende tastaturkommandoen, der
  bruges til at skifte mellem kontrol af fjernmaskine og din lokale maskine,
  direkte til gæstemaskinen, som du kontrollerer.
* Mulighed for at udveksle små filer (op til 10 MB) mellem brugere forbundet
  til samme session.
* Mulighed for at videresende porte via UPNP.
* Mulighed for at bruge en brugerdefineret portcheck-tjeneste.
* Nogle GUI tweaks.
* Flere fejlrettelser.

## Før du begynder

Du skal have installeret NVDA på begge computere og hente
TeleNVDA-tilføjelsen.

Installationen af både NVDA og TeleNVDA-tilføjelsen er standard. Hvis du har
brug for mere information, kan dette findes i NVDAs brugervejledning.

## Opdatering af tilføjelsen

Når du opdaterer tilføjelsen og du har installeret TeleNVDA på det sikre
skrivebord, anbefales det, at du også opdaterer kopien på det sikre
skrivebord (sikre skærme).

For at gøre dette skal du først opdatere din eksisterende tilføjelse. Åbn
derefter NVDA-menuen, Opsætning, Generelle indstillinger, og tryk på knappen
"Brug aktuelt gemte indstillinger på logon og andre sikre skærme (kræver
administratorrettigheder)".

## Start af en fjernsession gennem en relæserver

### På computeren, der skal styres

1. Åbn NVDA-menuen, Værktøjer, Fjernsupport, Forbind. Du kan også trykke
   direkte på NVDA+alt+side op. Denne tastaturkommando kan ændres fra
   dialogen "Håndter kommandoer"
2. Vælg klient ved den første gruppe af radioknapper
3. Vælg "Giv adgang til at styre denne computer" i den anden gruppe af
   radioknapper.
4. I værtsfeltet skal du indtaste værten for den server, du vil oprette
   forbindelse til, for eksempel remote.nvda.es. Når den bestemte server
   bruger en alternativ port, kan du indtaste værten i formatet
   &lt;vært&gt;:&lt;port&gt;, for eksempel remote.nvda.es:1234. Hvis du
   opretter forbindelse til en IPV6-adresse, skal du indtaste den mellem
   firkantede parenteser, for eksempel [2603:1020:800:2::32].
5. Indtast en nøgle i nøglefeltet, eller tryk på knappen Generer
   nøgle. Nøglen er, hvad andre vil bruge til at styre din
   computer. Maskinen, der styres, og alle dens klienter skal bruge den
   samme nøgle.
6. Tryk på ok. Når du er færdig, vil du høre en tone og få besked om, at du
   er forbundet. Hvis der er en besked fra serveren, vil den blive vist i en
   dialogboks. Du vil se denne dialog, hver gang du opretter forbindelse
   eller kun første gang, afhængigt af serverkonfigurationen.

### På den maskine, der skal være den styrende computer

1. Åbn NVDA-menuen, Værktøjer, Fjernsupport, Forbind. Du kan også trykke
   direkte på NVDA+alt+side op. Denne tastaturkommando kan ændres fra
   dialogen "Håndter kommandoer"
2. Vælg klient ved den første gruppe af radioknapper
3. Vælg "Kontrollér en anden computer" i den anden gruppe af radioknapper.
4. I værtsfeltet skal du indtaste værten for den server, du vil oprette
   forbindelse til, for eksempel remote.nvda.es. Når den bestemte server
   bruger en alternativ port, kan du indtaste værten i formatet
   &lt;vært&gt;:&lt;port&gt;, for eksempel remote.nvda.es:1234. Hvis du
   opretter forbindelse til en IPV6-adresse, skal du indtaste den mellem
   firkantede parenteser, for eksempel [2603:1020:800:2::32].
5. Indtast en nøgle i nøglefeltet, eller tryk på knappen Generer
   nøgle. Maskinen, der styres, og alle dens klienter skal bruge den samme
   nøgle.
6. Tryk på ok. Når du er færdig, vil du høre en tone og få besked om, at du
   er forbundet. Hvis der er en besked fra serveren, vil den blive vist i en
   dialogboks. Du vil se denne dialog, hver gang du opretter forbindelse
   eller kun første gang, afhængigt af serverkonfigurationen.

### Advarsel om forbindelsessikkerhed

Hvis du opretter forbindelse til en server uden et gyldigt SSL-certifikat,
vil du modtage en advarsel om forbindelsessikkerhed.

Det kan betyde, at din forbindelse er usikker. Hvis du stoler på dette
serverfingeraftryk, kan du trykke på "Forbind" for at oprette forbindelse én
gang eller "Forbind og spørg ikke igen for denne server" for at oprette
forbindelse og gemme fingeraftrykket.

## Direkte forbindelser

Serverindstillingen i forbindelsesdialogen giver dig mulighed for at oprette
en direkte forbindelse.

Når du har valgt dette, skal du vælge hvilken tilstand din ende af
forbindelsen vil være i.

Den anden person vil oprette forbindelse til dig ved at bruge det modsatte.

Når tilstanden er valgt, kan du bruge knappen Hent ekstern IP til at få din
eksterne IP-adresse og sikre dig, at den port, der er indtastet i
portfeltet, videresendes korrekt. Hvis det er aktiveret på din router, kan
du videresende porten ved hjælp af UPNP, før du udfører portcheck.

Hvis portcheck registrerer, at din port (6837 som standard) ikke er
tilgængelig, vises en advarsel.

Videresend din port og prøv igen. Sørg også for, at NVDA-processen er
tilladt gennem Windows firewall.

Bemærk: Processen til at videresende porte, aktivere UPNP eller konfigurere
Windows firewall er uden for dette dokuments omfang. Se venligst
oplysningerne, der følger med din router for yderligere instruktioner.

Indtast en nøgle i nøglefeltet, eller tryk på generer. Den anden person skal
bruge din eksterne IP sammen med nøglen for at oprette forbindelse. Hvis du
indtastede en anden port end standarden (6837) i portfeltet, skal du sørge
for, at den anden person tilføjer den alternative port til værtsadressen i
formatet &lt;ekstern ip&gt;:&lt;port&gt;.

Hvis du vil videresende den valgte port ved hjælp af UPNP, skal du markere
"Brug UPNP til at videresende denne port, hvis det er muligt".

Når der er trykket på ok, bliver du forbundet. Når den anden person opretter
forbindelse, kan du bruge TeleNVDA normalt.

## Styring af fjernmaskinen

Når sessionen er tilsluttet, kan brugeren af den kontrollerende maskine
trykke på f11 for at begynde at styre den eksterne maskine (f.eks. ved at
sende tastaturtaster eller punktinput). Denne kommando kan ændres fra
dialogen "Håndter kommandoer".

Når NVDA siger "Kontrollerer fjerncomputer", vil tastatur- og
brailledisplaytasterne, du trykker på, gå til fjernmaskinen. Ydermere, når
den styrende maskine bruger et punktdisplay, vil information fra den
eksterne maskine blive vist på punktskrift. Tryk på f11 igen for at skifte
tilbage til den lokale maskine. Når du kontrollere den lokale maskine, vil
tastaturkommandoer og kommandoer udført fra dit punktdisplay ikke blive
videresendt til fjerncomputeren.

For den bedste kompatibilitet skal du sørge for, at tastaturlayoutet på
begge maskiner stemmer overens.

## Deling af din session

For at dele et link, så en anden nemt kan deltage i din TeleNVDA-session,
skal du vælge Kopier link fra "Fnernsupport" i NVDA-menuen. Du kan også
tildele en tastaturkommando til denne funktion fra dialogen "Håndter
kommandoer".

Du kan vælge mellem to linkformater. Den første er kompatibel med både NVDA
Fjernsupport og TeleNVDA, og er den mest anbefalede i øjeblikket. Den anden
er kun kompatibel med TeleNVDA.

Hvis du er tilsluttet som den kontrollerende computer, vil dette link give
en anden mulighed for at oprette forbindelse og blive kontrolleret.

Hvis du i stedet har sat din computer op til at blive styret, vil linket
tillade personer, som du deler dette med, at styre din maskine.

Mange applikationer tillader brugere at aktivere dette link automatisk, men
hvis det ikke virker fra en specifik app, kan det kopieres til
udklipsholderen og køres fra dialogen "Kør".

Bemærk, at det delte link muligvis ikke virker, hvis du kopierer det fra en
server, der kører i den direkte forbindelsestilstand (server).

## Send Ctrl+Alt+Del

Når du videresender taster, kan du normalt ikke benytte Alt+Ctrl+Delete.

Hvis du skal sende CTRL+Alt+del, og fjernsystemet er på en sikker skærm,
skal du bruge denne kommando.

## Send tasten til at skifte mellem lokal og fjerncomputer

Normalt når du trykker på den tildelte tastaturkommando for at skifte mellem
den lokale og fjerncomputeren, vil den ikke blive sendt til
fjerncomputeren. Den vil i stedet skifte mellem den lokale maskine og
fjerncomputeren.

Hvis du vil videresende denne tastaturkommando til fjerncomputeren, kan du
vælge at ignorere denne adfærd ved at benytte det tilsvarende script.

Som standard er dette script tildelt til Ctrl+F11. Du kan ændre kommandoen,
ved at åbne dialogen "Håndter kommandoer".

Når dette script aktiveres, bliver den næste tastaturkommando ignoreret og
videresendt direkte til fjerncomputeren. Dette inkluderer også
tastekombinationen, der aktiverede dette script. Efter den næste kommando er
videresendt, genoptages den normale funktion.

## Fjernstyring af en uovervåget computer

Det kan til tider være praktisk at fjernstyre en af dine computere. Dette er
særligt anvendeligt, hvis du er på rejse og ønsker at tilgå din stationære
computer derhjemme fra din laptop, eller hvis du ønsker at styre en computer
indendørs, mens du sidder udenfor med en anden pc. Med lidt forberedelse kan
dette gøres nemt og effektivt.

1. Gå ind i NVDA-menuen, og vælg Værktøjer>Fjernsupport>Indstillinger
2. Vælg "Forbind til kontrolserver ved opstart"
3. Beslut, om du vil benytte en ekstern relæserver, eller om du selv vil
   fungere som vært for forbindelsen. Hvis du vælger at fungere som værten,
   kan du forsøge at viderestille porte via UPNP ved at markere den
   tilsvarende checkbox.
4. Vælg "Giv adgang til at styre denne computer" i den anden gruppe af
   radioknapper.
5. Hvis du selv er vært for forbindelsen, skal du sikre dig, at den port,
   der er indtastet i portfeltet (6837 som standard) på den kontrollerede
   maskine, kan tilgås fra de kontrollerende maskiner.
6. Hvis du ønsker at bruge en relæserver, skal du udfylde både værts- og
   nøglefelterne, tab til OK og trykke på Enter. Indstillingen "Generer
   nøgle" er ikke tilgængelig i denne situation. Det er bedst at vælge en
   nøgle, du kan huske, så du nemt kan bruge den fra ethvert sted.

Til avanceret brug kan du også konfigurere NVDA Fjernsupport til automatisk
at oprette forbindelse til en lokal eller ekstern relæserver i
kontroltilstand. Hvis du ønsker dette, skal du vælge "Kontrollér en anden
computer" i det andet sæt radioknapper.

Bemærk: Indstillingerne for automatisk forbindelse ved opstart træder først
i kraft, når NVDA er genstartet.

## Deaktivering af tale på fjerncomputeren

Hvis du ikke ønsker at høre fjerncomputerens tale eller NVDA-specifikke
lyde, skal du gå ind i NVDA-menuen>Værktøjer>Fjernsupport og vælge "Gør
fjerncomputeren lydløs". Bemærk venligst, at denne mulighed ikke vil
deaktivere ekstern punktoutput til det kontrollerende display, når den
kontrollerende maskine sender taster.

## Afslutning af en fjernsession

Gør følgende for at afslutte en fjernsession:

1. På den kontrollerende computer skal du trykke på F11 for at stoppe med at
   styre den eksterne maskine. Du bør få følgende besked: "Kontrollerer
   lokal maskine." Hvis du i stedet får besked om, at du styrer den eksterne
   maskine, skal du trykke på F11 igen.
2. Gå ind i NVDA-menuen>Værktøjer>Fjernsupport, og vælg "Afbryd".

Du kan også trykke NVDA+alt+side ned for at afbryde forbindelsen. Denne
kommando kan ændres fra dialogen "Håndter kommandoer". For at sikre, at den
anden ende af forbindelsen forbliver sikker, kan du udføre denne
tastaturkommando, når du sender taster til fjerncomputeren. Dette vil
afbryde fjerncomputerens forbindelse.

## Send udklipsholder

Denne indstilling fra menuen "Fjernsupport" lader dig sende indholdet fra
din udklipsholder.

Når dette menupunkt aktiveres, vil indholdet fra din udklipsholder sendes
til de andre maskiner.

## Sådan sendes filer

Indstillingen Send fil i fjernmenuen giver dig mulighed for at sende små
filer til alle sessionsmedlemmer, inklusive den kontrollerede
maskine. Bemærk venligst, at du kun kan sende filer mindre end 10 MB. Det er
ikke tilladt at sende eller modtage filer på sikre skærme.

Bemærk også, at afsendelse af filer kan forbruge for meget netværkstrafik på
serveren, afhængigt af filstørrelsen, de computere, der er tilsluttet den
samme session, og mængden af sendte filer. Kontakt din serveradministrator
og spørg dem, om trafikken faktureres. Overvej i så fald at bruge en anden
platform til at udveksle filer.

Når filen er modtaget på fjernmaskinerne, vil en "Gem som" dialog vises, så
du kan vælge, hvor du vil gemme filen.

## Konfigurer TeleNVDA til at fungere på en sikker skærm

For at TeleNVDA kan fungere på det sikre skrivebord, skal tilføjelsen være
installeret i den NVDA, der kører på den sikre skærm.

1. Fra NVDA-menuen, skal du vælge "Opsætning" og herefter "Indstillinger" og
   "Generelt".
2. Tab til knappen Brug aktuelt gemte indstillinger på logon- og andre sikre
   skærme (kræver administratorrettigheder), og tryk på Enter.
3. Svar Ja til meddelelserne om kopiering af dine indstillinger og om
   kopiering af tilføjelser, og evt. til dialogen om kontrol af brugerkonti.
4. Når indstillingerne er kopieret, skal du trykke på Enter for at afvise
   dialogen. Tab til OK og tryk Enter for at afslutte dialogen.

Når TeleNVDA er installeret til brug på sikre skærme, vil du herefter have
adgang til fjernmaskinen med både punkt og tale, hvis maskinen bliver
kontrolleret i et sikkert miljø.

## Rydning af SSL-certifikatets fingeraftryk

Hvis du ikke længere har tillid til de serverfingeraftryk, du har godkendt,
kan du rydde alle de godkendte fingeraftryk ved at trykke på knappen "Slet
alle godkendte fingeraftryk" i dialogboksen "Indstillinger".

## Brug af en brugerdefineret portcheck-tjeneste

Som standard kontrollerer TeleNVDA åbne porte ved hjælp af en tjeneste
leveret af det spanske NVDA-fællesskab. Du kan ændre tjenestens URL fra
indstillingsdialogen. Sørg for, at porten, der skal kontrolleres, er en del
af den tilpassede URL, og at resultaterne returneres i det forventede
format. Et eksempel på et portcheck-script distribueres i
TeleNVDA-repository, så du kan benytte din egen tjeneste.

## Ændring af TeleNVDA

Dette projekt er omfattet af GNU General Public License, version 2 eller
nyere. Du kan klone [denne repo][2] for at foretage ændringer i TeleNVDA,
forudsat at du læser, forstår og respekterer
licensbetingelserne. MiniUPNP-modulet er licenseret under en
BSD-3-klausullicens.

### Dependencies fra tredjeparter

Disse kan installeres med pip:

* Markdown
* scons

For at bygge den eksekverbare URL-handler skal du bruge Visual Studio 2019
eller nyere.

### Sådan pakker du tilføjelsen til distribution:

1. Åbn en kommandolinje, skift til roden af [denne repo][2]
2. Kør kommandoen **scons**. Den oprettede tilføjelse, hvis der ikke var
   nogen fejl, placeres i den aktuelle mappe.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
