import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: AnaSayfa(),
  ));
}

TextEditingController ad = new TextEditingController();
TextEditingController soyad = new TextEditingController();
TextEditingController yemek = new TextEditingController();
String fullName = ad.text + soyad.text;

var gelenVeriAd = "";
var gelenVeriSoyad = "";
var gelenVeriYemek = "";

class SiparisEkrani extends StatelessWidget {
  const SiparisEkrani({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Text('Sipariş Ekranı'),
        backgroundColor: Colors.brown[800],
      ),
      body: Center(
        child: ListView(
          children: [
            TextFormField(
              controller: ad,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Adınız:",
                hintText: "Adınız",
              ),
            ),
            TextFormField(
              controller: soyad,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Soyadınız",
                hintText: "Soyadınız",
              ),
            ),
            TextFormField(
              controller: yemek,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Yemek Bilgisi",
                hintText: "Yemek Bilgisi",
              ),
            ),
            ElevatedButton(
              child: Text('Sipariş Ver'),
              onPressed: () async {
                FirebaseFirestore firestore = FirebaseFirestore.instance;

                FirebaseFirestore.instance
                    .collection('siparisBilgileri')
                    .doc(fullName)
                    .set({
                  'ad': ad.text,
                  'soyad': soyad.text,
                  'yemek': yemek.text,
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SiparisAlindi()),
                );
              },
            ),
            Text(
                textAlign: TextAlign.center,
                "Siparişinizin oluşturulması için tüm bilgileri doğru girdiğinizden emin olun!"),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OncekiSiparis()),
                  );
                },
                child: Text('Önceki Siparişler'))
          ],
        ),
      ),
    );
  }
}
/*          CollectionReference siparisBilgileri =
                    FirebaseFirestore.instance.collection('siparisBilgileri');
*/



class SiparisAlindi extends StatelessWidget {
  const SiparisAlindi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('Siparişiniz Alınmıştır..'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 150, 0, 0),
        child: ListView(
          children: [
            Text("SİPARİŞİNİZ ALINMIŞTIR"),
            Text(ad.text),
            Text(soyad.text),
            Text(yemek.text),
          ],
        ),
      ),
    );
  }
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.fromLTRB(80, 100, 80, 0),
        child: ListView(
          children: [
            Image.asset('assets/karanda.jpg'),
            //Image.network('https://media-exp1.licdn.com/dms/image/C4D0BAQFPivthZ9kSsA/company-logo_200_200/0/1662573763565?e=1675296000&v=beta&t=3JIOG4WYnYZoLdb2obSZWHz_qusJ0RUMEq7gLWR0Qw0'),
            Text(
              'KARANDA',
              style: TextStyle(fontSize: 55, color: Colors.grey[400]),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SiparisEkrani()),
                );
              },
              child: Text(
                'Giriş',
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class OncekiSiparis extends StatefulWidget {
  const OncekiSiparis({Key? key}) : super(key: key);
  @override
  State<OncekiSiparis> createState() => _OncekiSiparisState();
}

class _OncekiSiparisState extends State<OncekiSiparis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Önceki Siparişler'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(onPressed: yaziGetir, child: Text('Getir'))
            ],
          ),
          ListTile(
            title: Text(gelenVeriYemek),
            subtitle: Text(gelenVeriSoyad),
          ),
        ],
      ),
    );
  }
  yaziGetir(){
    FirebaseFirestore.instance
        .collection('siparisBilgileri')
        .doc(fullName)
        .get().then((gelenVeri){
       setState(() {
         gelenVeriAd = gelenVeri.data()!['ad'];
         gelenVeriSoyad = gelenVeri.data()!['soyad'];
         gelenVeriYemek = gelenVeri.data()!['yemek'];
       });
    });
  }
}