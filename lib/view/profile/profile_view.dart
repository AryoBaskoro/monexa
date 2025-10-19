import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/common/currency_helper.dart';
import 'package:monexa_app/common/theme_manager.dart';
import 'package:monexa_app/services/transaction_service.dart';
import 'package:monexa_app/view/login/sign_in_view.dart';
import 'package:monexa_app/widgets/animated_entry.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  late AnimationController _animationController;

  // CRITICAL FIX: Load user data from SharedPreferences
  String userName = "User";
  String userEmail = "user@email.com";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    
    // CRITICAL FIX: Load user data on init
    _loadUserData();
    
    // Load transaction data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionService>(context, listen: false).getAllTransactions();
    });
  }

  // CRITICAL FIX: Load user preferences from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Kelompok 5';
      userEmail = prefs.getString('user_email') ?? 'kelompok5@gmail.com';
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    
    // CRITICAL FIX: Use Consumer for real-time data
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            transactionService.calculateMonthlyIncome(),
            transactionService.calculateMonthlyExpenses(),
            transactionService.calculateTotalBalance(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: TColor.background(context),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            // CRITICAL FIX: Use real financial data
            final double totalIncome = snapshot.data?[0] as double? ?? 0;
            final double totalExpenses = snapshot.data?[1] as double? ?? 0;
            final double totalBalance = snapshot.data?[2] as double? ?? 0;

            return Scaffold(
              backgroundColor: TColor.background(context),
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
                      child: _buildThemeToggle(),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry( 
                      index: 2,
                      controller: _animationController,
                      child: _buildFinancialSummary(totalIncome, totalExpenses, totalBalance),
                    ),
                    const SizedBox(height: 20),
                    AnimatedEntry( 
                      index: 3,
                      controller: _animationController,
                      child: _buildFinancialStats(totalIncome, totalExpenses, totalBalance),
                    ),
                    const SizedBox(height: 10),
                    AnimatedEntry( 
                      index: 4,
                      controller: _animationController,
                      child: _buildLogoutButton(),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileHeader(Size media) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
        color: TColor.header(context),
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
                child: Image.asset("assets/img/u1.png", width: 100, height: 100, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 15),
          _SubtleAnimatedEntry(
            delay: 200,
            child: Text(userName, style: TextStyle(color: TColor.white, fontSize: 24, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 5),
          _SubtleAnimatedEntry(
            delay: 300,
            child: Text(userEmail, style: TextStyle(color: TColor.gray40, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    final themeManager = Provider.of<ThemeManager>(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: TColor.card(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    themeManager.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: TColor.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      themeManager.isDarkMode ? "Enabled" : "Disabled",
                      style: TextStyle(
                        color: TColor.gray40,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: themeManager.isDarkMode,
                onChanged: (value) {
                  themeManager.toggleTheme();
                },
                activeColor: TColor.primary,
                activeTrackColor: TColor.primary.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(double totalIncome, double totalExpenses, double totalBalance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TColor.cardBackground(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: TColor.border.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Income", totalIncome, Colors.green),
                Container(width: 1, height: 40, color: TColor.gray50),
                _buildSummaryItem("Expenses", totalExpenses, Colors.red),
                Container(width: 1, height: 40, color: TColor.gray50),
                _buildSummaryItem("Balance", totalBalance, TColor.primary),
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
        // CRITICAL FIX: Use CurrencyHelper for consistency
        Text(
          CurrencyHelper.formatNumber(amount), 
          style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildFinancialStats(double totalIncome, double totalExpenses, double totalBalance) {
    // CRITICAL FIX: Create stats list from real data
    final List<Map<String, dynamic>> financialStats = [
      {
        "title": "Total Income",
        "amount": totalIncome,
        "icon": "assets/img/money.png",
        "color": Colors.green,
        "isPositive": true
      },
      {
        "title": "Total Expenses",
        "amount": totalExpenses,
        "icon": "assets/img/chart.png",
        "color": Colors.red,
        "isPositive": false
      },
      {
        "title": "Total Balance",
        "amount": totalBalance,
        "icon": "assets/img/creditcards.png",
        "color": TColor.primary,
        "isPositive": totalBalance >= 0
      },
    ];

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
        color: TColor.cardBackground(context).withOpacity(0.5),
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
                // CRITICAL FIX: Use CurrencyHelper for consistency
                Text(
                  CurrencyHelper.formatNumber(stat["amount"]), 
                  style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700),
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