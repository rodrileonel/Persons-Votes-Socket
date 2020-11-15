
class Person{
  String id;
  String name;
  int votes;

  Person({this.id,this.name,this.votes});

  factory Person.fromMap(Map<String,dynamic> obj) 
    => Person(
      id: obj.containsKey('id') ? obj['id']:'no-id',
      name: obj.containsKey('name') ? obj['name']:'no-name',
      votes: obj.containsKey('votes') ? obj['votes']:0,
    );
}