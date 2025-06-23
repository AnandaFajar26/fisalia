import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'admin_login.dart';
import 'profil_screen.dart';

class HomeScreen extends StatelessWidget {
  final Color primaryBlue = Color(0xFF045D72);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        leading: Icon(Icons.menu),
        title: Row(
          children: [
            Icon(Icons.flash_on, color: Colors.white),
            SizedBox(width: 5),
            Text("Fisalia Computer"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Get.to(() => ProfilScreen());
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          // 🔍 Search Bar
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search any product...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          SizedBox(height: 20),

          // 🔘 Kategori
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  ['laptop', 'komputer', 'kabel', 'aksesori', 'monitor'].map((
                    item,
                  ) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.devices),
                          ),
                          SizedBox(height: 5),
                          Text(item),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),

          SizedBox(height: 20),

          // 🛍 Promo Banner
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "50-40% OFF",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Now in [product]"),
                      Text("All colours"),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: () {}, child: Text("Shop Now")),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/shopping_girl.png',
                  height: 100,
                ), // Ganti sesuai asset
              ],
            ),
          ),

          SizedBox(height: 20),

          // 🔔 Deal of the Day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Deal of the Day",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("View all", style: TextStyle(color: Colors.blue)),
            ],
          ),
          Text("22h 55m 20s remaining"),
          SizedBox(height: 10),
          dealItem(
            "RAM Lexar 16 GB SODIMM",
            "₹1500",
            "₹2000",
            "assets/ram.png",
          ),
          dealItem("Lorem Ipsum Laptop", "₹2499", "₹4999", "assets/laptop.png"),

          SizedBox(height: 20),

          // 🧧 Special Offers
          ListTile(
            leading: Icon(Icons.local_offer, color: Colors.orange),
            title: Text("Special Offers"),
            subtitle: Text(
              "We make sure you get the offer you need at best prices",
            ),
          ),

          offerCard("Nvidia Geforce RTX 4090", "assets/rtx.png"),

          // 🔥 Trending Products
          sectionTitle("Trending Products", "Last Date 29/02/22"),
          dealItem("HP VICTUS 15", "₹650", "₹1599", "assets/hp.png"),
          dealItem(
            "Nvidia Geforce RTX 4090",
            "₹650",
            "₹1250",
            "assets/rtx.png",
          ),

          // ☀️ Summer Sale Banner
          SizedBox(height: 20),
          Image.asset("assets/summer_sale.png"),

          // 🆕 New Arrivals
          sectionTitle("New Arrivals", "Summer '25 Collections"),

          // 🔰 Sponsored
          SizedBox(height: 20),
          Text("Sponsored", style: TextStyle(fontWeight: FontWeight.bold)),
          Image.asset("assets/sponsored.png"),
        ],
      ),

      // 🔽 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryBlue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
    );
  }

  Widget dealItem(
    String title,
    String price,
    String oldPrice,
    String imagePath,
  ) {
    return Card(
      child: ListTile(
        leading: Image.asset(imagePath, width: 50),
        title: Text(title),
        subtitle: Text("$price  (was $oldPrice)"),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget offerCard(String title, String imagePath) {
    return Card(
      color: Colors.amber[100],
      child: ListTile(
        title: Text(title),
        trailing: ElevatedButton(onPressed: () {}, child: Text("Visit now")),
        leading: Image.asset(imagePath, width: 50),
      ),
    );
  }

  Widget sectionTitle(String title, String sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text("View all", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
