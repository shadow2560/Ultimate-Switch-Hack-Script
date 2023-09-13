# TeleNVDA #

* Autores: Asociación Comunidad Hispanohablante de NVDA y otros
  colaboradores. Trabajo original de Tyler Spivey y Christopher Toth
* Compatibilidad con NVDA: de 2019.3 en adelante
* Descargar [versión estable][1]

Nota: para facilitar la descarga a usuarios que necesitan asistencia o
formación y tienen conocimientos limitados en informática, proporcionamos un
enlace alternativo a la versión estable más reciente que es fácil de
recordar y compartir. Puedes ir a [nvda.es/tele](https://nvda.es/tele) y
descargar el complemento directamente, sin páginas web intermedias.

Bienvenido al complemento TeleNVDA, que te permitirá conectarte a otro
equipo que ejecute el lector de pantalla gratuito NVDA. Puedes conectarte al
equipo de otra persona, o permitir a una persona de confianza que se conecte
a tu sistema para realizar un mantenimiento rutinario, diagnosticar un
problema, o enseñarte algo. Este complemento es una versión modificada del
[complemento NVDARemote](https://nvdaremote.com), y su mantenimiento está a
cargo de la comunidad hispanohablante de NVDA. Es totalmente compatible con
NVDA Remote. Estas son las diferencias actuales:

* Una opción permite bloquear los comandos remotos de voz que no sean texto.
* Soporte mejorado para servidores proxy y servicios ocultos TOR (es
  necesario el [complemento Soporte
  Proxy](https://addons.nvda-project.org/addons/proxy.es.html)).
* Posibilidad de cambiar la tecla f11 por otro gesto. Ahora funciona como un
  script común, por lo que puedes asignar otros gestos en el diálogo "Gestos
  de entrada".
* Capacidad de ignorar completamente el siguiente gesto inmediato, es útil
  si necesitas enviar a la máquina remota el gesto utilizado para alternar
  entre el equipo local y la máquina remota.
* Posibilidad de intercambiar pequeños ficheros (hasta 10 MB) entre usuarios
  conectados a la misma sesión.
* Posibilidad de redirigir puertos mediante UPNP.
* Posibilidad de usar un servicio de comprobación de puertos personalizado.
* Algunos retoques a la interfaz gráfica.
* Varias correcciones de fallos.

## Antes de empezar

Es necesario tener instalado NVDA en ambos equipos, y obtener el complemento
TeleNVDA.

La instalación de NVDA y del complemento no varía con respecto a otras. Si
necesitas más información, puedes encontrarla en la guía de usuario de NVDA.

## Actualizaciones

Cuando actualices el complemento, si has instalado TeleNVDA en el escritorio
seguro, es recomendable que lo actualices también allí.

Para hacerlo, primero actualiza el complemento normalmente. Después, abre el
menú de NVDA, preferencias, Opciones Generales, y pulsa el botón etiquetado
como "Utilizar opciones actualmente guardadas en la autentificación (logon)
y otras pantallas seguras (requiere privilegios de administrador)".

## Iniciar una sesión remota a través de un servidor externo

### En el equipo controlado

1. Abre el menú de NVDA, herramientas, remoto, conectar. O pulsa
   directamente NVDA+alt+retroceso página. Se puede modificar este gesto
   desde el diálogo Gestos de entrada de NVDA.
2. Elige cliente en el primer grupo de botones de opción.
3. Elige permitir que controlen este equipo en el segundo grupo de botones
   de opción.
4. En el campo equipo o servidor, introduce el servidor al que te vas a
   conectar, por ejemplo remote.nvda.es. Cuando el servidor use un puerto
   distinto al que este complemento utiliza por defecto, puedes introducir
   su dirección en formato &lt;equipo&gt;:&lt;puerto&gt;, por ejemplo
   remote.nvda.es:1234. Si te conectas a una dirección IPV6, introdúcela
   entre corchetes. Por ejemplo: [2603:1020:800:2::32].
5. Introduce una clave en el campo clave, o pulsa el botón generar clave. La
   clave es lo que otros usarán para controlar tu equipo. El equipo
   controlado y todos sus clientes deben usar la misma clave.
6. Pulsa aceptar. Hecho esto, escucharás un pitido y conectado. Si el
   servidor incluye un mensaje de bienvenida, este se mostrará en un cuadro
   de diálogo. Verás este diálogo cada vez que te conectes o sólo la primera
   vez, dependiendo de la configuración del servidor.

### En el equipo desde el que se controla

1. Abre el menú de NVDA, herramientas, remoto, conectar. O pulsa
   directamente NVDA+alt+retroceso página. Se puede modificar este gesto
   desde el diálogo Gestos de entrada de NVDA.
2. Elige cliente en el primer grupo de botones de opción.
3. Selecciona controlar otro equipo en el segundo grupo de botones de
   opción.
4. En el campo equipo o servidor, introduce el servidor al que te vas a
   conectar, por ejemplo remote.nvda.es. Cuando el servidor use un puerto
   distinto al que este complemento utiliza por defecto, puedes introducir
   su dirección en formato &lt;equipo&gt;:&lt;puerto&gt;, por ejemplo
   remote.nvda.es:1234. Si te conectas a una dirección IPV6, introdúcela
   entre corchetes. Por ejemplo: [2603:1020:800:2::32].
5. Introduce una clave en el campo clave, o pulsa el botón generar clave. El
   equipo controlado y todos sus clientes deben usar la misma clave.
6. Pulsa aceptar. Hecho esto, escucharás un pitido y conectado. Si el
   servidor incluye un mensaje de bienvenida, este se mostrará en un cuadro
   de diálogo. Verás este diálogo cada vez que te conectes o sólo la primera
   vez, dependiendo de la configuración del servidor.

### Avisos de seguridad de la conexión

Si te conectas a un servidor con un certificado SSL no válido, recibirás un
aviso sobre la seguridad de la conexión.

Esto puede significar que tu conexión es insegura. Si confías en la huella
del servidor, puedes pulsar "Conectar" para conectarte una vez, o "Conectar
y no volver a preguntar para este servidor" para conectarte y guardar la
huella.

## Conexiones directas

La opción servidor en el diálogo conectar permite establecer una conexión
directa.

Una vez seleccionada, elige el modo en el que se comportará tu equipo
durante la conexión.

La otra persona se conectará usando el contrario.

Una vez seleccionado el modo, puedes usar el botón obtener IP externa para
obtener tu dirección IP externa y asegurarte de que el puerto que has
introducido en el campo puerto está abierto correctamente. Si está activado
en tu router, puedes redirigir el puerto usando UPNP antes de comprobar si
el puerto está abierto.

Si portcheck detecta que tu puerto (por defecto 6837) no está abierto,
aparecerá una advertencia.

Redirige tu puerto y prueba otra vez. Comprueba también que se permite el
proceso de NVDA en el firewall de Windows.

Nota: el proceso de abrir puertos, habilitar UPNP o configurar el firewall
de Windows está fuera del propósito de este documento. Consulta la
documentación que acompaña a tu router para más información.

Introduce una clave en el campo clave, o pulsa generar. La otra persona
necesitará tu IP externa junto con la clave para conectar. Si has
introducido un puerto distinto al que se usa por defecto (6837) en el campo
puerto, asegúrate de que la otra persona añade el puerto alternativo a la
dirección del equipo usando el formato &lt;ip externa&gt;:&lt;puerto&gt;.

Si quieres redirigir el puerto elegido usando UPNP, marca la casilla "Usar
UPNP para redirigir este puerto si es posible".

Una vez pulses aceptar, estarás conectado. Cuando la otra persona se
conecte, podrás usar TeleNVDA con normalidad.

## Control sobre el equipo remoto

Una vez la sesión está conectada, el usuario del equipo controlador puede
pulsar f11 para empezar a controlar el equipo remoto (por ejemplo, enviando
pulsaciones de teclado o entrada Braille). Este gesto se puede cambiar desde
el diálogo Gestos de entrada de NVDA.

Cuando NVDA diga controlando equipo remoto, las teclas que pulses en tu
teclado o pantalla braille irán al equipo remoto. Más aún, si el equipo
controlador dispone de una pantalla braille, la información remota se
mostrará en ella. Pulsa f11 de nuevo para detener el envío de pulsaciones y
volver al equipo controlador.

Para mayor compatibilidad, asegúrate de que las distribuciones de teclado de
ambos equipos coinciden.

## Compartir tu sesión

Para compartir un enlace que permita a alguien más unirse fácilmente a tu
sesión de TeleNVDA, selecciona Copiar enlace en el menú remoto. También se
pueden asignar gestos desde el diálogo Gestos de entrada para acelerar esta
tarea.

Puedes elegir entre dos formatos de enlace. El primero es compatible tanto
con NVDA Remote como con TeleNVDA, y es el más recomendado por ahora. El
segundo es compatible sólo con TeleNVDA.

Si estás conectado como controlador, este enlace permitirá a cualquiera
conectarse y ser controlado.

Si por el contrario has configurado tu equipo para ser controlado, el enlace
permitirá a la gente con la que lo compartas controlarlo.

Muchas aplicaciones permiten a los usuarios activar este enlace
automáticamente, pero si no se abre desde una aplicación específica, puedes
copiarlo y abrirlo desde el diálogo ejecutar.

Ten en cuenta que el enlace compartido puede no funcionar si lo copias desde
un servidor que funciona en modo de conexión directa.

## Enviar ctrl+alt+supr

Aunque el envío de teclas esté activado, la combinación ctrl+alt+supr no se
puede enviar como el resto.

Si necesitas enviar ctrl+alt+supr, y el sistema remoto se encuentra en el
escritorio seguro, elige esta opción.

## Enviar tecla de alternar entre equipo local y equipo remoto

Usualmente cuando pulsas el gesto asignado para cambiar entre el equipo
local y el remoto, este no se enviará al equipo controlado si no que
alternará entre la máquina local y el equipo remoto.

Si necesitas enviar este o cualquier gesto a la máquina remota, puedes
omitir este comportamiento para el siguiente gesto inmediato activando el
escript ignorar el siguiente gesto.

Por defecto, este script está asignado a la tecla control + f11. Este gesto
se puede cambiar desde el diálogo Gestos de entrada de NVDA.

Al llamar a este script, se ignorará el siguiente gesto y se enviará a la
máquina remota, incluido el gesto para activar el script ignorar el
siguiente gesto. Una vez enviado el siguiente gesto, regresará al
comportamiento habitual.

## Control remoto de un equipo desatendido

A veces puedes querer controlar uno de tus propios equipos remotamente. Esto
es especialmente útil si te encuentras viajando, y quieres controlar el pc
de casa desde el portátil, o controlar un equipo en una habitación de tu
casa mientras estás fuera con otro pc. Con una preparación un poco avanzada
esto se hace posible.

1. Entra en el menú de NVDA, elige herramientas y a continuación
   remoto. Finalmente, pulsa intro en opciones.
2. Marca la casilla que dice "Conectar automáticamente al servidor de
   control al arrancar".
3. Elige usar un servidor de control remoto o alojar la conexión
   localmente. Si decides alojar la conexión, puedes intentar redirigir los
   puertos con UPNP marcando la casilla proporcionada.
4. Elige permitir que controlen este equipo en el segundo grupo de botones
   de opción.
5. Si creas tu propio servidor, tendrás que asegurarte de que el puerto
   introducido en el campo puerto (por defecto 6837) está abierto en el
   equipo controlado y los equipos controladores pueden conectarse a él.
6. Si quieres usar un servidor de control remoto, rellena los campos equipo
   o servidor y clave, pulsa tabulador hasta aceptar, y pulsa intro. Ten en
   cuenta que la opción generar clave no se encuentra disponible en esta
   situación. Es mejor escribir una clave que se pueda recordar para que
   puedas usarla fácilmente desde cualquier lugar remoto.

Para un uso avanzado, puedes también configurar TeleNVDA para que se conecte
a un servidor local o remoto en modo controlador. Si quieres esto,
selecciona controlar otro equipo en el segundo grupo de botones de opción.

Nota: las opciones relacionadas con conectar automáticamente al arrancar en
el diálogo de opciones no tienen efecto hasta que se reinicia NVDA.

## Silenciar la voz del equipo remoto

Si no quieres oír la voz del ordenador remoto o sonidos específicos de NVDA,
es tan simple como ir al menú de NVDA, herramientas, remoto. Baja con flecha
abajo hasta oír silenciar equipo remoto, y pulsa intro. Ten en cuenta que
esta opción no desactivará la salida braille remota a la pantalla
controladora cuando el equipo controlador esté enviando pulsaciones.

## Finalizar una sesión remota

Para finalizar una sesión remota, haz lo siguiente:

1. En el equipo controlador, pulsa f11 para dejar de controlar el equipo
   remoto. Deberías escuchar o leer el mensaje: "Controlando equipo
   local". Si en vez de eso oyes o lees un mensaje diciendo que estás
   controlando el equipo remoto, pulsa f11 nuevamente.
2. Accede al menú de NVDA, herramientas, remoto, y pulsa intro en
   desconectar.

Alternativamente, puedes pulsar NVDA+alt+avance página para desconectar la
sesión directamente. Este gesto se puede cambiar desde el diálogo Gestos de
entrada de NVDA. Para mantener a salvo a la otra persona, puedes pulsar este
gesto mientras envías teclas para desconectar el equipo remoto.

## Enviar portapapeles

La opción enviar portapapeles en el menú remoto te permite enviar texto
desde tu portapapeles.

Cuando esté activada, cualquier texto en el portapapeles se enviará a los
otros equipos.

## Enviar archivos

La opción Enviar archivo en el menú remoto permite enviar pequeños archivos
a todos los miembros de la sesión, incluyendo el equipo controlado. Ten en
cuenta que sólo puedes enviar archivos menores de 10 MB. No se permite
enviar o recibir archivos en pantallas seguras.

Ten en cuenta también que enviar archivos puede consumir demasiado tráfico
de red en el servidor, dependiendo del tamaño del archivo, los ordenadores
conectados a la misma sesión y la cantidad de archivos enviados. Contacta
con el administrador de tu servidor y pregúntale si se factura el
tráfico. En tal caso, plantéate otra plataforma para intercambiar archivos.

Cuando el archivo se reciba en los equipos remotos, aparecerá un cuadro de
diálogo Guardar como, lo que te permitirá elegir dónde guardarlo.

## Configurar TeleNVDA para que funcione en el escritorio seguro

Para que TeleNVDA funcione en el escritorio seguro, el complemento debe
estar instalado en el NVDA que se ejecuta en el escritorio seguro.

1. En el menú de NVDA, selecciona preferencias, y a continuación opciones
   generales.
2. Pulsa tabulador hasta el botón Utilizar opciones actualmente guardadas en
   la autentificación (logon) y otras pantallas seguras (requiere
   privilegios de administrador), y pulsa Intro.
3. Responde sí a las advertencias sobre copiar la configuración y los
   complementos, y responde a la advertencia del control de cuentas de
   usuario que debería aparecer.
4. Cuando la configuración se haya copiado, pulsa intro para aceptar la
   confirmación. Pulsa tabulador hasta aceptar y pulsa intro de nuevo para
   salir del diálogo.

En cuanto TeleNVDA esté instalado en el escritorio seguro, si te controlan
en una sesión remota, el escritorio seguro tendrá soporte de voz y braille
cuando se entre en él.

## Eliminación de las huellas de los certificados SSL

Si ya no quieres confiar en huellas de servidores en las que has confiado,
puedes eliminar todas las huellas de confianza pulsando el botón "Eliminar
todas las huellas de confianza" desde el diálogo de opciones.

## Uso de un servicio personalizado de comprobación de puertos

Por defecto, TeleNVDA comprueba los puertos abiertos usando un servicio
proporcionado por la comunidad de NVDA en español. Puedes cambiar la URL del
servicio desde el diálogo de opciones. Asegúrate de que el puerto a
comprobar es parte de la URL personalizada y los resultados se devuelven en
el formato esperado. Se distribuye un script de muestra para la comprobación
de puertos en el repositorio de TeleNVDA, por lo que puedes alojar tu propia
copia si lo deseas.

## Alteración de TeleNVDA

Este proyecto se encuentra cubierto por la licencia pública general GNU,
versión 2 o posterior. Puedes clonar [este repositorio][2] para hacer
alteraciones a TeleNVDA, siempre que leas, entiendas y respetes los términos
de esta licencia. El módulo MiniUPNP está cubierto por una licencia BSD de 3
cláusulas.

### Dependencias de terceros

Se pueden instalar con Pip:

* Markdown
* scons

Para compilar el ejecutable manejador de URLs, es necesario disponer de
Visual Studio 2019 o posterior.

### Para empaquetar el complemento para su distribución:

1. Abre una línea de órdenes y cambia a la raíz de [este repositorio][2]
2. Ejecuta la orden **scons**. El complemento creado, si no hubo errores, se
   encuentra en la carpeta actual.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
