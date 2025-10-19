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
  
  // CRITICAL FIX: No need for rebuild counter - Provider handles updates!
  final List<Widget> _views = const [
    HomeView(),
    StatisticView(),
    CalenderView(),
    PromoView(),
    ProfileView(),
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
    
    // Force rebuild of the selected view to refresh data
    _fadeController.forward();
  }
  
  // REMOVED: No longer needed - Provider handles real-time updates automatically!

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarColor = isDark ? const Color(0xff1A1A24) : Colors.white;
    final inactiveColor = isDark ? TColor.gray30 : TColor.gray40;
    
    return SafeArea(
      child: Padding(
        // Padding lebih besar untuk efek "floating"
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // CRITICAL FIX: No callback needed - Provider notifyListeners handles it!
            const Padding(
              padding: EdgeInsets.only(right: 16, bottom: 12),
              child: TransactionFAB(),
            ),
            Container(
              decoration: BoxDecoration(
                // Warna latar belakang theme-aware
                color: navBarColor,
                // Radius lebih besar untuk bentuk kapsul yang modern
                borderRadius: BorderRadius.circular(50),
                // Shadow yang lebih lembut dan tersebar
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                // CRITICAL FIX: Reduced padding to prevent overflow
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: GNav(
                  selectedIndex: _selectTab,
                  onTabChange: _onTabChanged,
                  // --- STYLE BARU ---
                  rippleColor: TColor.primary.withOpacity(0.1),
                  hoverColor: TColor.primary.withOpacity(0.05),
                  gap: 6, // CRITICAL FIX: Reduced gap to save space
                  // Warna ikon dan teks saat aktif (putih agar kontras dengan background)
                  activeColor: Colors.white,
                  iconSize: 22, // CRITICAL FIX: Slightly smaller icons
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // CRITICAL FIX: Reduced padding
                  duration: const Duration(milliseconds: 400),
                  // Background tab yang aktif menggunakan warna primer
                  tabBackgroundColor: TColor.primary,
                  // Warna ikon saat tidak aktif
                  color: inactiveColor,
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), // CRITICAL FIX: Smaller text
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