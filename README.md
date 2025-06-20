# **FXSwift Uygulaması Proje Raporu**

FXSwift, bir döviz uygulaması olup Dart programlama dili ile geliştirilmiştir. Uygulama, GitHub üzerinden Buğra Kasapoğlu ve Tarık Karavar tarafından ortak olarak yürütülmüştür. Öğrenme amacı güdülerek geliştirilen bu projede, ekip üyeleri hem frontend (ön yüz) hem de backend (arka uç) alanlarında aktif olarak çalışmışlardır.

Uygulama içerisinde; anlık döviz kurlarını görebileceğiniz, bu kurlar üzerinden para birimi çevirisi yapabileceğiniz, dövizle ilgili haberleri okuyabileceğiniz, kullanıcı girişi gerçekleştirebileceğiniz ve uygulama ayarlarını düzenleyebileceğiniz çeşitli sayfalar bulunmaktadır. Ayarlar bölümünde üç farklı dil seçeneği mevcuttur: Almanca, İngilizce ve Türkçe. Kullanıcılar, tercihlerine göre uygulamayı gece veya gündüz modunda kullanabilmekte, bu geçişler sorunsuz bir şekilde sağlanmaktadır.

FXSwift’in tasarımı kullanıcı odaklı ve sade tutulmuştur. Amaç, uygulamanın herkes tarafından ilk bakışta anlaşılabilir ve kolay kullanılabilir olmasıdır.

# **Geliştirme Süreci**

Uygulamanın geliştirme süreci Visual Studio Code (VS Code) üzerinde gerçekleştirilmiş, Flutter eklentileri aktif olarak kullanılmıştır. Proje dosyaları, erişim kolaylığı sağlamak adına klasörler altında düzenli bir yapıda tutulmuştur. Tasarım aşamasında “https://lottiefiles.com/” ve “https://www.canva.com/” gibi görsel kaynak sitelerinden faydalanılmıştır.

Uygulamada döviz verilerinin çekilmesi “https://currencyapi.com/” sitesi üzerinden sağlanmaktadır. Ancak bu veriler gerçek anlamda anlık (dakikalık ya da saniyelik) değil, belirli bir gecikmeyle sunulmaktadır. Bu farkın nedeni, hizmetin ücretsiz sürümünün sınırlı veri güncelliği sunması ve daha sağlıklı veriler için ücretli hizmete yönlendirmesidir.

# **Kullanılan Flutter Paketleri ve Amaçları**

Uygulama içerisinde birden fazla Flutter paketi kullanılmıştır. Bu paketler ve kullanım amaçları şu şekildedir:

http: Döviz verilerini çekmek amacıyla projeye dahil edilmiştir.

lottie: Uygulamanın açılışında karşılaşılan yükleme animasyonunun çalışmasını sağlar.

flutter_secure_storage: Güvenli veri saklama için kullanılır. iOS cihazlarda Keychain, Android cihazlarda ise EncryptedSharedPreferences veya KeyStore kullanılarak veriler güvenli alanlara kaydedilir.

url_launcher: Haberler sayfasındaki haberlere tıklandığında, kullanıcıyı ilgili haber sitesine yönlendirmek için kullanılır.

intl: Çoklu dil desteği sağlamak amacıyla kullanılmıştır.

Bu proje, Flutter ile uygulama geliştirmeye yeni başlayanlar için hem pratik hem de kapsamlı bir öğrenme süreci sunmuş; backend ve frontend süreçlerine dair temel yetkinliklerin geliştirilmesine olanak sağlamıştır.


# **Uygulama Görselleri** 


## Yükleme Ekranı 

<img src="assets/readmephoto/loading.jpg" width="300"/>

## Api Çekme İşlemi

<img src="assets/readmephoto/succes.png" width="400"/>

## Ana Ekran Kur Değerleri 

<img src="assets/readmephoto/kurlarbeyaz.jpg" width="300"/>
<img src="assets/readmephoto/kurlarsiyah.jpg" width="300"/>

## Kur Çevirme Ekranı 

<img src="assets/readmephoto/ceviribeyaz.jpg" width="300"/>
<img src="assets/readmephoto/cevirisiyah.jpg" width="300"/>

## Haberler Ekranı 

<img src="assets/readmephoto/haberbeyaz.jpg" width="300"/>
<img src="assets/readmephoto/habersiyah.jpg" width="300"/>

## Ayarlar Ekranı 

<img src="assets/readmephoto/ayarbeyaz.jpg" width="300"/>
<img src="assets/readmephoto/ayarsiyah.jpg" width="300"/>

## Dil Değiştirme Ekranı 

<img src="assets/readmephoto/dilbeyaz.jpg" width="300"/>
<img src="assets/readmephoto/dilsiyah.jpg" width="300"/>

## Uygulama Teması Ekranı 

<img src="assets/readmephoto/modbeyaz.jpg" width="300"/>
<img src="assets/readmephoto/modsiyah.jpg" width="300"/>

## Giriş Yapma Ekranı

<img src="assets/readmephoto/girisbeyaz.jpg" width="300"/>
<img src="assets/readmephoto/girissiyah.jpg" width="300"/>

## Kayıt Olma Ekranı 

<img src="assets/readmephoto/kayıtbeyaz.png" width="300"/>
<img src="assets/readmephoto/kayıtsiyah.png" width="300"/>

## Profil Ekranı 

<img src="assets/readmephoto/profilbeyaz.png" width="300"/>
<img src="assets/readmephoto/profilsiyah.png" width="300"/>

## Google ile Giriş Ekranı 

<img src="assets/readmephoto/google.jpg" width="300"/>
