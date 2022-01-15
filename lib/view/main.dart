import 'package:flutter/material.dart';
import 'package:note/db/database.dart';
import 'package:note/model/note.dart';
import 'package:note/view/add_note_page.dart';
import 'package:note/utils/app_color.dart';
import 'package:note/view/detail_note_page.dart';
import 'package:note/utils/view_config.dart';

void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: AppColor.color,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Note>> noteList;
  var currentView = ViewConfig.LIST;

  @override
  Widget build(BuildContext context) {
    noteList = NoteDataBase.db.getNoteList();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            color: AppColor.color,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              if (currentView == ViewConfig.GRID) {
                currentView = ViewConfig.LIST;
              } else {
                currentView = ViewConfig.GRID;
              }
              //todo check
              setState(() {});
            },
            icon: const Icon(Icons.list_alt, color: AppColor.color),
          ),
        ],
      ),
      //فرق futureBuilder با listView اینه که در لیست ویو فقط میشه لیست نشون داد ولی توی future میشه چیزهای دیگه ای به همراه لیست نشون داد
      body: FutureBuilder<List<Note>>(
        future: noteList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Colors.black87,
              //کلاس mediaQuery یه سری اطلاعات ثابت به ما میده
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(
                  left: 0.0, top: 2.0, right: 0.0, bottom: 2.0),
              child: getView(snapshot),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNotePage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getView(AsyncSnapshot<List<Note>> snapshot) {
    switch (currentView) {
      case ViewConfig.GRID:
        return getGridView(snapshot);
      default:
        return getListView(snapshot);
    }
  }

  ListView getListView(AsyncSnapshot<List<Note>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailNotePage(note: snapshot.data![index])));
          },
          child: Container(
            padding: const EdgeInsets.all(1),
            child: Card(
              color: Colors.black87,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data![index].title,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  GridView getGridView(AsyncSnapshot<List<Note>> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailNotePage(note: snapshot.data![index])));
          },
          child: Container(
            padding: const EdgeInsets.all(1),
            child: Card(
              color: Colors.black87,
              elevation: 8.0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data![index].title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data![index].title,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
      ),
    );
  }
}
