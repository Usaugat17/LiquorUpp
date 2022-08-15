import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquor_inventory/utils/config/palette.dart';
import 'package:liquor_inventory/utils/string_extension.dart';
import 'package:liquor_inventory/utils/utils.dart';

class Widgets {
  static Widget backButton(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 10,
        ),
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Palette.primaryRed,
        ));
  }

  static Widget confimationDialog(BuildContext context, title, desc,
      dynamic Function(BuildContext) onPositive) {
    String location = "";

    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      content: Card(
        margin: const EdgeInsets.all(10),
        color: Colors.grey[300],
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Palette.primaryRed, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  backButton(context),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 60),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Expanded(
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Palette.accentedRed),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .35,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Palette.accentedRed)),
                      child: const Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Palette.primaryRed,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onPositive(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .35,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Palette.accentedRed),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        "Confirm",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.accentedRed),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  static Widget inputDialog(BuildContext context, String title, String hintText,
      {required onChange, required onComplete, icon = Icons.text_fields}) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      content: Card(
        margin: const EdgeInsets.all(10),
        color: Colors.grey[300],
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Palette.primaryRed, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  backButton(context),
                  Expanded(
                    flex: 8,
                    child: Container(
                      margin: const EdgeInsets.only(right: 60),
                      child: Text(
                        title.capitalize(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF000000)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * (1.3 / 6),
              width: MediaQuery.of(context).size.width * (6 / 6),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFFF),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 1,
                        cursorColor: Palette.primaryRed,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Palette.primaryRed, width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            hintText: hintText,
                            prefixIcon: Icon(icon, color: Palette.primaryRed)),
                        textInputAction: TextInputAction.next,
                        onChanged: (v) => onChange(v),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onComplete(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .35,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.accentedRed),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Text(
                          "Submit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Palette.accentedRed),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget infoDialog(BuildContext context, String title, String desc) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(0),
        content: Container(
          height: MediaQuery.of(context).size.height * (1.5 / 6),
          child: Card(
            margin: const EdgeInsets.all(10),
            color: Colors.grey[300],
            elevation: 2,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Palette.primaryRed, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      backButton(context),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: const EdgeInsets.only(right: 60),
                          child: Text(
                            title.capitalize(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Palette.accentedRed),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    desc,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000)),
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}
