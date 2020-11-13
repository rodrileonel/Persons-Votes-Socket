import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:votes/src/models/person.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Person> people =[
    Person(id: '1',name: 'Rodrigo',votes: 5),
    Person(id: '2',name: 'Elvis',votes: 2),
    Person(id: '3',name: 'Ian',votes: 1),
    Person(id: '4',name: 'Sol',votes: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Votos',style: TextStyle(color: Colors.black),)),backgroundColor: Colors.white,elevation: 1,),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (BuildContext context, int index) {
          return _voteItem(people[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPerson,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[800],
        elevation: 1,
      ),
    );
  }

  Widget _voteItem(Person person) {
    return Dismissible(
      key: Key(person.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){ 
        //person.id;
        //TODO: Borrar item en el server
        people.remove(person); //borrar esto
      },
      background: Container(
        padding: EdgeInsets.only(left:20),
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Icon(Icons.delete,color:Colors.white),
      ),
      child: ListTile(
        leading:CircleAvatar(
          child:Text(person.name.substring(0,2),style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.orange[800],
        ),
        title: Text(person.name),
        trailing: Text('${person.votes}',style: TextStyle(fontSize: 20),),
        onTap: (){},
      ),
    );
  }

  _addPerson(){
    final textController = TextEditingController();

    if(Platform.isAndroid)
      showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text('Agregar nueva persona'),
            content: TextField(controller: textController,),
            actions: [
              MaterialButton(
                child: Text('Agregar'),
                elevation: 3,
                textColor: Colors.orange[700],
                onPressed:() => addToList(textController.text)
              ),
            ],
          );
        }
      );
    else
      showCupertinoDialog(
        context: context, 
        builder: (_){
          return CupertinoAlertDialog(
            title: Text('Agregar nueva persona'),
            content: CupertinoTextField(controller: textController,),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Agregar'),
                onPressed:() => addToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cancelar'),
                onPressed:() => Navigator.pop(context),
              ),
            ],
          );
        }
      );
  }

  addToList(String text) {
    if(text.length>1){
      this.people.add(Person(id: '${DateTime.now()}',name: text,votes: 0));
      setState(() {});
    }
    Navigator.pop(context);            
  }
}