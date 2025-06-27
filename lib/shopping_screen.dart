import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({super.key});

  @override
  _PaymentCheckoutScreenState createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  String? _selectedPaymentMethod; // Untuk menandai metode pembayaran mana yang "aktif"

  // Controllers untuk TextField
  final TextEditingController _visaCardNumberController = TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();
  final TextEditingController _bcaVirtualAccountController = TextEditingController();
  final TextEditingController _applePayIdController = TextEditingController();

  // FocusNodes untuk mengelola fokus TextField
  final FocusNode _visaFocusNode = FocusNode();
  final FocusNode _paypalFocusNode = FocusNode();
  final FocusNode _bcaFocusNode = FocusNode();
  final FocusNode _applePayFocusNode = FocusNode();

  @override
  void dispose() {
    _visaCardNumberController.dispose();
    _paypalEmailController.dispose();
    _bcaVirtualAccountController.dispose();
    _applePayIdController.dispose();

    _visaFocusNode.dispose();
    _paypalFocusNode.dispose();
    _bcaFocusNode.dispose();
    _applePayFocusNode.dispose();

    super.dispose();
  }

  // Fungsi untuk menangani pemilihan metode pembayaran
  void _selectPaymentMethod(String value, FocusNode focusNode) {
    setState(() {
      _selectedPaymentMethod = value;
    });
    // Berikan fokus ke TextField yang dipilih
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB((255 * 0.1).round(), 128, 128, 128),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const Text(
                        '₹ 7,000',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipping',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const Text(
                        '₹ 30',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1), // Divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '₹ 7,030',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Payment Section
            const Text(
              'Payment',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // Payment Method TextFields - can be filled by user and hide content
            _buildFillablePaymentMethodTextField(
              context,
              controller: _visaCardNumberController,
              focusNode: _visaFocusNode,
              methodName: 'VISA',
              hintText: 'Enter Card Number',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)], // Hanya angka, maks 16 digit
              obscureText: true, // Otomatis hide
              value: 'visa',
            ),
            const SizedBox(height: 12.0),
            _buildFillablePaymentMethodTextField(
              context,
              controller: _paypalEmailController,
              focusNode: _paypalFocusNode,
              methodName: 'PayPal',
              hintText: 'Enter PayPal Email',
              keyboardType: TextInputType.emailAddress,
              obscureText: false, // Email tidak perlu di-hide
              value: 'paypal',
            ),
            const SizedBox(height: 12.0),
            _buildFillablePaymentMethodTextField(
              context,
              controller: _bcaVirtualAccountController,
              focusNode: _bcaFocusNode,
              methodName: 'BCA Virtual Account',
              hintText: 'Enter Virtual Account Number',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Hanya angka
              obscureText: true, // Hide Virtual Account
              value: 'bca',
            ),
            const SizedBox(height: 12.0),
            _buildFillablePaymentMethodTextField(
              context,
              controller: _applePayIdController,
              focusNode: _applePayFocusNode,
              methodName: 'Apple Pay ID',
              hintText: 'Enter Apple Pay ID',
              keyboardType: TextInputType.text,
              obscureText: true, // Hide Apple Pay ID
              value: 'applepay',
            ),

            const SizedBox(height: 40.0), // Spacer before continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Continue button tap
                  // Validasi input di sini sebelum melanjutkan
                  if (_selectedPaymentMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a payment method and fill details.')),
                    );
                    return;
                  }

                  String paymentDetails = '';
                  if (_selectedPaymentMethod == 'visa') {
                    paymentDetails = _visaCardNumberController.text;
                    if (paymentDetails.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Visa Card Number.'))); return;
                    }
                  } else if (_selectedPaymentMethod == 'paypal') {
                    paymentDetails = _paypalEmailController.text;
                     if (paymentDetails.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter PayPal Email.'))); return;
                    }
                  } else if (_selectedPaymentMethod == 'bca') {
                    paymentDetails = _bcaVirtualAccountController.text;
                     if (paymentDetails.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter BCA Virtual Account Number.'))); return;
                    }
                  } else if (_selectedPaymentMethod == 'applepay') {
                    paymentDetails = _applePayIdController.text;
                     if (paymentDetails.isEmpty) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Apple Pay ID.'))); return;
                    }
                  }

                  print('Selected payment method: $_selectedPaymentMethod');
                  print('Payment Details: $paymentDetails');
                  // Lakukan logika pembayaran selanjutnya dengan paymentDetails
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E528A), // Warna biru gelap
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        onTap: (index) {
          print('Tapped on index $index');
        },
      ),
    );
  }

  Widget _buildFillablePaymentMethodTextField(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required String methodName,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    required String value, // Value unik untuk identifikasi metode
  }) {
    bool isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        _selectPaymentMethod(value, focusNode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Sesuaikan padding
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB((255 * 0.1).round(), 128, 128, 128),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row( // Menggunakan Row untuk menempatkan prefix (logo/nama) di kiri dan TextField di kanan
          children: [
            // Logo placeholder (dinonaktifkan)
            const SizedBox(width: 40, height: 25), // Ruang kosong seukuran logo
            // if (imagePath != null)
            //   Image.asset(
            //     imagePath,
            //     width: 40,
            //     height: 25,
            //     fit: BoxFit.contain,
            //   ),
            const SizedBox(width: 16.0), // Jarak antara logo dan TextField
            Expanded( // Expanded agar TextField mengisi sisa ruang
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                obscureText: obscureText, // Ini yang akan menyembunyikan input
                decoration: InputDecoration(
                  border: InputBorder.none, // Menghilangkan border default TextField
                  hintText: hintText,
                  labelText: methodName, // Label di atas hint text
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always, // Label selalu di atas
                  contentPadding: EdgeInsets.zero, // Mengurangi padding default
                  isDense: true, // Membuat TextField lebih rapat
                  suffixIcon: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.blue, size: 20) // Ikon cek jika dipilih
                      : null,
                  // Teks inputnya sendiri akan muncul di sisi kanan jika align nya TextAlign.end,
                  // tapi untuk input yang di hide, biasanya tidak perlu TextAlign.end
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                onTap: () {
                  // Pastikan TextField ini terpilih saat diklik
                  _selectPaymentMethod(value, focusNode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}