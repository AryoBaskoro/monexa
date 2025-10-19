import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/common/currency_helper.dart';
import 'package:monexa_app/common/transaction_helper.dart';
import 'package:monexa_app/services/transaction_service.dart';
import 'package:monexa_app/widgets/spending_chart_painter.dart';
import 'package:provider/provider.dart';

enum DateFilter { week, month, year }
enum SortType { ascending, descending }

class StatisticView extends StatefulWidget {
  const StatisticView({super.key});

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView> with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;
  late AnimationController _minimizeController;
  late Animation<double> _minimizeAnimation;
  
  DateFilter _selectedDateFilter = DateFilter.month;
  SortType _sortType = SortType.descending;
  bool _isChartMinimized = false;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _chartAnimation = CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _minimizeController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _minimizeAnimation = CurvedAnimation(
      parent: _minimizeController,
      curve: Curves.easeInOutCubic,
    );
    
    _chartAnimationController.forward();
    
    // CRITICAL FIX: Load data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionService>(context, listen: false).getAllTransactions();
    });
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    _minimizeController.dispose();
    super.dispose();
  }

  // CRITICAL FIX: Get date range based on filter
  Map<String, DateTime> _getDateRange(DateFilter filter) {
    final now = DateTime.now();
    DateTime start, end;
    
    switch (filter) {
      case DateFilter.week:
        start = now.subtract(const Duration(days: 7));
        end = now;
        break;
      case DateFilter.month:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0);
        break;
      case DateFilter.year:
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31);
        break;
    }
    
    return {'start': start, 'end': end};
  }

  void _changeFilter(DateFilter newFilter) {
    if (_selectedDateFilter != newFilter) {
      setState(() {
        _selectedDateFilter = newFilter;
      });
      _chartAnimationController.reset();
      _chartAnimationController.forward();
    }
  }

  void _toggleSort(List<MapEntry<String, double>> categoryList) {
    setState(() {
      _sortType = _sortType == SortType.ascending ? SortType.descending : SortType.ascending;
      categoryList.sort((a, b) {
        if (_sortType == SortType.ascending) {
          return a.value.compareTo(b.value);
        } else {
          return b.value.compareTo(a.value);
        }
      });
    });
  }

  double _dragOffset = 0;

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      _dragOffset = _dragOffset.clamp(-100.0, 100.0);
      
      if (!_isChartMinimized && _dragOffset < 0) {
        _minimizeController.value = (-_dragOffset / 100).clamp(0.0, 1.0);
      } else if (_isChartMinimized && _dragOffset > 0) {
        _minimizeController.value = (1 - _dragOffset / 100).clamp(0.0, 1.0);
      }
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    
    if (velocity < -300 && !_isChartMinimized) {
      setState(() {
        _isChartMinimized = true;
        _dragOffset = 0;
      });
      _minimizeController.forward();
    }
    else if (velocity > 300 && _isChartMinimized) {
      setState(() {
        _isChartMinimized = false;
        _dragOffset = 0;
      });
      _minimizeController.reverse();
    }
    else if (_minimizeController.value > 0.5 && !_isChartMinimized) {
      setState(() {
        _isChartMinimized = true;
        _dragOffset = 0;
      });
      _minimizeController.forward();
    } else if (_minimizeController.value < 0.5 && _isChartMinimized) {
      setState(() {
        _isChartMinimized = false;
        _dragOffset = 0;
      });
      _minimizeController.reverse();
    } else {
      setState(() {
        _dragOffset = 0;
      });
      if (_isChartMinimized) {
        _minimizeController.forward();
      } else {
        _minimizeController.reverse();
      }
    }
  }

  // CRITICAL FIX: Category colors that match chart colors
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'makanan':
        return Colors.orange.shade300;
      case 'transport':
      case 'transportation':
      case 'transportasi':
        return Colors.blue.shade300;
      case 'shopping':
      case 'belanja':
        return Colors.pink.shade300;
      case 'entertainment':
      case 'hiburan':
        return Colors.purple.shade300;
      case 'health':
      case 'healthcare':
      case 'kesehatan':
        return Colors.red.shade300;
      case 'home':
      case 'rumah':
        return Colors.green.shade300;
      case 'electricity':
      case 'listrik':
        return Colors.yellow.shade600;
      case 'water':
      case 'air':
        return Colors.teal.shade300;
      case 'internet':
      case 'phone':
      case 'telepon':
        return Colors.indigo.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL FIX: Use Consumer for real-time data
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        // Get date range based on selected filter
        final dateRange = _getDateRange(_selectedDateFilter);
        
        return FutureBuilder<Map<String, dynamic>>(
          future: transactionService.getStatisticsForDateRange(
            dateRange['start']!,
            dateRange['end']!,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: TColor.background(context),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            final stats = snapshot.data ?? {};
            final double totalExpense = stats['totalExpense'] ?? 0.0;
            final double totalIncome = stats['totalIncome'] ?? 0.0;
            final double highestExpense = stats['highestExpense'] ?? 0.0;
            final String mostUsedCategory = stats['mostUsedCategory'] ?? 'None';
            final Map<String, double> categorySpending = 
                (stats['categorySpending'] as Map<String, double>?) ?? {};
            
            // CRITICAL FIX: Use TransactionHelper for consistent icons
            final categoryListData = categorySpending.entries.map((entry) {
              return {
                'name': entry.key,
                'amount': entry.value,
                'icon': TransactionHelper.getIconForCategory(entry.key), // Use same helper as Home page
                'color': _getCategoryColor(entry.key),
              };
            }).toList();
            
            if (_sortType == SortType.descending) {
              categoryListData.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
            } else {
              categoryListData.sort((a, b) => (a['amount'] as double).compareTo(b['amount'] as double));
            }
            
            // Get icon for most used category
            final categoryIcon = TransactionHelper.getIconForCategory(mostUsedCategory); // Use same helper as Home page

            final List<ChartData> chartData = _createChartData(categorySpending);

            return Scaffold(
              backgroundColor: TColor.background(context),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildChartSection(
                      chartData, 
                      totalExpense,
                      totalIncome,
                      highestExpense,
                      mostUsedCategory,
                      categoryIcon,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          if (!_isChartMinimized) ...[
                            _buildSummarySection(
                              totalExpense,
                              highestExpense,
                              totalIncome,
                              mostUsedCategory,
                              categoryIcon,
                            ),
                            const SizedBox(height: 20),
                          ],
                          _buildCategoryListSection(categoryListData),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // CRITICAL FIX: Create chart data with colors matching category colors
  List<ChartData> _createChartData(Map<String, double> categorySpending) {
    if (categorySpending.isEmpty) {
      return [ChartData(color: Colors.grey.shade300, value: 1)];
    }

    final List<ChartData> chartData = [];

    categorySpending.forEach((category, amount) {
      chartData.add(ChartData(
        color: _getCategoryColor(category), // Use same color as category list
        value: amount / 100000, // Scale for chart display
      ));
    });

    return chartData;
  }

  Widget _buildChartSection(
    List<ChartData> chartData,
    double totalExpense,
    double totalIncome,
    double highestExpense,
    String mostUsedCategory,
    IconData categoryIcon,
  ) {
    return GestureDetector(
      onVerticalDragUpdate: _handleVerticalDragUpdate,
      onVerticalDragEnd: _handleVerticalDragEnd,
      child: AnimatedBuilder(
        animation: _minimizeAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            padding: EdgeInsets.fromLTRB(
              20,
              40,
              20,
              _isChartMinimized ? 16 : 10,
            ),
            decoration: BoxDecoration(
              color: TColor.header(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                if (_isChartMinimized)
                  _buildMinimizedChart(
                    chartData,
                    CurrencyHelper.formatNumber(totalExpense),
                    totalExpense,
                    highestExpense,
                    totalIncome,
                    mostUsedCategory,
                    categoryIcon,
                  )
                else
                  _buildExpandedChart(chartData, CurrencyHelper.formatNumber(totalExpense)),
                
                const SizedBox(height: 12),
                _buildSwipeBarIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwipeBarIndicator() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: TColor.dividerColor(context),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildMinimizedChart(List<ChartData> chartData, String totalAmount, double totalExpense, double highestExpense, double totalIncome, String categoryName, IconData categoryIcon) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: TColor.dividerColor(context),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: SpendingChartPainter(
                  data: chartData,
                  strokeWidth: 12,
                  animationValue: 1.0,
                ),
                size: const Size(100, 100),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          // Pass dynamic data to the mini summary grid
          child: _buildMiniSummaryGrid(totalExpense, highestExpense, totalIncome, categoryName, categoryIcon),
        ),
      ],
    );
  }

  Widget _buildMiniSummaryGrid(double totalExpense, double highestExpense, double totalIncome, String categoryName, IconData categoryIcon) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.card(context).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildMiniGridItem(
                "Total Expense",
                CurrencyHelper.formatExpense(totalExpense),
                showRightBorder: true,
                showBottomBorder: true,
              ),
              _buildMiniGridItem(
                "Highest Expense",
                CurrencyHelper.formatExpense(highestExpense),
                showBottomBorder: true,
              ),
            ],
          ),
          Row(
            children: [
              _buildMiniGridItem(
                "Total Income",
                CurrencyHelper.formatIncome(totalIncome),
                showRightBorder: true,
              ),
              _buildMiniGridItem(
                "Most Category",
                categoryName,
                icon: categoryIcon,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniGridItem(
    String title,
    String value, {
    IconData? icon,
    bool showRightBorder = false,
    bool showBottomBorder = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            right: showRightBorder
                ? BorderSide(color: TColor.dividerColor(context), width: 1)
                : BorderSide.none,
            bottom: showBottomBorder
                ? BorderSide(color: TColor.dividerColor(context), width: 1)
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: TColor.secondaryText(context),
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            icon == null
                ? Text(
                    value,
                    style: TextStyle(
                      color: TColor.text(context),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Row(
                    children: [
                      Icon(icon, color: TColor.secondaryText(context), size: 14),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          value,
                          style: TextStyle(
                            color: TColor.text(context),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedChart(List<ChartData> chartData, String totalAmount) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: TColor.dividerColor(context),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedBuilder(
                  animation: _chartAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: SpendingChartPainter(
                        data: chartData,
                        strokeWidth: 35,
                        animationValue: _chartAnimation.value,
                      ),
                    );
                  },
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    totalAmount,
                    key: ValueKey(totalAmount),
                    style: TextStyle(
                      color: TColor.text(context),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total Expenses",
                  style: TextStyle(color: TColor.gray30, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildDateFilterChips(),
      ],
    );
  }

  Widget _buildDateFilterChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFilterChipButton("Week", DateFilter.week),
        const SizedBox(width: 8),
        _buildFilterChipButton("Month", DateFilter.month),
        const SizedBox(width: 8),
        _buildFilterChipButton("Year", DateFilter.year),
      ],
    );
  }

  Widget _buildFilterChipButton(String label, DateFilter filter) {
    final isSelected = _selectedDateFilter == filter;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedTextColor = isDark ? TColor.gray20 : TColor.gray30;
    
    return GestureDetector(
      onTap: () => _changeFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TColor.primary : TColor.cardBackground(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? TColor.text(context) : unselectedTextColor,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(double totalExpense, double highestExpense, double totalIncome, String categoryName, IconData categoryIcon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: TColor.card(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // CRITICAL FIX: Red color for Total Expense
              _buildGridItem("Total Expense", CurrencyHelper.formatExpense(totalExpense), 
                showRightBorder: true, showBottomBorder: true, valueColor: Colors.red),
              // CRITICAL FIX: Red color for Highest Expense
              _buildGridItem("Highest Expense", CurrencyHelper.formatExpense(highestExpense), 
                showBottomBorder: true, valueColor: Colors.red),
            ],
          ),
          Row(
            children: [
              _buildGridItem("Total Income", CurrencyHelper.formatIncome(totalIncome), showRightBorder: true),
              _buildGridItem("Most Used Category", categoryName, icon: categoryIcon),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, String value, {IconData? icon, bool showRightBorder = false, bool showBottomBorder = false, Color? valueColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            right: showRightBorder ? BorderSide(color: TColor.dividerColor(context), width: 1) : BorderSide.none,
            bottom: showBottomBorder ? BorderSide(color: TColor.dividerColor(context), width: 1) : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: TColor.secondaryText(context), fontSize: 12)),
            const SizedBox(height: 4),
            icon == null
                // CRITICAL FIX: Use valueColor if provided, otherwise use default text color
                ? Text(value, style: TextStyle(color: valueColor ?? TColor.text(context), fontSize: 16, fontWeight: FontWeight.bold))
                : Row(
                    children: [
                      Icon(icon, color: TColor.secondaryText(context), size: 18),
                      const SizedBox(width: 4),
                      Text(value, style: TextStyle(color: valueColor ?? TColor.text(context), fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListSection(List<Map<String, dynamic>> categoryList) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.card(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStaticFilterChip("Category"),
              GestureDetector(
                onTap: () => _toggleSort([]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TColor.inputBackground(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TColor.dividerColor(context)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Sort",
                        style: TextStyle(
                          color: TColor.text(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedRotation(
                        turns: _sortType == SortType.ascending ? 0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.arrow_upward,
                          size: 14,
                          color: TColor.text(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // CRITICAL FIX: Use passed categoryList instead of undefined categoryItems
          if (categoryList.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "No category data available",
                style: TextStyle(color: TColor.gray40, fontSize: 14),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final item = categoryList[index];
                return _CategoryListItem(
                  icon: item['icon'],
                  color: item['color'],
                  name: item['name'],
                  amount: item['amount'],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStaticFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: TColor.inputBackground(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColor.dividerColor(context)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: TColor.text(context),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CategoryListItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final double amount;

  const _CategoryListItem({
    required this.icon,
    required this.color,
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            // CRITICAL FIX: Using CurrencyHelper with thousands separator and minus sign
            CurrencyHelper.formatExpense(amount),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}