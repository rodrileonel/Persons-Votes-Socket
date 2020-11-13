
class Person{
  String id;
  String name;
  int votes;

  Person({this.id,this.name,this.votes});

  factory Person.fromMap(Map<String,dynamic> obj) 
    => Person(
      id: obj['id'],
      name: obj['name'],
      votes: obj['votes'],
    );
}