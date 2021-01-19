
import 'db_helper.dart';

class car{

  int id;
  String name;
  int miles;

  car({this.id, this.name, this.miles});

  car.fromMap(Map<String , dynamic> map){

    id = map['id'];
    name = map['name'];
    miles = map['miles'];

    Map<String , dynamic> toMap(){
      return{
        DatabaseHelper.columnId : id ,
        DatabaseHelper.columnName : name ,
        DatabaseHelper.columnMiles : miles ,
      };
    }

  }
}