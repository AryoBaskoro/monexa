import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/spending_chart_painter.dart';

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

  // --- MOCK DATA untuk berbagai filter ---
  final Map<DateFilter, List<ChartData>> chartDataByFilter = {
    DateFilter.week: [
      ChartData(color: Colors.pink.shade300, value: 15),
      ChartData(color: Colors.green.shade300, value: 20),
      ChartData(color: Colors.blue.shade300, value: 10),
      ChartData(color: Colors.orange.shade300, value: 8),
      ChartData(color: Colors.purple.shade300, value: 5),
    ],
    DateFilter.month: [
      ChartData(color: Colors.pink.shade300, value: 20),
      ChartData(color: Colors.green.shade300, value: 25),
      ChartData(color: Colors.blue.shade300, value: 15),
      ChartData(color: Colors.orange.shade300, value: 10),
      ChartData(color: Colors.purple.shade300, value: 5),
      ChartData(color: Colors.yellow.shade600, value: 8),
      ChartData(color: Colors.teal.shade300, value: 12),
      ChartData(color: Colors.red.shade300, value: 18),
    ],
    DateFilter.year: [
      ChartData(color: Colors.pink.shade300, value: 30),
      ChartData(color: Colors.green.shade300, value: 35),
      ChartData(color: Colors.blue.shade300, value: 25),
      ChartData(color: Colors.orange.shade300, value: 20),
      ChartData(color: Colors.purple.shade300, value: 15),
      ChartData(color: Colors.yellow.shade600, value: 18),
      ChartData(color: Colors.teal.shade300, value: 22),
      ChartData(color: Colors.red.shade300, value: 28),
      ChartData(color: Colors.indigo.shade300, value: 12),
    ],
  };

  final Map<DateFilter, String> totalAmountByFilter = {
    DateFilter.week: "IDR 5.8M",
    DateFilter.month: "IDR 27M",
    DateFilter.year: "IDR 205M",
  };

  List<Map<String, dynamic>> categoryItems = [
    {'name': 'Food & Drinks', 'icon': Icons.fastfood_rounded, 'color': Colors.orange, 'amount': 250.00},
    {'name': 'Shopping', 'icon': Icons.shopping_bag_rounded, 'color': Colors.pink, 'amount': 420.50},
    {'name': 'Transportation', 'icon': Icons.directions_car_rounded, 'color': Colors.blue, 'amount': 85.70},
    {'name': 'Entertainment', 'icon': Icons.movie_rounded, 'color': Colors.purple, 'amount': 150.00},
    {'name': 'Bills & Utilities', 'icon': Icons.receipt_long_rounded, 'color': Colors.red, 'amount': 320.00},
    {'name': 'Healthcare', 'icon': Icons.local_hospital_rounded, 'color': Colors.green, 'amount': 180.25},
  ];

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
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    _minimizeController.dispose();
    super.dispose();
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

  void _toggleSort() {
    setState(() {
      _sortType = _sortType == SortType.ascending ? SortType.descending : SortType.ascending;
      categoryItems.sort((a, b) {
        if (_sortType == SortType.ascending) {
          return a['amount'].compareTo(b['amount']);
        } else {
          return b['amount'].compareTo(a['amount']);
        }
      });
    });
  }

  double _dragOffset = 0;

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      // Clamp between -100 and 100 for smooth tracking
      _dragOffset = _dragOffset.clamp(-100.0, 100.0);
      
      // Update animation based on drag
      if (!_isChartMinimized && _dragOffset < 0) {
        _minimizeController.value = (-_dragOffset / 100).clamp(0.0, 1.0);
      } else if (_isChartMinimized && _dragOffset > 0) {
        _minimizeController.value = (1 - _dragOffset / 100).clamp(0.0, 1.0);
      }
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    
    // Swipe up (velocity negative) -> minimize
    if (velocity < -300 && !_isChartMinimized) {
      setState(() {
        _isChartMinimized = true;
        _dragOffset = 0;
      });
      _minimizeController.forward();
    }
    // Swipe down (velocity positive) -> expand
    else if (velocity > 300 && _isChartMinimized) {
      setState(() {
        _isChartMinimized = false;
        _dragOffset = 0;
      });
      _minimizeController.reverse();
    }
    // Snap back based on current position
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
      // Snap back to original state
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildChartSection(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Summary section hanya muncul jika chart di-minimize
                  if (!_isChartMinimized) ...[
                    _buildSummarySection(),
                    const SizedBox(height: 20),
                  ],
                  _buildCategoryListSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    final currentChartData = chartDataByFilter[_selectedDateFilter]!;
    final currentTotalAmount = totalAmountByFilter[_selectedDateFilter]!;

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
              20,
              20,
              _isChartMinimized ? 16 : 10,
            ),
            decoration: BoxDecoration(
              color: TColor.gray70.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                if (_isChartMinimized)
                  _buildMinimizedChart(currentChartData, currentTotalAmount)
                else
                  _buildExpandedChart(currentChartData, currentTotalAmount),
                
                // Bar indicator untuk swipe
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
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildMinimizedChart(List<ChartData> chartData, String totalAmount) {
    return Row(
      children: [
        // Mini Chart
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
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
        // Summary Grid
        Expanded(
          child: _buildMiniSummaryGrid(totalAmount),
        ),
      ],
    );
  }

  Widget _buildMiniSummaryGrid(String totalAmount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildMiniGridItem(
                "Total Expense",
                "\$20000",
                showRightBorder: true,
                showBottomBorder: true,
              ),
              _buildMiniGridItem(
                "Highest Expense",
                "\$20000",
                showBottomBorder: true,
              ),
            ],
          ),
          Row(
            children: [
              _buildMiniGridItem(
                "Total Income",
                "\$20000",
                showRightBorder: true,
              ),
              _buildMiniGridItem(
                "Most Category",
                "Food",
                icon: Icons.fastfood_outlined,
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
                ? BorderSide(color: Colors.grey.shade200, width: 1)
                : BorderSide.none,
            bottom: showBottomBorder
                ? BorderSide(color: Colors.grey.shade200, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            icon == null
                ? Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Row(
                    children: [
                      Icon(icon, color: Colors.grey[700], size: 14),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          value,
                          style: const TextStyle(
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
                    color: Colors.white.withOpacity(0.1),
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
                      color: TColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total Amount",
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
    return GestureDetector(
      onTap: () => _changeFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildGridItem("Total Expense", "\$20000", showRightBorder: true, showBottomBorder: true),
              _buildGridItem("Highest Expense", "\$20000", showBottomBorder: true),
            ],
          ),
          Row(
            children: [
              _buildGridItem("Total Income", "\$20000", showRightBorder: true),
              _buildGridItem("Most Used Category", "Food", icon: Icons.fastfood_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String title, String value, {IconData? icon, bool showRightBorder = false, bool showBottomBorder = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            right: showRightBorder ? BorderSide(color: Colors.grey.shade200, width: 1) : BorderSide.none,
            bottom: showBottomBorder ? BorderSide(color: Colors.grey.shade200, width: 1) : BorderSide.none,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            icon == null
                ? Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                : Row(
                    children: [
                      Icon(icon, color: Colors.grey[700], size: 18),
                      const SizedBox(width: 4),
                      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStaticFilterChip("Category"),
              GestureDetector(
                onTap: _toggleSort,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "Sort",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedRotation(
                        turns: _sortType == SortType.ascending ? 0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.arrow_upward,
                          size: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryItems.length,
            itemBuilder: (context, index) {
              final item = categoryItems[index];
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
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// --- WIDGET HELPER ---

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
            "-\$${amount.toStringAsFixed(2)}",
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