import 'package:flutter/material.dart';
import 'package:PAM/Auth/login_screen.dart';
import 'package:PAM/Mahasiswa.views/BookingBaju.dart';
import 'package:PAM/Mahasiswa.views/RequestIzinKeluar.dart';
import 'package:PAM/Mahasiswa.views/RequestIzinBermalam.dart';
import 'package:PAM/Mahasiswa.views/RequestSurat.dart';
import 'package:PAM/Services/User_service.dart';
import 'package:PAM/Mahasiswa.views/BookingRuangan.dart';

class MahasiswaScreen extends StatelessWidget {
  const MahasiswaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baak Application'),
        backgroundColor: Colors.blue,
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
                  _buildDashboardItem(
                    context,
                    'Request Izin Keluar',
                    Icons.outbox,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RequestIzinKeluarScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    'Request Izin Bermalam',
                    Icons.night_shelter,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RequestIzinBermalamScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    'Booking Ruangan',
                    Icons.event,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => BookingScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    'Request Surat',
                    Icons.mail,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RequestIzinSuratScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    'Log Out',
                    Icons.exit_to_app,
                    () async {
                      await logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context,
    String title,
    IconData iconData,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 5.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 50.0, color: Colors.black),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
