Bu uygulama, WordPress tabanlı bir blogdaki yazıları kolayca okumanız için geliştirilmiş basit bir iOS uygulamasıdır. Kullanıcı dostu bir arayüze sahiptir ve temel blog yazısı okuma ihtiyaçlarını karşılar.


## 📋 Özellikler

### 🚀 Performans İyileştirmeleri
- **Image ve API caching sistemi**: Daha hızlı yükleme süreleri için içerikler önbelleğe alınır.
- **Paralel yükleme işlemleri**: Daha hızlı veri indirme için paralel işlemler.
- **Memory yönetimi optimizasyonları**: Daha verimli bellek kullanımı.

### 🎨 UI/UX İyileştirmeleri
- **Grid/Liste görünümü seçeneği**: Kullanıcılar, içeriği istedikleri düzenle görüntüleyebilir.
- **Custom Toast bildirimleri**: Kullanıcı etkileşimlerini görsel olarak destekleyen özel bildirimler.
- **Dark/Light mode geçişleri**: Tema tercihlerine göre otomatik veya manuel geçiş.
- **Smooth animasyonlar**: Daha iyi bir kullanıcı deneyimi için akıcı animasyonlar.
- **Loading states**: Yüklenme sırasında kullanıcıyı bilgilendiren geçişler.

### 💻 Kod Kalitesi
- **Modüler yapı**: Daha kolay bakım ve genişletilebilirlik.
- **Clean Architecture**: Kodun daha okunabilir ve sürdürülebilir olması için temiz mimari.
- **Error handling**: Hataları yakalamak ve kullanıcıya bildirmek için kapsamlı hata yönetimi.
- **Async/await kullanımı**: Daha modern ve okunabilir bir kod yapısı için asenkron işlemler.
- **Extension'lar**: Tekrarlanan kodları düzenlemek ve yeniden kullanmak için genişletmeler.

### 🌟 Diğer Özellikler
- **Cache yönetimi**: İnternet bağlantısı olmasa bile hızlı veri erişimi.
- **Offline destek altyapısı**: Çevrimdışı durumda temel özellikler çalışmaya devam eder.
- **Pull-to-refresh**: Kullanıcıların kolayca içerik yenilemesi.
- **Kategoriler**: İçeriklerin kategorilere göre ayrılması ve filtrelenmesi.
- **Responsive tasarım**: Farklı cihaz boyutlarına uyum sağlayan esnek arayüz.


## 🚀 Kurulum

1. **Depoyu Klonlayın**:
   ```bash
   git clone https://github.com/burakmucahit/WordPress-IOSBlog.git

2. API URL'lerini Güncelleyin:

Klonlama işleminden sonra, API bağlantılarının doğru çalışması için şu dosyaları düzenlemeniz gerekmektedir:

    Desteklio/Views/PostDetailView.swift
    Desteklio/Services/WordPressService.swift

Bu dosyalarda yer alan API URL'lerini kendi WordPress sitenizin API URL'leriyle değiştirin.
