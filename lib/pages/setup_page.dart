import 'package:brie/main.dart';
import 'package:brie/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostInput = useTextEditingController(
      text: api.apiKey.isEmpty ? 'http://localhost:9862' : api.apiKey,
    );
    final userName = useTextEditingController(text: kDebugMode ? 'admin' : '');
    final pass = useTextEditingController(text: kDebugMode ? 'admin' : '');

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 200.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Setup page', style: TextStyle(fontSize: 30)),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                  hintText: 'API url', border: OutlineInputBorder()),
              controller: hostInput,
            ),
            AutofillGroup(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextField(
                    autofillHints: [AutofillHints.username],
                    decoration: InputDecoration(
                        hintText: 'Username', border: OutlineInputBorder()),
                    controller: userName,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    autofillHints: [AutofillHints.password],
                    decoration: InputDecoration(
                        hintText: 'Password', border: OutlineInputBorder()),
                    controller: pass,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final res = await http.head(Uri.parse('${hostInput.text}/'));
                  if (res.statusCode != 200) {
                    throw Exception('Invalid api url check and try again');
                  }

                  await prefs.setString('basepath', hostInput.text);
                  api.basePath = hostInput.text;

                  if (!context.mounted) return;
                  await api.login(context,
                      user: userName.text, pass: pass.text);
                } catch (e) {
                  print(e);
                  if (!context.mounted) return;

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return Column(
                        children: [
                          Text('An error occured'),
                          Text(e.toString())
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkUrlAndLogin(String host, String user, String pass) async {}
}
