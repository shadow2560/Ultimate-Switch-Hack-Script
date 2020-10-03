function load_menu() {
var menu_text='\
<h1>Menu</h1>\
&nbsp;\
<ul>\
<li><a href="../index.html">Accueil de la documentation</a></li>\
<br/>\
<li><a target="_blank" href="changelog.html">Changelog du script</a></li>\
<li><a target="_blank" href="packs_changelog.html">Changelog des packs du script</a></li>\
<li><a target="_blank" href="credits.html">Crédits</a></li>\
<li><a target="_blank" href="donate.html">Me faire une donation</a></li>\
<br/>\
<li><a href="sd_prepare.html">Contenue des packs du script</a></li>\
<li><a href="install_drivers.html">Installation des drivers</a></li>\
<li><a href="keys_dump.html">Dump des clés</a></li>\
<li><a href="choidujournx.html">Utiliser ChoiDuJourNX</a></li>\
<li><a href="netplay.html">Utiliser le réseau alternatif pour jouer</a></li>\
<li><a href="unbrick.html">Infos sur le script de débrickage</a></li>\
<br/>\
<li><a href="translate.html">Aider à traduire</a></li>\
</ul>\
';
document.getElementById("menu").innerHTML=menu_text;
}