import 'package:flutter/material.dart';
import 'package:traffic_congestion/views/shared/text_field_widget.dart';

class DateFieldWidget extends StatefulWidget {
  const DateFieldWidget(
      {Key? key,
        required this.controller,
        this.hintText,
        this.validator, this.readOnly=false})
      : super(key: key);
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  @override
  State<DateFieldWidget> createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      controller: widget.controller,
      readOnly: true,
      hintText: widget.hintText,
      validator: widget.validator,
      prefixIcon: Icon(Icons.date_range, color: Theme.of(context).primaryColor),
      onTap: widget.readOnly?null:() async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2100));

        if (pickedDate != null) {
          // String formattedDate =
          //     "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
          widget.controller.text = pickedDate.toIso8601String();
          setState(() {});
        } else {}
      },
    );
  }
}
