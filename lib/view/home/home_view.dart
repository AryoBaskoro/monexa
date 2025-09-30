import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/collapsible_header.dart';
import 'package:monexa_app/widgets/segment_button.dart';
import 'package:monexa_app/widgets/history_list.dart';
import 'package:monexa_app/widgets/upcoming_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSubscription = true;

  final List subArr = [
    {"name": "Spotify", "icon": "assets/img/spotify_logo.png", "price": "5.99"},
    {"name": "YouTube Premium", "icon": "assets/img/youtube_logo.png", "price": "18.99"},
    {"name": "Microsoft OneDrive", "icon": "assets/img/onedrive_logo.png", "price": "29.99"},
    {"name": "NetFlix", "icon": "assets/img/netflix_logo.png", "price": "15.00"},
  ];

  final List bilArr = [
    {"name": "Spotify", "date": DateTime(2025, 10, 25), "price": "5.99"},
    {"name": "YouTube Premium", "date": DateTime(2025, 10, 25), "price": "18.99"},
    {"name": "Microsoft OneDrive", "date": DateTime(2025, 10, 28), "price": "29.99"},
    {"name": "NetFlix", "date": DateTime(2025, 11, 5), "price": "15.00"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: Column(
        children: [
          const CollapsibleHeader(),
          
          _buildTabSelector(),
          
          Expanded(
            child: _buildAnimatedList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
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
              title: "History",
              isActive: isSubscription,
              onPressed: () => setState(() => isSubscription = true),
            ),
          ),
          Expanded(
            child: SegmentButton(
              title: "Upcoming",
              isActive: !isSubscription,
              onPressed: () => setState(() => isSubscription = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedList() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(isSubscription ? -0.1 : 0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: isSubscription
          ? _buildSubscriptionList()
          : _buildUpcomingBillsList(),
    );
  }

  Widget _buildSubscriptionList() {
    return ListView.builder(
      key: const ValueKey('subscription_list'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: subArr.length,
      itemBuilder: (context, index) {
        var sObj = subArr[index] as Map? ?? {};
        return HistoryList(
          sObj: sObj,
          onPressed: () {},
        );
      },
    );
  }

  Widget _buildUpcomingBillsList() {
    return ListView.builder(
      key: const ValueKey('bills_list'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: bilArr.length,
      itemBuilder: (context, index) {
        var sObj = bilArr[index] as Map? ?? {};
        return UpcomingList(
          sObj: sObj,
          onPressed: () {},
        );
      },
    );
  }
}