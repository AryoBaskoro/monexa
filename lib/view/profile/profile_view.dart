import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "avatar": "assets/img/u1.png",
    "totalIncome": 5240.00,
    "totalExpenses": 3890.50,
    "totalMoney": 1349.50,
  };

  final List<Map<String, dynamic>> financialStats = [
    {
      "title": "Total Income",
      "amount": 5240.00,
      "icon": "assets/img/money.png",
      "color": Colors.green,
      "isPositive": true,
    },
    {
      "title": "Total Expenses", 
      "amount": 3890.50,
      "icon": "assets/img/chart.png",
      "color": Colors.red,
      "isPositive": false,
    },
    {
      "title": "Available Money",
      "amount": 1349.50,
      "icon": "assets/img/creditcards.png", 
      "color": TColor.primary,
      "isPositive": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(media),
            const SizedBox(height: 20),
            _buildFinancialSummary(),
            const SizedBox(height: 30),
            _buildFinancialStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Size media) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: BoxDecoration(
        color: TColor.gray70.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Settings button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    color: TColor.gray30,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/img/settings.png",
                    width: 25,
                    height: 25,
                    color: TColor.gray30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // User Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: TColor.primary, width: 3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                userData["avatar"],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // User Name
          Text(
            userData["name"],
            style: TextStyle(
              color: TColor.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          // User Email
          Text(
            userData["email"],
            style: TextStyle(
              color: TColor.gray40,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TColor.gray70.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: TColor.border.withOpacity(0.15),
          ),
        ),
        child: Column(
          children: [
            Text(
              "Financial Overview",
              style: TextStyle(
                color: TColor.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Income", userData["totalIncome"], Colors.green),
                Container(width: 1, height: 40, color: TColor.gray50),
                _buildSummaryItem("Expenses", userData["totalExpenses"], Colors.red),
                Container(width: 1, height: 40, color: TColor.gray50),
                _buildSummaryItem("Balance", userData["totalMoney"], TColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: TColor.gray40,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Financial Details",
            style: TextStyle(
              color: TColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          ...financialStats.map((stat) => _buildStatCard(stat)).toList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: TColor.border.withOpacity(0.15),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: stat["color"].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              stat["icon"],
              color: stat["color"],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat["title"],
                  style: TextStyle(
                    color: TColor.gray30,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${stat["amount"].toStringAsFixed(2)}",
                  style: TextStyle(
                    color: TColor.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            stat["isPositive"] ? Icons.trending_up : Icons.trending_down,
            color: stat["isPositive"] ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }
}