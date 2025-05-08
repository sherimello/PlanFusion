import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ServiceProviderProfile extends StatefulWidget {
  const ServiceProviderProfile({super.key});

  @override
  _ServiceProviderProfileState createState() => _ServiceProviderProfileState();
}

class _ServiceProviderProfileState extends State<ServiceProviderProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  // Service Provider Data
  final TextEditingController _nameController = TextEditingController(text: "Ali Beauty Salon");
  final TextEditingController _categoryController = TextEditingController(text: "Beauty & Spa");
  final TextEditingController _bioController = TextEditingController(text: "Professional makeup artist & hairstylist with 5 years experience");

  // Services Data
  List<Service> services = [
    Service("Bridal Makeup", "2,500", "2 hours", ["9:00 AM", "2:00 PM", "5:00 PM"]),
    Service("Hair Styling", "1,200", "1 hour", ["10:00 AM", "3:00 PM", "6:00 PM"]),
    Service("Manicure/Pedicure", "800", "45 mins", ["11:00 AM", "4:00 PM"]),
  ];

  // Clients Data
  List<Client> clients = [
    Client("Sara Khan", "Bridal Makeup", "25 May 2023", "assets/client1.jpg"),
    Client("Fatima Ahmed", "Hair Styling", "28 May 2023", "assets/client2.jpg"),
    Client("Ayesha Malik", "Manicure", "1 June 2023", "assets/client3.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Service Provider Profile',
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
              Tab(text: 'Profile'),
              Tab(text: 'Services'),
              Tab(text: 'Clients'),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 4,
          shadowColor: const Color(0xFFDFC2BF),
        ),
        backgroundColor: const Color(0xFFFFF5F4),
        body: TabBarView(
          children: [
            _buildProfileTab(),
            _buildServicesTab(),
            _buildClientsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFEFC8C5),
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!.path))
                      : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.black)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFC8C5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildEditableField("Business Name", _nameController),
          _buildEditableField("Category", _categoryController),
          _buildEditableField("About", _bioController, maxLines: 3),

          const SizedBox(height: 20),
          const Text(
            "Working Hours",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildWorkingHours(),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEFC8C5),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Save profile logic
              },
              child: const Text(
                "UPDATE PROFILE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "My Services",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.black),
                onPressed: () => _addNewService(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(services[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClientsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Clients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                child: const Text(
                  "View All",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              return _buildClientCard(clients[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                onPressed: () {},
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHours() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFC2BF)),
      ),
      child: Column(
        children: [
          _buildDayRow("Monday - Friday", "9:00 AM - 7:00 PM"),
          const Divider(color: Color(0xFFDFC2BF)),
          _buildDayRow("Saturday", "10:00 AM - 5:00 PM"),
          const Divider(color: Color(0xFFDFC2BF)),
          _buildDayRow("Sunday", "Closed"),
        ],
      ),
    );
  }

  Widget _buildDayRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            hours,
            style: TextStyle(
              color: hours == "Closed" ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                      onPressed: () => _editService(service),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                      onPressed: () => _deleteService(service),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  "Rs. ${service.price}",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.timer, size: 16, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  service.duration,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: service.availableTimes.map((time) => Chip(
                label: Text(
                  time,
                  style: const TextStyle(color: Colors.black),
                ),
                backgroundColor: const Color(0xFFEFC8C5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard(Client client) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEFC8C5),
          backgroundImage: AssetImage(client.imagePath),
          child: client.imagePath.isEmpty
              ? Text(
            client.name[0],
            style: const TextStyle(color: Colors.black),
          )
              : null,
        ),
        title: Text(
          client.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.service,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              client.date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        onTap: () {
          // View client details
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  void _addNewService() {
    // Implement add new service dialog
  }

  void _editService(Service service) {
    // Implement edit service dialog
  }

  void _deleteService(Service service) {
    // Implement delete service confirmation
  }
}

class Service {
  final String name;
  final String price;
  final String duration;
  final List<String> availableTimes;

  Service(this.name, this.price, this.duration, this.availableTimes);
}

class Client {
  final String name;
  final String service;
  final String date;
  final String imagePath;

  Client(this.name, this.service, this.date, this.imagePath);
}