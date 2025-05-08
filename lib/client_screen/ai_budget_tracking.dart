import 'package:flutter/material.dart';
import 'marquee_list_page.dart';

class AIBudgetTracking extends StatefulWidget {
  @override
  _AIBudgetTrackingState createState() => _AIBudgetTrackingState();
}

class _AIBudgetTrackingState extends State<AIBudgetTracking> {
  double _budget = 123455;

  void _navigateToMarquees() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarqueeListPage(budget: _budget),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: const Text("Find Your Perfect Marquee"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Your Budget:", style: TextStyle(fontSize: 16)),
                  Text("PKR ${_budget.toStringAsFixed(0)}",
                      style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Slider(
                    min: 100000,
                    max: 1000000000,
                    divisions: 90,
                    value: _budget,
                    onChanged: (val) {
                      setState(() {
                        _budget = val;
                      });
                    },
                  ),
                  const Text("Showing marquees within your budget range")
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToMarquees,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text("Show Suggested Marquees"),
            ),
          ],
        ),
      ),
    );
  }
}