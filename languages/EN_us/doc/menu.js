function load_menu() {
var menu_text='\
<h1>Menu</h1>\
&nbsp;\
<ul>\
<li><a href="index.html">Home page of the documentation</a></li>\
<br/>\
<li><a target="_blank" href="files/changelog.html">Changelog of the script</a></li>\
<li><a target="_blank" href="files/packs_changelog.html">Changelog of the packs of the script</a></li>\
<li><a target="_blank" href="files/credits.html">Credits</a></li>\
<li><a target="_blank" href="files/donate.html">Donate to me</a></li>\
<br/>\
<li><a href="files/sd_prepare.html">packs content of the script</a></li>\
<li><a href="files/install_drivers.html">Drivers installation</a></li>\
<li><a href="files/keys_dump.html">Keys dump</a></li>\
<li><a href="files/choidujournx.html">Use ChoiDuJourNX</a></li>\
<li><a href="files/netplay.html">Use the alternative network to play</a></li>\
<li><a href="files/unbrick.html">Infos on the unbrick script</a></li>\
<br/>\
<li><a href="files/translate.html">Help to translate</a></li>\
</ul>\
';
document.getElementById("menu").innerHTML=menu_text;
}