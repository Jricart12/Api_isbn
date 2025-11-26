import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _isbnController = TextEditingController();

  @override
  void dispose() {
    _isbnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/collecotheque.png',
                  height: 120,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Numéro ISBN :',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _isbnController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(13),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ex: 9781234567897',
                  ),
                  validator: (valeur) {
                    if (valeur == null ||
                        valeur.isEmpty ||
                        valeur.length != 13) {
                      return 'Please enter a valid 13-digit ISBN';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final isbn = _isbnController.text.trim();
                        Navigator.pushNamed(
                          context,
                          '/affiche',
                          arguments: isbn,
                        );
                      }
                    },
                    child: const Text('Entrer'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // future formulaire
                      },
                      child: const Text("Créer une bibliothèque"),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/bibliotheques');
                      },
                      child: const Text("Mes bibliothèque(s)"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
