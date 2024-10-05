import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../classes/app_contact.dart';
import '../classes/data_base.dart';
import 'add_contact.dart';
import 'edit_contact.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late Future<List<AppContact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _contactsFuture = _fetchContacts();
  }

  Future<List<AppContact>> _fetchContacts() async {
    try {
      Database database = await AppDataBase().database;
      final contacts = await AppContact.getAllContacts(database);
      print('Fetched contacts: ${contacts.length}');
      return contacts;
    } catch (e) {
      print('Error fetching contacts: $e');
      return [];
    }
  }

  Future<void> _deleteContact(AppContact contact) async {
    try {
      if (contact.id != null) {
        Database database = await AppDataBase().database;
        await AppContact.deleteContact(contact.id!, database);

        // Refresh the contact list after deletion
        setState(() {
          _contactsFuture = _fetchContacts();
        });
      } else {
        print('Contact ID is null. Cannot delete.');
      }
    } catch (e) {
      print('Error deleting contact: $e');
    }
  }

  void _showDeleteConfirmationDialog(AppContact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Contact"),
          content: Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                _deleteContact(contact);     // Then execute the deletion
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trusted Contacts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<AppContact>>(
              future: _contactsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final contact = snapshot.data![index];
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(contact.name),
                        subtitle: Text('Phone: ${contact.number}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                // Wait for the result when coming back from EditContactScreen
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditContactScreen(contactId: contact.id!),
                                  ),
                                );

                                // Refresh the contact list when returning from edit screen
                                setState(() {
                                  _contactsFuture = _fetchContacts();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(contact);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Wait for the result when coming back from AddContactScreen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddContactScreen()),
                    );

                    // Refresh the contact list when returning from add screen
                    setState(() {
                      _contactsFuture = _fetchContacts();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Add'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    addFromContacts(context); // Call the function to add from contacts
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Add from Contacts'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to add contacts from the phone's contact list
  void addFromContacts(BuildContext context) async {
    // Step 1: Request permission to access contacts
    if (await Permission.contacts.request().isGranted) {
      // Fetch the contacts
      Iterable<Contact> phoneContacts = await ContactsService.getContacts();

      // Show a dialog with the contacts
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select a Contact'),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: phoneContacts.length,
                itemBuilder: (context, index) {
                  Contact contact = phoneContacts.elementAt(index);

                  // Check if the contact has at least one phone number
                  if (contact.phones != null && contact.phones!.isNotEmpty) {
                    return ListTile(
                      title: Text(contact.displayName ?? 'No Name'),
                      subtitle: Text(contact.phones!.first.value ?? 'No Number'),
                      onTap: () async {
                        // Insert the selected contact into the database
                        await _insertSelectedContact(contact);

                        // Refresh the contact list after insertion
                        setState(() {
                          _contactsFuture = _fetchContacts();
                        });

                        Navigator.pop(context); // Close the dialog after selection
                      },
                    );
                  } else {
                    return Container(); // Skip contacts without a phone number
                  }
                },
              ),
            ),
          );
        },
      );
    } else {
      // If permission is denied, show a message or open the app settings.
      print('Permission denied to access contacts.');
    }
  }

  // Step 2: Insert the selected contact into the database
  Future<void> _insertSelectedContact(Contact contact) async {
    Database database = await AppDataBase().database;

    // Assuming you want to use the first phone number for the contact
    String phoneNumber = contact.phones!.first.value ?? '';

    AppContact newContact = AppContact(
      name: contact.displayName ?? 'No Name',
      appUserId: '', // Modify or add actual appUserId here
      number: phoneNumber,
      publicKey: '', // Add other fields if needed
      appId: '', // Add actual appId
      userId: '', // Add actual userId
    );

    try {
      await AppContact.insertAppContact(newContact, database);
      print('Contact from phone inserted successfully');
    } catch (e) {
      print('Error inserting contact from phone: $e');
    }
  }
}
