import 'package:flutter/material.dart';
import 'package:PAM/Auth/login_screen.dart';
import 'package:PAM/Baak.views/izinkeluarBaak_screen.dart';
import 'package:PAM/Baak.views/izinbermalamBaak_screen.dart';
import 'package:PAM/Baak.views/bookingruanganBaak_screen.dart';
import 'package:PAM/Baak.views/bookingbajuBaak_screen.dart';
import 'package:PAM/Baak.views/suratBaak_screen.dart';
import 'package:PAM/Services/User_service.dart';

class BaakScreen extends StatelessWidget {
  const BaakScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baak Application'),
        backgroundColor: Colors.grey[800], // Warna abu-abu tua
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildDashboardItem(context, 'Izin Keluar', Icons.outbox, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                IzinKeluarBaakView()));
                  }),
                  _buildDashboardItem(
                      context, 'Izin Bermalam', Icons.night_shelter, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                IzinBermalamBaakView()));
                  }),
                  _buildDashboardItem(context, 'Booking Ruangan', Icons.event,
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                BookingRuanganBaakView()));
                  }),
                  _buildDashboardItem(context, 'Request Surat', Icons.mail, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                IzinSuratBaakView()));
                  }),
                  _buildDashboardItem(context, 'Log Out', Icons.exit_to_app,
                      () async {
                    await logout();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, String title,
      IconData iconData, VoidCallback onPressed) {
    return Card(
      elevation: 5.0,
      color: Colors.grey[600], // Warna abu-abu tua
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 50.0, color: Colors.black), // Warna hitam
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Warna hitam
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
