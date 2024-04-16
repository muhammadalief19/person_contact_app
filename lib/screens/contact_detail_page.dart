import 'package:flutter/material.dart';
import 'package:person_contact_app/database/contact_database.dart';
import 'package:person_contact_app/models/contact.dart';
import 'package:person_contact_app/screens/add_edit_contact_page.dart';
import 'package:person_contact_app/services/contact_message.dart';

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({super.key, required this.id, required this.contact});
  final int id;
  final Contact contact;
  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  late Contact contact =
      Contact(name: '', phoneNumber: '', createdTime: DateTime.now());

  Future<void> getContactById() async {
    Contact cont = await ContactDatabase.instance.getNoteById(widget.id);
    setState(() {
      contact = cont;
    });
  }

  @override
  void initState() {
    super.initState();
    getContactById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Contact',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white12,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/100?u=${contact.phoneNumber}'),
                ),
              )
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Name : ${contact.name}',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                'Phone Number : ${contact.phoneNumber}',
                style: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    final route = MaterialPageRoute(
                      builder: (context) => AddEditContactPage(
                        contact: contact,
                      ),
                    );
                    await Navigator.push(context, route);
                    getContactById();
                  },
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                ),
                const SizedBox(
                  width: 5.0,
                ),
                IconButton(
                  onPressed: () async {
                    int response = await ContactDatabase.instance
                        .deleteContactById(widget.id);
                    if (response == 1) {
                      showSuccessMessage(
                          'Delete contact successfully', context);
                      Navigator.pop(context);
                    } else {
                      showErrorMessage('Delete contact faild', context);
                    }
                  },
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
