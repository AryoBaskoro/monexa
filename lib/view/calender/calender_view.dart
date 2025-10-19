import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/common/currency_helper.dart';
import 'package:monexa_app/models/transaction.dart';
import 'package:monexa_app/services/transaction_service.dart';
import 'package:provider/provider.dart';
import '../../widgets/history_list.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  CalendarAgendaController calendarAgendaControllerNotAppBar =
      CalendarAgendaController();
  late DateTime selectedDateNotAppBBar;

  @override
  void initState() {
    super.initState();
    selectedDateNotAppBBar = DateTime.now();
  }

  // CRITICAL FIX: Get transactions for selected date
  List<Transaction> _getTransactionsForDate(List<Transaction> allTransactions, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return allTransactions.where((t) {
      final transactionDate = DateTime(t.date.year, t.date.month, t.date.day);
      return transactionDate.isAtSameMomentAs(dateOnly);
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Sort by time, newest first
  }

  // CRITICAL FIX: Get all dates that have transactions for event markers
  List<DateTime> _getTransactionDates(List<Transaction> allTransactions) {
    final dates = allTransactions.map((t) {
      // Normalize to midnight for proper date comparison
      return DateTime(t.date.year, t.date.month, t.date.day);
    }).toSet().toList();
    
    // Debug: Print transaction dates
    print('📅 Calendar: Found ${dates.length} unique dates with transactions');
    for (var date in dates.take(5)) {
      print('  - ${DateFormat('MMM dd, yyyy').format(date)}');
    }
    
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL FIX: Use Consumer to get real transaction data
    return Consumer<TransactionService>(
      builder: (context, transactionService, child) {
        return FutureBuilder<List<Transaction>>(
          future: transactionService.getAllTransactions(),
          builder: (context, snapshot) {
            final allTransactions = snapshot.data ?? [];
            final selectedDateTransactions = _getTransactionsForDate(allTransactions, selectedDateNotAppBBar);
            final transactionDates = _getTransactionDates(allTransactions);
            
            // CRITICAL DEBUG: Print to verify events are passed
            print('🔍 Total transactions: ${allTransactions.length}');
            print('🔍 Unique transaction dates: ${transactionDates.length}');
            if (transactionDates.isNotEmpty) {
              print('🔍 First event date: ${transactionDates.first}');
              print('🔍 First event date string: ${transactionDates.first.toString().split(" ").first}');
            }
            
            // Calculate total for selected date
            final double totalForDate = selectedDateTransactions.fold(
              0.0, 
              (sum, t) => sum + (t.type == TransactionType.income ? t.amount : -t.amount)
            );

            return Scaffold(
              backgroundColor: TColor.background(context),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: TColor.header(context),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    "Calendar",
                                    style: TextStyle(
                                        color: TColor.text(context),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // CRITICAL FIX: Show count of transactions for selected date
                                        "${selectedDateTransactions.length} transaction${selectedDateTransactions.length != 1 ? 's' : ''} on this date",
                                        style: TextStyle(
                                            color: TColor.secondaryText(context),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          calendarAgendaControllerNotAppBar.openCalender();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: TColor.border.withOpacity(0.1),
                                            ),
                                            color: TColor.buttonBackground(context),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              Text(
                                                DateFormat('MMMM').format(selectedDateNotAppBBar),
                                                style: TextStyle(
                                                    color: TColor.text(context),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Icon(
                                                Icons.expand_more, 
                                                color: TColor.text(context),
                                                size: 16.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),

                            CalendarAgenda(
                              controller: calendarAgendaControllerNotAppBar,
                              backgroundColor: Colors.transparent,
                              fullCalendarBackgroundColor: TColor.background(context),
                              dateColor: TColor.text(context),
                              fullCalendar: false,
                              locale: 'en',
                              weekDay: WeekDay.short,
                              fullCalendarDay: WeekDay.short,
                              selectedDateColor: TColor.text(context),
                              initialDate: DateTime.now(),
                              // CRITICAL FIX: Set explicit event color - RED for visibility
                              calendarEventColor: Colors.red,
                              calendarEventSelectedColor: TColor.primary,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              // CRITICAL FIX: Use real transaction dates for event markers
                              events: transactionDates,
                              onDateSelected: (date) {
                                setState(() {
                                  selectedDateNotAppBBar = date;
                                });
                              },

                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: TColor.border.withOpacity(0.15),
                                ),
                                color: TColor.cardBackground(context),
                                borderRadius: BorderRadius.circular(12),
                              ),

                              selectDecoration: BoxDecoration(
                                border: Border.all(
                                  color: TColor.border.withOpacity(0.15),
                                ),
                                color: TColor.cardBackground(context).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),

                              // CRITICAL FIX: Larger, more visible event dots
                              selectedEventLogo: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: TColor.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              eventLogo: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // CRITICAL FIX: Show selected date summary
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('EEEE, MMM dd').format(selectedDateNotAppBBar),
                                style: TextStyle(
                                    color: TColor.text(context),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                CurrencyHelper.formatNumber(totalForDate.abs()),
                                style: TextStyle(
                                    color: totalForDate >= 0 ? TColor.primary : TColor.secondary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd.MM.yyyy').format(selectedDateNotAppBBar),
                                style: TextStyle(
                                    color: TColor.secondaryText(context),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                totalForDate >= 0 ? "net positive" : "net negative",
                                style: TextStyle(
                                    color: TColor.secondaryText(context),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    
                    // CRITICAL FIX: Display transactions for selected date
                    if (selectedDateTransactions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 64,
                              color: TColor.gray40,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions on this date',
                              style: TextStyle(
                                color: TColor.gray30,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: selectedDateTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = selectedDateTransactions[index];
                          return HistoryList(
                            sObj: {
                              "id": transaction.id,
                              "name": transaction.category,
                              "icon": "assets/img/app_logo.png",
                              "price": transaction.amount,
                              "date": transaction.date,
                              "note": transaction.note,
                              "type": transaction.type.toString().split('.').last,
                            },
                            onPressed: () {},
                          );
                        },
                      ),
                    const SizedBox(height: 130),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}