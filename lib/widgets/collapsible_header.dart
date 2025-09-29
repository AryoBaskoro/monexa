import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/custom_arc_painter.dart';
import 'package:monexa_app/widgets/status_button.dart';

class CollapsibleHeader extends StatefulWidget {
  const CollapsibleHeader({super.key});

  @override
  State<CollapsibleHeader> createState() => _CollapsibleHeaderState();
}

class _CollapsibleHeaderState extends State<CollapsibleHeader> with SingleTickerProviderStateMixin {
  bool _isHeaderExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  double get _headerHeight => MediaQuery.of(context).size.width * 1.1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Sedikit percepat durasi untuk feel lebih responsif
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleHeader() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
  
  void _handleDragUpdate(DragUpdateDetails details) {
    double delta = details.primaryDelta! / _headerHeight;
    _animationController.value += delta;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 500) {
      _animationController.forward(); // Buka paksa
    } else if (details.primaryVelocity! < -500) {
      _animationController.reverse(); // Tutup paksa
    } else {
      if (_animationController.value > 0.5) {
        _animationController.forward();
      } else {
        _animationController.reverse();
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
          // Toggle Button
          InkWell(
            onTap: _toggleHeader,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
    // ... (Isi dari widget ini tidak berubah sama sekali)
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
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 25),
                child: Row(
                  children: [
                    const Spacer(),
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
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: media.width * 0.05),
              Image.asset(
                "assets/img/app_logo.png",
                width: media.width * 0.25,
                fit: BoxFit.contain,
              ),
              SizedBox(height: media.width * 0.07),
              Text(
                "\$1,235",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: media.width * 0.055),
              Text(
                "This month bills",
                style: TextStyle(
                  color: TColor.gray40,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: media.width * 0.07),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: TColor.border.withOpacity(0.15),
                    ),
                    color: TColor.gray60.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "See your budget",
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: StatusButton(
                        title: "Active subs",
                        value: "12",
                        statusColor: TColor.secondary,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatusButton(
                        title: "Highest subs",
                        value: "\$19.99",
                        statusColor: TColor.primary10,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: StatusButton(
                        title: "Lowest subs",
                        value: "\$5.99",
                        statusColor: TColor.secondaryG,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}