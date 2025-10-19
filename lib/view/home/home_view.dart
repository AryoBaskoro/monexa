import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/services/transaction_service.dart';
import 'package:monexa_app/widgets/collapsible_header.dart';
import 'package:monexa_app/widgets/segment_button.dart';
import 'package:monexa_app/widgets/history_list.dart';
import 'package:monexa_app/widgets/upcoming_list.dart';
import 'package:monexa_app/models/transaction.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isSubscription = true;

  @override
  void initState() {
    super.initState();
    // CRITICAL FIX: Load data saat pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionService>(context, listen: false).getAllTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL FIX: Use Consumer untuk listen ke TransactionService changes
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([
            transactionService.calculateTotalBalance(),
            transactionService.calculateMonthlyExpenses(), // CRITICAL FIX: Changed to monthlyExpenses
            transactionService.getCurrentMonthTransactions(),
            transactionService.getUpcomingBills(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: TColor.background(context),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            final totalBalance = snapshot.data?[0] as double? ?? 0;
            final monthlyExpenses = snapshot.data?[1] as double? ?? 0; // CRITICAL FIX: Changed variable name
            final historyTransactions = snapshot.data?[2] as List<Transaction>? ?? [];
            final upcomingBills = snapshot.data?[3] as List<Transaction>? ?? [];

            return Scaffold(
              backgroundColor: TColor.background(context),
              body: Column(
                children: [
                  CollapsibleHeader(
                    totalBalance: totalBalance,
                    monthlyExpenses: monthlyExpenses, // CRITICAL FIX: Pass monthlyExpenses
                  ),
                  
                  _buildTabSelector(),
                  
                  Expanded(
                    child: _buildAnimatedList(historyTransactions, upcomingBills),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTabSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectorBgColor = isDark ? TColor.card(context) : Colors.white;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: selectorBgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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

  Widget _buildAnimatedList(List<Transaction> historyTransactions, List<Transaction> upcomingBills) {
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
          ? _buildSubscriptionList(historyTransactions)
          : _buildUpcomingBillsList(upcomingBills),
    );
  }

  Widget _buildSubscriptionList(List<Transaction> historyTransactions) {
    // Use real transaction data
    final dataToShow = historyTransactions.isNotEmpty 
        ? historyTransactions.map((t) => {
            "id": t.id,
            "name": t.category,
            "icon": "assets/img/app_logo.png", // Default icon
            "price": t.amount,
            "date": t.date,
            "note": t.note,
            "type": t.type.toString().split('.').last,
          }).toList()
        : []; // Empty list if no data
    
    if (dataToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: TColor.gray40),
            const SizedBox(height: 16),
            Text(
              'No transaction history yet',
              style: TextStyle(color: TColor.gray30, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding transactions to see them here',
              style: TextStyle(color: TColor.gray40, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('subscription_list'),
      padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 80),
      itemCount: dataToShow.length,
      itemBuilder: (context, index) {
        var sObj = dataToShow[index] as Map? ?? {};
        return HistoryList(
          sObj: sObj,
          onPressed: () {},
        );
      },
    );
  }

  Widget _buildUpcomingBillsList(List<Transaction> upcomingBills) {
    // Use real upcoming bills data
    final dataToShow = upcomingBills.map((t) => {
          "id": t.id,
          "name": t.category,
          "date": t.date,
          "price": t.amount,
          "note": t.note,
        }).toList();
    
    if (dataToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_rounded, size: 64, color: TColor.gray40),
            const SizedBox(height: 16),
            Text(
              'No upcoming bills',
              style: TextStyle(color: TColor.gray30, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Add recurring expenses to track bills',
              style: TextStyle(color: TColor.gray40, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('bills_list'),
      padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 80),
      itemCount: dataToShow.length,
      itemBuilder: (context, index) {
        var sObj = dataToShow[index] as Map? ?? {};
        return UpcomingList(
          sObj: sObj,
          onPressed: () {},
        );
      },
    );
  }
}