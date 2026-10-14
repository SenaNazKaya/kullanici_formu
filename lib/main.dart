import 'dart:io';

// 3. OOP - Ürün Sınıfı
class Product {
  String name;
  double price;

  Product(this.name, this.price);
}

// 3. OOP - Alışveriş Sepeti Sınıfı
class ShoppingCart {
  List<Product> products = [];
  double totalPrice = 0.0;

  // Ürün ekleme metodu
  void addProduct(Product product) {
    products.add(product);
    calculateTotal();
  }

  // Toplam tutarı hesaplama metodu
  void calculateTotal() {
    totalPrice = 0.0;
    for (var product in products) {
      totalPrice += product.price;
    }
  }

  // O ana kadar eklenen ürünleri listeleyen metod
  void showProducts() {
    print('\n--- O Anki Sepetiniz ---');
    if (products.isEmpty) {
      print('Sepetiniz henüz boş.');
    } else {
      for (int i = 0; i < products.length; i++) {
        print('${i + 1}. Ürün: ${products[i].name} - ${products[i].price} TL');
      }
    }
    print('Güncel Toplam Tutar: ${totalPrice.toStringAsFixed(2)} TL');
    print('------------------------\n');
  }
}

void main() {
  print('=== Alışveriş Sepeti Uygulamasına Hoş Geldiniz ===\n');

  // 1. Değişkenler
  int userAge;
  int customerNumber;

  // Kullanıcıdan yaş ve müşteri numarası alma
  print('Lütfen yaşınızı giriniz:');
  userAge = int.parse(stdin.readLineSync()!);

  print('Lütfen müşteri numaranızı giriniz:');
  customerNumber = int.parse(stdin.readLineSync()!);

  print('\nMüşteri No: $customerNumber, Yaş: $userAge');

  // Sepet nesnesini oluşturuyoruz
  ShoppingCart cart = ShoppingCart();

  // 2. Döngüler (While) - Ürün Ekleme
  print('\nÜrün eklemeye başlayabilirsiniz. (Çıkış yapmak için ürün adı kısmına "q" yazın)');
  
  while (true) {
    stdout.write('Ürün Adı (Çıkış için q): ');
    String? inputName = stdin.readLineSync();

    // Kullanıcı 'q' yazdıysa döngüyü sonlandır
    if (inputName == null || inputName.toLowerCase() == 'q') {
      break;
    }

    stdout.write('Ürün Fiyatı: ');
    String? inputPriceStr = stdin.readLineSync();
    double? inputPrice = double.tryParse(inputPriceStr ?? '');

    if (inputPrice == null || inputPrice < 0) {
      print('Geçersiz fiyat girdiniz, lütfen tekrar deneyin.\n');
      continue;
    }

    // Product nesnesi oluşturup sepete ekleme (OOP kullanımı)
    Product newProduct = Product(inputName, inputPrice);
    cart.addProduct(newProduct);

    // O ana kadar eklenen ürünleri listele
    cart.showProducts();
  }

  // 1. Karar Yapıları (İndirim Hesaplama)
  double discountRate = 0.0;

  if (userAge < 18) {
    discountRate = 0.10; // %10 indirim
    print('18 yaşından küçük olduğunuz için %10 indirim uygulandı.');
  } else if (userAge >= 18 && userAge <= 60) {
    discountRate = 0.05; // %5 indirim
    print('Yaş aralığınız nedeniyle %5 indirim uygulandı.');
  } else {
    discountRate = 0.15; // %15 indirim
    print('60 yaş üstü olduğunuz için %15 indirim uygulandı.');
  }

  // Sonuçların Hesaplanması
  double rawTotal = cart.totalPrice;
  double discountAmount = rawTotal * discountRate;
  double finalAmount = rawTotal - discountAmount;

  // Çıktı Özeti
  print('\n==============================');
  print('          SİPARİŞ ÖZETİ       ');
  print('==============================');
  print('Müşteri Numarası : $customerNumber');
  print('Kullanıcı Yaşı   : $userAge');
  print('Sepetteki Ürün Ad : ${cart.products.length} adet');
  print('İndirimsiz Tutar : ${rawTotal.toStringAsFixed(2)} TL');
  print('Uygulanan İndirim: ${discountAmount.toStringAsFixed(2)} TL');
  print('Ödenecek Tutar   : ${finalAmount.toStringAsFixed(2)} TL');
  print('==============================');
  print('Alışverişiniz için teşekkür ederiz!');
}