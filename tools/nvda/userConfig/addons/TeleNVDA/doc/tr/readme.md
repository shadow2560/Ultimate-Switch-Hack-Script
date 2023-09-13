# TeleNVDA #

* Yazarlar: NVDA İspanyol Topluluğu Derneği ve diğer katkıda
  bulunanlar. Tyler Spivey ve Christopher Toth'un orijinal çalışması
* NVDA Uyumluluğu: 2019.3 ve sonrası
* [Kararlı sürümü indir][1]

Not: Yardıma veya eğitime ihtiyaç duyan ve sınırlı bilgi işlem becerilerine
sahip kullanıcılar için indirmeyi kolaylaştırmak amacıyla, hatırlaması ve
paylaşması kolay en son kararlı sürüme alternatif bir bağlantı
sağlıyoruz. [nvda.es/tele](https://nvda.es/tele) adresine gidip eklentiyi
ara web sayfaları olmadan doğrudan indirebilirsiniz.

Ücretsiz NVDA ekran okuyucusunu çalıştıran başka bir bilgisayara
bağlanmanızı sağlayacak TeleNVDA eklentisine hoş geldiniz. Bu eklenti ile
başka bir kişinin bilgisayarına bağlanabilir veya güvendiğiniz bir kişinin
rutin bakım yapmak, bir sorunu teşhis etmek veya eğitim vermek için
sisteminize bağlanmasına izin verebilirsiniz. Bu eklenti, [NVDA Uzaktan
Destek eklentisinin](https://nvdaremote.com) değiştirilmiş bir versiyonudur
ve NVDA ispanyol topluluğu tarafından sağlanmaktadır. NVDA Uzaktan Destek
ile tamamen uyumludur. Var olan farklılıklar aşağıdaki gibidir:

* Bir seçenek, metinden farklı uzaktan konuşma komutlarının engellenmesini
  sağlar.
* Proxy sunucuları ve TOR gizli hizmetleri için geliştirilmiş destek ([Proxy
  desteği eklentisi](https://addons.nvda-project.org/addons/proxy.en.html)
  gereklidir).
* F11 tuşunu başka bir hareketle değiştirebilme. Şimdi bu ortak bir komut
  olarak çalışır, böylece "Girdi Hareketleri" iletişim kutusunda hareketleri
  atayabilirsiniz.
* Bir sonraki hareketi tamamen görmezden gelme yeteneği, ana makine ile uzak
  makine arasında geçiş yapmak için kullanılan hareketi uzak makineye
  göndermeniz gerekiyorsa kullanışlıdır.
* Aynı oturuma bağlı kullanıcılar arasında küçük dosya alışverişi (10 MB'a
  kadar) yapabilme.
* UPNP aracılığıyla bağlantı noktalarını iletme yeteneği.
* Özel bir portcheck hizmeti kullanabilme.
* Bazı GUI düzenlemeleri.
* Birkaç hata düzeltmesi.

## Başlamadan Önce

NVDA'yı her iki bilgisayara da kurmuş olmanız ve TeleNVDA eklentisini
edinmiş olmanız gerekir.

Hem NVDA'nın hem de TeleNVDA eklentisinin kurulumu standarttır. Daha fazla
bilgiye ihtiyaç duyarsanız, bu NVDA Kullanıcı Kılavuzunda bulunabilir.

## Güncelleştirme

Eklentiyi güncellerken, TeleNVDA'yı güvenli masaüstüne yüklediyseniz,
kopyayı güvenli masaüstünde de güncellemeniz önerilir.

Bunun için öncelikle mevcut eklentinizi güncelleyin. Ardından NVDA menüsünü,
tercihleri, Ayarlar, geneli açın ve "Oturum açma ve diğer güvenli ekranlarda
(yönetici ayrıcalıkları gerektirir) şu anda kayıtlı ayarları kullan"
etiketli düğmeye basın.

## Aktarıcı sunucu üzerinden uzak oturum başlatma

### Kontrol edilecek bilgisayarda

1. NVDA menüsü, Araçlar, Uzak bağlantı, Bağlan'ı açın. Veya doğrudan
   NVDA+alt+Sonraki sayfa tuşlarına basın. Bu hareket, NVDA girdi
   hareketleri iletişim kutusundan değiştirilebilir.
2. İlk radyo düğmesinde istemciyi seçin.
3. İkinci radyo düğmesi setinde Bu bilgisayarın kontrol edilmesine izin ver
   öğesini seçin.
4. Ana bilgisayar alanına, bağlandığınız sunucunun ana bilgisayarını girin,
   örneğin remote.nvda.es. Belirli bir sunucu alternatif bir bağlantı
   noktası kullandığında, ana bilgisayarı <host>:<port> biçiminde
   girebilirsiniz, örneğin remote.nvda.es:1234. Bir IPV6 adresine
   bağlanıyorsanız, bunu köşeli parantezler arasında girin, örneğin
   [2603:1020:800:2::32].
5. Anahtar alanına bir anahtar girin veya anahtar oluştur düğmesine
   basın. Anahtar, başkalarının bilgisayarınızı kontrol etmek için
   kullanacağı şeydir. Kontrol edilen makine ve tüm istemcilerinin aynı
   anahtarı kullanması gerekir.
6. Tamam tuşuna basın. Bittiğinde, bir ses duyacaksınız ve
   bağlanacaksınız. Sunucu günün mesajını içeriyorsa, bir iletişim kutusunda
   görüntülenecektir. Sunucu yapılandırmasına bağlı olarak, her
   bağlandığınızda veya yalnızca ilk kez bu iletişim kutusunu göreceksiniz.

### Kontrol bilgisayarı olacak makinede

1. NVDA menüsü, Araçlar, Uzak bağlantı, Bağlan'ı açın. Veya doğrudan
   NVDA+alt+Sonraki sayfa tuşlarına basın. Bu hareket, NVDA girdi
   hareketleri iletişim kutusundan değiştirilebilir.
2. İlk radyo düğmesinde istemciyi seçin.
3. İkinci radyo düğmesi setinde Başka bir bilgisayarı yönet seçeneğini
   belirleyin.
4. Ana bilgisayar alanına, bağlandığınız sunucunun ana bilgisayarını girin,
   örneğin remote.nvda.es. Belirli bir sunucu alternatif bir bağlantı
   noktası kullandığında, ana bilgisayarı <host>:<port> biçiminde
   girebilirsiniz, örneğin remote.nvda.es:1234. Bir IPV6 adresine
   bağlanıyorsanız, bunu köşeli parantezler arasında girin, örneğin
   [2603:1020:800:2::32].
5. Anahtar alanına bir anahtar girin veya anahtar oluştur düğmesine
   basın. Kontrol edilen makine ve tüm istemcilerinin aynı anahtarı
   kullanması gerekir.
6. Tamam tuşuna basın. Bittiğinde, bir ses duyacaksınız ve
   bağlanacaksınız. Sunucu günün mesajını içeriyorsa, bir iletişim kutusunda
   görüntülenecektir. Sunucu yapılandırmasına bağlı olarak, her
   bağlandığınızda veya yalnızca ilk kez bu iletişim kutusunu göreceksiniz.

### Bağlantı güvenliği uyarısı

Geçerli bir SSL sertifikası olmayan bir sunucuya bağlanırsanız, bir bağlantı
güvenlik uyarısı alırsınız.

Bu, bağlantınızın güvensiz olduğu anlamına gelebilir. Bu sunucu parmak izine
güveniyorsanız, bir kez bağlanmak için "Bağlan" düğmesine veya bağlanmak ve
parmak izini kaydetmek için "Bağlan ve bu sunucu için bir daha sorma"
seçeneğine basabilirsiniz.

## Doğrudan bağlantılar

Bağlan iletişim kutusundaki sunucu seçeneği, doğrudan bağlantı kurmanıza
olanak tanır.

Bunu seçtikten sonra, bağlantınızın sonunun hangi modda olacağını seçin.

Diğer kişi ise tam tersini kullanarak size bağlanacaktır.

Mod seçildikten sonra Harici IP Alın butonunu kullanarak harici IP
adresinizi alabilir ve port alanına girilen portun doğru yönlendirildiğinden
emin olabilirsiniz. Yönlendiricinizde etkinleştirildiyse, port kontrolü
gerçekleştirmeden önce UPNP kullanarak portu iletebilirsiniz.

Bağlantı noktası kontrolü, bağlantı noktanıza (varsayılan olarak 6837)
ulaşılamadığını tespit ederse, bir uyarı görüntülenir.

Bağlantı noktanızı iletin ve tekrar deneyin. Ayrıca, NVDA işlemine Windows
güvenlik duvarı üzerinden izin verildiğinden emin olun.

Not: Bağlantı noktalarını iletme, UPNP'yi etkinleştirme veya Windows
güvenlik duvarını yapılandırma işlemleri bu belgenin kapsamı
dışındadır. Daha fazla talimat için lütfen yönlendiricinizle birlikte
verilen bilgilere bakın.

Anahtar alanına bir anahtar girin veya oluştur'a basın. Diğer kişi,
bağlanmak için anahtarla birlikte harici IP'nize ihtiyaç
duyacaktır. Bağlantı noktası alanına varsayılandan (6837) farklı bir
bağlantı noktası girdiyseniz, diğer kişinin alternatif bağlantı noktasını
ana bilgisayar adresine <harici ip>:<bağlantı noktası> biçiminde
eklediğinden emin olun.

Seçilen bağlantı noktasını UPNP kullanarak iletmek istiyorsanız, "Mümkünse
bu bağlantı noktasını iletmek için UPNP kullan" onay kutusunu etkinleştirin.

Tamam düğmesine basıldığında bağlanacaksınız. Diğer kişi bağlandığında,
TeleNVDA'yı normal şekilde kullanabilirsiniz.

## Uzak makineyi kontrol etme

Oturum bağlandıktan sonra, kontrol eden makinenin kullanıcısı uzak makineyi
kontrol etmeye başlamak için f11 tuşuna basabilir (ör. klavye tuşları veya
braille girişi göndererek). Bu hareket, NVDA Girdi Hareketleri İletişim
Kutusundan değiştirilebilir.

NVDA uzak makine kullanılıyor dediğinde, bastığınız klavye ve braille ekran
tuşları uzak makineye gidecektir. Ayrıca, kontrol eden makine bir braille
ekran kullanıyorsa, uzak makineden gelen bilgiler bu ekranda
görüntülenecektir. Tuş göndermeyi durdurmak ve kontrol eden makineye geri
dönmek için tekrar f11 tuşuna basın.

En iyi uyumluluk için lütfen her iki makinedeki klavye düzenlerinin
eşleştiğinden emin olun.

## Oturumu paylaşma

Bir başkasının TeleNVDA oturumunuza kolayca katılabilmesi için bir bağlantı
paylaşmak üzere Uzak Bağlantı menüsünden Bağlantıyı Kopyala'yı seçin. Bu
görevi hızlandırmak için NVDA Girdi Hareketleri iletişim kutusundan da
hareketler atayabilirsiniz.

İki bağlantı biçimi arasından seçim yapabilirsiniz. İlki hem NVDA Uzaktan
Destek hem de TeleNVDA ile uyumludur ve şimdilik en çok
önerilendir. İkincisi yalnızca TeleNVDA ile uyumludur.

Kontrol eden bilgisayar olarak bağlıysanız, bu bağlantı başka birinin
bağlanmasına ve kontrol edilmesine izin verecektir.

Bunun yerine bilgisayarınızı kontrol edilecek şekilde ayarladıysanız,
bağlantı, onu paylaştığınız kişilerin makinenizi kontrol etmesine izin
verecektir.

Birçok uygulama, kullanıcıların bu bağlantıyı otomatik olarak
etkinleştirmesine izin verir, ancak belirli bir uygulama içinden
çalışmıyorsa, panoya kopyalanabilir ve çalıştır iletişim kutusundan
çalıştırılabilir.

Doğrudan bağlantı modunda çalışan bir sunucudan kopyalarsanız paylaşılan
bağlantının çalışmayabileceğini unutmayın.

## Ctrl+Alt+Sil komutu Gönder

Tuşları gönderirken CTRL+Alt+Sil kombinasyonunu normal şekilde göndermek
mümkün değildir.

CTRL+Alt+Sil göndermeniz gerekiyorsa ve uzak sistem güvenli masaüstündeyse
bu komutu kullanın.

## Yerel ve uzak bilgisayar arasında geçiş anahtarı gönder

Genellikle, yerel ve uzak makine arasında geçiş yapmak için atanmış harekete
bastığınızda, bu hareket uzak makineye gönderilmez; bunun yerine yerel
makine ile uzak makine arasında geçiş yapacaktır.

Bunu veya herhangi bir hareketi uzaktaki makineye göndermeniz gerekirse,
sonraki hareketi yoksay komut dosyasını etkinleştirerek bu davranışı bir
sonraki anlık hareket için geçersiz kılabilirsiniz.

Varsayılan olarak, bu komut, kontrol + f11 tuşuna atanır. Bu hareket, NVDA
Girdi Hareketleri İletişim Kutusundan değiştirilebilir.

Bu komut çağrıldığında, sonraki hareket yoksayılacak ve sonraki hareketi
yoksay'ı etkinleştirme hareketi de dahil olmak üzere uzak makineye
gönderilecektir. Bir sonraki hareket gönderildikten sonra normal davranışa
dönecektir.

## Katılımsız Bir Bilgisayarı Uzaktan Kontrol Etme

Bazen kendi bilgisayarlarınızdan birini uzaktan kontrol etmek
isteyebilirsiniz. Bu, özellikle seyahat ediyorsanız ve ev bilgisayarınızı
dizüstü bilgisayarınızdan kontrol etmek istiyorsanız yararlıdır. Ya da
evinizin bir odasındaki bir bilgisayarı dışarıda otururken başka bir
bilgisayarla kontrol etmek isteyebilirsiniz. Biraz gelişmiş hazırlık, bunu
uygun ve mümkün kılar.

1. NVDA menüsüne girin, Araçlar'ı ve ardından Uzak Bağlantı'yı seçin. Son
   olarak, Seçenekler'de Enter tuşuna basın.
2. "Başlangıçta kontrol sunucusuna otomatik bağlan" yazan kutuyu
   işaretleyin.
3. Bir uzak geçiş sunucusu kullanmayı veya bağlantıyı yerel olarak
   barındırmayı seçin. Bağlantıyı barındırmaya karar verirseniz, sağlanan
   onay kutusunu işaretleyerek bağlantı noktalarını UPNP kullanarak iletmeyi
   deneyebilirsiniz.
4. İkinci radyo düğmesi setinde Bu bilgisayarın kontrol edilmesine izin ver
   öğesini seçin.
5. Bağlantıyı kendiniz barındırıyorsanız, kontrol edilen makinede bağlantı
   noktası alanına girilen bağlantı noktasına (varsayılan olarak 6837)
   kontrol eden makinelerden erişilebildiğinden emin olmanız gerekir.
6. Bir aktarma sunucusu kullanmak istiyorsanız, Ana Bilgisayar ve Anahtar
   alanlarının her ikisini de doldurun, sekme ile Tamam üzerine gelin ve
   Enter tuşuna basın. Anahtar Oluştur seçeneği bu durumda
   kullanılamaz. Herhangi bir uzak konumdan kolayca kullanabilmeniz için
   hatırlayacağınız bir anahtar bulmak en iyisidir.

Gelişmiş kullanım için, NVDA Uzaktan Desteği kontrol modunda yerel veya uzak
bir aktarma sunucusuna otomatik olarak bağlanacak şekilde de
yapılandırabilirsiniz. Bunu istiyorsanız, ikinci radyo düğmeleri kümesinde
Başka bir makineyi kontrol et seçeneğini belirleyin.

Not: Seçenekler iletişim kutusundaki başlangıçta otomatik bağlantı ile
ilgili seçenekler, NVDA yeniden başlatılana kadar geçerli değildir.

## Uzak Bilgisayarda Konuşmayı Susturma

Uzak bilgisayarın konuşmasını veya NVDA'ya özgü sesleri duymak
istemiyorsanız, NVDA menüsüne, Araçlar'a ve Uzak bağlantıya erişmeniz
yeterlidir. Aşağı okla Uzaktan Sesi Kapat'a gidin ve Enter'a basın. Lütfen
bu seçeneğin, kontrol eden makine anahtarları gönderirken kontrol eden
ekrana uzaktan braille çıkışını devre dışı bırakmayacağını unutmayın.

## Uzak Oturumu Sonlandırma

Bir uzak oturumu sonlandırmak için aşağıdakileri yapın:

1. Kontrol eden bilgisayarda, uzak makineyi kontrol etmeyi durdurmak için
   F11'e basın. "Yerel makine kontrol ediliyor" mesajını duymalı veya
   okumalısınız. Bunun yerine, uzak makineyi kontrol ettiğinize dair bir
   mesaj duyar veya okursanız, bir kez daha F11 tuşuna basın.
2. NVDA menüsüne, Araçlar, Uzak Bağlantıya erişin ve Bağlantıyı Kes üzerinde
   Enter'a basın.

Alternatif olarak, oturumun bağlantısını doğrudan kesmek için
NVDA+alt+Önceki Sayfa tuşlarına da basabilirsiniz. Bu hareket, NVDA Girdi
Hareketleri İletişim Kutusundan değiştirilebilir. Diğer ucu güvende tutmak
için, uzak bilgisayarın bağlantısını kesmek üzere anahtarlar gönderirken bu
harekete basabilirsiniz.

## Panoya gönderme

Uzak Bağlantı menüsündeki Pano içeriğini gönder seçeneği, panonuzdan metin
göndermenizi sağlar.

Etkinleştirildiğinde, panodaki herhangi bir metin diğer makinelere
iletilecektir.

## Dosya gönderme

Uzak Bağlantı menüsündeki Dosya gönder seçeneği, kontrol edilen makine dahil
tüm oturum üyelerine küçük dosyalar göndermenizi sağlar. Lütfen yalnızca 10
MB'tan küçük dosyaları gönderebileceğinizi unutmayın. Güvenli ekranlarda
dosya gönderilmesine veya alınmasına izin verilmez.

Ayrıca dosya göndermenin, dosya boyutuna, aynı oturuma bağlı bilgisayarlara
ve gönderilen dosya miktarına bağlı olarak sunucuda çok fazla ağ trafiği
tüketebileceğini unutmayın. Sunucu yöneticinize başvurun ve trafiğin
faturalandırılıp faturalandırılmadığını sorun. Bu durumda, dosya alışverişi
için başka bir platform kullanmayı düşünün.

Dosya uzaktaki makinelerde alındığında, dosyayı nereye kaydedeceğinizi
seçmenize izin veren Farklı kaydet iletişim kutusu açılır.

## TeleNVDA'yı Güvenli Bir Masaüstünde Çalışacak Şekilde Yapılandırma

TeleNVDA'nın güvenli masaüstünde çalışması için, güvenli masaüstünde çalışan
NVDA'da eklentinin kurulu olması gerekir.

1. NVDA menüsünden Tercihler'i, ardından Ayarları açın ve Geneli seçin.
2. Oturum Açma ve Diğer Güvenli Ekranlarda Şu Anda Kaydedilmiş Ayarları
   Kullan (yönetici ayrıcalıkları gerektirir) düğmesine gidin ve Enter'a
   basın.
3. Ayarlarınızı kopyalamak ve eklentileri kopyalamakla ilgili istemlere Evet
   yanıtı verin ve görünebilecek Kullanıcı Hesabı Denetimi istemine yanıt
   verin.
4. Ayarlar kopyalandığında, Tamam düğmesine basın. İletişim kutusundan
   çıkmak için Sekme ile Tamam üzerine gelin ve Enter tuşuna tekrar basın.

TeleNVDA güvenli masaüstüne yüklendikten sonra, şu anda uzak bir oturumda
kontrol ediliyorsanız, geçiş yaptığınızda güvenli masaüstüne konuşma ve
braille erişimine sahip olacaksınız.

## SSL sertifikası parmak izlerini temizleme

Güvendiğiniz sunucu parmak izlerine artık güvenmek istemiyorsanız,
Seçenekler iletişim kutusundaki "Tüm güvenilen parmak izlerini sil"
düğmesine basarak tüm güvenilen parmak izlerini temizleyebilirsiniz.

## Özel bir portcheck hizmeti kullanma

Varsayılan olarak TeleNVDA, NVDA İspanyol topluluğu tarafından sağlanan bir
hizmeti kullanarak açık bağlantı noktalarını kontrol eder. Hizmet Adresini
seçenekler iletişim kutusundan değiştirebilirsiniz. Kontrol edilecek
bağlantı noktasının özel URL'nin parçası olduğundan ve sonuçların beklenen
biçimde döndürüldüğünden emin olun. TeleNVDA deposunda bir portcheck örnek
komut dosyası dağıtılır, böylece isterseniz kendi kopyanızı
barındırabilirsiniz.

## TeleNVDA'yı Değiştirme

Bu proje, GNU Genel Kamu Lisansı, sürüm 2 veya üzeri kapsamındadır. Lisans
koşullarını okumanız, anlamanız ve bunlara saygı göstermeniz koşuluyla [bu
depoyu][2] TeleNVDA'da değişiklik yapmak için kopyalayabilirsiniz. MiniUPNP
modülü, bir BSD-3 yan tümce lisansı altında lisanslanmıştır.

### 3. Taraf bağımlılıkları

Bunlar pip ile kurulabilir:

* Markdown
* scons

URL işleyici yürütülebilir dosyasını oluşturmak için Visual Studio 2019 veya
sonraki bir sürüme ihtiyacınız var.

### Eklentiyi dağıtım amacıyla paketlemek için:

1. Bir komut satırı açın, [bu depo][2] kök dizinine geçin
2. **scons** komutunu çalıştırın. Oluşturulan eklenti, herhangi bir hata
   yoksa geçerli dizine yerleştirilir.

[[!tag dev stable]]

[1]: https://www.nvaccess.org/addonStore/legacy?file=TeleNVDA

[2]: https://github.com/nvda-es/TeleNVDA
