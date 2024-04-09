import 'package:flutter/material.dart';
import 'package:my_note_keeper/Models/note_model.dart';
import 'package:my_note_keeper/note_add.dart';
import 'package:my_note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<NoteModel> notes = [];
  int count = 0;
 @override
  void initState() {
    super.initState();
    UpdateListview();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text("Notes"),
      ),
      body: getNotesListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigateToNextScreen(NoteModel('', 2, ''), "Add Note");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNotesListView() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(this.notes[index].title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            subtitle: Text(this.notes[index].date,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.notes[index].priority),
              child: getPriorityIcon(this.notes[index].priority),
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                deleteNote(context, this.notes[index]);
              },),
            onTap: () {
              NavigateToNextScreen(this.notes[index], "Edit Note");
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 3, thickness: 2,);
        },
        itemCount: count);
  }


  Color getPriorityColor(int priority) {
    if (priority == 1) {
      return Colors.red;
    }
    return Colors.yellow;
  }

  Icon getPriorityIcon(int priority) {
    if (priority == 1) {
      return Icon(Icons.play_arrow);
    }
    return Icon(Icons.keyboard_arrow_right);
  }


  // Deleting Note
  Future<void> deleteNote(BuildContext context, NoteModel note) async {
    int result = await databaseHelper.DeleteNote(note.id!);
    if (result != 0) {
      _showSnakbar(context, "Note deleted Sucessfully");
      UpdateListview();
    }
  }

  void _showSnakbar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


  // Getting Data List from database
  void UpdateListview() {
    final Future<Database?> dbFuture = databaseHelper.mydatabase;
    dbFuture.then((database) {
      Future<List<NoteModel>> futureNoteList = databaseHelper.getNoteList(); //then function means that under query will be executed only after above query is executed and data recieved
      futureNoteList.then((
          notelist) { //the result of above line is notelist here
        this.notes = notelist;
        this.count = notelist.length;
        setState(() {});
      });
    });
  }

  Future<void> NavigateToNextScreen(NoteModel noteModel,String title) async {
     bool result=await Navigator.push(context, MaterialPageRoute(builder: (context) =>
        Note_Add(noteModel, title)));

     if(result){
       UpdateListview();
     }
  }
}


