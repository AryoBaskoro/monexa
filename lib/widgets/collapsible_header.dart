import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/custom_arc_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollapsibleHeader extends StatefulWidget {
  const CollapsibleHeader({super.key});

  @override
  State<CollapsibleHeader> createState() => _CollapsibleHeaderState();
}

class _CollapsibleHeaderState extends State<CollapsibleHeader> with SingleTickerProviderStateMixin {
  bool _isHeaderExpanded = true;
  bool _isCurrencyVisible = true;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  double get _headerHeight => MediaQuery.of(context).size.width * 1.1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.addStatusListener((status) {
      if (mounted) {
        setState(() {
          _isHeaderExpanded = status == AnimationStatus.completed;
        });
      }
    });

    _loadStates();
  }

  Future<void> _loadStates() async {
    final prefs = await SharedPreferences.getInstance();
    final isExpanded = prefs.getBool('header_expanded') ?? true;
    final isCurrencyVisible = prefs.getBool('currency_visible') ?? true;
    
    setState(() {
      _isHeaderExpanded = isExpanded;
      _isCurrencyVisible = isCurrencyVisible;
    });

    if (isExpanded) {
      _animationController.forward();
    } else {
      _animationController.value = 0;
    }
  }

  Future<void> _saveHeaderState(bool isExpanded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('header_expanded', isExpanded);
  }

  Future<void> _saveCurrencyState(bool isVisible) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('currency_visible', isVisible);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleHeader() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
      _saveHeaderState(false);
    } else {
      _animationController.forward();
      _saveHeaderState(true);
    }
  }

  void _toggleCurrencyVisibility() {
    setState(() {
      _isCurrencyVisible = !_isCurrencyVisible;
      _saveCurrencyState(_isCurrencyVisible);
    });
  }
  
  void _handleDragUpdate(DragUpdateDetails details) {
    double delta = details.primaryDelta! / _headerHeight;
    _animationController.value += delta;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 500) {
      _animationController.forward();
      _saveHeaderState(true);
    } else if (details.primaryVelocity! < -500) {
      _animationController.reverse();
      _saveHeaderState(false);
    } else {
      if (_animationController.value > 0.5) {
        _animationController.forward();
        _saveHeaderState(true);
      } else {
        _animationController.reverse();
        _saveHeaderState(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return Container(
                height: _heightAnimation.value * _headerHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: TColor.gray70.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _heightAnimation.value,
                      child: Image.asset("assets/img/home_bg.png"),
                    ),
                    if (_heightAnimation.value > 0.3)
                      _buildHeaderContent(MediaQuery.of(context).size),
                  ],
                ),
              );
            },
          ),
          InkWell(
            onTap: _toggleHeader,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: AnimatedRotation(
                turns: _isHeaderExpanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: TColor.gray40,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(Size media) {
    return Opacity(
      opacity: _heightAnimation.value,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: media.width * 0.05),
                width: media.width * 0.72,
                height: media.width * 0.72,
                child: CustomPaint(
                  painter: CustomArcPainter(end: 220),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: media.width * 0.02),
              Image.asset(
                "assets/img/app_logo.png",
                width: media.width * 0.25,
                fit: BoxFit.contain,
              ),
              SizedBox(height: media.width * 0.02),
              Text(
                "10.235.000",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: media.width * 0.05),
              Text(
                "This month bills",
                style: TextStyle(
                  color: TColor.gray40,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: media.width * 0.05),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: TColor.gray.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: TColor.gray40.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total Balance",
                              style: TextStyle(
                                color: TColor.gray40,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                _isCurrencyVisible ? "IDR 19.999.999" : "••••••",
                                key: ValueKey<bool>(_isCurrencyVisible),
                                style: TextStyle(
                                  color: TColor.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: _isCurrencyVisible ? 0 : 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TColor.primary10.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _toggleCurrencyVisibility,
                          icon: Icon(
                            _isCurrencyVisible 
                              ? Icons.visibility_rounded 
                              : Icons.visibility_off_rounded,
                            color: TColor.primary10,
                            size: 20,
                          ),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}