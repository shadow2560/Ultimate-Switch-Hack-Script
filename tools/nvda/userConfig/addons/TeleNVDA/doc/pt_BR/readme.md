# TeleNVDA #

* Autores: Asociación Comunidad Hispanohablante de NVDA e outros
  colaboradores. Trabalho original de Tyler Spivey e Christopher Toth
* Compatibilidade com NVDA: 2019.3 e posterior
* Download [versão estável][1]

Nota: para facilitar o download para usuários que precisam de assistência ou
treinamento e têm habilidades computacionais limitadas, fornecemos um link
alternativo para a versão estável mais recente que é fácil de lembrar e
compartilhar. Você pode acessar [nvda.es/tele] (https://nvda.es/tele) e
fazer o download do complemento diretamente, sem páginas da Web
intermediárias.

Bem-vindo ao complemento TeleNVDA, que permitirá que você se conecte a outro
computador que esteja executando o leitor de tela gratuito NVDA. Com esse
complemento, você pode se conectar ao computador de outra pessoa ou permitir
que uma pessoa de confiança se conecte ao seu sistema para realizar
manutenção de rotina, diagnosticar um problema ou fornecer treinamento. Esse
complemento é uma versão modificada do [complemento NVDA Remote]
(https://nvdaremote.com) e é mantido pela comunidade espanhola do NVDA. Ele
é totalmente compatível com o NVDA Remote. Estas são as diferenças atuais:

* Um gesto (não atribuído por padrão) informa quantos computadores estão
  conectados a uma sessão remota.
* Uma opção permite o bloqueio de comandos de voz remotos diferentes do
  texto.
* Uma opção permite exibir a mensagem de boas-vindas do servidor (também
  conhecida como mensagem do dia) somente na primeira conexão ou sempre que
  a mensagem for alterada, ignorando as preferências do servidor.
* Uma opção para silenciar a fala remota ao controlar a máquina local e
  ativar o silêncio ao controlar a máquina remota.
* Suporte aprimorado para servidores proxy e serviços ocultos TOR ([Proxy
  support add-on](https://addons.nvda-project.org/addons/proxy.en.html) é
  necessário).
* Capacidade de alterar a tecla f11 para outro gesto. Agora isso funciona
  como um script comum, portanto, você pode atribuir gestos na caixa de
  diálogo Gestos de entrada.
* um gesto (não atribuído por padrão) para abrir as opções do complemento
* Capacidade de atribuir um gesto à opção enviar ctrl+alt+delete na caixa de
  diálogo Gestos de entrada. Atenção: você não deve atribuir as teclas
  ctrl+alt+delete a essa opção. Isso ainda funcionará normalmente, mas
  sempre que você pressionar as teclas ctrl+alt+delete para enviar o
  ctrl+alt+delete para a máquina remota, sua própria máquina também será
  afetada pela função ctrl+alt+delete, o que provavelmente não é o que você
  espera!
* Ao atualizar o complemento, se você tiver instalado o TeleNVDA na área de
  trabalho segura, é recomendável que você também atualize a cópia na área
  de trabalho segura.
* Capacidade de trocar arquivos pequenos (até 10 MB) entre usuários
  conectados à mesma sessão.
* Capacidade de encaminhar portas via UPNP.
* Capacidade de usar um serviço de portcheck personalizado.
* Alguns ajustes na GUI.
* Diversas correções de bugs.

## Antes de começar

Você precisará ter instalado o NVDA em ambos os computadores e obter o
complemento TeleNVDA.

A instalação do NVDA e do complemento TeleNVDA é padrão. Se precisar de mais
informações, elas podem ser encontradas no Guia do usuário do NVDA.

## Atualizando

Ao atualizar o complemento, se você tiver instalado o TeleNVDA na área de
trabalho segura, é recomendável que você também atualize a cópia na área de
trabalho segura.

Para fazer isso, primeiro atualize o complemento existente. Em seguida, abra
o menu NVDA, preferências, configurações gerais e pressione o botão “Use as
configurações salvas atualmente no logon e em outras telas seguras (requer
privilégios administrativos)”.

## Início de uma sessão remota por meio de um servidor de retransmissão

### No computador a ser controlado

1. Abra o menu do NVDA, Ferramentas, Remoto, Connectar. Ou pressione
   diretamente NVDA+alt+page up. Esse gesto pode ser modificado na caixa de
   diálogo de gestos de entrada do NVDA.
2. Escolha cliente no primeiro botão de rádio.
3. Selecione Permitir que essa máquina seja controlada no segundo conjunto
   de botões de rádio.
4. No campo servidor, digite o host do servidor ao qual você está se
   conectando, por exemplo, remote.nvda.es. Quando o servidor específico usa
   uma porta alternativa, você pode inserir o servidor no formato
   &lt;host&gt;:&lt;port&gt;, por exemplo, remote.nvda.es:1234. Se estiver
   se conectando a um endereço IPV6, digite-o entre colchetes, por exemplo,
   [2603:1020:800:2::32].
5. Digite umm código no campo de código ou pressione o botão gerar código. O
   código é o que outras pessoas usarão para controlar seu computador. A
   máquina que está sendo controlada e todos os seus clientes precisam usar
   o mesmo código.
6. Pressione ok. Quando terminar, você ouvirá um tom e estará conectado. Se
   o servidor incluir uma mensagem do dia, ela será exibida em uma caixa de
   diálogo. Você verá essa caixa de diálogo sempre que se conectar ou
   somente na primeira vez, dependendo da configuração do servidor.

### No computador que será a máquina de controle

1. Abra o menu do NVDA, Ferramentas, Remoto, Connectar. Ou pressione
   diretamente NVDA+alt+page up. Esse gesto pode ser modificado na caixa de
   diálogo de gestos de entrada do NVDA.
2. Escolha cliente no primeiro botão de rádio.
3. Selecione Controlar outro computador no segundo conjunto de botões de
   rádio.
4. No campo servidor, digite o host do servidor ao qual você está se
   conectando, por exemplo, remote.nvda.es. Quando o servidor específico usa
   uma porta alternativa, você pode inserir o servidor no formato
   &lt;host&gt;:&lt;port&gt;, por exemplo, remote.nvda.es:1234. Se estiver
   se conectando a um endereço IPV6, digite-o entre colchetes, por exemplo,
   [2603:1020:800:2::32].
5. Digite um código no campo ou pressione o botão gerar código. A máquina
   que está sendo controlada e todos os seus clientes precisam usar o mesmo
   código.
6. Pressione ok. Quando terminar, você ouvirá um tom e estará conectado. Se
   o servidor incluir uma mensagem do dia, ela será exibida em uma caixa de
   diálogo. Você verá essa caixa de diálogo sempre que se conectar ou
   somente na primeira vez, dependendo da configuração do servidor.

### Aviso de segurança da conexão

Se você se conectar a um servidor sem um certificado SSL válido, receberá um
aviso de segurança de conexão.

Isso pode significar que sua conexão não é segura. Se você confiar na
impressão digital desse servidor, poderá pressionar “Conectar” (Conectar)
para se conectar uma vez ou “Conecte-se e não solicite novamente esse
servidor” (Conectar e não perguntar novamente por este servidor) para se
conectar e salvar a impressão digital.

## Conexões diretas

A opção de servidor na caixa de diálogo de conexão permite que você
configure uma conexão direta.

Depois de selecionar isso, selecione o modo em que sua extremidade da
conexão estará.

A outra pessoa se conectará a você usando o oposto.

Depois que o modo for selecionado, você poderá usar o botão Get External IP
para obter o endereço IP externo e verificar se a porta inserida no campo da
porta foi encaminhada corretamente. Se estiver ativado no roteador, você
poderá encaminhar a porta usando UPNP antes de executar a verificação de
porta.

Se o portcheck detectar que sua porta (6837 por padrão) não pode ser
acessada, será exibido um aviso.

Encaminhe sua porta e tente novamente. Além disso, certifique-se de que o
processo do NVDA seja permitido pelo firewall do Windows.

Nota: o processo de encaminhamento de portas, ativação de UPNP ou
configuração do firewall do Windows está fora do escopo deste
documento. Consulte as informações fornecidas com o seu roteador para obter
mais instruções.

Digite um código no campo ou pressione gerar. A outra pessoa precisará de
seu IP externo junto com a chave para se conectar. Se você inseriu uma porta
diferente da padrão (6837) no campo da porta, certifique-se de que a outra
pessoa anexe a porta alternativa ao endereço do host no formato &lt;external
ip&gt;:&lt;port&gt;.

Se você quiser encaminhar a porta escolhida usando UPNP, ative a caixa de
seleção “Use UPNP to forward this port if possible”.

Quando ok for pressionado, você será conectado. Quando a outra pessoa se
conectar, você poderá usar o TeleNVDA normalmente.

## Controle da máquina remota

Quando a sessão estiver conectada, o usuário da máquina controladora poderá
pressionar f11 para começar a controlar a máquina remota (por exemplo,
enviando teclas do teclado ou entrada em braile). Esse gesto pode ser
alterado na caixa de diálogo Gestos de entrada do NVDA.

Quando o NVDA diz que está controlando a máquina remota, as teclas do
teclado e do visor em braile que você pressionar irão para a máquina
remota. Além disso, quando a máquina de controle estiver usando um visor em
braile, as informações da máquina remota serão exibidas nele. Pressione f11
novamente para interromper o envio de teclas e voltar para a máquina de
controle.

Para obter a melhor compatibilidade, certifique-se de que os layouts de
teclado de ambas as máquinas sejam iguais.

## Compartilhando sua sessão

Para compartilhar um link para que outra pessoa possa entrar facilmente na
sua sessão do TeleNVDA, selecione Copiar link no menu Remoto. Você também
pode atribuir gestos na caixa de diálogo Gestos de entrada do NVDA para
acelerar essa tarefa.

Você pode escolher entre dois formatos de link. O primeiro é compatível com
o NVDA Remote e o TeleNVDA e, por enquanto, é o mais recomendado. O segundo
é compatível apenas com o TeleNVDA.

SE você estiver conectado como o computador de controle, esse link permitirá
que outra pessoa se conecte e seja controlada.

Se, em vez disso, você tiver configurado seu computador para ser controlado,
o link permitirá que as pessoas com quem você o compartilha controlem sua
máquina.

Muitos aplicativos permitirão que os usuários ativem esse link
automaticamente, mas se ele não for executado em um aplicativo específico,
poderá ser copiado para a área de transferência e executado na caixa de
diálogo Executar.

Note que o link compartilhado pode não funcionar se você o copiar de um
servidor em execução no modo de conexão direta.

## Enviar Ctrl+Alt+Del

Ao enviar teclas, não é possível enviar a combinação CTRL+Alt+del
normalmente.

Se você precisar enviar CTRL+Alt+del e o sistema remoto estiver na área de
trabalho segura, use esse comando. Você também pode atribuir um gesto a esse
comando na caixa de diálogo Gestos de entrada.

## Enviar tecla de alternância entre o computador local e o remoto

Normalmente, quando você pressiona o gesto atribuído para alternar entre a
máquina local e a remota, ele não é enviado para a máquina remota; em vez
disso, ele alterna entre a máquina local e a remota.

Se precisar enviar esse ou qualquer outro gesto para a máquina remota, você
poderá substituir esse comportamento para o próximo gesto imediato ativando
o script ignorar próximo gesto.

Por padrão, esse script é atribuído à tecla control + f11. Esse gesto pode
ser alterado na caixa de diálogo Gestos de entrada do NVDA.

Quando esse script for chamado, o próximo gesto será ignorado e enviado para
a máquina remota, incluindo o gesto para ativar o script ignorar próximo
gesto. Depois que o próximo gesto tiver sido enviado, ele voltará ao
comportamento normal.

## Controle remoto de um computador sem supervisão

Às vezes, você pode querer controlar um de seus próprios computadores
remotamente. Isso é especialmente útil se estiver viajando e quiser
controlar o PC de sua casa pelo laptop. Ou, talvez queira controlar um
computador em um cômodo da casa enquanto está sentado do lado de fora com
outro PC. Um pouco de preparação avançada torna isso conveniente e possível.

1. Acesse o menu do NVDA e escolha Ferramentas e Remoto. Por fim, pressione
   Enter em Opções.
2. Marque a caixa que diz  Conexão automática ao servidor de controle na
   inicialização.
3. Selecione se deseja usar um servidor de retransmissão remota ou hospedar
   a conexão localmente. Se decidir hospedar a conexão, você poderá tentar
   encaminhar portas usando UPNP marcando a caixa de seleção fornecida.
4. Selecione Permitir que essa máquina seja controlada no segundo conjunto
   de botões de rádio.
5. Se você mesmo hospedar a conexão, precisará garantir que a porta inserida
   no campo de porta (6837 por padrão) na máquina controlada possa ser
   acessada pelas máquinas controladoras.
6. Se desejar usar um servidor de retransmissão, preencha os campos servidor
   e código, pressione a guia OK e pressione Enter. A opção Gerar código não
   está disponível nessa situação. É melhor criar uma chave da qual você se
   lembrará para poder usá-la facilmente em qualquer local remoto.

Para uso avançado, também é possível configurar o NVDA Remote para se
conectar automaticamente a um servidor de retransmissão local ou remoto no
modo de controle. Se quiser fazer isso, selecione Controlar outra máquina no
segundo conjunto de botões de rádio.

Nota: as opções relacionadas à conexão automática na inicialização na caixa
de diálogo de opções não se aplicam até que o NVDA seja reiniciado.

## Silenciar a fala no computador remoto

Se não quiser ouvir a fala do computador remoto ou os sons específicos do
NVDA, basta acessar o menu NVDA, Ferramentas e Remoto. Use a seta para baixo
até silenciar remoto e pressione Enter. Você pode atribuir um gesto a essa
opção na caixa de diálogo Gestos de entrada do NVDA. Observe que essa opção
não desativará a saída remota de braile para a tela de controle quando a
máquina de controle estiver enviando teclas.

Você pode silenciar permanentemente a fala remota enquanto trabalha em sua
máquina local, ativando essa configuração na categoria TeleNVDA na caixa de
diálogo de configurações do NVDA.

## Encerramento de uma sessão remota

Para encerrar uma sessão remota, faça o seguinte:

1. No computador de controle, pressione F11 para parar de controlar a
   máquina remota. Você deverá ouvir ou ler a mensagem: “Controlando a
   máquina local”. Se, em vez disso, ouvir ou ler uma mensagem de que está
   controlando a máquina remota, pressione F11 mais uma vez.
2. Acesse o menu NVDA, depois Ferramentas, Remoto e pressione Enter em
   desconectar.

Como alternativa, você pode pressionar NVDA+alt+page down para desconectar
diretamente a sessão. Esse gesto pode ser alterado na caixa de diálogo
Gestos de entrada do NVDA. Para manter a outra extremidade segura, você pode
pressionar esse gesto ao enviar teclas para desconectar o computador remoto.

## Enviar para área de transferência

A opção Enviar para área de transferência no menu remoto permite que você
envie o texto da área de transferência.

Quando ativado, qualquer texto na área de transferência será enviado para as
outras máquinas.

## Envio de arquivos

A opção Enviar arquivo no menu remoto permite enviar arquivos pequenos para
todos os membros da sessão, inclusive para a máquina controlada. Observe que
só é possível enviar arquivos com menos de 10 MB. Não é permitido enviar ou
receber arquivos em telas seguras.

Observe também que o envio de arquivos pode consumir muito tráfego de rede
no servidor, dependendo do tamanho , dos computadores conectados à mesma
sessão e da quantidade de arquivos enviados. Entre em contato com o
administrador do servidor e pergunte se o tráfego é cobrado. Nesse caso,
considere a possibilidade de usar outra plataforma para trocar arquivos.

Quando o arquivo for recebido nas máquinas remotas, uma caixa de diálogo
Salvar como será exibida, permitindo que você escolha onde salvá-lo.

## Configuração do TeleNVDA para funcionar em uma área de trabalho segura

Para que o TeleNVDA funcione na área de trabalho segura, o complemento deve
ser instalado no NVDA em execução na área de trabalho segura.

1. No menu do NVDA, selecione Preferências e, em seguida, Configurações
   gerais.
2. Selecione o botão Use Configurações salvas no momento em telas de logon e
   outras telas seguras  (requer privilégios administrativos) e pressione
   Enter.
3. Responda Yes aos avisos sobre a cópia de suas configurações e sobre a
   cópia de plug-ins e responda ao aviso de Controle de Conta de Usuário que
   pode ser exibido.
4. Quando as configurações forem copiadas, pressione Enter para dispensar o
   botão OK. Pressione Tab para OK e Enter mais uma vez para sair da caixa
   de diálogo.

Depois que o TeleNVDA for instalado na área de trabalho segura, se você
estiver sendo controlado em uma sessão remota, terá acesso à fala e ao
braile na área de trabalho segura quando alternar para ela.

## Limpeza de impressões digitais de certificados SSL

Se você não quiser mais confiar nas impressões digitais do servidor em que
confiou, poderá limpar todas as impressões digitais confiáveis pressionando
o botão “Excluir todas as impressões digitais confiáveis” na caixa de
diálogo Opções.

## Uso de um serviço de portcheck personalizado

Por padrão, o TeleNVDA verifica as portas abertas usando um serviço
fornecido pela comunidade espanhola do NVDA. Você pode alterar o URL do
serviço na caixa de diálogo de opções. Verifique se a porta a ser verificada
faz parte do URL personalizado e se os resultados são retornados no formato
esperado. Um script de amostra de verificação de porta é distribuído no
repositório TeleNVDA, portanto, você pode hospedar sua própria cópia, se
desejar.

## Alteração do TeleNVDA

Este projeto é coberto pela Licença Pública Geral GNU, versão 2 ou
posterior. Você pode clonar [este repositório][2] para fazer alterações no
TeleNVDA, desde que leia, compreenda e respeite os termos da licença. O
módulo MiniUPNP está licenciado sob uma licença BSD-3 clause.

### Dependências de terceiros

Eles podem ser instalados com o pip:

* Markdown
* scons

Para criar o executável do manipulador de URL, você precisa do Visual Studio
2019 ou posterior.

### Para empacotar o complemento para distribuição:

1. Abra uma linha de comando, mude para a raiz de [este repositório][2]
2. Execute o comando **scons**. O add-on criado, se não houver erros, será
   colocado no diretório atual.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
