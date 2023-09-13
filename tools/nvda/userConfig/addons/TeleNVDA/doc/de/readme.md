# TeleNVDA #

* Autoren: Asociación Comunidad Hispanohablante de NVDA und andere
  Mitwirkende. ursprünglich von Tyler Spivey und Christopher Toth
* NVDA-Kompatibilität: 2019.3 und neuer
* [Stabile Version herunterladen][1]

Hinweis: Um das Herunterladen für Benutzer zu erleichtern, die Unterstützung
oder Schulung benötigen und nur über begrenzte Computerkenntnisse verfügen,
bieten wir einen alternativen Link zur neuesten stabilen Version an, der
leicht zu merken ist und weitergegeben werden kann. Sie können zu
[nvda.es/tele](https://nvda.es/tele) gehen und die NVDA-Erweiterung direkt
herunterladen, ohne zwischengeschaltete Webseiten.

Willkommen bei TeleNVDA, mit dem Sie eine Verbindung zu einem anderen
Computer herstellen können, auf dem der kostenfreie Screenreader NVDA
läuft. Mit diesem Add-on können Sie sich mit dem Computer einer anderen
Person verbinden oder einer vertrauenswürdigen Person erlauben, sich mit
Ihrem System zu verbinden, um eine Routine-Wartung durchzuführen, ein
Problem zu diagnostizieren oder eine Schulung durchzuführen. Diese
NVDA-Erweiterung ist eine modifizierte Version der [NVDA-Remote]-Erweiterung
(https://nvdaremote.com) und wird von der spanischen NVDA-Community
gepflegt. Es ist vollständig kompatibel mit NVDA Remote. Dies sind die
aktuellen Unterschiede:

* Eine Option ermöglicht die Blockierung von Sprachbefehlen, die sich von
  Text unterscheiden.
* Verbesserte Unterstützung für Proxy-Server und versteckte TOR-Dienste
  (NVDA-Erweiterung
  [Proxy-Unterstützung](https://addons.nvda-project.org/addons/proxy.en.html)
  ist erforderlich).
* Möglichkeit, die Taste F11 auf einen anderen Taste zu ändern. Dies
  funktioniert nun als allgemeines Skript, so dass Sie die Tastenbefehle im
  Dialogfeld "Tastenbefehle" zuweisen können.
* Möglichkeit, den nächsten unmittelbaren Tastenbefehl vollständig zu
  ignorieren. Dies ist nützlich, wenn Sie den Tastenbefehl, mit der Sie
  zwischen Host- und Remote-Computer umschalten, an den Remote-Computer
  senden müssen.
* Möglichkeit, kleine Dateien (bis zu 10 MB) zwischen Benutzern
  auszutauschen, die mit der gleichen Sitzung verbunden sind.
* Möglichkeit zur Weiterleitung von Ports über UPnP.
* Möglichkeit der Verwendung eines benutzerdefinierten Port-Check-Dienstes.
* Einige Änderungen an der grafischen Benutzeroberfläche.
* Mehrere Fehlerkorrekturen.

## Vorbereitungen

Sie müssen NVDA auf beiden Computern installiert haben und die
NVDA-Erweiterung TeleNVDA erhalten.

Die Installation von NVDA und TeleNVDA verläuft wie gewohnt. Wenn Sie
weitere Informationen benötigen, finden Sie diese im NVDA-Benutzerhandbuch.

## Aktualisieren

Wenn Sie TeleNVDA auf dem sicheren Desktop installiert haben, wird
empfohlen, bei der Aktualisierung der NVDA-Erweiterung auch die Kopie auf
dem sicheren Desktop zu aktualisieren.

Aktualisieren Sie dazu zunächst Ihre bestehende NVDA-Erweiterung. Öffnen Sie
dann das NVDA-Menü, Einstellungen, Allgemeine Einstellungen und klicken Sie
auf die Schaltfläche "Aktuell gespeicherte Einstellungen auf dem
Anmeldebildschirm und anderen Sicherheitsbildschirmen verwenden (erfordert
Administratorrechte)".

## Starten einer Remote-Sitzung über einen Relay-Server

### Auf dem zu steuernden Computer

1. Öffnen Sie das NVDA-Menü, Werkzeuge, Fernbedienung, Verbinden. Oder
   drücken Sie direkt NVDA+Alt+Seite nach oben. Diesen Tastenbefehl kann
   über das Dialogfeld für die Tastenbefehle in NVDA geändert werden.
2. Wählen Sie in der ersten Optionsschaltfläche "Client" aus.
3. Wählen Sie in der zweiten Gruppe von Optionsfeldern die Option "Erlauben"
   aus, dass dieser Computer gesteuert wird.
4. Geben Sie in das Feld Host den Host des Servers ein, zu dem Sie eine
   Verbindung herstellen wollen, z. B. remote.nvda.es. Wenn der betreffende
   Server einen anderen Port verwendet, können Sie den Host in der Form
   &lt;host&gt;:&lt;port&gt; eingeben, zum Beispiel
   remote.nvda.es:1234. Wenn Sie eine Verbindung zu einer IPV6-Adresse
   herstellen, geben Sie diese zwischen eckigen Klammern ein, zum Beispiel
   [2603:1020:800:2::32].
5. Geben Sie einen Schlüssel in das Schlüsselfeld ein oder klicken Sie auf
   die Schaltfläche "Schlüssel generieren". Der Schlüssel wird von anderen
   zur Steuerung Ihres Computers verwendet. Der zu steuernde Computer und
   alle dessen Clients müssen denselben Schlüssel verwenden.
6. Drücken Sie auf "OK". Sobald Sie dies getan haben, hören Sie einen Ton
   und die Verbindung ist hergestellt. Wenn der Server eine Nachricht des
   Tages enthält, wird diese in einem Dialogfeld angezeigt. Dieses
   Dialogfeld wird bei jeder Verbindung oder nur beim ersten Mal angezeigt,
   je nach Server-Konfiguration.

### Auf dem Computer, der als zu steuernder Computer dienen soll

1. Öffnen Sie das NVDA-Menü, Werkzeuge, Fernbedienung, Verbinden. Oder
   drücken Sie direkt NVDA+Alt+Seite nach oben. Diesen Tastenbefehl kann
   über das Dialogfeld für die Tastenbefehle in NVDA geändert werden.
2. Wählen Sie in der ersten Optionsschaltfläche "Client" aus.
3. Wählen Sie in der zweiten Gruppe von Optionsfeldern die Option "Steuerung
   eines anderen Computers" aus.
4. Geben Sie in das Feld Host den Host des Servers ein, zu dem Sie eine
   Verbindung herstellen wollen, z. B. remote.nvda.es. Wenn der betreffende
   Server einen anderen Port verwendet, können Sie den Host in der Form
   &lt;host&gt;:&lt;port&gt; eingeben, zum Beispiel
   remote.nvda.es:1234. Wenn Sie eine Verbindung zu einer IPV6-Adresse
   herstellen, geben Sie diese zwischen eckigen Klammern ein, zum Beispiel
   [2603:1020:800:2::32].
5. Geben Sie einen Schlüssel in das Schlüsselfeld ein oder klicken Sie auf
   die Schaltfläche "Schlüssel generieren". Der zu steuernde Computer und
   alle dessen Clients müssen denselben Schlüssel verwenden.
6. Drücken Sie auf "OK". Sobald Sie dies getan haben, hören Sie einen Ton
   und die Verbindung ist hergestellt. Wenn der Server eine Nachricht des
   Tages enthält, wird diese in einem Dialogfeld angezeigt. Dieses
   Dialogfeld wird bei jeder Verbindung oder nur beim ersten Mal angezeigt,
   je nach Server-Konfiguration.

### Warnung zur Verbindungssicherheit

Wenn Sie eine Verbindung zu einem Server ohne gültiges SSL-Zertifikat
herstellen, erhalten Sie eine Warnung zur Verbindungssicherheit.

Dies bedeutet, dass die Verbindung unsicher ist. Wenn Sie dem Fingerprint
dieses Servers vertrauen, können Sie auf "Verbinden" klicken, um eine
Verbindung herzustellen, oder auf "Verbinden und nicht mehr nach diesem
Server fragen", um eine Verbindung herzustellen und den Fingerprint zu
speichern.

## Direktverbindungen

Mit der Server-Option im Dialogfeld für die Verbindung können Sie eine
direkte Verbindung herstellen.

Wenn Sie dies ausgewählt haben, wählen Sie aus, in welchem Modus das Ende
der Verbindung sein soll.

Die andere Person wird sich mit Ihnen verbinden, indem sie das Gegenteil
benutzt.

Sobald der Modus ausgewählt ist, können Sie die Schaltfläche Externe IP
abrufen verwenden, um Ihre externe IP-Adresse zu ermitteln und
sicherzustellen, dass der im Feld Port eingegebene Port korrekt
weitergeleitet wird. Wenn Ihr Router dies zulässt, können Sie den Port mit
UPnP weiterleiten, bevor Sie den Portcheck durchführen.

Wenn der Port-Check feststellt, dass der Port (standardmäßig 6837) nicht
erreichbar ist, wird eine Warnung angezeigt.

Leiten Sie Ihren Port weiter und versuchen Sie es erneut. Stellen Sie
außerdem sicher, dass der NVDA-Prozess durch die Windows-Firewall zugelassen
ist.

Hinweis: Die Weiterleitung von Ports, die Aktivierung von UPnP oder die
Konfiguration der Windows-Firewall liegen außerhalb des Rahmens dieses
Dokuments. Weitere Informationen finden Sie in den mitgelieferten
Informationen zu Ihrem Router.

Geben Sie einen Schlüssel in das Schlüsselfeld ein oder drücken Sie auf
"Schlüssel generieren". Die andere Person benötigt Ihre externe IP zusammen
mit dem Schlüssel, um eine Verbindung herzustellen. Wenn Sie einen anderen
Anschluss als den Standard-Anschluss (6837) in das Anschlussfeld eingegeben
haben, vergewissern Sie sich, dass die andere Person den alternativen
Anschluss an die Host-Adresse in der Form &lt;external ip&gt;:&lt;port&gt;
anhängt.

Wenn Sie den gewählten Port über UPnP weiterleiten möchten, aktivieren Sie
das Kontrollkästchen "UPnP zur Weiterleitung dieses Ports verwenden, wenn
möglich".

Sobald Sie auf "OK" geklickt haben, wird die Verbindung hergestellt. Wenn
die Gegenseite die Verbindung hergestellt hat, können Sie TeleNVDA normal
verwenden.

## Steuerung des entfernten Rechners

Sobald die Sitzung verbunden ist, kann der Benutzer des steuernden Computers
F11 drücken, um dden Remote-Computer zu steuern (z. B. durch Senden von
Tastaturtasten oder Braille-Eingaben). Dieser Tastenbefehl kann im
Dialogfeld für die Tastenbefehle in NVDA geändert werden.

Wenn NVDA mitteilt, dass ein Remote-Computer gesteuert wird, werden die
Tasten der Tastatur und der Braillezeile, die Sie drücken, auf den
Remote-Computer übertragen. Wenn der steuernde Computer eine Braillezeile
verwendet, werden die Informationen des Remote-Computers auf diesem
angezeigt. Drücken Sie erneut F11, um das Senden von Tasten zu stoppen und
wieder zum steuernden Computer zurück zu wechseln.

Um eine optimale Kompatibilität zu gewährleisten, stellen Sie bitte sicher,
dass die Tastaturbelegung auf beiden Geräten übereinstimmt.

## Aktuelle Sitzung teilen

Um einen Link freizugeben, damit eine andere Person einfach an Ihrer
TeleNVDA-Sitzung teilnehmen kann, wählen Sie den Eintrag "Link kopieren" aus
dem Menü "Fernbedienung". Sie können auch Tastenbefehle aus dem Dialogfeld
für die Tastenbefehle zuweisen, um diese Aufgabe zu beschleunigen.

Sie können zwischen zwei Link-Formaten auswählen. Das erste Format ist
sowohl mit NVDA-Remote als auch mit TeleNVDA kompatibel und wird im Moment
am meisten empfohlen. Das zweite Format ist nur mit TeleNVDA kompatibel.

Wenn Sie als Host-Computer angeschlossen sind, kann über diesen Link eine
andere Person angeschlossen und gesteuert werden.

Wenn Sie stattdessen Ihren Computer so eingerichtet haben, dass er gesteuert
werden kann, ermöglicht der Link den Personen, für die Sie ihn freigeben,
die Steuerung Ihres Computers.

Bei vielen Anwendungen kann diese Verknüpfung automatisch aktiviert
werden. Wenn sie jedoch nicht aus einer bestimmten Anwendung heraus
ausgeführt wird, kann sie in die Zwischenablage kopiert und über den
Ausführen-Dialogfeld ausgeführt werden.

Beachten Sie, dass der gemeinsame Link möglicherweise nicht funktioniert,
wenn Sie ihn von einem Server kopieren, der im Modus der Direktverbindung
läuft.

## Strg+Alt+Entf senden

Beim Senden von Tasten ist es nicht möglich, die Kombination Strg+Alt+Entf
normalerweise zu senden.

Wenn Sie Strg+Alt+Entf senden müssen und der Remote-Computer sich auf dem
sicheren Desktop befindet, verwenden Sie diesen Befehl.

## Umschalt-Taste zwischen lokalem und entferntem Computer senden

Wenn Sie den zugewiesenen Tastenbefehl drücken, um zwischen dem lokalen und
dem entfernten Computer zu wechseln, wird sie normalerweise nicht an den
Remote-Computer gesendet, sondern zwischen dem lokalen und dem entfernten
Computer umgeschaltet.

Wenn Sie diesen oder einen anderen Tastenbefehl an den Remote-Computer
senden müssen, können Sie dieses Verhalten für den nächsten unmittelbaren
Tastenbefehl außer Kraft setzen, indem Sie das Skript "Nächsten Tastenbefehl
ignorieren" aktivieren.

Standardmäßig ist dieses Skript der Taste Strg+F11 zugewiesen. Dieser
Tastenbefehl kann im Dialogfeld für die Tastenbefehle in NVDA geändert
werden.

Wenn dieses Skript aufgerufen wird, wird der nächste Tastenbefehl ignoriert
und an den Remote-Computer gesendet, einschließlich des Tastenbefehls zur
Aktivierung des Skripts "Nächsten Tastenbefehl ignorieren". Sobald der
nächste Tastenbefehl gesendet wurde, kehrt das Skript zum regulären
Verhalten zurück.

## Fernsteuerung eines unbeaufsichtigten Computers

Gelegentlich möchte man vielleicht einen eigenen Computer aus der Ferne
steuern. Dies ist besonders hilfreich, wenn Sie auf Reisen sind und den
Heim-PC von Ihrem Laptop aus steuern möchten. Oder Sie möchten einen
Computer in einem Raum Ihres Hauses steuern, während Sie draußen an einem
anderen PC sitzen. Mit ein wenig Vorbereitung ist dies bequem und möglich.

1. Rufen Sie das NVDA-Menü auf und wählen Sie "Werkzeuge" und dann
   "Fernsteuerung" aus. Drücken Sie schließlich die Eingabetaste bei
   "Optionen".
2. Aktivieren Sie das Kontrollkästchen "Beim Starten automatisch mit dem
   Kontroll-Server verbinden".
3. Wählen Sie aus, ob Sie einen Remote-Relay-Server verwenden oder die
   Verbindung lokal hosten wollen. Wenn Sie sich dafür entscheiden, die
   Verbindung zu hosten, können Sie versuchen, die Ports über UPnP
   weiterzuleiten, indem Sie das entsprechende Kontrollkästchen aktivieren.
4. Wählen Sie in der zweiten Gruppe von Optionsfeldern die Option "Erlauben"
   aus, dass dieser Computer gesteuert wird.
5. Wenn Sie die Verbindung selbst hosten, müssen Sie sicherstellen, dass der
   im Feld Port angegebene Port (standardmäßig 6837) auf dem kontrollierten
   Computer von den kontrollierenden Computern aus zugänglich ist.
6. Wenn Sie einen Relay-Server verwenden möchten, füllen Sie die Felder Host
   und Schlüssel aus, klicken Sie auf "OK" und drücken Sie die
   Eingabetaste. Die Option "Schlüssel generieren" ist in diesem Fall nicht
   verfügbar. Es ist am besten, wenn Sie sich einen Schlüssel ausdenken, den
   Sie sich merken können, damit Sie ihn von überall aus verwenden können.

Für fortgeschrittene Anwender können Sie NVDA-Remote auch so konfigurieren,
dass im Steuerungsmodus automatisch eine Verbindung zu einem lokalen oder
entfernten Relay-Server hergestellt wird. Wenn Sie dies wünschen, wählen Sie
in der zweiten Gruppe von Optionsfeldern die Option "Anderen Computer
steuern" aus.

Hinweis: Die Optionen für die automatische Verbindung beim Start im
Optionsdialog werden erst nach einem Neustart von NVDA wirksam.

## Stummschalten der Sprachausgabe auf dem Remote-Computer

Wenn Sie die Sprachausgabe des Remote-Computers oder NVDA-spezifische Töne
nicht hören möchten, rufen Sie einfach das NVDA-Menü, Extras und
Fernbedienung auf. Gehen Sie mit dem Pfeil nach unten zu Stummschaltung der
Fernbedienung und drücken Sie die Eingabetaste. Bitte beachten Sie, dass
diese Option nicht die Ausgabe der Fern-Braille-Schrift auf dem
Remote-Bildschirm deaktiviert, wenn der steuernde Rechner Tasten sendet.

## Beenden einer Remote-Sitzung

Um eine Remote-Sitzung zu beenden, gehen Sie wie folgt vor:

1. Drücken Sie beim Remote-Computer F11, um die Steuerung des
   Remote-Computers zu beenden. Sie sollten die Meldung erhalten: "Lokaler
   Computer wird gesteuert". Wenn Sie stattdessen die Meldung erhalten, dass
   Sie den Remote-Computer steuern, drücken Sie erneut die Taste F11.
2. Rufen Sie das NVDA-Menü auf, dann "Werkzeuge", "Fernsteuerung" und
   drücken Sie bei "Trennen" die Eingabetaste.

Alternativ können Sie auch NVDA+Alt+Seite nach unten drücken, um die Sitzung
direkt zu beenden. Dieser Tastenbefehl kann im Dialogfeld für die
Tastenbefehle in NVDA geändert werden. Um die andere Seite zu schützen,
können Sie diesen Tastenbefehl drücken, während Sie Tasten senden, um die
Verbindung mit dem Remote-Computer zu trennen.

## Aus Zwischenablage einfügen

Mit der Option "Aus Zwischenablage einfügen" im Remote-Menü können Sie Text
aus der Zwischenablage einfügen.

Wenn diese Funktion aktiviert ist, wird jeder Text in der Zwischenablage auf
die anderen Rechner übertragen.

## Versenden von Dateien

Mit der Option "Datei senden" im Remote-Menü können Sie kleine Dateien an
alle Sitzungsteilnehmer, einschließlich der überwachten Computer,
senden. Bitte beachten Sie, dass Sie nur Dateien mit einer Größe von weniger
als 10 MB senden können. Das Senden oder Empfangen von Dateien auf sicheren
Bildschirmen ist nicht erlaubt.

Beachten Sie auch, dass das Versenden von Dateien je nach Dateigröße, den
mit derselben Sitzung verbundenen Computern und der Menge der versendeten
Dateien zu viel Netzwerkverkehr auf dem Server verbrauchen kann. Wenden Sie
sich an den Server-Administrator und fragen Sie nach, ob der Datenverkehr in
Rechnung gestellt wird. In diesem Fall sollten Sie eine andere Plattform für
den Dateiaustausch in Betracht ziehen.

Wenn die Datei auf den Remote-Computern empfangen wird, erscheint ein
Dialogfeld "Speichern unter", in dem Sie auswählen können, wo die Datei
gespeichert werden soll.

## TeleNVDA für die Arbeit auf einem sicheren Desktop konfigurieren

Damit TeleNVDA auf dem sicheren Desktop funktioniert, muss die
NVDA-Erweiterung in dem auf dem sicheren Desktop laufenden NVDA installiert
sein.

1. Wählen Sie im Menü NVDA die Option Einstellungen und dann Allgemeine
   Einstellungen aus.
2. Wechseln Sie zur Schaltfläche "Aktuell gespeicherte Einstellungen für die
   Anmeldung und andere sichere Bildschirme verwenden (Administratorrechte
   erforderlich)" und drücken Sie die Eingabetaste.
3. Beantworten Sie die Aufforderungen zum Kopieren Ihrer Einstellungen und
   zum Kopieren von Plugins mit "Ja" und beantworten Sie die möglicherweise
   erscheinende Aufforderung zur Benutzerkontensteuerung.
4. Wenn die Einstellungen kopiert sind, drücken Sie die Eingabetaste, um die
   Schaltfläche "OK" zu schließen. Gehen Sie mit der Tabulatortaste auf "OK"
   und drücken Sie erneut die Eingabetaste, um das Dialogfeld zu verlassen.

Sobald TeleNVDA auf dem gesicherten Desktop installiert ist, haben Sie, wenn
Sie gerade in einer Fernsitzung gesteuert werden, Sprach- und
Braille-Zugriff auf den gesicherten Desktop, wenn Sie dahin wechseln.

## Löschen von SSL-Zertifikat-Fingerprints

Wenn Sie den Server-Fingerprints, denen Sie vertraut haben, nicht mehr
vertrauen, können Sie sie löschen, indem Sie im Dialogfeld Optionen auf die
Schaltfläche "Alle vertrauenswürdigen Fingerprints löschen" klicken.

## Verwendung eines benutzerdefinierten Port-Check-Dienstes

Standardmäßig prüft TeleNVDA offene Ports mit Hilfe eines Dienstes, der von
der spanischen NVDA-Community bereitgestellt wird. Sie können die URL des
Dienstes über den Dialogfeld "Optionen" ändern. Stellen Sie sicher, dass der
zu prüfende Port Teil der benutzerdefinierten URL ist und die Ergebnisse im
erwarteten Format zurückgegeben werden. Ein Beispielskript für den Portcheck
wird im TeleNVDA-Repository zur Verfügung gestellt, so dass Sie bei Bedarf
Ihre eigene Kopie hosten können.

## Änderung von TeleNVDA

Dieses Projekt unterliegt der GNU General Public License, Version 2 oder
neuer. Sie dürfen [dieses Repository][2] klonen, um Änderungen an TeleNVDA
vorzunehmen, vorausgesetzt, Sie lesen, verstehen und respektieren die
Lizenzbedingungen. Das Mini-UPnP-Modul ist unter einer BSD-3-Klausel
lizenziert.

### Abhängigkeiten von Drittanbietern

Diese können mit PIP installiert werden:

* Markdown
* scons

Um die ausführbare URL-Handler-Datei zu erstellen, benötigen Sie Visual
Studio 2019 oder neuer.

### Um die NVDA-Erweiterung für die Verteilung zu verpacken:

1. Öffnen Sie eine Befehlszeile, wechseln Sie zum Stammverzeichnis von
   [diesem Repository][2]
2. Führen Sie den Befehl **scons** aus. Die erstellte NVDA-Erweiterung wird,
   wenn keine Fehler aufgetreten sind, im aktuellen Verzeichnis abgelegt.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
