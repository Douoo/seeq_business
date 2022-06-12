import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../screens/events/add_ticket.dart';
import '../services/main_db.dart';
import '../utils/size_config.dart';

Future<dynamic> confirmDeleteDialog(
    BuildContext context, VoidCallback onDelete) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?', textAlign: TextAlign.center),
          content: const Text(
              'This will delete your ticket and can not be undone.',
              textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('CANCEL', style: TextStyle(color: Colors.grey))),
            SizedBox(width: SizeConfig.screenWidth * 0.03),
            ScopedModelDescendant<AppModel>(builder: (context, child, model) {
              return TextButton(
                  onPressed: onDelete,
                  child: Text('DELETE', style: TextStyle(color: Colors.red)));
            })
          ],
        );
      });
}
