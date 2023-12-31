import 'package:flutter/material.dart';
import 'package:PAM/Mahasiswa.views/FormIzinSurat.dart';
import 'package:PAM/Mahasiswa.views/MahasiswaScreen.dart';
import 'package:PAM/Models/api_response.dart';
import 'package:PAM/Models/request_surat.dart';
import 'package:PAM/Auth/login_screen.dart';
import 'package:PAM/Services/Surat_service.dart';
import 'package:PAM/Services/globals.dart';
import 'package:PAM/Services/User_service.dart';

class RequestIzinSuratScreen extends StatefulWidget {
  @override
  _RequestIzinSuratScreenState createState() => _RequestIzinSuratScreenState();
}

class _RequestIzinSuratScreenState extends State<RequestIzinSuratScreen> {
  List<dynamic> _izinsuratlist = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    try {
      userId = await getUserId();
      ApiResponse response = await getIzinSurat();

      if (response.error == null) {
        setState(() {
          _izinsuratlist = response.data as List<dynamic>;
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
        builder: (context) => FormIzinSurats(
              title: 'Request Surat',
            )));
  }

  void deleteIzinSurat(int id) async {
    try {
      ApiResponse response = await DeleteIzinSurat(id);

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
      print("Error in deleteSurat: $e");
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Izin Surat Requests'),
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
                  DataColumn(label: Text('Keperluan Surat')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _izinsuratlist.map((requestIzinSurat) {
                  int index = _izinsuratlist.indexOf(requestIzinSurat);
                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(requestIzinSurat.reason)),
                      DataCell(Text(requestIzinSurat.status)),
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
                                  _izinsuratlist.indexOf(requestIzinSurat);
                              RequestIzinSurat selectedIzinSurat =
                                  _izinsuratlist[index];

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FormIzinSurats(
                                  title: "Edit Surat",
                                  formIzinSurat: selectedIzinSurat,
                                ),
                              ));
                            } else if (value == 'view') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("View Surat"),
                                    content: Text(
                                        "Keperluan Surat: ${requestIzinSurat.reason}"),
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
                                  _izinsuratlist.indexOf(requestIzinSurat);
                              RequestIzinSurat selectedIzinSurat =
                                  _izinsuratlist[index];
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Surat"),
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
                                          deleteIzinSurat(
                                              selectedIzinSurat.id ?? 0);
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
    );
  }
}
