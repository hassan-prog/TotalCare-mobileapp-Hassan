import 'package:flutter/material.dart';

import '../models/user.dart';

// ignore: must_be_immutable
class BloodTypeInput extends StatefulWidget {
  final List bloodTypes;
  final TextEditingController bloodTypeController;
  User? user;
  Color? backColor;

  BloodTypeInput({
    super.key,
    required this.bloodTypes,
    required this.bloodTypeController,
    this.user,
    this.backColor,
  });

  @override
  State<BloodTypeInput> createState() => _BloodTypeInputState();
}

class _BloodTypeInputState extends State<BloodTypeInput> {
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.grey,
    ),
  );

  @override
  Widget build(BuildContext context) {
    Color containerFillColor = Colors.grey.shade100;
    Color labelColor = Colors.grey;

    return Container(
      decoration: widget.backColor != null
          ? null
          : BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.35),
                  offset: const Offset(0, 10),
                  blurRadius: 25,
                ),
              ],
            ),
      child: DropdownButtonFormField(
        icon: Icon(
          Icons.arrow_drop_down_circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        menuMaxHeight: 200,
        elevation: 0,
        isExpanded: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Blood Type',
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: widget.backColor != null
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent),
                )
              : outlineInputBorder,
          focusedBorder: widget.backColor != null
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent),
                )
              : outlineInputBorder,
          filled: true,
          fillColor: widget.backColor ?? containerFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items: widget.bloodTypes.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            widget.bloodTypeController.text = value!.toString();
          });
        },
        onSaved: (value) {
          if (value != null) {
            widget.user?.bloodType = value.toString();
          }
        },
      ),
    );
  }
}
