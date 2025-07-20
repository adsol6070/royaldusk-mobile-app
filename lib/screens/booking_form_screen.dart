import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/package.dart';
import 'package:royaldusk_mobile_app/models/tour.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Abstract class for bookable items
abstract class BookableItem {
  String get id;
  String get name;
  String get imageUrl;
  String get locationName;
  double get price;
  String get currency;
  String get serviceType;
  String get durationText;
  String get availabilityText;
}

// Package adapter
class PackageBookableItem implements BookableItem {
  final Package package;

  PackageBookableItem(this.package);

  @override
  String get id => package.id;

  @override
  String get name => package.name;

  @override
  String get imageUrl => package.imageUrl;

  @override
  String get locationName => package.location.name;

  @override
  double get price => package.price;

  @override
  String get currency => package.currency;

  @override
  String get serviceType => 'Package';

  @override
  String get durationText => '${package.duration} Days';

  @override
  String get availabilityText => package.availability;
}

// Tour adapter
class TourBookableItem implements BookableItem {
  final Tour tour;

  TourBookableItem(this.tour);

  @override
  String get id => tour.id;

  @override
  String get name => tour.name;

  @override
  String get imageUrl => tour.imageUrl;

  @override
  String get locationName => tour.location.name;

  @override
  double get price => tour.price;

  @override
  String get currency => 'INR'; // Tours use INR

  @override
  String get serviceType => 'Tour';

  @override
  String get durationText => '4-6 Hours';

  @override
  String get availabilityText => tour.tourAvailability;
}

class BookingFormScreen extends StatefulWidget {
  // final Package package;
  final BookableItem item;

  const BookingFormScreen({
    super.key,
    // required this.package,
    required this.item,
  });

  BookingFormScreen.fromPackage({
    super.key,
    required Package package,
  }) : item = PackageBookableItem(package);

  BookingFormScreen.fromTour({
    super.key,
    required Tour tour,
  }) : item = TourBookableItem(tour);

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialRequestsController =
      TextEditingController();

  // Form data
  DateTime? _selectedStartDate;
  String? _selectedNationality;
  int _numberOfTravelers = 1;
  bool _isProcessingPayment = false;

  // Contact information
  // static const String bookingPhoneNumber = '+91-98761-49140';
  // static const String bookingEmail = 'go@royaldusk.com';
  static const String whatsappNumber = '+919876149140';

  // Replace with your backend URL
  static const String backendUrl = 'https://api.royaldusk.com';

  // Sample nationalities list
  final List<String> _nationalities = [
    'Afghan',
    'Albanian',
    'Algerian',
    'American',
    'Andorran',
    'Angolan',
    'Argentine',
    'Armenian',
    'Australian',
    'Austrian',
    'Azerbaijani',
    'Bahamian',
    'Bahraini',
    'Bangladeshi',
    'Barbadian',
    'Belarusian',
    'Belgian',
    'Belizean',
    'Beninese',
    'Bhutanese',
    'Bolivian',
    'Bosnian',
    'Brazilian',
    'British',
    'Bruneian',
    'Bulgarian',
    'Burkinabe',
    'Burmese',
    'Burundian',
    'Cambodian',
    'Cameroonian',
    'Canadian',
    'Cape Verdean',
    'Central African',
    'Chadian',
    'Chilean',
    'Chinese',
    'Colombian',
    'Comoran',
    'Congolese',
    'Costa Rican',
    'Croatian',
    'Cuban',
    'Cypriot',
    'Czech',
    'Danish',
    'Djiboutian',
    'Dominican',
    'Dutch',
    'East Timorese',
    'Ecuadorean',
    'Egyptian',
    'Emirian',
    'English',
    'Equatorial Guinean',
    'Eritrean',
    'Estonian',
    'Ethiopian',
    'Fijian',
    'Filipino',
    'Finnish',
    'French',
    'Gabonese',
    'Gambian',
    'Georgian',
    'German',
    'Ghanaian',
    'Greek',
    'Grenadian',
    'Guatemalan',
    'Guinea-Bissauan',
    'Guinean',
    'Guyanese',
    'Haitian',
    'Herzegovinian',
    'Honduran',
    'Hungarian',
    'I-Kiribati',
    'Icelandic',
    'Indian',
    'Indonesian',
    'Iranian',
    'Iraqi',
    'Irish',
    'Israeli',
    'Italian',
    'Ivorian',
    'Jamaican',
    'Japanese',
    'Jordanian',
    'Kazakhstani',
    'Kenyan',
    'Kittian and Nevisian',
    'Kuwaiti',
    'Kyrgyz',
    'Laotian',
    'Latvian',
    'Lebanese',
    'Liberian',
    'Libyan',
    'Liechtensteiner',
    'Lithuanian',
    'Luxembourgish',
    'Macedonian',
    'Malagasy',
    'Malawian',
    'Malaysian',
    'Maldivan',
    'Malian',
    'Maltese',
    'Marshallese',
    'Mauritanian',
    'Mauritian',
    'Mexican',
    'Micronesian',
    'Moldovan',
    'Monacan',
    'Mongolian',
    'Moroccan',
    'Mosotho',
    'Motswana',
    'Mozambican',
    'Namibian',
    'Nauruan',
    'Nepalese',
    'New Zealander',
    'Ni-Vanuatu',
    'Nicaraguan',
    'Nigerian',
    'Nigerien',
    'North Korean',
    'Northern Irish',
    'Norwegian',
    'Omani',
    'Pakistani',
    'Palauan',
    'Panamanian',
    'Papua New Guinean',
    'Paraguayan',
    'Peruvian',
    'Polish',
    'Portuguese',
    'Qatari',
    'Romanian',
    'Russian',
    'Rwandan',
    'Saint Lucian',
    'Salvadoran',
    'Samoan',
    'San Marinese',
    'Sao Tomean',
    'Saudi',
    'Scottish',
    'Senegalese',
    'Serbian',
    'Seychellois',
    'Sierra Leonean',
    'Singaporean',
    'Slovakian',
    'Slovenian',
    'Solomon Islander',
    'Somali',
    'South African',
    'South Korean',
    'Spanish',
    'Sri Lankan',
    'Sudanese',
    'Surinamer',
    'Swazi',
    'Swedish',
    'Swiss',
    'Syrian',
    'Taiwanese',
    'Tajik',
    'Tanzanian',
    'Thai',
    'Togolese',
    'Tongan',
    'Trinidadian',
    'Tunisian',
    'Turkish',
    'Tuvaluan',
    'Ugandan',
    'Ukrainian',
    'Uruguayan',
    'Uzbekistani',
    'Venezuelan',
    'Vietnamese',
    'Welsh',
    'Yemenite',
    'Zambian',
    'Zimbabwean'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: Colors.white,
              onSurface: AppColors.darkGray,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  // Create Payment Intent on your backend
  Future<Map<String, dynamic>?> _createPaymentIntent() async {
    try {
      final totalPrice = widget.item.price * _numberOfTravelers;

      // Convert currency to appropriate format for Stripe
      String stripeCurrency;
      int stripeAmount;

      if (widget.item.currency == 'AED') {
        stripeCurrency = 'AED';
        stripeAmount = (totalPrice * 100).round(); // Amount in fils
      } else {
        // For INR, convert to AED (approximate conversion)
        stripeCurrency = 'AED';
        stripeAmount = ((totalPrice * 0.02) * 100).round(); // 1 INR ≈ 0.02 AED
      }

      final response = await http.post(
        Uri.parse('$backendUrl/payment-service/payment/create-intent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'amount': stripeAmount,
          'currency': stripeCurrency,
          'metadata': {
            'guestName': _fullNameController.text,
            'guestEmail': _emailController.text,
            'guestMobile': _phoneController.text,
            'guestNationality': _selectedNationality,
            'remarks': _specialRequestsController.text,
            'paymentMethod': 'Credit Card',
            'serviceType': widget.item.serviceType,
            'serviceId': widget.item.id,
            'serviceData': json.encode({
              'itemName': widget.item.name,
              'travelers': _numberOfTravelers,
              'travelDate': _selectedStartDate?.toIso8601String(),
              'price': widget.item.price,
              'totalAmount': totalPrice.toString(),
            }),
          },
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to create payment intent: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      return null;
    }
  }

  // // Process payment with Stripe
  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate() ||
        _selectedStartDate == null ||
        _selectedNationality == null) {
      _showValidationErrors();
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      // Step 1: Create Payment Intent
      final paymentIntentData = await _createPaymentIntent();

      if (paymentIntentData == null) {
        _showErrorDialog('Failed to create payment session. Please try again.');
        return;
      }

      // Step 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          merchantDisplayName: 'Royal Dusk Tours',
          customerId: paymentIntentData['customer_id'],
          customerEphemeralKeySecret: paymentIntentData['ephemeral_key'],
          billingDetails: BillingDetails(
            name: _fullNameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
          ),
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: AppColors.primaryOrange,
                  text: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

      // Step 3: Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // Step 4: Payment successful
      _showPaymentSuccessDialog();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User canceled the payment
        _showErrorDialog('Payment was canceled.');
      } else {
        _showErrorDialog('Payment failed: ${e.error.message}');
      }
    } catch (e) {
      _showErrorDialog('An unexpected error occurred: $e');
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
  }

  void _showValidationErrors() {
    String errorMessage = '';
    if (_selectedStartDate == null) {
      errorMessage += '• Please select a start date\n';
    }
    if (_selectedNationality == null) {
      errorMessage += '• Please select your nationality\n';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Missing Information',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          errorMessage.trim(),
          style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK',
                style: TextStyle(color: AppColors.primaryOrange)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Payment Error',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK',
                style: TextStyle(color: AppColors.primaryOrange)),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    final totalPrice = widget.item.price * _numberOfTravelers;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text('Payment Successful!',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person,
                          size: 14, color: AppColors.mediumGray),
                      const SizedBox(width: 4),
                      Text(
                        _fullNameController.text,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.mediumGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: AppColors.mediumGray),
                      const SizedBox(width: 4),
                      Text(
                        '${_selectedStartDate?.day}/${_selectedStartDate?.month}/${_selectedStartDate?.year}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.mediumGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.group,
                          size: 14, color: AppColors.mediumGray),
                      const SizedBox(width: 4),
                      Text(
                        '$_numberOfTravelers ${_numberOfTravelers == 1 ? 'Traveler' : 'Travelers'}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.mediumGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Paid: ${widget.item.currency} $totalPrice',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your ${widget.item.serviceType.toLowerCase()} booking has been confirmed! You will receive a confirmation email shortly with your booking details.',
              style: const TextStyle(fontSize: 14, color: AppColors.mediumGray),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to detail screen
              Navigator.pop(context); // Go back to list screen
            },
            child: Text('Back to ${widget.item.serviceType}s',
                style: const TextStyle(color: AppColors.mediumGray)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _contactViaWhatsApp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('WhatsApp'),
          ),
        ],
      ),
    );
  }

  Future<void> _contactViaWhatsApp() async {
    final totalPrice = widget.item.price * _numberOfTravelers;
    final message = '''
Hi! I've just submitted a booking request:

Package: ${widget.item.name}
Name: ${_fullNameController.text}
Email: ${_emailController.text}
Phone: ${_phoneController.text}
Nationality: $_selectedNationality
Start Date: ${_selectedStartDate?.day}/${_selectedStartDate?.month}/${_selectedStartDate?.year}
Travelers: $_numberOfTravelers
Total Price: ${widget.item.currency} $totalPrice

${_specialRequestsController.text.isNotEmpty ? 'Special Requests: ${_specialRequestsController.text}' : ''}

Please confirm my booking and provide payment details.
''';

    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _animationController,
            child: Column(
              children: [
                _buildItemHeader(),
                Expanded(
                  child: _buildBookingForm(),
                ),
                _buildBottomSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: AppColors.darkGray, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Column(
        children: [
          Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          Text(
            'Complete your booking information',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFF1F5F9)),
      ),
    );
  }

  Widget _buildItemHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: AppColors.lightOrange,
                  child: Icon(
                    widget.item.serviceType == 'Tour'
                        ? Icons.tour
                        : Icons.card_travel,
                    color: AppColors.primaryOrange,
                    size: 32,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: AppColors.mediumGray),
                    const SizedBox(width: 4),
                    Text(
                      widget.item.locationName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      widget.item.serviceType == 'Tour'
                          ? Icons.schedule
                          : Icons.access_time,
                      size: 14,
                      color: AppColors.mediumGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.item.durationText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.item.currency} ${widget.item.price} /person',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Personal Information'),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _fullNameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildNationalityDropdown(),
            const SizedBox(height: 24),
            _buildSectionTitle('Travel Information'),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildTravelerCounter(),
            const SizedBox(height: 24),
            _buildSectionTitle('Additional Information'),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _specialRequestsController,
              label: 'Special Requests (Optional)',
              icon: Icons.note_add,
              maxLines: 4,
              validator: null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.darkGray,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryOrange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryOrange),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: AppColors.mediumGray),
      ),
    );
  }

  Widget _buildNationalityDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedNationality,
        decoration: const InputDecoration(
          labelText: 'Nationality',
          prefixIcon: Icon(Icons.flag, color: AppColors.primaryOrange),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: _nationalities.map((nationality) {
          return DropdownMenuItem(
            value: nationality,
            child: Text(nationality),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedNationality = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select your nationality';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectStartDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primaryOrange),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start Date',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedStartDate != null
                        ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}'
                        : 'Select your travel start date',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedStartDate != null
                          ? AppColors.darkGray
                          : AppColors.mediumGray,
                      fontWeight: _selectedStartDate != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.mediumGray),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelerCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const Icon(Icons.group, color: AppColors.primaryOrange),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Number of Travelers',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_numberOfTravelers ${_numberOfTravelers == 1 ? 'Traveler' : 'Travelers'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _numberOfTravelers > 1
                    ? () {
                        setState(() {
                          _numberOfTravelers--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.primaryOrange,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '$_numberOfTravelers',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _numberOfTravelers < 10
                    ? () {
                        setState(() {
                          _numberOfTravelers++;
                        });
                      }
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.primaryOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    final totalPrice = widget.item.price * _numberOfTravelers;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                Text(
                  '${widget.item.currency} $totalPrice',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessingPayment ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isProcessingPayment
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Processing Payment...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Secure payment powered by Stripe. Your payment information is encrypted and secure.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
