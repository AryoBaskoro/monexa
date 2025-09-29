import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';

import '../../common_widget/custom_arc_painter.dart';
import '../../common_widget/segment_button.dart';
import '../../common_widget/status_button.dart';
import '../../common_widget/subscription_home_row.dart';
import '../../common_widget/upcoming_bill_row.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  bool isSubscription = true;
  bool isHeaderExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  
  List subArr = [
    {"name": "Spotify", "icon": "assets/img/spotify_logo.png", "price": "5.99"},
    {
      "name": "YouTube Premium",
      "icon": "assets/img/youtube_logo.png",
      "price": "18.99"
    },
    {
      "name": "Microsoft OneDrive",
      "icon": "assets/img/onedrive_logo.png",
      "price": "29.99"
    },
    {"name": "NetFlix", "icon": "assets/img/netflix_logo.png", "price": "15.00"},
  ];

  List bilArr = [
    {"name": "Spotify", "date": DateTime(2023, 07, 25), "price": "5.99"},
    {
      "name": "YouTube Premium",
      "date": DateTime(2023, 07, 25),
      "price": "18.99"
    },
    {
      "name": "Microsoft OneDrive",
      "date": DateTime(2023, 07, 25),
      "price": "29.99"
    },
    {"name": "NetFlix", "date": DateTime(2023, 07, 25), "price": "15.00"}
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleHeader() {
    setState(() {
      isHeaderExpanded = !isHeaderExpanded;
      if (isHeaderExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Column(
        children: [
          // Collapsible Header
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return Container(
                height: _heightAnimation.value * (media.width * 1.1),
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
                    if (_heightAnimation.value > 0.3) ...[
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
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    // Navigate to settings
                                  },
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
                      Opacity(
                        opacity: _heightAnimation.value,
                        child: Column(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Spacer(),
                            Opacity(
                              opacity: _heightAnimation.value,
                              child: Row(
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
                            ),
                          ],
                        ),
                      ),
                    ],
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
                turns: isHeaderExpanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: TColor.gray40,
                  size: 24,
                ),
              ),
            ),
          ),
          
          // Sticky Tab Selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SegmentButton(
                    title: "Your subscription",
                    isActive: isSubscription,
                    onPressed: () {
                      setState(() {
                        isSubscription = true;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SegmentButton(
                    title: "Upcoming bills",
                    isActive: !isSubscription,
                    onPressed: () {
                      setState(() {
                        isSubscription = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Scrollable List
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: isSubscription
                  ? ListView.builder(
                      key: const ValueKey('subscription'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      itemCount: subArr.length,
                      itemBuilder: (context, index) {
                        var sObj = subArr[index] as Map? ?? {};
                        return SubScriptionHomeRow(
                          sObj: sObj,
                          onPressed: () {},
                        );
                      },
                    )
                  : ListView.builder(
                      key: const ValueKey('bills'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      itemCount: bilArr.length,
                      itemBuilder: (context, index) {
                        var sObj = bilArr[index] as Map? ?? {};
                        return UpcomingBillRow(
                          sObj: sObj,
                          onPressed: () {},
                        );
                      },
                    ),
            ),
          ),
          
          const SizedBox(height: 80), // Space for bottom nav
        ],
      ),
    );
  }
}