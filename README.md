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

![Image](https://github.com/user-attachments/assets/cfe7f545-4f3f-4390-b202-9cca85b9ee59)

## Api Çekme İşlemi
![Image](https://github.com/user-attachments/assets/0f494938-3548-47b8-901b-6903fe520112)

## Ana Ekran Kur Değerleri 

<img src="https://github.com/user-attachments/assets/b5bba6ac-e720-414c-adf5-742e07c82821" alt="Image 1" width="400"/>

<br/>

<img src="https://github.com/user-attachments/assets/52d01602-139a-4d49-9575-3660e71e1f4d" alt="Image 2" width="400"/>


## Kur Çevirme Ekranı 

![Image](https://github.com/user-attachments/assets/16a8445e-3d30-4e98-90fd-49e0cbd63779)

![Image](https://github.com/user-attachments/assets/789a15ca-4295-4998-a370-2af89499b41e)

## Haberler Ekranı 

![Image](https://github.com/user-attachments/assets/11279e98-886c-4749-989e-6145aafaeff4)

![Image](https://github.com/user-attachments/assets/e36cb69d-3638-41bf-aae6-4bb2384de3e0)

## Ayarlar Ekranı 

![Image](https://github.com/user-attachments/assets/4b629599-c0ee-432b-8370-0b7a0f579ded)

![Image](https://github.com/user-attachments/assets/1a57a720-0229-45ac-97b7-5c7367e30ecb)

## Dil Değiştirme Ekranı 

![Image](https://github.com/user-attachments/assets/e4a1fe83-71f1-4459-b19a-e6bed3c5c792)

![Image](https://github.com/user-attachments/assets/310894a8-498a-4965-a8ba-21ec29a33c5c)

## Uygulama Teması Ekranı 

![Image](https://github.com/user-attachments/assets/e0547709-46ba-4fe7-b1d4-4f0ba228eb23)

![Image](https://github.com/user-attachments/assets/6e6322e9-fe83-4de8-8bf5-b41a49a92208)

## Giriş Yapma Ekranı

![Image](https://github.com/user-attachments/assets/aa908655-e22a-479c-acc0-e181ca6f8a9a)

![Image](https://github.com/user-attachments/assets/a2fb3cd5-dd5e-49be-b9a7-024cb77eb23e)

## Kayıt Olma Ekranı 

![Image](https://github.com/user-attachments/assets/d552f29c-4b55-4b35-855d-341c3f542196)

![Image](https://github.com/user-attachments/assets/cf754022-8748-4330-83ed-5101153c84e0)

## Profil Ekranı 

![Image](https://github.com/user-attachments/assets/fa621fee-3748-4c0d-a684-6af19d05bf33)

![Image](https://github.com/user-attachments/assets/28ad70ee-07e8-45c2-960f-62ddfc9af910)
