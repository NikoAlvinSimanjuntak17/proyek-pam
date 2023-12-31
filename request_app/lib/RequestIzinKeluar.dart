import 'package:flutter/material.dart';
import 'package:PAM/Mahasiswa.views/FormIzinKeluar.dart';
import 'package:PAM/Mahasiswa.views/MahasiswaScreen.dart';
import 'package:PAM/Models/api_response.dart';
import 'package:PAM/Models/request_izin_keluar.dart';
import 'package:PAM/Auth/login_screen.dart';
import 'package:PAM/Services/IzinKeluar_service.dart';
import 'package:PAM/Services/globals.dart';
import 'package:PAM/Services/User_service.dart';

class RequestIzinKeluarScreen extends StatefulWidget {
  @override
  _RequestIzinKeluarScreenState createState() =>
      _RequestIzinKeluarScreenState();
}

class _RequestIzinKeluarScreenState extends State<RequestIzinKeluarScreen> {
  List<dynamic> _izinkeluarlist = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    try {
      userId = await getUserId();
      ApiResponse response = await getIzinKeluar();

      if (response.error == null) {
        setState(() {
          _izinkeluarlist = response.data as List<dynamic>;
          _loading = false;
        });
      } else if (response.error == unauthrorized) {
        logout().then((value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              )
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in retrievePosts: $e");
    }
  }

  void _navigateToAddData() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FormIzinKeluars(
              title: 'Request Izin Keluar',
            )));
  }

  void deleteIzinKeluar(int id) async {
    try {
      ApiResponse response = await DeleteIzinKeluar(id);

      if (response.error == null) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
        retrievePosts();
      } else if (response.error == unauthrorized) {
        // ... (unchanged)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in deleteIzinKeluar: $e");
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Izin Keluar Requests'),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Keperluan IK')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _izinkeluarlist.map((requestIzinKeluar) {
                    int index = _izinkeluarlist.indexOf(requestIzinKeluar);
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(requestIzinKeluar.reason)),
                        DataCell(Text(requestIzinKeluar.status)),
                        DataCell(
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: Text('Edit'),
                                  value: 'edit',
                                ),
                                PopupMenuItem(
                                  child: Text('View'),
                                  value: 'view',
                                ),
                                PopupMenuItem(
                                  child: Text('Delete'),
                                  value: 'delete',
                                ),
                              ];
                            },
                            onSelected: (String value) {
                              if (value == 'edit') {
                                int index =
                                    _izinkeluarlist.indexOf(requestIzinKeluar);
                                RequestIzinKeluar selectedIzinKeluar =
                                    _izinkeluarlist[index];

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FormIzinKeluars(
                                    title: "Edit Izin Keluar",
                                    formIzinKeluar: selectedIzinKeluar,
                                  ),
                                ));
                              } else if (value == 'view') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("View Izin Keluar"),
                                      content: Text(
                                          "Keperluan IK: ${requestIzinKeluar.reason}"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (value == 'delete') {
                                int index =
                                    _izinkeluarlist.indexOf(requestIzinKeluar);
                                RequestIzinKeluar selectedIzinKeluar =
                                    _izinkeluarlist[index];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Delete Izin Keluar"),
                                      content: Text(
                                          "Are you sure you want to delete this request?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteIzinKeluar(
                                                selectedIzinKeluar.id ?? 0);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddData,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
