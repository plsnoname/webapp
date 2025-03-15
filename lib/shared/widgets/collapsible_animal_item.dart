import 'package:flutter/material.dart';

class CollapsibleAnimalItem extends StatefulWidget {
  final Map<String, dynamic> animal;

  const CollapsibleAnimalItem({
    Key? key,
    required this.animal,
  }) : super(key: key);

  @override
  _CollapsibleAnimalItemState createState() => _CollapsibleAnimalItemState();
}

class _CollapsibleAnimalItemState extends State<CollapsibleAnimalItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text('${widget.animal['type']} - ${widget.animal['breed']}'),
        subtitle: Text('Name: ${widget.animal['name'] ?? 'Unknown'}'),
        children: [
          ListTile(
            title: Text('Type: ${widget.animal['type']}'),
          ),
          ListTile(
            title: Text('Breed: ${widget.animal['breed']}'),
          ),
          ListTile(
            title: Text('Sex: ${widget.animal['sex']}'),
          ),
          ListTile(
            title: Text('Age: ${widget.animal['age']}'),
          ),
          ListTile(
            title: Text('Size: ${widget.animal['size']}'),
          ),
          ListTile(
            title: Text('Neuter: ${widget.animal['neuter']}'),
          ),
        ],
      ),
    );
  }
}
