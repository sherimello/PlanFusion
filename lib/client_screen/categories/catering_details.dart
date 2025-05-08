import 'package:flutter/material.dart';
import 'package:untitled5/client_screen/categories/booking_form.dart';
import 'package:dots_indicator/dots_indicator.dart';

class CateringDetailsScreen extends StatefulWidget {
  final String cateringName;
  final String cateringDescription;
  final List<String> cateringImages;

  const CateringDetailsScreen({
    super.key,
    required this.cateringName,
    required this.cateringDescription,
    required this.cateringImages,
  });

  @override
  _CateringDetailsScreenState createState() => _CateringDetailsScreenState();
}

class _CateringDetailsScreenState extends State<CateringDetailsScreen> {
  bool vegetarianSelected = false;
  bool nonVegetarianSelected = false;
  bool dessertSelected = false;

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

  void _navigateToBookingForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingFormScreen(
          marqueeName: widget.cateringName,
          marqueeDescription: widget.cateringDescription,
          marqueeImages: widget.cateringImages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cateringName),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Carousel
            Expanded(
              flex: 2,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.cateringImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    child: Image.asset(
                      widget.cateringImages[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              ),
            ),
            // Dots Indicator Below Images
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DotsIndicator(
                dotsCount: widget.cateringImages.length,
                position: _currentPage.toInt(),
                decorator: DotsDecorator(
                  activeColor: Colors.pink,
                  color: Colors.grey,
                  size: const Size.square(8.0),
                  activeSize: const Size(12.0, 12.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            // Catering Description Below Dots
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.cateringDescription,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Menu Options
            const Text("Select Menu Options:", style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text("Vegetarian Options"),
              value: vegetarianSelected,
              onChanged: (value) {
                setState(() {
                  vegetarianSelected = value!;
                });
                if (value == true) {
                  _navigateToBookingForm();
                }
              },
            ),
            CheckboxListTile(
              title: const Text("Non-Vegetarian Options"),
              value: nonVegetarianSelected,
              onChanged: (value) {
                setState(() {
                  nonVegetarianSelected = value!;
                });
                if (value == true) {
                  _navigateToBookingForm();
                }
              },
            ),
            CheckboxListTile(
              title: const Text("Dessert Options"),
              value: dessertSelected,
              onChanged: (value) {
                setState(() {
                  dessertSelected = value!;
                });
                if (value == true) {
                  _navigateToBookingForm();
                }
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
