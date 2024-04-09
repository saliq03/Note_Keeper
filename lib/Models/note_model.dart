

class NoteModel {
  int? _id;
  String _title;
  String? _discription;
  int _priority;
  String _date;

  NoteModel(this._title, this._priority, this._date,[this._discription]);

  NoteModel.withid(this._id, this._title, this._priority, this._date, [this._discription]);


  String get date => _date;

  int get priority => _priority;

  String? get discription => _discription;

  String get title => _title;

  int? get id => _id;



  set date(String newdate) {
    _date = newdate;
  }

  set priority(int value) {
    if(value>=1&& value<=2){
      _priority = value;
    }
  }

  set discription(String? newdescription) {
    if(newdescription!=null) {
      if (newdescription.length <= 255) {
        _discription = newdescription;
      }
    }
  }

  set title(String newtitle) {
    if(newtitle.length<=255){
      _title = newtitle;
    }
  }

  set id(int? newid) {
    _id = newid;
  }

  // converting Note object to Map Object
  Map<String,dynamic> tomap(){
    var map=Map<String,dynamic>();
    map['id']=_id;
    map['title']=_title;
    map['priority']=_priority;
    map['date']=_date;
    map['description']=_discription;

    return map;
  }

  //Extracting Note object from Map object
  factory NoteModel.fromMapObject(Map<String,dynamic>map){
    return new NoteModel.withid(
      map['id'],
      map['title'],
      map['priority'],
      map ['date'],
      map['description']??'',

     );
  }
}