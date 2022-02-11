import 'package:flutter/material.dart';

class ResetPage extends StatelessWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: Colors.green[900],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset("images/eproof_app_logo.png"),
            const Center(
              child: SizedBox(
                width: 400,
                child: Card(
                  child: ResetForm(),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text('Developed by Tekda Pty Ltd/Gaia Inc'),
          ],
        ),
      ),
    );
  }
}

class ResetForm extends StatefulWidget {
  const ResetForm({Key? key}) : super(key: key);

  @override
  _ResetFormState createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  String _email = '';

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              validator: (value) =>
                  value!.isEmpty ? 'Email cannot be empty' : null,
              onSaved: (value) => _email = value!,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Send Request',
                style: TextStyle(fontSize: 20.0),
              ),
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.green[900]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Got your password? Login here')),
          )
        ],
      ),
    );
  }
}
