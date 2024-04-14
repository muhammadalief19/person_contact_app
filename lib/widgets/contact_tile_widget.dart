import 'package:flutter/material.dart';
import 'package:person_contact_app/models/contact.dart';

class ContactTileWidget extends StatelessWidget {
  const ContactTileWidget(
      {super.key,
      required this.contact,
      required this.index,
      required this.context});
  final Contact contact;
  final int index;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage:
            NetworkImage('https://i.pravatar.cc/100?u=${contact.phoneNumber}'),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.phoneNumber),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
    );
  }
}
