import 'package:flutter/material.dart';

Future <bool?> showDeleteDialog(
  BuildContext context,{
    String title="Delete Confirmation",
    String content="Are you sure you want to delete this item?",
    String discard="DISCARD",
    String delete="DELETE",
  }){
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:  Text("Discard"),
            ),
            
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }