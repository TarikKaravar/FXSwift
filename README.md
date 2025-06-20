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

<img src="https://raw.githubusercontent.com/TarikKaravar/FXSwift/main/assets/readmefoto/loading.jpg" width="300"/>



## Api Çekme İşlemi

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/succes.png?raw=true" width="400"/>


## Ana Ekran Kur Değerleri 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/kurlarbeyaz.jpg?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/kurlarsiyah.jpg?raw=true" width="300"/>


## Kur Çevirme Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/ceviribeyaz.jpg?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/cevirisiyah.jpg?raw=true" width="300"/>


## Haberler Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/haberbeyaz.jpg?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/habersiyah.jpg?raw=true" width="300"/>


## Ayarlar Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/ayarbeyaz.jpg?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/ayarsiyah.jpg?raw=true" width="300"/>


## Dil Değiştirme Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/dilbeyaz.jpg?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/dilsiyah.jpg?raw=true" width="300"/>


## Uygulama Teması Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/modbeyaz.jpg?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/modsiyah.jpg?raw=true" width="300"/>


## Giriş Yapma Ekranı

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/girisbeyaz.jpg?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/girissiyah.jpg?raw=true" width="300"/>


## Kayıt Olma Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/kayıtbeyaz.png?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/kayıtsiyah.png?raw=true" width="300"/>


## Profil Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/profilbeyaz.png?raw=true" width="300"/>
<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/profilsiyah.png?raw=true" width="300"/>


## Google ile Giriş Ekranı 

<img src="https://github.com/tarikkaravar/FXSwift/blob/main/assets/readmephoto/google.jpg?raw=true" width="300"/>

