import 'package:flutter/material.dart';
import 'package:person_contact_app/database/contact_database.dart';
import 'package:person_contact_app/models/contact.dart';
import 'package:person_contact_app/screens/add_edit_contact_page.dart';
import 'package:person_contact_app/screens/contact_detail_page.dart';
import 'package:person_contact_app/widgets/contact_tile_widget.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late List<Contact> _contacts = [];
  bool _isLoading = true;

  Future<void> refreshContact() async {
    _contacts = await ContactDatabase.instance.getAllContacts();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white12,
        centerTitle: true,
      ),
      body: Visibility(
        visible: _isLoading,
        replacement: Visibility(
          visible: _contacts.isNotEmpty,
          replacement: const Center(
            child: Text('No Contact'),
          ),
          child: RefreshIndicator(
            onRefresh: refreshContact,
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final Contact contact = _contacts[index];
                return Card(
                  child: GestureDetector(
                    onTap: () async {
                      final route = MaterialPageRoute(
                        builder: (context) => ContactDetailPage(
                          id: contact.id!,
                          contact: contact,
                        ),
                      );
                      await Navigator.push(context, route);
                      refreshContact();
                    },
                    child: ContactTileWidget(
                      contact: contact,
                      index: index,
                      context: context,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        backgroundColor: Colors.white12,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddEditContactPage(),
    );
    await Navigator.push(context, route);
    refreshContact();
  }
}
