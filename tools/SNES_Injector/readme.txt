Utilisation:

- Copier les roms au format smc dans le dossier "sources_files\roms".
- Copier les images au format jpg dans le dossier "sources_files\images". Attention, pour qu'une image soit liée à la rom, elle devra avoir le même nom que celle-ci (sauf l'extension qui sera ".jpg" au lieu d'être ".smc".
- Faire un double-clique sur le fichier "SNES_Injector_0.3.bat" (la version pourra peut-être être différente) et attendre la fin du script.
- Si tout s'est bien passer, copier le contenu du dossier "snes_classic\game" à l'endroit dédié de l'émulateur sur la SD de la Switch, ici "/switch/snes_classic/game".

Attention, il faut savoir que le dossier "snes_classic\game" est réinitialisé à chaque lancement du script.

Note: Il est possible de mettre une image par défaut aux jeux dont les images ne seraient pas trouvées par le script, celle-ci doit être au format jpg et être nomée "default_image.jpg" et être placée à la racine du script.

Bugs connus:
- Les jeux n'affichent toujours qu'un seul joueur dans le nombre de joueur possibles, ceci est à configurer manuellement dans le fichier "snes_classic\game\database.json".

Changements:

0.1: 
- Première release.

0.3:
- Correction du bug qui faisait qu'il fallait corriger le json à la main.
- Début de remaniement du script.

0.6:
- Complet remaniement du script pour être mieux organisé, plus lisible, avoir un bien meilleur contrôle d'erreurs et être un peu mieux optimisé (sur ce dernier point on peut encore faire bien mieux je pense).
- Ajout d'un fichier d'image par défaut servant au cas où une image de jeu pour une rom ne soit pas trouvée durant le script. Cette image se trouve à la racine du script et se nomme "default_image.jpg".

0.7:
- Correction d'un bug faisant que les images n'étaient pas correctement copiées même si elles existaient.

0.8:
- Les roms au format sfc placés dans le dossier "sources_files\roms" seront renommées au format smc en début de script pour les rendre compatibles avec l'émulateur.
- Les lignes de commandes sont masquées, seul le résultat est affiché.
- Correction des espaces du fichier json qui était mal implémentés.

0.9.5:
- Le script a été adapté pour être utilisable via l'Ultimate Switch Hack Script mais il peut toujours être utilisé indépendament de celui-ci.
- La plupart des chemins de dossiers importants ont été remplacés par des variables, permettant une plus grande souplesse de programmation.
- Le chemin de sortie est maintenant "snes_classic\game" si le script est exécuté en dehors de l'Ultimate Switch Hack Script.
- Quelques optimisations et autres petites choses.

0.9.6:
- Corrections de bugs.

0.9.7:
- Le script n'est maintenant utilisable qu'avec mon Ultimate Switch Hack Script pour des raisons pratiques liées à la traduction de celui-ci.