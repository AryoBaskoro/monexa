import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:monexa_app/widgets/transaction_fab.dart';
import '../../common/color_extension.dart';
import '../calender/calender_view.dart';
import '../profile/profile_view.dart';
import '../home/home_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> with TickerProviderStateMixin {
  int _selectTab = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _views = [
    const HomeView(),
    Container(color: TColor.gray), // Placeholder untuk 'Budget'
    const CalenderView(),
    const ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_selectTab == index) return;
    
    setState(() {
      _fadeController.reset();
      _selectTab = index;
    });
    
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: _views[_selectTab],
          ),
          // Posisi navigasi di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16, bottom: 8),
              child: TransactionFAB(), // Memanggil widget FAB kustom
            ),
            Container(
              decoration: BoxDecoration(
                color: TColor.gray70,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: GNav(
                  selectedIndex: _selectTab,
                  onTabChange: _onTabChanged,
                  gap: 8,
                  activeColor: TColor.white,
                  color: TColor.gray30,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: TColor.primary.withOpacity(0.15),
                  tabBorderRadius: 20,
                  tabs: const [
                    GButton(icon: Icons.home_rounded, text: 'Home'),
                    GButton(icon: Icons.account_balance_wallet_rounded, text: 'Budget'),
                    GButton(icon: Icons.calendar_month_rounded, text: 'Calendar'),
                    GButton(icon: Icons.person_rounded, text: 'Profile'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}