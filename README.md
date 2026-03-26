🌿 Garden Library Management System
Bu proje, hem ASP.NET Core MVC hem de Flutter ekosistemlerinden ilham alınarak geliştirilmiş, modern ve estetik bir kütüphane yönetim sistemidir. Okul ortamındaki derslik, öğrenci ve kitap trafiğini yönetmek için "Spring Garden" (Bahar Bahçesi) temasıyla tasarlanmıştır.

🚀 Geliştirme Aşamaları
1. Mimari Tasarım ve Veritabanı (ASP.NET Core MVC)
Model Yapılandırması: Projenin temelini oluşturan Kitap, Kategori, Ogrenci ve Sinif modelleri Entity Framework Core kullanılarak oluşturuldu.

Database Integration: SQL Server üzerinde ilişkisel bir veritabanı yapısı kuruldu; örneğin bir sınıfın birden fazla öğrencisi olabileceği şekilde tablolar bağlandı.

CRUD Operasyonları: Her modül için Ekleme, Listeleme, Güncelleme ve Silme (CRUD) fonksiyonları Controller seviyesinde yazıldı.

2. UI/UX: Flutter Esintili Web Tasarımı
Temalandırma: Standart karanlık moddan vazgeçilerek; Blush Pink, Sage Green ve Buttercream tonlarından oluşan özel bir pastel paleti (Spring Garden) uygulandı.

Modern Componentler: Klasik HTML tabloları yerine Flutter'daki Card widget'larını andıran, gölgeli ve yuvarlatılmış köşeli (border-radius: 25px) kart tasarımlarına geçildi.

Layout Revizyonu: Tüm sayfaların tutarlı görünmesi için _Layout.cshtml üzerinden navigasyon barı ve alt bilgi (footer) alanları ferah ve beyaz bir görünüme kavuşturuldu.

3. Animasyonlar ve Detaylar
Floating Garden: CSS @keyframes animasyonları kullanılarak ekranın sağ tarafına süzülen çiçek ve böcek ikonları eklendi.

Responsive Yapı: Tasarımın sadece masaüstünde değil, mobil cihazlarda da Flutter uygulamasıymış gibi akıcı çalışması için Bootstrap Grid sistemi optimize edildi.

🛠️ Kullanılan Teknolojiler
Backend: ASP.NET Core 10.0 MVC

Frontend: HTML5, CSS3 (Custom Animation), Bootstrap 5

Database: MS SQL Server & Entity Framework Core

Icons: Bootstrap Icons
