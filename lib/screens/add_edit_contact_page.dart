import 'package:flutter/material.dart';
import 'package:person_contact_app/database/contact_database.dart';
import 'package:person_contact_app/models/contact.dart';
import 'package:person_contact_app/services/contact_message.dart';

class AddEditContactPage extends StatefulWidget {
  const AddEditContactPage({super.key, this.contact});
  final Contact? contact;

  @override
  State<AddEditContactPage> createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      final contact = widget.contact!;
      isUpdate = true;
      final name = contact.name;
      final phoneNumber = contact.phoneNumber;
      nameController.text = name;
      phoneNumberController.text = phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Update Contact' : 'Add Contact',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white12,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
          TextField(
            controller: phoneNumberController,
            decoration: const InputDecoration(
              hintText: 'Phone Number',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (isUpdate) {
                  await updateContact();
                } else {
                  await createContact();
                }
              },
              style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(Colors.blueAccent),
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
              child: Text(isUpdate ? 'Update' : 'Submit'),
            ),
          )
        ],
      ),
    );
  }

  Future<void> createContact() async {
    final name = nameController.text;
    final phoneNumber = phoneNumberController.text;
    final Contact contact = Contact(
        name: name, phoneNumber: phoneNumber, createdTime: DateTime.now());
    await ContactDatabase.instance.create(contact);

    // debugPrint('$response');
    showSuccessMessage('Create contact successfully', context);
    Navigator.pop(context);
  }

  Future<void> updateContact() async {
    final name = nameController.text;
    final phoneNumber = phoneNumberController.text;
    final Contact contact = Contact(
        id: widget.contact?.id,
        name: name,
        phoneNumber: phoneNumber,
        createdTime: DateTime.now());
    int update = await ContactDatabase.instance.updateContactById(contact);

    if (update == 1) {
      showSuccessMessage('Update contact successfully', context);
      Navigator.pop(context);
    } else {
      showErrorMessage('Update contact failed', context);
      debugPrint('$name');
    }
  }
}
