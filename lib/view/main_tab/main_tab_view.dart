import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:monexa_app/view/transaction/create_expense_view.dart';

import '../../common/color_extension.dart';
import '../calender/calender_view.dart';
import '../card/cards_view.dart';
import '../home/home_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> with TickerProviderStateMixin {
  int selectTab = 0;
  PageStorageBucket pageStorageBucket = PageStorageBucket();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _views = [
    const HomeView(),
    Container(), 
    CalenderView(),
    CardsView(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (selectTab == index) return;
    
    setState(() {
      _fadeController.reset();
      selectTab = index;
    });
    
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Stack(
        children: [
          PageStorage(
            bucket: pageStorageBucket,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _views[selectTab],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                _buildBottomNavBar(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: _buildAddButton(),
              ),
            ],
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
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: GNav(
                selectedIndex: selectTab,
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
                  GButton(
                    icon: Icons.home_rounded,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.account_balance_wallet_rounded,
                    text: 'Budget',
                  ),
                  GButton(
                    icon: Icons.calendar_month_rounded,
                    text: 'Calendar',
                  ),
                  GButton(
                    icon: Icons.credit_card_rounded,
                    text: 'Cards',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return TweenAnimationBuilder<double>(
      key: ValueKey(_addButtonKey),
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TColor.secondary,
                  TColor.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: TColor.secondary.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _onAddButtonTapped,
                customBorder: const CircleBorder(),
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(_rotationKey),
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeInOut,
                  builder: (context, rotValue, child) {
                    return Transform.rotate(
                      angle: rotValue * 0.785398, 
                      child: Icon(
                        Icons.add_rounded,
                        color: TColor.white,
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  int _addButtonKey = 0;
  int _rotationKey = 0;

  void _onAddButtonTapped() {
    setState(() {
      _rotationKey++;
    });
    
    _showAddTransactionModal();
  }

  void _showAddTransactionModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => _buildAddTransactionModal(),
    );
  }

  Widget _buildAddTransactionModal() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColor.gray70.withOpacity(0.98),
            TColor.gray70,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar untuk drag
          Container(
            margin: const EdgeInsets.only(top: 14),
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: TColor.gray30.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          const SizedBox(height: 28),
          
          // Title with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColor.secondary.withOpacity(0.2),
                      TColor.primary.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: TColor.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Add Transaction',
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 36),
          
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _buildModalButton(
                    icon: Icons.arrow_upward_rounded,
                    label: 'Create Expense',
                    colors: [
                      TColor.secondary,
                      TColor.secondary.withOpacity(0.8),
                    ],
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to add expense screen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateExpenseView()));
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: _buildModalButton(
                    icon: Icons.arrow_downward_rounded,
                    label: 'Add Income',
                    colors: [
                      TColor.primary,
                      TColor.primary.withOpacity(0.8),
                    ],
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to add income screen
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const AddIncomeView()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalButton({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  left: -10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: TColor.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        label,
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}