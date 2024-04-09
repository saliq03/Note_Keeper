import 'dart:io';

import 'package:my_note_keeper/Models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static Database? _database;  //singleton object ...this will be created only once

 Future<Database?> get mydatabase async{

  if(_database!=null){
    return _database;
  }

 _database= await InitializeDatabase();
  print('creating database');
  return _database;
  }

  String TableName="Note_Table";
 String colId='id';
 String colTitle='title';
  String colDescription='description';
  String colPriority='priority';
  String colDate='date';

  InitializeDatabase() async {
  Directory directory= await getApplicationDocumentsDirectory();
  String path=directory.path+'/notes.db';
  var db=openDatabase(path,version: 1,onCreate: _CreateDB);
  return db;
  }

  void _CreateDB(Database db,int version)async{
   await db.execute(
       'CREATE TABLE $TableName($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }

  // Read operation
Future<List<Map<String,dynamic>>> GetNoteMapList() async {
   var db=await _database;
   // var result=db!.rawQuery('SELECT * From $TableName order by $colPriority ASC');  //Raw sql query
   var result=db!.query(TableName,orderBy: '$colPriority ASC');
   return result;
 }

  // Insert Operation
 Future<int> InsertNote(NoteModel note) async {
   var db=await _database;
  var result= db!.insert(TableName, note.tomap());
  return result;
 }

 // Update Operation
  Future<int> UpdateNote(NoteModel note) async {
  var db=await _database;
  var result= db!.update(TableName, note.tomap(),where: '$colId=?',whereArgs: [note.id]);
  return result;
 }

 // Delete Operation
  Future<int> DeleteNote(int id) async {
   var db=await _database;
   var result=db!.delete(TableName,where: '$colId=?',whereArgs: [id]);
   return result;
  }

  //getCount
   Future<int?> getCount()async{
   var db=await _database;
   List<Map<String,dynamic>> x=await db!.rawQuery('SELECT COUNT (*) FROM $TableName');
   var result =Sqflite.firstIntValue(x);
   return result;
   }

// return data from data base in the form of list of notemodels
   Future<List<NoteModel>> getNoteList() async {
     var noteMapList=await GetNoteMapList();
     if (noteMapList != null && noteMapList.isNotEmpty) {
       int count = noteMapList.length;
       List<NoteModel> noteList = [];
       for (int i = 0; i < count; i++) {
         noteList.add(NoteModel.fromMapObject(noteMapList[i]));
       }
       return noteList;
     }
     return [];


   }
}