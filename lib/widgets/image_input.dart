import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final imageFile =
        await imagePicker.getImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) {
      return;
    }
    setState(() {
      this._storedImage = File(imageFile.path);
    });
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage!.copy("${appDir.path}/$fileName");
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: (this._storedImage == null)
              ? Text(
                  "No image taken",
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  this._storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
          alignment: Alignment.center,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: this._takePicture,
            icon: Icon(Icons.camera),
            label: Text("Take Picture"),
            textColor: Theme.of(context).primaryColor,
          ),
        )
      ],
    );
  }
}
