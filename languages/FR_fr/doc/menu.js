function load_menu() {
var menu_text='\
<h1>Menu</h1>\
&nbsp;\
<ul>\
<li><a href="index.html">Accueil de la documentation</a></li>\
<br/>\
<li><a target="_blank" href="files/changelog.html">Changelog du script</a></li>\
<li><a target="_blank" href="files/packs_changelog.html">Changelog des packs du script</a></li>\
<li><a target="_blank" href="files/credits.html">Crédits</a></li>\
<li><a target="_blank" href="files/donate.html">Me faire une donation</a></li>\
<br/>\
<li><a href="files/sd_prepare.html">Contenue des packs du script</a></li>\
<li><a href="files/install_drivers.html">Installation des drivers</a></li>\
<li><a href="files/keys_dump.html">Dump des clés</a></li>\
<li><a href="files/choidujournx.html">Utiliser ChoiDuJourNX</a></li>\
<li><a href="files/netplay.html">Utiliser le réseau alternatif pour jouer</a></li>\
<li><a href="files/unbrick.html">Infos sur le script de débrickage</a></li>\
<br/>\
<li><a href="files/translate.html">Aider à traduire</a></li>\
</ul>\
';
document.getElementById("menu").innerHTML=menu_text;
}