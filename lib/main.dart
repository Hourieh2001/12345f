import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';

void main() {
  runApp(ParkingApp());
}

class ParkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          // تحسين خط النص
          bodyText1: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyText2: TextStyle(
            fontSize: 14,
            color: Colors.black45,
          ),
          button: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Parking App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GPSPickerPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // لون الزر
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GPSPickerPage extends StatelessWidget {
  Future<void> _getLocation(BuildContext context) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Nearest Parking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'GPS Picker Page',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                _getLocation(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MYHomePage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text(
                'Search',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSlot {
  final String time;
  final String date;

  TimeSlot({required this.time, required this.date});
}

class MYHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Parking App',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReserveParkingPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text(
                'Reserve Parking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReserveParkingPage extends StatelessWidget {
  final List<int> reservedSlots = [2, 4, 6]; // Mocking reserved slots

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Parking'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 10, // Assuming there are 10 slots
          itemBuilder: (BuildContext context, int index) {
            final slotNumber = index + 1;
            final isReserved = reservedSlots.contains(slotNumber);

            return ListTile(
              title: Text('Slot $slotNumber'),
              subtitle: isReserved ? Text('Reserved') : Text('Available'),
              trailing: isReserved
                  ? null
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmReservationPage()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: const Text(
                        'Reserve',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class ConfirmReservationPage extends StatefulWidget {
  @override
  _ConfirmReservationPageState createState() => _ConfirmReservationPageState();
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Parking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select a timeslot:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Select Date'),
            ),
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Select Time'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Reservation Confirmed'),
                      content: Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}\nTime: ${_selectedTime.format(context)}'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ServicesPage()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Confirm Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Do you need any additional services?',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentMethodPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Skip'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdditionalServicesPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Request Service'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalServicesPage extends StatefulWidget {
  @override
  _AdditionalServicesPageState createState() => _AdditionalServicesPageState();
}

class _AdditionalServicesPageState extends State<AdditionalServicesPage> {
  bool carWash = false;
  bool oilChange = false;
  bool chargeCar = false;
  bool carMaintenance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Services'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Choose additional services:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('Car Wash'),
              value: carWash,
              onChanged: (bool? value) {
                setState(() {
                  carWash = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Oil Change'),
              value: oilChange,
              onChanged: (bool? value) {
                setState(() {
                  oilChange = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Charge Car'),
              value: chargeCar,
              onChanged: (bool? value) {
                setState(() {
                  chargeCar = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Car Maintenance'),
              value: carMaintenance,
              onChanged: (bool? value) {
                setState(() {
                  carMaintenance = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentMethodPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodPage extends StatefulWidget {
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  // Define controllers for payment details
  late TextEditingController cardNumberController;
  late TextEditingController cvvController;
  late TextEditingController expiryDateController;
  late TextEditingController paypalEmailController;
  late TextEditingController paypalPasswordController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    cardNumberController = TextEditingController();
    cvvController = TextEditingController();
    expiryDateController = TextEditingController();
    paypalEmailController = TextEditingController();
    paypalPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    cardNumberController.dispose();
    cvvController.dispose();
    expiryDateController.dispose();
    paypalEmailController.dispose();
    paypalPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Choose a payment method:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showCreditCardPaymentDialog(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Credit Card'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showPayPalPaymentDialog(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('PayPal'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreditCardPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Credit Card Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
              ),
              TextField(
                controller: cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
              ),
              TextField(
                controller: expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _processCreditCardPayment(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Confirm Payment'),
            ),
          ],
        );
      },
    );
  }

  void _showPayPalPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter PayPal Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: paypalEmailController,
                decoration: InputDecoration(labelText: 'PayPal Email'),
              ),
              TextField(
                controller: paypalPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _processPayPalPayment(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('Confirm Payment'),
            ),
          ],
        );
      },
    );
  }

  void _processCreditCardPayment(BuildContext context) {
    // Process credit card payment here
    print('Credit Card Number: ${cardNumberController.text}');
    print('CVV: ${cvvController.text}');
    print('Expiry Date: ${expiryDateController.text}');
    // Show payment success dialog
    _showPaymentSuccessDialog(context);
  }

  void _processPayPalPayment(BuildContext context) {
    // Process PayPal payment here
    print('PayPal Email: ${paypalEmailController.text}');
    print('Password: ${paypalPasswordController.text}');
    // Show payment success dialog
    _showPaymentSuccessDialog(context);
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment has been processed.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MYHomePage()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue), // لون الزر
                foregroundColor:
                    MaterialStateProperty.all(Colors.white), // لون النص
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
