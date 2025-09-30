import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/collapsible_header.dart';
import 'package:monexa_app/widgets/segment_button.dart';
import 'package:monexa_app/widgets/transaction_row.dart';
import 'package:monexa_app/widgets/upcoming_bill_row.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isTransactionHistory = true;

  // Transaction history data with mixed income and expenses
  final List transactionArr = [
    {
      "name": "Salary Payment",
      "type": "income",
      "amount": 3500.00,
      "date": DateTime(2025, 9, 30, 9, 0),
    },
    {
      "name": "Spotify Subscription",
      "type": "expense",
      "amount": 5.99,
      "date": DateTime(2025, 9, 29, 14, 30),
    },
    {
      "name": "Freelance Project",
      "type": "income", 
      "amount": 850.00,
      "date": DateTime(2025, 9, 28, 16, 45),
    },
    {
      "name": "Grocery Shopping",
      "type": "expense",
      "amount": 127.50,
      "date": DateTime(2025, 9, 27, 11, 20),
    },
    {
      "name": "YouTube Premium",
      "type": "expense",
      "amount": 18.99,
      "date": DateTime(2025, 9, 26, 8, 15),
    },
    {
      "name": "Investment Dividend",
      "type": "income",
      "amount": 245.75,
      "date": DateTime(2025, 9, 25, 10, 0),
    },
    {
      "name": "Netflix Subscription",
      "type": "expense",
      "amount": 15.00,
      "date": DateTime(2025, 9, 24, 19, 30),
    },
    {
      "name": "Side Hustle",
      "type": "income",
      "amount": 420.00,
      "date": DateTime(2025, 9, 23, 13, 15),
    },
  ];

  // Upcoming bills data
  final List bilArr = [
    {
      "name": "Electric Bill",
      "date": DateTime(2025, 10, 5),
      "amount": 89.50,
    },
    {
      "name": "Internet Service",
      "date": DateTime(2025, 10, 8),
      "amount": 55.99,
    },
    {
      "name": "Phone Bill",
      "date": DateTime(2025, 10, 12),
      "amount": 45.00,
    },
    {
      "name": "Credit Card Payment",
      "date": DateTime(2025, 10, 15),
      "amount": 235.80,
    },
    {
      "name": "Car Insurance",
      "date": DateTime(2025, 10, 20),
      "amount": 125.00,
    },
    {
      "name": "Microsoft OneDrive",
      "date": DateTime(2025, 10, 28),
      "amount": 29.99,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Sort transactions by date (latest first)
    transactionArr.sort((a, b) => b["date"].compareTo(a["date"]));
    // Sort bills by date (nearest first)
    bilArr.sort((a, b) => a["date"].compareTo(b["date"]));
    
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
              title: "Transaction History",
              isActive: isTransactionHistory,
              onPressed: () => setState(() => isTransactionHistory = true),
            ),
          ),
          Expanded(
            child: SegmentButton(
              title: "Upcoming Bills",
              isActive: !isTransactionHistory,
              onPressed: () => setState(() => isTransactionHistory = false),
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
              begin: Offset(isTransactionHistory ? -0.1 : 0.1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: isTransactionHistory
          ? _buildTransactionHistoryList()
          : _buildUpcomingBillsList(),
    );
  }

  Widget _buildTransactionHistoryList() {
    return ListView.builder(
      key: const ValueKey('transaction_history_list'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: transactionArr.length,
      itemBuilder: (context, index) {
        var tObj = transactionArr[index] as Map? ?? {};
        return TransactionRow(
          sObj: tObj,
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
        return UpcomingBillRow(
          sObj: sObj,
          onPressed: () {},
        );
      },
    );
  }
}