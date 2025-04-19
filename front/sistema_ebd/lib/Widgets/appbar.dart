import 'package:flutter/material.dart';

AppBar CriarAppBar(context, String title){
  return AppBar(
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left, size: 30),
            color: Colors.white,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 16.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
  );
}