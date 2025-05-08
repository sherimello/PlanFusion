import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'booking_details.dart';

class BookingFormScreen extends StatefulWidget {
  final String marqueeName;
  final String marqueeDescription;
  final List<String> marqueeImages;

  const BookingFormScreen({
    super.key,
    required this.marqueeName,
    required this.marqueeDescription,
    required this.marqueeImages,
  });

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final PageController _pageController = PageController();
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.marqueeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFEFC8C5), // Elegant pink background
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 4,
        titleSpacing: 0,
        shadowColor: const Color(0xFFDFC2BF),
      ),
      backgroundColor: const Color(0xFFFDF5F5), // Soft background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Image Carousel with Rounded Corners
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.marqueeImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.marqueeImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
              ),
              // Dots Indicator Below Images
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DotsIndicator(
                  dotsCount: widget.marqueeImages.length,
                  position: _currentPage.toInt(), // Convert to int
                  decorator: DotsDecorator(
                    activeColor: const Color(0xFFEFC8C5), // Elegant pink
                    color: Colors.grey,
                    size: const Size.square(8.0),
                    activeSize: const Size(12.0, 12.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              // Marquee Description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  widget.marqueeDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87, // Darker color for readability
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Book Now Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsScreen(
                            marqueeName: widget.marqueeName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEFC8C5), // Elegant pink
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Book Now",
                      style: TextStyle(color: Colors.black), // Black text for contrast
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
