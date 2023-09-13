# TeleNVDA #

* Auteurs : Asociación Comunidad Hispanohablante de NVDA et d'autres
  contributeurs. Travail original par Tyler Spivey et Christopher Toth
* Compatibilité NVDA : 2019.3 et au-delà.
* Télécharger [version stable][1]

Remarque : Afin de faciliter le téléchargement pour les utilisateurs qui ont
besoin d'aide ou de formation et qui ont des compétences informatiques
limitées, nous fournissons un autre lien vers la dernière version stable qui
est facile à retenir et à partager. Vous pouvez vous rendre sur
[nvda.es/tele](https://nvda.es/tele) et téléchargez directement l'extension
sans pages Web intermédiaires.

Bienvenue à l'extension TeleNVDA, une extension qui vous permettra de vous
connecter à un ordinateur distant exécutant le lecteur d'écran libre et
gratuit NVDA. Vous pouvez vous connecter à l'ordinateur d'une autre personne
ou autoriser une personne de confiance à se connecter à votre système, afin
d'accomplir des tâches de maintenance, diagnostiquer un problème ou encore
dispenser une formation. Cette extension est une version modifiée de
[l'extension NVDARemote](https://nvdaremote.com), et sa maintenance est en
charge de la communauté espagnole de NVDA. Il est entièrement compatible
avec NVDA Remote. Voici les différences actuelles :

* Une option vous permet de bloquer les commandes vocales distantes autres
  que le texte.
* Amélioration du support des serveurs proxy et des services cachés TOR (est
  nécessaire [l'extension Support
  Proxy](https://addons.nvda-project.org/addons/proxy.fr.html)).
* Possibilité de changer la touche F11 pour un autre geste. Maintenant, cela
  fonctionne comme un script commun, vous pouvez donc attribuer d'autres
  gestes dans le dialogue " Gestes de commandes ".
* Possibilité à ignorer complètement le geste immédiat suivant, il est utile
  si vous devez envoyer à l'ordinateur distant le geste utilisé pour
  alterner entre la machine locale et la machine distante.
* Possibilité d'échanger de petits fichiers (jusqu'à 10 Mo) parmi les
  utilisateurs connectés à la même session.
* Possibilité de rediriger les ports via UPNP.
* Possibilité d'utiliser un service portcheck personnalisé.
* Quelques ajustements de l'interface graphique.
* Diverses corrections de bogues.

## Avant De Commencer

Vous aurez besoin d'avoir préalablement installé NVDA sur les deux
ordinateurs et obtenir l'extension TeleNVDA.

Les deux installations respectent une procédure standard. Si vous avez
besoin de plus d'informations à ce sujet, vous pouvez consulter le guide de
l'utilisateur de NVDA.

## Mise à jour

Lors de la mise à jour de l'extension, si vous avez installé TeleNVDA dans
le bureau sécurisé (dialogue d'ouverture de session, écrans sécurisés
UAC...) il est recommandé de mettre à jour l'extension pour ces écrans.

Pour ce faire, commencez par mettre à jour l'extension. Puis dans le menu
NVDA, Préférences, Paramètres généraux, activez le bouton " Utiliser les
paramètres NVDA actuellement sauvegardés pour l'écran de connexion et sur
les écrans sécurisés (nécessite des privilèges administrateur) ".

## Démarrage d'une session distante à travers un serveur relai

### Sur l'ordinateur à contrôler

1. Ouvrez le menu NVDA, Outils, Accès distant, Se Connecter. Ou appuyez
   directement sur NVDA+alt+page précédente. Ce geste peut être modifié à
   partir du dialogue Gestes de commandes de NVDA.
2. Choisissez " Client " dans le premier ensemble de boutons radio.
3. Sélectionnez " Permettre le contrôle de cet ordinateur " dans le second
   ensemble de boutons radio.
4. Dans le champ " Adresse du serveur ", saisissez l'IP ou l'adresse du
   serveur relai auquel vous vous connectez, par exemple remote.nvda.es. Au
   cas où le serveur utilise un port alternatif, vous pouvez saisir
   l'adresse du serveur sous la forme &lt;adresse&gt;:&lt;port&gt;, comme
   dans : remote.nvda.es:1234. Si vous vous connectez à une adresse IPv6,
   introduisez-la entre crochets. Par exemple: [2603:1020:800:2::32].
5. Entrez une clé dans le champ " Clé " ou appuyez sur le bouton " Générer
   la Clé ". Cette clé est celle que les autres utiliseront pour contrôler
   l'ordinateur. L'ordinateur contrôlé ainsi que tous ses clients doivent
   utiliser la même clé.
6. Appuyez sur OK. Une fois ceci fait, vous entendrez un signal sonore ainsi
   que le message " connecté au serveur de contrôle ". Si le serveur
   comprend un message du jour, cela sera affiché dans une boîte de
   dialogue. Vous verrez cette boîte de dialogue à chaque fois que vous vous
   connectez ou la première fois, selon la configuration du serveur.

### Sur l'ordinateur contrôleur

1. Ouvrez le menu NVDA, Outils, Accès distant, Se Connecter. Ou appuyez
   directement sur NVDA+alt+page précédente. Ce geste peut être modifié à
   partir du dialogue Gestes de commandes de NVDA.
2. Choisissez " Client " dans le premier ensemble de boutons radio.
3. Sélectionnez " Contrôler un autre ordinateur " dans le second ensemble de
   boutons radio.
4. Dans le champ " Adresse du serveur ", saisissez l'IP ou l'adresse du
   serveur relai auquel vous vous connectez, par exemple remote.nvda.es. Au
   cas où le serveur utilise un port alternatif, vous pouvez saisir
   l'adresse du serveur sous la forme &lt;adresse&gt;:&lt;port&gt;, comme
   dans : remote.nvda.es:1234. Si vous vous connectez à une adresse IPv6,
   introduisez-la entre crochets. Par exemple: [2603:1020:800:2::32].
5. Entrez une clé dans le champ " Clé " ou appuyez sur le bouton " Générer
   la Clé ". L'ordinateur contrôlé ainsi que tous ses clients doivent
   utiliser la même clé.
6. Appuyez sur OK. Une fois ceci fait, vous entendrez un signal sonore ainsi
   que le message " connecté au serveur de contrôle ". Si le serveur
   comprend un message du jour, cela sera affiché dans une boîte de
   dialogue. Vous verrez cette boîte de dialogue à chaque fois que vous vous
   connectez ou la première fois, selon la configuration du serveur.

### Avertissement de sécurité de connexion

Si vous vous connectez à un serveur sans certificat SSL valide, vous
recevrez un avertissement de sécurité de connexion.

Cela peut signifier que votre connexion n'est pas sécurisée. Si vous faites
confiance à ce serveur d'empreintes digitales, vous pouvez appuyer sur " Se
Connecter. " pour vous connecter une fois, ou " Se connecter et ne plus
demander pour ce serveur " pour se connecter et enregistrer l'empreinte
digitale.

## Connexion directe

L'option " Serveur " du dialogue Se Connecter vous permet d'établir une
connexion directe.

Une fois l'option sélectionnée, choisissez le mode dans lequel votre
connexion devra s'établir, contrôleur ou contrôlé.

L'autre personne se connectera à votre ordinateur en sélectionnant le mode
opposé.

Quand le mode est sélectionné, vous pouvez utiliser le bouton "Obtenir
l'adresse IP publique" pour obtenir votre adresse IP et vous assurer que le
port de connexion (indiqué dans le champ " Port ", est correctement
redirigé. Si vous êtes activé sur votre routeur, vous pouvez redirigé le
port à l'aide de UPNP avant d'effectuer le portcheck.

Si la procédure de vérification détecte que le port spécifié (6837 par
défaut) n'est pas accessible, un avertissement s'affiche.

Redirigez votre port et réessayez. Assurez-vous également que le processus
NVDA est autorisé via un pare-feu Windows.

Remarque : Le processus de redirection des ports, d'activation UPNP ou de
configuration du pare-feu Windows est en dehors de l'objectif de ce
document. Veuillez consulter les informations fournies avec votre routeur
pour plus d'instructions.

Saisissez une clé dans le champ "Clé" ou appuyez sur " Générer la Clé
". L'autre personne aura besoin de votre adresse IP ainsi que de cette même
clé pour se connecter. Si vous avez saisi un port autre que la valeur par
défaut (6837) Dans le champ " Port ", assurez-vous que l'autre personne
ajoute le port alternatif à l'adresse du serveur sous la forme &lt;ip
publique&gt;:&lt;port&gt;.

Si vous souhaitez rediriger le port choisi à l'aide de UPNP, activez la case
à cocher "Utilisez UPNP pour rediriger ce port si possible".

Sitôt OK appuyé, vous serez connecté. Quand l'autre personne se connecte,
vous pouvez utiliser TeleNVDA normalement.

## Contrôler l'ordinateur distant

Dès que la session est ouverte, l'utilisateur de l'ordinateur contrôleur
peut appuyer sur F11 pour commencer à contrôler l'ordinateur distant, par
ex. : en envoyant des touches clavier ou de la saisie Braille. Ce geste peut
être modifié à partir du dialogue Gestes de commandes de NVDA.

Lorsque NVDA dit : " Contrôle de la machine distante ", toutes les touches
que vous actionnerez sur le clavier ou sur le terminal Braille iront vers
l'ordinateur distant. De plus, si l'ordinateur contrôleur est doté d'un
terminal Braille, les informations de l'ordinateur contrôlées y seront
affichées. Appuyez à nouveau sur F11 pour interrompre l'envoi de commandes
et revenir à l'ordinateur contrôleur.

Pour une compatibilité optimale, assurez-vous que les configurations clavier
des deux ordinateurs correspondent.

## Partager votre session

Pour partager un lien permettant à quelqu'un d'autre de rejoindre facilement
votre session de TeleNVDA, choisissez le menu "copier le lien" dans le
sous-menu Accès distant. Vous pouvez également attribuer des gestes à partir
du dialogue Gestes de commandes de NVDA pour accélérer cette tâche.

Vous pouvez choisir entre deux formats de liens. Le premier est compatible
avec NVDA Remote et TeleNVDA, et est le plus recommandé pour l'instant. Le
deuxième est compatible uniquement avec TeleNVDA.

Si vous êtes connecté en tant qu'ordinateur contrôleur, ce lien permet à
quelqu'un d'autre de se connecter et être contrôlé.

Si, en revanche, vous avez configuré votre ordinateur pour être contrôlé,
les personnes avec qui vous avez partagé ce lien pourront contrôler votre
machine.

De nombreuses applications permettent aux utilisateurs d'activer ce lien
automatiquement, mais s'il ne s'exécute pas au sein d'une application
précise, le lien peut être copié dans le presse-papiers et utilisé dans la
commande Exécuter.

Notez que le lien partagé peut ne pas fonctionner si vous le copiez à partir
d'un serveur s'exécutant en mode connexion directe.

## Envoyer Ctrl+Alt+Suppr

Pendant l'envoi de commandes, il n'est pas possible d'envoyer la combinaison
de touches Ctrl+Alt+Suppr de façon normale.

Si vous devez envoyer cette commande mais que le système distant est en mode
bureau sécurisé, utilisez alors la commande de menu "Envoyer
Ctrl+Alt+Suppr".

## Envoyer une touche de bascule entre la machine locale et la machine distante

Habituellement, lorsque vous appuyez sur le geste attribué pour basculer
entre la machine locale et distante, il ne sera pas envoyé à la machine
distante; Il basculera à la place entre la machine locale et la machine
distante.

Si vous avez besoin d'envoyer ce geste ou n'importe quel geste à la machine
distante, vous pouvez remplacer ce comportement pour le geste immédiat
suivant en activant le script ignorer complètement le geste suivant.

Par défaut, ce script est attribué à la touche Control+F11. Ce geste peut
être modifié à partir du dialogue Gestes de commandes de NVDA.

Lorsque ce script sera appelé, le geste suivant sera ignoré et sera envoyé à
la machine distante, y compris le geste pour activer le script ignorer
complètement le geste suivant. Une fois le prochain geste envoyé, il
reviendra au comportement habituel.

## Contrôler un ordinateur distant sans assistance

Parfois, vous aurez peut-être besoin de vous connecter à l'un de vos
ordinateurs personnels à distance. Ceci peut s'avérer particulièrement utile
lorsque vous êtes en voyage et que vous souhaitez contrôler l'ordinateur de
la maison depuis votre ordinateur portable, ou encore qu'il vous est
nécessaire d'intervenir sur un ordinateur se trouvant dans une pièce de
votre domicile alors que vous vous situez à l'extérieur de celle-ci avec un
autre ordinateur. Il suffit pour cela d'une petite opération avancée pour
rendre le processus simple et confortable.

1. Rendez-vous dans le menu NVDA et choisissez Outils puis Accès
   distant. Validez ensuite sur Options.
2. Cochez la case intitulée " Se connecter automatiquement au serveur de
   contrôle au démarrage ".
3. Sélectionnez s'il faut utiliser un serveur de relais distant ou pour
   héberger localement la connexion. Si vous décidez d'héberger la
   connexion, vous pouvez essayer de rediriger des ports à l'aide de UPNP en
   vérifiant la case à cocher fournie.
4. Sélectionnez " Permettre le contrôle de cet ordinateur " dans le second
   ensemble de boutons radio.
5. Si vous hébergez le serveur, (mode serveur), assurez-vous que le port
   spécifié dans le champ " Port " sur l'ordinateur contrôlé (6837 par
   défaut) est accessible à l'ordinateur contrôleur.
6. Si vous souhaitez utiliser un serveur relai, renseignez les champs
   Adresse du serveur et Clé, tabulez jusqu'à OK puis appuyez sur Entrée. Le
   bouton Générer la clé n'est pas disponible dans ce cas. Le mieux est que
   vous vous conceviez une clé dont vous vous rappellerez facilement de
   façon à pouvoir l'utiliser d'un endroit distant.

Pour une utilisation avancée, vous pouvez aussi configurer TeleNVDA pour
qu'il se connecte automatiquement à un serveur relai local ou distant en
mode contrôleur. Si c'est cela que vous voulez, sélectionnez Contrôler un
autre ordinateur dans le second ensemble de boutons radio.

Remarque : Les options concernant la connexion automatique au démarrage ne
s'appliquent que lorsque NVDA est relancé.

## Couper le son de l'ordinateur distant

Si vous ne souhaitez pas entendre la synthèse vocale ainsi que les sons de
NVDA de l'ordinateur distant, rendez-vous simplement dans le menu NVDA,
outils puis Accès distant, puis descendez avec les flèches jusqu'à " Couper
le son distant " et validez avec Entrée. Veuillez noter que cette option ne
désactivera pas le terminal Braille distant pour l'écran à contrôler lorsque
l'ordinateur contrôleur envoi des commandes.

## Fermer une session distante

Pour mettre fin à une session distante, procédez comme suit :

1. Sur l'ordinateur contrôleur, appuyez sur F11 pour arrêter l'envoi de
   commandes. Vous devriez entendre le message " Contrôle de la machine
   locale ". Si vous entendez " Contrôle de la machine locale ", appuyez sur
   F11 une nouvelle fois.
2. Rendez-vous dans le menu NVDA, Outils puis Accès distant et faites entrée
   sur l'option " Se déconnecter ".

Alternativement, vous pouvez appuyer sur NVDA+alt+page suivante pour
déconnecter directement la session. Ce geste peut être modifié à partir du
dialogue Gestes de commandes de NVDA. Pour assurer la sécurité de l'autre
personne, vous pouvez appuyer sur ce geste tout en envoyant des touches pour
déconnecter l'ordinateur distant.

## Envoyer le presse-papiers

L'option " Envoyer le presse-papiers " présente dans le menu Accès Distant
vous permet d'envoyer du texte depuis votre presse-papiers.

Une fois activée, tout texte présent dans votre presse-papiers sera envoyé à
l'ordinateur distant.

## Envoyer des fichiers

L'option Envoyer fichier dans le menu Accès Distant vous permet d'envoyer de
petits fichiers à tous les membres de la session, y compris la machine
contrôlée. Veuillez noter que vous ne pouvez envoyer que des fichiers
inférieurs à 10 Mo. Il n'est pas autorisé à envoyer ou à recevoir des
fichiers sur des écrans sécurisés.

Notez également que l'envoi de fichiers peut consommer trop de trafic réseau
sur le serveur, selon la taille du fichier, les ordinateurs connectés à la
même session et de la quantité de fichiers envoyés. Contactez votre
administrateur de serveur et demandez-leur si le trafic est facturé. Dans ce
cas, envisagez d'utiliser une autre plate-forme pour échanger des fichiers.

Lorsque le fichier est reçu sur les machines distantes, une boîte de
dialogue Enregistrer sous va apparaître, vous permettant de choisir où
enregistrer le fichier.

## Configurer TeleNVDA pour fonctionner sur le bureau sécurisé

Pour que TeleNVDA fonctionne sur un bureau sécurisé, il faut que l'extension
soit installée sur la version de NVDA qui s'y exécute.

1. Depuis le menu de NVDA, sélectionnez Préférences, puis Paramètres
   généraux.
2. Faites Tabulation jusqu'au bouton intitulé " Utiliser les paramètres NVDA
   actuellement sauvegardés pour l'écran de connexion et sur les écrans
   sécurisés (nécessite des privilèges administrateur) " et appuyez sur
   Entrée.
3. Répondez Oui aux questions relatives à la copie de vos paramètres et
   extensions et répondez Oui à l'invite du contrôle de compte d'utilisateur
   qui apparaîtrait.
4. Une fois les paramètres copiés, appuyez sur Entrée pour valider le bouton
   OK. Refaites Tabulation jusqu'à OK. Enfin, refaites Entrée pour fermer ce
   dialogue.

Une fois TeleNVDA installé sur le bureau sécurisé et que votre ordinateur
est contrôlé, le bureau sécurisé sera sonorisé et affiché en Braille
lorsqu'il est focalisé.

## Effacer les empreintes digitales du certificat SSL

Si vous ne voulez plus faire confiance aux empreintes digitales du serveur
en qui vous avez confiance, vous pouvez effacer toutes les empreintes
digitales de confiance en appuyant sur le bouton " Supprimer toutes les
empreintes digitales de confiance " dans la boîte de dialogue Options.

## Utilisation d'un service portcheck personnalisé

Par défaut, TeleNVDA vérifie les ports ouverts à l'aide d'un service fourni
par la communauté espagnole NVDA. Vous pouvez modifier l'URL de service à
partir de la boîte de dialogue Options. Assurez-vous que le port à vérifier
fait partie de l'URL personnalisée et que les résultats sont renvoyés dans
le format attendu. Un exemple de script portcheck  est distribué sur le
dépôt TeleNVDA, vous pouvez donc héberger votre propre copie si vous le
souhaitez.

## Modification de TeleNVDA

Ce projet est couvert par la licence publique générale GNU, version 2 ou
version ultérieure. Vous pouvez cloner [ce dépôt][2] pour modifier TeleNVDA,
à condition de lire, de comprendre et de respecter les conditions de
licence. Le module MiniUPNP  est sous licence de BSD-3 clause license.

### Dépendances tierce

Ceux-ci peuvent être installés avec pip :

* Markdown
* scons

Afin de compiler l'exécutable de gestion d'URLs, il est nécessaire d'avoir
Visual Studio 2019 ou version ultérieure.

### Empaquetage de l'extension pour sa distribution :

1. Ouvrez une ligne de commande, changer à la racine de [ce dépôt][2]
2. Exécutez la commande **scons**. L'extension créée, s'il n'y a pas
   d'erreur, sera placée dans le répertoire actuel.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
