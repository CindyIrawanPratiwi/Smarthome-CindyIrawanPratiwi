import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DisplayImagePage extends StatefulWidget {
  @override
  _DisplayImagePageState createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  late String _email;
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _getEmail();
    _loadImages();
  }

  Future<void> _getEmail() async {
    setState(() {
      _email = "example@example.com";
    });
  }

  Future<void> _loadImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localPath = appDir.path + '/user_images/$_email/';

      final Directory directory = Directory(localPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      setState(() {
        _imagePaths = directory.listSync().map((file) => file.path).toList();
      });
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  Future<void> _deleteImage(String imagePath) async {
    try {
      File(imagePath).deleteSync();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gambar dihapus'),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        _imagePaths.remove(imagePath);
      });
    } catch (e) {
      print('Error deleting image from local storage: $e');
    }
  }

  void _showDeleteOption(String imagePath) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Hapus gambar'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteImage(imagePath);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImageToLocalStorage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localPath = appDir.path + '/user_images/${_email}/';

      final Directory directory = Directory(localPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final String imagePath =
          '$localPath${DateTime.now().millisecondsSinceEpoch}.png';
      imageFile.copySync(imagePath);

      _loadImages();
    } catch (e) {
      print('Error uploading image to local storage: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      _uploadImageToLocalStorage(imageFile);
    }
  }

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(
          imagePaths: _imagePaths,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galeri Foto'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _openGallery(context, index);
            },
            onLongPress: () {
              _showDeleteOption(_imagePaths[index]);
            },
            child: Image.file(
              File(_imagePaths[index]),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    // ListTile(
                    //   leading: Icon(Icons.photo_library),
                    //   title: Text('Import from Gallery'),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     _getImage(ImageSource.gallery);
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.camera_alt_outlined),
                      title: Text('Ambil Gambar'),
                      onTap: () {
                        Navigator.pop(context);
                        _getImage(ImageSource.camera);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final List<String> imagePaths;
  final int initialIndex;

  FullScreenImagePage({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: imagePaths.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(imagePaths[index])),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
