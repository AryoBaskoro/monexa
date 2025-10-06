import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/view/login/sign_in_view.dart';
import 'package:monexa_app/widgets/animated_entry.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  late AnimationController _animationController;

  final Map<String, dynamic> userData = {
    "name": "Kelompok 5",
    "email": "kelompok5@gmail.com",
    "avatar": "assets/img/u1.png",
  };

  final List<Map<String, dynamic>> financialStats = [
    {"title": "Total Income", "amount": 5240.00, "icon": "assets/img/money.png", "color": Colors.green, "isPositive": true},
    {"title": "Total Expenses", "amount": 3890.50, "icon": "assets/img/chart.png", "color": Colors.red, "isPositive": false},
    {"title": "Total Balance", "amount": 1349.50, "icon": "assets/img/creditcards.png", "color": TColor.primary, "isPositive": true},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            AnimatedEntry( 
              index: 0,
              controller: _animationController,
              child: _buildProfileHeader(media),
            ),
            const SizedBox(height: 20),
            AnimatedEntry( 
              index: 1,
              controller: _animationController,
              child: _buildFinancialSummary(),
            ),
            const SizedBox(height: 20),
            AnimatedEntry( 
              index: 2,
              controller: _animationController,
              child: _buildFinancialStats(),
            ),
            const SizedBox(height: 10),
            AnimatedEntry( 
              index: 3,
              controller: _animationController,
              child: _buildLogoutButton(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Size media) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
        color: TColor.gray70.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _SubtleAnimatedEntry(
            delay: 100,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: TColor.primary, width: 3),
                boxShadow: [
                  BoxShadow(color: TColor.primary.withOpacity(0.3), blurRadius: 15, spreadRadius: 2)
                ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(userData["avatar"], width: 100, height: 100, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 15),
          _SubtleAnimatedEntry(
            delay: 200,
            child: Text(userData["name"], style: TextStyle(color: TColor.white, fontSize: 24, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 5),
          _SubtleAnimatedEntry(
            delay: 300,
            child: Text(userData["email"], style: TextStyle(color: TColor.gray40, fontSize: 14, fontWeight: FontWeight.w500)),
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
          border: Border.all(color: TColor.border.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            // Text("Financial Overview", style: TextStyle(color: TColor.white, fontSize: 18, fontWeight: FontWeight.w600)),
            // const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Income", financialStats[0]["amount"], Colors.green),
                Container(width: 1, height: 40, color: TColor.gray50),
                _buildSummaryItem("Expenses", financialStats[1]["amount"], Colors.red),
                Container(width: 1, height: 40, color: TColor.gray50),
                _buildSummaryItem("Balance", financialStats[2]["amount"], TColor.primary),
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
        Text(title, style: TextStyle(color: TColor.gray40, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text("\$${amount.toStringAsFixed(2)}", style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildFinancialStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Financial Details", style: TextStyle(color: TColor.white, fontSize: 18, fontWeight: FontWeight.w600)),
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
        border: Border.all(color: TColor.border.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(16),
        color: TColor.gray70.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: stat["color"].withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Image.asset(stat["icon"], color: stat["color"]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stat["title"], style: TextStyle(color: TColor.gray30, fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text("\$${stat["amount"].toStringAsFixed(2)}", style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Icon(stat["isPositive"] ? Icons.trending_up : Icons.trending_down, color: stat["isPositive"] ? Colors.green : Colors.red, size: 20),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Logout Success!"), backgroundColor: TColor.secondary),
          );
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => const SignInView(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: TColor.secondary.withOpacity(0.5)), borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: TColor.secondary, size: 20),
              const SizedBox(width: 10),
              Text("Logout", style: TextStyle(color: TColor.secondary, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubtleAnimatedEntry extends StatelessWidget {
  final int delay;
  final Widget child;

  const _SubtleAnimatedEntry({required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
    );
  }
}