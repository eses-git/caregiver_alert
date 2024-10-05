import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];
  bool _isLoading = false;
  int _currentBatch = 0;
  final int _batchSize = 20; // Fetch contacts in batches

  @override
  void initState() {
    super.initState();
  }

  // Function to load contacts and show loading dialog
  Future<void> _loadContacts(BuildContext context) async {
    // Show the loading dialog
    AlertDialog loadingDialog = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text("Loading Contacts..."),
        ],
      ),
    );

    // Ensure the dialog is shown
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return loadingDialog; // Show loading dialog
      },
    );

    setState(() => _isLoading = true); // Update loading state

    // Request permission and fetch contacts
    if (await Permission.contacts.request().isGranted) {
      List<Contact> fetchedContacts = await FlutterContacts.getContacts(
        withProperties: false,
        withThumbnail: false,
      );

      setState(() {
        _contacts.addAll(fetchedContacts);
        _currentBatch++;
      });
    } else {
      print('Permission denied');
    }

    // Close the loading dialog after contacts are loaded
    Navigator.of(context).pop(); // Close the loading dialog
    setState(() => _isLoading = false); // Update loading state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Contact'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length + 1, // For lazy loading
        itemBuilder: (context, index) {
          if (index == _contacts.length) {
            // Lazy load more contacts when at the end of the list
            if (!_isLoading) {
              _loadContacts(context); // Trigger loading more contacts
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final contact = _contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? 'No Name'),
            subtitle: Text(contact.phones.isNotEmpty
                ? contact.phones.first.number
                : 'No Phone'),
            onTap: () {
              // Insert selected contact logic here
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _loadContacts(context); // Start loading contacts on button click
        },
        child: Icon(Icons.contacts),
        tooltip: 'Add from Contacts',
      ),
    );
  }
}
