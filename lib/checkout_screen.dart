import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  // Ditambahkan const Key? key dan super(key: key)
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black), // Ditambahkan const
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text( // Ditambahkan const
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Ditambahkan const
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.grey), // Ditambahkan const
                const SizedBox(width: 8.0), // Ditambahkan const
                const Text( // Ditambahkan const
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0), // Ditambahkan const
            Container(
              padding: const EdgeInsets.all(16.0), // Ditambahkan const
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    // Mengganti withOpacity dengan Color.fromARGB untuk mengatasi deprecation
                    color: Color.fromARGB((255 * 0.1).round(), 128, 128, 128), // Abu-abu dengan opacity 0.1
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Ditambahkan const
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text( // Ditambahkan const
                          'Address :',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey, // Menggunakan Colors.grey langsung
                          ),
                        ),
                        const SizedBox(height: 4.0), // Ditambahkan const
                        const Text( // Ditambahkan const
                          '216 St Paul\'s Rd, London N1 2LL, UK',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4.0), // Ditambahkan const
                        const Text( // Ditambahkan const
                          'Contact : +44-784232',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.grey), // Ditambahkan const
                    onPressed: () {
                      // Handle edit address
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0), // Ditambahkan const

            // Add new address button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      // Mengganti withOpacity dengan Color.fromARGB untuk mengatasi deprecation
                      color: Color.fromARGB((255 * 0.2).round(), 0, 0, 0), // Hitam dengan opacity 0.2
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Ditambahkan const
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.black), // Ditambahkan const
                  onPressed: () {
                    // Handle add new address
                  },
                ),
              ),
            ),
            const SizedBox(height: 24.0), // Ditambahkan const

            // Shopping List Section
            const Text( // Ditambahkan const
              'Shopping List',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0), // Ditambahkan const

            // Item 1
            _buildShoppingListItem(
              // imagePath: 'assets/item1.png', // Baris ini tetap dinonaktifkan
              title: 'Lorem ipsum',
              rating: 4.8,
              originalPrice: 54.00,
              discountedPrice: 34.00,
              discountPercentage: '33% off',
              variations: const ['Black', 'Red'], // Ditambahkan const
              selectedVariation: 'Black',
              totalOrder: 1,
            ),
            const SizedBox(height: 16.0), // Ditambahkan const

            // Item 2
            _buildShoppingListItem(
              // imagePath: 'assets/item2.png', // Baris ini tetap dinonaktifkan
              title: 'Lorem ipsum',
              rating: 4.7,
              originalPrice: 67.00,
              discountedPrice: 45.00,
              discountPercentage: '28% off',
              variations: const ['Green', 'Grey'], // Ditambahkan const
              selectedVariation: 'Green',
              totalOrder: 1,
            ),
            const SizedBox(height: 80.0), // Spacer for bottom content // Ditambahkan const
          ],
        ),
      ),
    );
  }

  Widget _buildShoppingListItem({
    // Parameter imagePath tetap dinonaktifkan
    required String title,
    required double rating,
    required double originalPrice,
    required double discountedPrice,
    required String discountPercentage,
    required List<String> variations,
    required String selectedVariation,
    required int totalOrder,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Ditambahkan const
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            // Mengganti withOpacity dengan Color.fromARGB untuk mengatasi deprecation
            color: Color.fromARGB((255 * 0.1).round(), 128, 128, 128), // Abu-abu dengan opacity 0.1
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // Ditambahkan const
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian ini tetap menggunakan SizedBox kosong
              const SizedBox(width: 90, height: 90), // Ditambahkan const
              const SizedBox(width: 16.0), // Ditambahkan const
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle( // Ditambahkan const
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0), // Ditambahkan const
                    Row(
                      children: [
                        const Text('Variations : '), // Ditambahkan const
                        Wrap(
                          spacing: 8.0,
                          children: variations.map((variation) {
                            return ChoiceChip(
                              label: Text(variation),
                              selected: variation == selectedVariation,
                              selectedColor: Colors.grey[300],
                              onSelected: (selected) {
                                // You might want to update state here if this was interactive
                              },
                              labelStyle: TextStyle(
                                color: variation == selectedVariation
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4.0), // Ditambahkan const
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1.0,
                                ),
                              ),
                              backgroundColor: Colors.white,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0), // Ditambahkan const
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16), // Ditambahkan const
                        const SizedBox(width: 4.0), // Ditambahkan const
                        Text(
                          rating.toString(),
                          style: const TextStyle( // Ditambahkan const
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(), // Ditambahkan const
                        Text(
                          '\$${discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle( // Ditambahkan const
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8.0), // Ditambahkan const
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle( // Ditambahkan const
                                fontSize: 12.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              'upto $discountPercentage',
                              style: const TextStyle( // Ditambahkan const
                                fontSize: 12.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1, color: Colors.grey), // Menggunakan Colors.grey langsung, dan ditambahkan const
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Order ($totalOrder) :',
                style: const TextStyle( // Ditambahkan const
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle( // Ditambahkan const
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}