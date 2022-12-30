import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ));
}

OutlineInputBorder myfocusborder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ));
}

// Widget myTextField(
//   final controller,
//   bool validate,
//   String validationTitle,
// ) {
//   return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: "Email",
//         prefixIcon: Icon(Icons.email_outlined),
//         border: myinputborder(),
//         enabledBorder: myinputborder(),
//         focusedBorder: myfocusborder(),
//       ),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: (value) => validate ? validationTitle : null);
// }

// Widget filePickerWidget(Future<dynamic> selectFile, PlatformFile pickedFile) {
//   return GestureDetector(
//     onTap: (() => selectFile),
//     child: Container(
//       height: 100,
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           border: Border.all(width: 2, color: Colors.black)),
//       child: Row(
//         children: [
//           // Image.asset(
//           //   'assets/img/logo.png',
//           //   fit: BoxFit.cover,
//           //   width: 120,
//           // ),
//           if (pickedFile != null)
//             Expanded(
//               child: Container(
//                 child: Image.file(
//                   File(pickedFile.path!),
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           SizedBox(
//             width: 20,
//           ),
//           Text('Foto Selfie')
//         ],
//       ),
//     ),
//   );
// }
