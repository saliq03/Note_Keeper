import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:my_note_keeper/utils/database_helper.dart';

import 'Models/note_model.dart';

class Note_Add extends StatefulWidget{
  String appBarTitle;
  NoteModel noteModel;
  Note_Add(this.noteModel,this.appBarTitle);
  @override
  State<StatefulWidget> createState() =>_Note_Add(this.noteModel,this.appBarTitle);
}

class _Note_Add extends State<Note_Add>{
  String appBarTitle;
  NoteModel note;
  _Note_Add(this.note,this.appBarTitle);


  DatabaseHelper dbhelper=DatabaseHelper();
  var chooseValue;
  var _proirties=['Low','High'];
  var titleController=TextEditingController();
  var descriptionController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    // setting values of textfields when edit note
    titleController.text=note.title;
    if(note.discription!=null){
      descriptionController.text=note.discription!;
    }

   return Scaffold(
     appBar: AppBar(
       title: Text(this.appBarTitle,style:TextStyle(color: Colors.white),),
       backgroundColor: Colors.deepPurple.shade800,
     ),
     body: Padding(
       padding: const EdgeInsets.only(left: 15,right: 15),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [

           SizedBox(height: 10,),
           DropdownButton(
               items: _proirties.map((valueItem){
             return DropdownMenuItem(
                 value: valueItem,
                 child: Text(valueItem));
                 }).toList(),
                value: PriorityAsString(note.priority),
               hint: Text("Select Proiraty"),
               dropdownColor: Colors.grey,
               style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w400),

               onChanged:(newValue){
             PriorityAsInt(newValue!);
             setState(() {});
           }),

           SizedBox(height: 10,),
           TextField(
             controller: titleController,
             decoration:  InputDecoration(
               labelText: 'Title',
                border:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                )
             ),
           ),

           SizedBox(height: 10,),
           TextField(
             controller: descriptionController,
             decoration:  InputDecoration(
                 labelText: 'Discription',
                 border:  OutlineInputBorder(
                     borderRadius: BorderRadius.circular(6),
                     )
                 )
             ),

           SizedBox(height: 10,),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
             Expanded(child: ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,),onPressed: (){ _Save();}, child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),
             SizedBox(width: 5,),
             Expanded(child: ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple,),onPressed: (){_Delete();}, child: Text("Delete",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)))),
           ],)
         ],
       ),
     ),
   );
  }

  // Converting priority int value to String and display it to user in dropdown
 String PriorityAsString(int value){
    String priority=_proirties[0];
    switch (value){
      case 1:
        priority=_proirties[1];
        break;
      case 2:
        priority=_proirties[0];
        break;
    }
    return priority;
 }
  // Converting priority String value to int to before saving it into database
 void PriorityAsInt(String value){
   switch (value){
     case 'Low':
      note.priority=2;
      break;
     case 'High':
       note.priority=1;
       break;
   }
 }

 Future<void> _Save() async {

    note.title=titleController.text;
    note.discription=descriptionController.text;
    note.date=DateFormat.yMMMM().format(DateTime.now());

  try{
    int result=0;
    if(note.id!=null){
      result=await dbhelper.UpdateNote(note);
      }
    else{
      result=await dbhelper.InsertNote(note);
      }
    if(result!=0){
      _displaySnakbar(context, "Note saved successfully");
    }
    else{
      _displaySnakbar(context, "Problem Saving Note");
    }
  } catch (e) {
  print("Error saving note:");
  print( e);
  _displaySnakbar(context, "An error occurred while saving the note");
  }
    MoveToLastScreen();
 }

 void _Delete()async{
    if(note.id==null){
      _displaySnakbar(context,'No note was deleted');
      MoveToLastScreen();
      return;
    }
    int result=await dbhelper.DeleteNote(note.id!);
    if(result!=0){
      _displaySnakbar(context, "Note Deleted successfully");
    }
    else{
      _displaySnakbar(context, "Error occured while deleting note");
    }
    MoveToLastScreen();
 }
  void _displaySnakbar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void MoveToLastScreen(){
    Navigator.pop(context,true);
  }
}