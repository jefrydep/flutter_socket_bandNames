import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_server/models/band.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'queen', votes: 4),
    Band(id: '3', name: 'Heroes', votes: 7),
    Band(id: '4', name: 'Rock', votes: 9)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildBands(bands[index]);
        },
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: addNewBand),
    );
  }

  Widget _buildBands(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        // TODO: llamar el borrado en el server
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'deleted data',
              style: TextStyle(color: Colors.white),
            )),
      ),
      key: Key(band.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}'),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (!Platform.isAndroid) {
      return showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('new band name'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('add'),
                  onPressed: () {
                    return addBandList(textController.text);
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text('dismiss'),
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: textController,
            ),
            title: Text('Add New Name'),
            actions: [
              MaterialButton(
                  child: Text('Add'),
                  textColor: Colors.blue,
                  onPressed: () {
                    addBandList(textController.text);
                    print(textController.text);
                  })
            ],
          );
        });
  }

  addBandList(String name) {
    if (name.length > 1) {
      setState(() {});
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
    }
    return Navigator.pop(context);
  }

  deleteBandList(int id) {
    bands.remove(id);

    return bands;
  }
}
