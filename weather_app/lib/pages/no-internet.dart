import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple,
              Colors.orange,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 120,
            ),
            SizedBox(height: 40),
            Text(
              "İnternet Bağlantısı Yok",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Lütfen önce internet bağlantınızı kontrol ediniz, ardından sayfayı yenileyiniz.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 2.0, color: Colors.white),
                    minimumSize: Size(150, 50),
                    primary: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => print("a"),
                  //onPressed: () => checkPermissions(),
                  child: Text(
                    "Yenile",
                    style: TextStyle(fontSize: 16),
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
