import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p; // For basename and extension


class VendorManagementScreen extends StatefulWidget {
  const VendorManagementScreen({super.key});

  @override
  State<VendorManagementScreen> createState() => _VendorManagementScreenState();
}

class _VendorManagementScreenState extends State<VendorManagementScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  final supabase = Supabase.instance.client;


  Future<String?> uploadFileAndGetUrl(File? imageFileToUpload, String bucketName, String uid) async {
    if (imageFileToUpload == null) {
      print('No file provided.');
      return null;
    }

    // --- 1. Define a unique path within the bucket for the file ---
    // It's good practice to make this path unique to avoid overwriting files.
    // You might include a user ID, timestamp, or the original filename.

    // Get the original file name and extension
    final String originalFileName = p.basename(imageFileToUpload.path); // e.g., 'my_image.jpg'
    final String fileExtension = p.extension(imageFileToUpload.path); // e.g., '.jpg' (includes the dot)
    // If you don't want the dot in the extension:
    // final String fileExtension = p.extension(imageFileToUpload.path).substring(1);


    // final String userId = supabase.auth.currentUser?.id ?? 'anonymous_user';
    // Ensure pathInBucket ends with the correct extension.
    // Using originalFileName directly might be okay if it's already unique,
    // otherwise, create a new unique name.
    // final String pathInBucket = '${DateTime.now().millisecondsSinceEpoch}_$originalFileName';
    final String pathInBucket = uid;
    // Or more simply if you just want a timestamped name:
    // final String pathInBucket = '$userId/${DateTime.now().millisecondsSinceEpoch}${fileExtension}';

    print('Uploading to bucket path: $pathInBucket');

    try {
      // --- 2. Upload the file ---
      await supabase.storage
          .from(bucketName) // Use the passed bucketName
          .upload(
        pathInBucket,    // The desired path and filename within the bucket
        imageFileToUpload, // This is already a dart:io File
        fileOptions: const FileOptions(
          cacheControl: '3600', // Optional: Cache for 1 hour
          upsert: false,        // Optional: false to fail if file exists, true to overwrite
        ),
      );
      print('File uploaded successfully to: $pathInBucket');

      // --- 3. Get the Public URL (if bucket/file is public) ---
      // This URL can be used directly if the file has public read access.
      final String publicUrl = await supabase.storage
          .from(bucketName)
          .createSignedUrl(pathInBucket, 365 * 24 * 60 * 60);
          // .getPublicUrl(pathInBucket);

      print('Public URL: $publicUrl');
      return publicUrl;

      // --- OR 3. Get a Signed URL (for private files, grants temporary access) ---
      /*
    try {
      final String signedUrl = await supabase.storage
          .from(bucketName)
          .createSignedUrl(
            pathInBucket,
            60 * 5, // URL valid for 5 minutes (300 seconds)
          );
      print('Signed URL: $signedUrl');
      return signedUrl;
    } on StorageException catch (e) {
      print('Error creating signed URL: ${e.message}');
      return null;
    }
    */

    } on StorageException catch (error) {
      print('Error uploading file or getting URL: ${error.message}');
      // Handle specific errors like 'BUCKET_NOT_FOUND', 'OBJECT_ALREADY_EXISTS' (if upsert is false)
      return null;
    } catch (error) {
      print('An unexpected error occurred: $error');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Vendor Management",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          backgroundColor: const Color(0xFFEFC8C5),
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "Jewellery"),
              Tab(text: "Dress"),
              Tab(text: "Catering"),
              Tab(text: "Marquee"),
              Tab(text: "Beauty"),
              // Tab(text: "Furniture"),
              // Tab(text: "Venue"),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 4,
          shadowColor: const Color(0xFFDFC2BF),
        ),
        backgroundColor: const Color(0xFFFFF5F4),
        body: TabBarView(
          children: [
            _buildCategoryScreen("Jewellery"),
            _buildCategoryScreen("Dress"),
            _buildCategoryScreen("Catering"),
            _buildCategoryScreen("Marquee"),
            _buildCategoryScreen("Beauty"),
            // _buildCategoryScreen("Furniture"),
            // _buildCategoryScreen("Venue"),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryScreen(String category) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F4),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(nameController, 'Product Name', 'Enter product name'),
              _buildTextField(descriptionController, 'Description', 'Enter product description'),
              _buildTextField(weightController, 'Weight', 'Enter product weight'),
              _buildTextField(priceController, 'Total Price', 'Enter total price'),
              _buildTextField(discountController, 'Discount', 'Enter discount (if any)'),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => uploadVendorData(category),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFC8C5),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("SAVE VENDOR"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        _imageFile != null
            ? Image.file(
          File(_imageFile!.path),
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        )
            : Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey[200],
          child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _showImageSourceDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEFC8C5),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("Capture/Select Image"),
        ),
      ],
    );
  }

  Future<void> _showImageSourceDialog() async {
    final isWeb = !(Platform.isAndroid || Platform.isIOS);

    if (isWeb) {
      await _pickImage(ImageSource.gallery);
      return;
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _checkCameraPermission();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _checkGalleryPermission();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _pickImage(ImageSource.camera);
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog('Camera');
    }
  }

  Future<void> _checkGalleryPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      await _pickImage(ImageSource.gallery);
    } else if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog('Gallery');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showPermissionDeniedDialog(String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: Text("$permission permission is needed to select images"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> uploadVendorData(String category) async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not authenticated"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // final storageRef = FirebaseStorage.instance
      //     .ref()
      //     .child('vendor_uploads')
      //     .child('$category-${DateTime.now().millisecondsSinceEpoch}.jpg');

      // await storageRef.putFile(File(_imageFile!.path));
      // final imageUrl = await storageRef.getDownloadURL();
      var fireStoreRef = FirebaseFirestore.instance.collection('vendor_services');
      var key = fireStoreRef.doc().id;

      String? imageUrl = await uploadFileAndGetUrl(File(_imageFile!.path), "fusion.ai", key).catchError((e) => print(e.toString()));
      // final supabase = Supabase.instance.client;
      //
      // final file = File(_imageFile!.path);
      // file.writeAsStringSync('File content');
      // await supabase.storage
      //     .from('my_bucket')
      //     .upload(_imageFile!.path, file).;

// Use the `uploadBinary` method to upload files on Flutter web
//       await supabase.storage
//           .from('my_bucket')
//           .uploadBinary('my/path/to/files/example.txt', file.readAsBytesSync());

      //https://gidofdfgiiawlahmdpjd.supabase.co/storage/v1/object/public/fusion.ai/1746719120885_scaled_e9cf34da-b955-4d08-ac7c-e1008218b08a3867615888988009679.jpg
      //1746718938079_scaled_2fc179d7-ec8b-43ef-9bb8-06a5a667a23b4789663170224725995.jpg
      await fireStoreRef.doc(key).set({
        'uid': key,
        'category': category,
        'productName': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'weight': weightController.text.trim(),
        'price': priceController.text.trim(),
        'discount': discountController.text.trim(),
        'imageUrl': imageUrl,
        'providerId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // await FirebaseFirestore.instance.collection('vendor_services').add({
      //   'category': category,
      //   'productName': nameController.text.trim(),
      //   'description': descriptionController.text.trim(),
      //   'weight': weightController.text.trim(),
      //   'price': priceController.text.trim(),
      //   'discount': discountController.text.trim(),
      //   'imageUrl': imageUrl,
      //   'providerId': userId,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });

      Navigator.pop(context);
      _clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vendor data uploaded successfully!"),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    weightController.clear();
    priceController.clear();
    discountController.clear();
    setState(() => _imageFile = null);
  }
}
