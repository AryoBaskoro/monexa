import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:monexa_app/view/promo/promo_view.dart';
import 'package:monexa_app/view/statistic/statistic_view.dart';
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
    const StatisticView(),
    const CalenderView(),
    const PromoView(),
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

  // --- WIDGET YANG DIDESAIN ULANG ---
  Widget _buildBottomNavBar() {
    return SafeArea(
      child: Padding(
        // Padding lebih besar untuk efek "floating"
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16, bottom: 12),
              child: TransactionFAB(),
            ),
            Container(
              decoration: BoxDecoration(
                // Warna latar belakang yang bersih (putih)
                color: Colors.white,
                // Radius lebih besar untuk bentuk kapsul yang modern
                borderRadius: BorderRadius.circular(50),
                // Shadow yang lebih lembut dan tersebar
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                // Padding di dalam container untuk GNav
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: GNav(
                  selectedIndex: _selectTab,
                  onTabChange: _onTabChanged,
                  // --- STYLE BARU ---
                  rippleColor: TColor.primary.withOpacity(0.1),
                  hoverColor: TColor.primary.withOpacity(0.05),
                  gap: 8,
                  // Warna ikon dan teks saat aktif (putih agar kontras dengan background)
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  // Background tab yang aktif menggunakan warna primer
                  tabBackgroundColor: TColor.primary,
                  // Warna ikon saat tidak aktif
                  color: TColor.gray40,
                  tabs: const [
                    GButton(icon: Icons.home_rounded, text: 'Home'),
                    GButton(icon: Icons.bar_chart_rounded, text: 'Statistic'),
                    GButton(icon: Icons.calendar_month_rounded, text: 'Calendar'),
                    GButton(icon: Icons.local_offer_rounded, text: 'Promo'),
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