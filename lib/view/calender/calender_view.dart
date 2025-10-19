import 'dart:math';

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Make sure to import intl package
import 'package:monexa_app/common/color_extension.dart';

import '../../widgets/subscription_cell.dart';

// Helper function to format currency for Indonesian Rupiah
String _formatCurrency(dynamic amount) {
  if (amount is! num) {
    return 'Rp 0'; 
  }
  final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  return format.format(amount);
}


class CalenderView extends StatefulWidget {
  const CalenderView({super.key});

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  CalendarAgendaController calendarAgendaControllerNotAppBar =
      CalendarAgendaController();
  late DateTime selectedDateNotAppBBar;

  Random random = new Random();

  // FIXED: Updated prices to double and used reasonable Rupiah amounts
  List subArr = [
    {"name": "Spotify", "icon": "assets/img/spotify_logo.png", "price": 54900.0},
    {
      "name": "YouTube Premium",
      "icon": "assets/img/youtube_logo.png",
      "price": 59000.0
    },
    {
      "name": "Microsoft OneDrive",
      "icon": "assets/img/onedrive_logo.png",
      "price": 95999.0
    },
    {"name": "NetFlix", "icon": "assets/img/netflix_logo.png", "price": 120000.0}
  ];

    @override
  void initState() {
    super.initState();
    selectedDateNotAppBBar = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // ADDED: Calculate total price dynamically
    double totalPrice = subArr.fold(0.0, (sum, item) => sum + (item["price"] as num));

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
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              
                              
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Calendar",
                            style: TextStyle(
                                color: TColor.text(context),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // FIXED: Made subscription count dynamic
                                "${subArr.length} subscriptions this month",
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
                                        // FIXED: Month name is now dynamic
                                        DateFormat('MMMM').format(selectedDateNotAppBBar),
                                        style: TextStyle(
                                            color: TColor.text(context),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Icon(
                                        Icons.expand_more, color: TColor.text(context),
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
                      calendarEventColor: TColor.secondary,
                      firstDate: DateTime.now().subtract(const Duration(days: 140)),
                      lastDate: DateTime.now().add(const Duration(days: 140)),
                      events: List.generate(
                          100,
                          (index) => DateTime.now().subtract(
                              Duration(days: index * random.nextInt(5)))),
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

                      selectedEventLogo: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: TColor.secondary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      eventLogo: Container(
                        width: 5,
                        height: 5,
                        decoration:  BoxDecoration(
                          
                          color: TColor.secondary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // FIXED: Month name is now dynamic
                        DateFormat('MMMM').format(selectedDateNotAppBBar),
                        style: TextStyle(
                            color: TColor.text(context),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        // FIXED: Total price is now dynamic and formatted
                        _formatCurrency(totalPrice),
                        style: TextStyle(
                            color: TColor.text(context),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // FIXED: Date is now dynamic and formatted
                        DateFormat('dd.MM.yyyy').format(selectedDateNotAppBBar),
                        style: TextStyle(
                            color: TColor.secondaryText(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "in upcoming bills",
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
            GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1),
                itemCount: subArr.length,
                itemBuilder: (context, index) {
                  var sObj = subArr[index] as Map? ?? {};

                  return SubScriptionCell(
                    sObj: sObj,
                    onPressed: () {},
                  );
                }),
            const SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}