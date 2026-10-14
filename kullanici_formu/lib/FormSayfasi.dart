import 'package:flutter/material.dart';

class FormSayfasi extends StatefulWidget {
  const FormSayfasi({super.key});

  @override
  State<FormSayfasi> createState() => _FormSayfasiState();
}

class _FormSayfasiState extends State<FormSayfasi> {
  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController sehirController = TextEditingController();
  // Yeni eklenen alanlar için controller'lar
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController epostaController = TextEditingController();

  String? cinsiyet;
  DateTime? dogumTarihi;
  int? yas;

  Future<void> tarihSec() async {
    final DateTime? secilenTarih = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (secilenTarih != null) {
      setState(() {
        dogumTarihi = secilenTarih;
        yas = yasHesapla(secilenTarih);
      });
    }
  }

  int yasHesapla(DateTime dogum) {
    final bugun = DateTime.now();
    int hesaplananYas = bugun.year - dogum.year;

    if (bugun.month < dogum.month ||
        (bugun.month == dogum.month && bugun.day < dogum.day)) {
      hesaplananYas--;
    }

    return hesaplananYas;
  }

  // Formu ve alanları tamamen sıfırlayan fonksiyon
  void temizle() {
    setState(() {
      adController.clear();
      soyadController.clear();
      sehirController.clear();
      telefonController.clear();
      epostaController.clear();
      cinsiyet = null;
      dogumTarihi = null;
      yas = null;
    });
  }

  void kaydet() {
    if (cinsiyet == null ||
        adController.text.isEmpty ||
        soyadController.text.isEmpty ||
        telefonController.text.isEmpty ||
        epostaController.text.isEmpty ||
        dogumTarihi == null ||
        sehirController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doldurun.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kayıt Başarılı'),
          content: Text(
            // Popup'a ad, yaş ve diğer bilgilerin eklenmesi
            'Ad: ${adController.text}\n'
            'Soyad: ${soyadController.text}\n'
            'Yaş: $yas\n'
            'Cinsiyet: $cinsiyet\n'
            'Telefon: ${telefonController.text}\n'
            'E-posta: ${epostaController.text}\n'
            'Şehir: ${sehirController.text}\n\n'
            'Kayıt oldu!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Popup'ı kapat
                Navigator.pop(context); // Kayıt başarılı olduktan sonra ana sayfaya dön
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    adController.dispose();
    soyadController.dispose();
    sehirController.dispose();
    telefonController.dispose();
    epostaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Formu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Cinsiyet (Belirtmek istemiyorum seçeneği eklendi)
            DropdownButtonFormField<String>(
              value: cinsiyet,
              decoration: const InputDecoration(
                labelText: 'Cinsiyet',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Erkek',
                  child: Text('Erkek'),
                ),
                DropdownMenuItem(
                  value: 'Kadın',
                  child: Text('Kadın'),
                ),
                DropdownMenuItem(
                  value: 'Belirtmek istemiyorum',
                  child: Text('Belirtmek istemiyorum'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  cinsiyet = value;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: adController,
              decoration: const InputDecoration(
                labelText: 'Ad',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: soyadController,
              decoration: const InputDecoration(
                labelText: 'Soyad',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Telefon Numarası Alanı
            TextField(
              controller: telefonController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // E-posta Alanı
            TextField(
              controller: epostaController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.grey),
              ),
              title: Text(
                dogumTarihi == null
                    ? 'Doğum tarihi seç'
                    : '${dogumTarihi!.day}.${dogumTarihi!.month}.${dogumTarihi!.year}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: tarihSec,
            ),

            const SizedBox(height: 15),

            if (yas != null)
              Text(
                'Yaş: $yas',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 15),

            TextField(
              controller: sehirController,
              decoration: const InputDecoration(
                labelText: 'Yaşadığınız şehir',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            // Kaydol ve Temizle Butonları
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: kaydet,
                    child: const Text('Kaydol'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: temizle,
                    child: const Text('Temizle'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}