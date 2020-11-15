import 'dart:io';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:votes/src/services/socket.dart';
import 'package:votes/src/models/person.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Person> people =[];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('persons', _handlePersons);
    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.off('persons');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Votos',style: TextStyle(color: Colors.black),)),
        backgroundColor: Colors.white,elevation: 1,
        actions: [
          Container(
            padding: EdgeInsets.only(right:15),
            child: Center(child: FaIcon(FontAwesomeIcons.plug,color:
              (socketService.serverStatus == ServerStatus.Online)?Colors.green:Colors.grey
            )),
          )
        ],
      ),
      body: Column(
        children: [
          if(people.isNotEmpty) _showGraph(context),
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (BuildContext context, int index) {
                return _voteItem(people[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPerson(socketService),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[800],
        elevation: 1,
      ),
    );
  }

  _handlePersons(dynamic data) {
    this.people = (data as List)
      .map((person) 
        => Person.fromMap(person)).toList();
    setState(() {});
  }

  Widget _voteItem(Person person) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: Key(person.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit('person-delete',{'id':person.id}),
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
        onTap: () => socketService.socket.emit('person-vote',{'id':person.id}),
      ),
    );
  }

  _addPerson(SocketService socketService){
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
                onPressed:() => _addToList(textController.text,socketService)
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
                onPressed:() => _addToList(textController.text,socketService),
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

  _addToList(String text,SocketService socketService) {
    if(text.length>1){
      //this.people.add(Person(id: '${DateTime.now()}',name: text,votes: 0));
      socketService.socket.emit('person-add',{'name':text});
      setState(() {});
    }
    Navigator.pop(context);            
  }
  
  Widget _showGraph(BuildContext context){
    Map<String, double> dataMap = Map();
    people.forEach((e) {
      dataMap.putIfAbsent(e.name, () => e.votes.toDouble());
    });
    return Container(
      margin: EdgeInsets.symmetric(vertical:15),
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.25,
      child: PieChart(dataMap: dataMap,chartType: ChartType.ring,)
    );
  }
}

