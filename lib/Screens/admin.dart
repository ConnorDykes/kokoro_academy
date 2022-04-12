import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokoro_academy/main.dart';

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  TextEditingController titleCntrl = TextEditingController();
  TextEditingController infoCntrl = TextEditingController();

  Future<void> showAlert() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Announcements'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    controller: titleCntrl,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: 'Details',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    controller: infoCntrl,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                addAnnouncement();
                setState(() {
                  titleCntrl.clear();
                  infoCntrl.clear();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAnnouncements() async {
    return await FirebaseFirestore.instance.collection("Announcements").get();
  }

  Future<void> addAnnouncement() async {
    await FirebaseFirestore.instance.collection("Announcements").add({
      "title": titleCntrl.text,
      "date": DateTime.now(),
      "info": infoCntrl.text
    });
  }

  Future<void> deleteAnnouncement(String id) async {
    await FirebaseFirestore.instance
        .collection("Announcements")
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    showAlert();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      Text('Add Announcemment'),
                    ],
                  )),
            ),
          ],
        ),
        Text(
          'Swipe to Delete',
          style: TextStyle(color: Colors.grey),
        ),
        FutureBuilder<QuerySnapshot>(
            future: fetchAnnouncements(),
            builder: (context, snapshot) {
              List<QueryDocumentSnapshot> announcements =
                  snapshot.data?.docs ?? [];
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      String title = announcements[index]["title"];
                      DateTime datetime =
                          (announcements[index]["date"] as Timestamp).toDate();
                      String date = DateFormat('MM/dd/yyyy').format(datetime);
                      String info = announcements[index]["info"];
                      Key key = GlobalKey();
                      return Dismissible(
                        background: Container(color: Colors.red),
                        key: key,
                        onDismissed: (DismissDirection) {
                          deleteAnnouncement(announcements[index].id);
                        },
                        child: Card(
                            child: ExpansionTile(
                          collapsedIconColor: Theme.of(context).primaryColor,
                          title: Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(date),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(info),
                            )
                          ],
                        )),
                      );
                    }),
              );
            })
      ]),
    );
  }
}
