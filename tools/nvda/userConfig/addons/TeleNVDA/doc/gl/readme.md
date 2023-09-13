# TeleNVDA #

* Autores: Asociación Comunidade Hispanofalante do NVDA e outros
  colaboradores. Traballo orixinal de Tyler Spivey e Christopher Toth
* Compatibilidade co NVDA: do 2019.3 en adiante
* Descargar [versión estable][1]

Nota: para facer máis doada a descarga a usuarios que necesitan asistencia
ou formación e teñen conocementos limitados en informática, proporcionamos
un ligazón alternativo á versión estable máis recente que é sinxela de
lembrar e compartir. Podes ir a [nvda.es/tele](https://nvda.es/tele) e
descargar o complemento directamente, sen páxinas web intermedias.

Benvido ao complemento TeleNVDA, que che permitirá conectarte a outro equipo
que execute o lector de pantalla gratuito NVDA. Podes conectarte ao equipo
de outra persoa, ou permitir a unha persoa de confianza que se conecte ao
teu sistema para realizar un mantemento rutinario, diagnosticar un problema
ou ensinarte algo. Este complemento é unha versión modificada do
[complemento NVDARemote](https://nvdaremote.com), e o seu mantemento está a
cargo da comunidade hispanofalante do NVDA. É totalmente compatible co NVDA
Remote. Estas son as diferencias actuais:

* Unha opción permite bloquear as ordes remotas de voz que non sexan texto.
* Soporte mellorado para servidores proxy e servizos agachados TOR (é
  necesario o [complemento Soporte
  Proxy](https://addons.nvda-project.org/addons/proxy.es.html)).
* Posibilidade de cambiar a tecla f11 por outro xesto. Agora funciona coma
  un script común, polo que podes asignar outros xestos no diálogo "Xestos
  de entrada".
* Capacidade de ignorar compretamente o seguinte xesto inmediato, é útil se
  necesitas enviar á máquina remota o xesto usado para alternar entre o
  equipo local e a máquina remota.
* Posibilidade de intercambiar pequenos ficheiros (ate 10 MB) entre usuarios
  conectados á mesma sesión.
* Posibilidade de redirixir portos mediante UPNP.
* Posibilidade de usar un servizo de comprobación de portos persoalizado.
* Algúns retoques á interfaz gráfica.
* Varios arranxos de fallos.

## Antes de comezar

É necesario ter instalado o NVDA en ambos equipos, e obter o complemento
TeleNVDA.

A instalación do NVDA y do complemento non varía con respecto a outras. Se
necesitas máis información, podes atopala na guía do usuario do NVDA.

## Actualizacións

Cando actualices o complemento, se instalaches o TeleNVDA no escritorio
seguro, é recomendable que o actualices tamén alí.

Para facelo, primeiro actualiza o complemento normalmente. Despois, abre o
menú de NVDA, preferencias, Opcións Xerais, e preme o botón etiquetado coma
"Usar opcións actualmente gardadas na autentificación (logon) e outras
pantallas seguras (require privilexios de administrador)".

## Comezar unha sesión remota a través dun servidor externo

### No equipo controlado

1. Abre o menú de NVDA, ferramentas, remoto, conectar. Ou preme directamente
   NVDA+alt+retroceso de páxina. Pódese modificar este xesto dende o diálogo
   Xestos de entrada do NVDA.
2. Escolle cliente no primeiro grupo de botóns de opción.
3. Escolle permitir que controlen este equipo no segundo grupo de botóns de
   opción.
4. No campo equipo ou servidor, introduce o servidor ao que te vas a
   conectar, por exemplo remote.nvda.es. Cando o servidor use un porto
   distinto ao que este complemento usa por defecto, podes introducir o seu
   enderezo en formato &lt;equipo&gt;:&lt;porto&gt;, por exemplo
   remote.nvda.es:1234. Se te conectas a un enderezo IPV6, introdúcea entre
   corchetes. Por exemplo: [2603:1020:800:2::32].
5. Introduce unha chave no campo contrasinal, ou preme o botón xerar
   contrasinal. A chave é o que outros usarán para controlar o teu equipo. O
   equipo controlado e todos os seus clientes deben usar a mesma chave.
6. Preme aceptar. Feito esto, escoitarás un pitido e conectado. Se o
   servidor inclúe unha mensaxe de benvida, este amosarase nunha Caixa de
   diálogo. Verás este diálogo cada vez que te conectes ou só a primeira
   vez, dependendo da configuración do servidor.

### No equipo dende o que se controla

1. Abre o menú de NVDA, ferramentas, remoto, conectar. Ou preme directamente
   NVDA+alt+retroceso de páxina. Pódese modificar este xesto dende o diálogo
   Xestos de entrada do NVDA.
2. Escolle cliente no primeiro grupo de botóns de opción.
3. Seleciona controlar outro equipo no segundo grupo de botóns de opción.
4. No campo equipo ou servidor, introduce o servidor ao que te vas a
   conectar, por exemplo remote.nvda.es. Cando o servidor use un porto
   distinto ao que este complemento usa por defecto, podes introducir o seu
   enderezo en formato &lt;equipo&gt;:&lt;porto&gt;, por exemplo
   remote.nvda.es:1234. Se te conectas a un enderezo IPV6, introdúcea entre
   corchetes. Por exemplo: [2603:1020:800:2::32].
5. Introduce unha chave no campo contrasinal, ou preme o botón xerar
   contrasinal. O equipo controlado e todos os seus clientes deben usar a
   mesma chave.
6. Preme aceptar. Feito esto, escoitarás un pitido e conectado. Se o
   servidor inclúe unha mensaxe de benvida, este amosarase nunha Caixa de
   diálogo. Verás este diálogo cada vez que te conectes ou só a primeira
   vez, dependendo da configuración do servidor.

### Avisos de seguridade da conexión

Se te conectas a un servidor cun certificado SSL non válido, recibirás un
aviso sobre a seguridade da conexión.

Esto pode significar que a túa conexión é insegura. Se confías na pegada do
servidor, podes premer "Conectar" para conectarte unha vez, ou "Conectar e
non voltar a preguntar para este servidor" para conectarte e gardar a
pegada.

## Conexións directas

A opción servidor no diálogo conectar permite estabrecer unha conexión
directa.

Unha vez selecionada, escolle o modo en el que se comportará o teu equipo
durante a conexión.

A outra persoa conectarase usando o contrario.

Unha vez selecionado o modo, podes usar o botón obter IP externa para obter
o teu enderezo IP externo e asegurarte de que o porto que introduciches no
campo porto está aberto correctamente. Se está activado no teu router, podes
redirixir o porto usando UPNP antes de comprobar se o porto está aberto.

Se portcheck detecta que o teu porto (por defecto 6837) non está aberto,
aparecerá unha advertencia.

Redirixe o teu porto e proba outra vez. Comproba tamén que se permite o
proceso de NVDA no firewall de Windows.

Nota: o proceso de abrir portos, habilitar UPNP ou configurar o firewall de
Windows está fora do propósito deste documento. Consulta a documentación que
acompaña ao teu router para máis información.

Introduce unha chave no campo contrasinal, ou preme xerar. A outra persoa
necesitará o teu IP externo xunto coa chave para conectar. Se introduciches
un porto distinto ao que se usa por defecto (6837) no campo porto, asegúrate
de que a outra persoa engade o porto alternativo ao enderezo do equipo
usando o formato &lt;ip externo&gt;:&lt;porto&gt;.

Se queres redirixir o porto escollido usando UPNP, marca a Caixa "Usar UPNP
para redirixir este porto se é posible".

Unha vez premas aceptar, estarás conectado. Cando a outra persoa se conecte,
poderás usar TeleNVDA con normalidade.

## Control sobre o equipo remoto

Unha vez a sesión está conectada, o usuario do equipo controlador pode
premer f11 para comezar a controlar o equipo remoto (por exemplo, enviando
pulsacións de teclado ou entrada Braille). Este xesto pódese cambiar dende o
diálogo Xestos de entrada de NVDA.

Cando NVDA diga controlando equipo remoto, as teclas que premas no teu
teclado ou pantalla braille irán ao equipo remoto. Aínda máis, se o equipo
controlador dispón dunha pantalla braille, a información remota amosarase
nela. Preme f11 de novo para deter o envío de pulsacións e voltar ao equipo
controlador.

Para maior compatibilidade, asegúrate de que as distribucións de teclado de
ambos equipos coinciden.

## Compartir a túa sesión

Para compartir un ligazón que permita a alguén máis unirse doadamente a túa
sesión de TeleNVDA, seleciona Copiar ligazón no menú remoto. Tamén se poden
asignar xestos dende o diálogo Xestos de entrada para acelerar esta tarefa.

Podes escoller entre dous formatos de ligazón. O primeiro é compatible tanto
co NVDA Remote coma co TeleNVDA, e é o máis recomendado polo de agora. O
segundo é compatible só co TeleNVDA.

Se estás conectado como controlador, este ligazón permitirá a calquera
conectarse e seren controlado.

Se pola contra confiburaches o teu equipo para ser controlado, o ligazón
permitirá á xente coa que o compartas controlalo.

Moitas aplicacións permiten aos usuarios activar este ligazón
automáticamente, pero se non se abre dende unha aplicación específica, podes
copialo e abrilo dende o diálogo executar.

Ten en conta que o ligazón compartido pode non funcionar se o copias dende
un servidor que funciona en modo de conexión directa.

## Enviar ctrl+alt+supr

Aíndaque o envío de teclas estea activado, a combinación ctrl+alt+supr non
se pode enviar coma o resto.

Se necesitas enviar ctrl+alt+supr, e o sistema remoto atópase no escritorio
seguro, escolle esta opción.

## Enviar tecla de alternar entre equipo local e equipo remoto

Normalmente cando premes o xesto asignado para cambiar entre o equipo local
e o remoto, este non se enviará ao equipo controlado se non que alternará
entre a máquina local e o equipo remoto.

Se necesitas enviar este ou calquera xesto á máquina remota, podes omitir
este comportamento para o seguinte xesto inmediato activando o escript
ignorar o seguinte xesto.

Por defecto, este script está asignado á tecla control + f11. Este xesto
pódese cambiar desde o diálogo Xestos de entrada de NVDA.

Ao chamar a este script, ignorarase o seguinte xesto e enviarase á máquina
remota, incluido o xesto para activar o script ignorar o seguinte
xesto. Unha vez enviado o seguinte xesto, voltará ao comportamento habitual.

## Control remoto dun equipo desatendido

Ás veces podes querer controlar un dos teus proprios equipos
remotamente. Esto é especialmente útil se te atopas viaxando, e queres
controlar o pc de casa dende o portátil, ou controlar un equipo nunha
habitación da túa casa mentres estás fora con outro pc. Cunha preparación un
pouco avanzada esto faise posible.

1. Entra no menú de NVDA, escolle Ferramentas e seguido remoto. Finalmente,
   preme intro en opcións.
2. Marca a Caixa que di "Conectar automáticamente ao servidor de control ao
   comezar".
3. Escolle usar un servidor de control remoto ou aloxar a conexión
   localmente. Se decides aloxar a conexión, podes tentar redirixir os
   portos con UPNP marcando a Caixa proporcionada.
4. Escolle permitir que controlen este equipo no segundo grupo de botóns de
   opción.
5. Se creas o teu proprio servidor, terás que asegurarte de que o porto
   introducido no campo porto (por defecto 6837) está aberto no equipo
   controlado e os equipos controladores poden conectarse a el.
6. Se queres usar un servidor de control remoto, rechea os campos equipo ou
   servidor e contrasinal, preme tabulador ate aceptar, e preme intro. Ten
   en conta que a opción xerar contrasinal non se atopa dispoñible nesta
   situación. É mellor escrebir unha chave que se poda lembrar para que
   podas usala doadamente dende calquera sitio remoto.

Para un uso avanzado, podes tamén configurar o TeleNVDA para que se conecte
a un servidor local ou remoto en modo controlador. Se queres esto, seleciona
controlar outro equipo no segundo grupo de botóns de opción.

Nota: as opcións relacionadas con conectar automáticamente ao comezar no
diálogo de opcións non teñen efecto ate que se reinicia o NVDA.

## Silenciar a voz do equipo remoto

Se non queres oubir a voz do computador remoto ou sons específicos do NVDA,
é tan sinxelo como ir ao menú de NVDA, ferramentas, remoto. Baixa coa frecha
abaixo ate oubir silenciar equipo remoto, e preme intro. Ten en conta que
esta opción non desactivará a saída braille remota á pantalla controladora
cando o equipo controlador estea enviando pulsacións.

## Rematar unha sesión remota

Para rematar unha sesión remota, Fai o seguinte:

1. No equipo controlador, preme f11 para deixar de controlar o equipo
   remoto. Deberías escoitar ou ler a mensaxe: "Controlando equipo
   local". Se en vez deso oes ou lees unha mensaxe dicindo que estás
   controlando o equipo remoto, preme f11 novamente.
2. Acede ao menú de NVDA, ferramentas, remoto, e preme intro en desconectar.

Alternativamente, podes premer NVDA+alt+avance de páxina para desconectar a
sesión directamente. Este xesto pódese cambiar dende o diálogo Xestos de
entrada do NVDA. Para manter a salvo á outra persoa, podes premer este xesto
mentres envías teclas para desconectar o equipo remoto.

## Enviar portapapeis

A opción enviar portapapeis no menú remoto permíteche enviar texto dende o
teu portapapeis.

Cando estea activada, calquera texto no portapapeis enviarase aos outros
equipos.

## Enviar arquivos

A opción Enviar arquivo no menú remoto permite enviar pequenos arquivos a
todos os membros da sesión, incluíndo o equipo controlado. Ten en conta que
só podes enviar arquivos menores de 10 MB. Non se permite enviar ou recibir
arquivos en pantallas seguras.

Ten en conta tamén que enviar arquivos pode consumir demasiado tráfico de
rede no servidor, dependendo do tamaño do arquivo, os computadores
conectados á mesma sesión e a cantidade de arquivos enviados. Contacta co
administrador do teu servidor e pregúntalle se se factura o tráfico. En tal
caso, prantéxate outra plataforma para intercambiar arquivos.

Cando o arquivo se reciba nos equipos remotos, aparecerá una Caixa de
diálogo Gardar como, o que che permitirá escoller ónde gardalo.

## Configurar TeleNVDA para que funcione no escritorio seguro

Para que o TeleNVDA funcione no escritorio seguro, o complemento debe estar
instalado no NVDA que se executa no escritorio seguro.

1. No menú de NVDA, seleciona preferencias, e de seguido opcións xerais.
2. Preme tab ate o botón Usar opcións actualmente gardadas na
   autentificación (logon) e outras pantallas seguras (require privilexios
   de administrador), e preme Intro.
3. Resposta si ás advertencias sobre copiar a configuración e os
   complementos, e resposta á advertencia do control de contas de usuario
   que debería aparecer.
4. Cando a configuración secopiara , preme intro para aceptar a
   confirmación. Preme tabulador ate aceptar e preme intro de novo para
   saíir do diálogo.

Unha vez que o TeleNVDA estea instalado no escritorio seguro, se te
controlan nunha sesión remota, o escritorio seguro terá soporte de voz e
braille cando se entre nel.

## Borrado das pegadas dos certificados SSL

Se xa non queres confiar nas pegadas d servidores nas que confiaches, podes
borrar todas as pegadas de confianza premendo o botón "borrar todas as
pegadas de confianza" dende o diálogo de opcións.

## Uso dun servizo persoalizado de comprobación de portos

Por defecto, o TeleNVDA comproba os portos abertos usando un servizo
proporcionado pola comunidade de NVDA en español. Podes cambiar a URL do
servizo dende o diálogo de opcións. Asegúrate de que o porto a comprobar é
parte da URL persoalizada e os resultados devólvense no formato
esperado. Distribúese un script de mostra para a comprobación de portos no
repositorio do TeleNVDA, polo que podes aloxar a túa propria copia se o
desexas.

## Alteración do TeleNVDA

Este proxecto atópase cuberto pola licenza pública xeral GNU, versión 2 ou
posterior. Podes clonar [este repositorio][2] para facer alteracións ao
TeleNVDA, sempre que leas, entendas e respetes os termos desta licenza. O
módulo MiniUPNP está cuberto por unha licenza BSD de 3 cláusulas.

### Dependencias de terceiros

Pódense instalar con Pip:

* Markdown
* scons

Para compilar o executable manexador de URLs, é necesario dispor de Visual
Studio 2019 ou posterior.

### Para empaquetar o complemento para a súa distribución:

1. Abre unha liña de ordes e cambia á raíz de [este repositorio][2]
2. Executa a orde **scons**. O complemento creado, se non houbo erros,
   atópase no cartafol actual.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
