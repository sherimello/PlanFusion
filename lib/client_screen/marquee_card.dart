import 'package:flutter/material.dart';
import '../bookings/booking_form_al_karim.dart';
import '../bookings/booking_form_diamond.dart';
import '../bookings/booking_form_elegance.dart';
import '../bookings/booking_form_grandeur.dart';
import '../bookings/booking_form_imperial.dart';
import '../bookings/booking_form_majesty.dart';
import '../bookings/booking_form_moonlight.dart';
import '../bookings/booking_form_royal_palace.dart';
import '../bookings/booking_form_sunshine.dart';
import '../bookings/booking_form_topi_rakh.dart';

class MarqueeCard extends StatelessWidget {
  final Map<String, dynamic> marquee;
  const MarqueeCard({required this.marquee});

  void navigateToForm(BuildContext context) {
    switch (marquee['name']) {
      case 'Majesty Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormMajesty()));
        break;
      case 'Al Karim Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormAlKarim()));
        break;
      case 'Topi Rakh Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormTopiRakh()));
        break;
      case 'Grandeur Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormGrandeur()));
        break;
      case 'Royal Palace Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormRoyalPalace()));
        break;
      case 'Elegance Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormElegance()));
        break;
      case 'Diamond Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormDiamond()));
        break;
      case 'Sunshine Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormSunshine()));
        break;
      case 'Moonlight Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormMoonlight()));
        break;
      case 'Imperial Marquee':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormImperial()));
        break;
      default:
        print('No booking form available for this marquee.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              marquee['image'],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: Text(marquee['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PKR ${marquee['minPrice']}", style: const TextStyle(color: Colors.pink)),
                Text(marquee['range']),
                Text(marquee['menu']),
                Text(marquee['location']),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => navigateToForm(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink.shade200),
              child: const Text("Book Now"),
            ),
          ),
        ],
      ),
    );
  }
}
