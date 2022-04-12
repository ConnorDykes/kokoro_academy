import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kokoro_academy/Screens/class_schedule.dart';
import 'package:kokoro_academy/Screens/contact_us.dart';
import 'package:kokoro_academy/Screens/info.dart';
import 'package:kokoro_academy/Screens/memberships.dart';
import 'package:kokoro_academy/Screens/store.dart';
import 'package:kokoro_academy/Screens/videos.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(71, 104, 213, 1),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromRGBO(71, 104, 213, 1),
          ),
          backgroundColor: const Color.fromRGBO(241, 244, 248, 1),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          )),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAnnouncements() {
    return FirebaseFirestore.instance.collection("Announcements").get();
  }

  @override
  void initState() {
    fetchAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () => _key.currentState!.openDrawer(),
          child: Icon(Icons.menu)),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/Kokoro_Logo.png",
                  height: 100,
                  width: 100,
                ),
              ],
            ),
            Text(
              "ANNOUNCEMENTS",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
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
                              (announcements[index]["date"] as Timestamp)
                                  .toDate();
                          String date =
                              DateFormat('MM/dd/yyyy').format(datetime);
                          String info = announcements[index]["info"];
                          return Card(
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
                          ));
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/Kokoro_Logo.png",
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              tileColor: Theme.of(context).primaryColor,
              title: const Text(
                'Home',
                style: TextStyle(fontSize: 18),
              ),
              textColor: Colors.white,
              leading: Icon(
                Icons.home_rounded,
                color: Colors.white,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Home(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              tileColor: Theme.of(context).primaryColor,
              title: const Text(
                'Videos',
                style: TextStyle(fontSize: 18),
              ),
              textColor: Colors.white,
              leading: Icon(
                Icons.ondemand_video_rounded,
                color: Colors.white,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Videos(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              tileColor: Theme.of(context).primaryColor,
              title: const Text(
                'Class Schedule',
                style: TextStyle(fontSize: 18),
              ),
              leading: Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              textColor: Colors.white,
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ClassSchedule(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              tileColor: Theme.of(context).primaryColor,
              title: const Text(
                'Store',
                style: TextStyle(fontSize: 18),
              ),
              textColor: Colors.white,
              leading: Icon(
                Icons.store_rounded,
                color: Colors.white,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Store(),
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              tileColor: Theme.of(context).primaryColor,
              title: const Text(
                'Membership',
                style: TextStyle(fontSize: 18),
              ),
              textColor: Colors.white,
              leading: Icon(
                Icons.badge,
                color: Colors.white,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Memberships(),
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              tileColor: Theme.of(context).primaryColor,
              title: const Text(
                'Contact Us',
                style: TextStyle(fontSize: 18),
              ),
              textColor: Colors.white,
              leading: Icon(
                Icons.contact_support,
                color: Colors.white,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ContactUs(),
                    ));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '212 W. McDaniel St.',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Springfield, MO 65806',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Info(),
                    ));
              },
              icon: Icon(
                Icons.info_rounded,
                color: Theme.of(context).primaryColor,
              ))
        ],
      ),
    );
  }
}
