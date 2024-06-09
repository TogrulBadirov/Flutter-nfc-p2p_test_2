import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC ISO-DEP Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _messageController = TextEditingController();
  String _nfcMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC ISO-DEP Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter Message',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendNfcMessage,
              child: Text('Send NFC Message'),
            ),
            SizedBox(height: 20),
            Text(
              _nfcMessage,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _sendNfcMessage() async {
    try {
      String message = _messageController.text;
      if (message.isNotEmpty) {
        // Convert the message to hexadecimal string
        String hexMessage = _stringToHex(message);

        // Start NFC session
        var tag = await FlutterNfcKit.poll();

        // Ensure the tag is not null and supports ISO-DEP
        if (tag != null && tag.type == NFCTagType.iso18092) {
          // Prepare a custom APDU command (adjust CLA, INS, P1, P2, Lc, Data, Le as needed)
          String apduCommand = '00A40400' + hexMessage.length.toRadixString(16).padLeft(2, '0') + hexMessage;
          print('Sending APDU Command: $apduCommand');

          // Send custom message over NFC
          var response = await FlutterNfcKit.transceive(apduCommand);
          print('Received Response: $response');

          setState(() {
            _nfcMessage = 'Response: $response';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('NFC message sent successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('NFC tag not found or ISO-DEP not supported.')),
          );
        }

        // End NFC session
        await FlutterNfcKit.finish();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a message to send.')),
        );
      }
    } catch (e) {
      print('Error sending NFC message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending NFC message: $e')),
      );
    }
  }

  // Helper function to convert a string to hexadecimal
  String _stringToHex(String input) {
    List<String> hex = [];
    for (int i = 0; i < input.length; i++) {
      hex.add(input.codeUnitAt(i).toRadixString(16).padLeft(2, '0'));
    }
    return hex.join('');
  }
}
