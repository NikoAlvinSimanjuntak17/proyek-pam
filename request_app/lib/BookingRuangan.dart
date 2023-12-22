import 'package:flutter/material.dart';
import 'package:PAM/Mahasiswa.views/FormBookingRuangan.dart';
import 'package:PAM/Models/api_response.dart';
import 'package:PAM/Models/booking_ruangan.dart';
import 'package:PAM/Services/bookingruangan_service.dart';
import 'package:PAM/Models/ruangan.dart';
import 'package:PAM/Services/globals.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<BookingRuangan> bookingList = [];
  List<Ruangan> roomList = [];

  void deleteBooking(int id) async {
    try {
      ApiResponse response = await DeleteBookingRuangan(id);

      if (response.error == null) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
        fetchBookingRequests();
      } else if (response.error == unauthrorized) {
        // ... (unchanged)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in deleteBooking: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookingRequests();
  }

  Future<void> fetchBookingRequests() async {
    ApiResponse apiResponse = await getRequestRuangan();
    if (apiResponse.data != null) {
      setState(() {
        bookingList = List<BookingRuangan>.from(apiResponse.data);
      });
      await fetchRoomList();
    } else {
      print(apiResponse.error);
    }
  }

  Future<void> fetchRoomList() async {
    ApiResponse roomResponse = await getRuangan();
    if (roomResponse.data != null) {
      setState(() {
        roomList = List<Ruangan>.from(roomResponse.data);
      });
    } else {
      print(roomResponse.error);
    }
  }

  String getRoomName(int? roomId) {
    Ruangan? room = roomList.firstWhere(
      (room) => room.id == roomId,
      orElse: () => Ruangan(),
    );
    return room?.NamaRuangan ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Requests'),
      ),
      body: DataTable(
        columns: [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Room')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: bookingList.map((booking) {
          int index = bookingList.indexOf(booking);
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text('Room: ${getRoomName(booking.roomId)}')),
              DataCell(Text(booking.status ?? 'N/A')),
              DataCell(
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
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
                    if (value == 'view') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("View Booking Ruangan"),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Keperluan: ${booking.reason}"),
                                SizedBox(height: 8),
                                Text(
                                    "Waktu Mulai: ${booking.startTime ?? 'N/A'}"),
                                Text(
                                    "Waktu Berakhir: ${booking.endTime ?? 'N/A'}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                            ],
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          );
                        },
                      );
                    } else if (value == 'delete') {
                      int index = bookingList.indexOf(booking);
                      BookingRuangan selectedBooking = bookingList[index];
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete Booking"),
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
                                  deleteBooking(selectedBooking.id ?? 0);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingFormScreen(),
            ),
          ).then((value) {
            if (value == true) {
              fetchBookingRequests();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
