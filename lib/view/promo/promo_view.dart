import 'package:flutter/material.dart';
import 'package:monexa_app/common/color_extension.dart';
import 'package:monexa_app/widgets/animated_entry.dart';
import 'promo_detail_view.dart';

class PromoView extends StatefulWidget {
  const PromoView({super.key});

  @override
  State<PromoView> createState() => _PromoViewState();
}

class _PromoViewState extends State<PromoView> with TickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Map<String, dynamic>> coupons = [
    {
      "brand": "Domino's Pizza",
      "discount": "50% off",
      "details": "On any large pizza",
      "logoAsset": "assets/img/dominos_logo.png",
      "expires": "January 20, 2025",
      "qrAsset": "assets/img/qr_code.png",
      "color": Colors.red,
    },
    {
      "brand": "Adidas",
      "discount": "25% off",
      "details": "On selected running shoes",
      "logoAsset": "assets/img/adidas_logo.png",
      "expires": "February 15, 2025",
      "qrAsset": "assets/img/qr_code.png",
      "color": Colors.blue,
    },
    {
      "brand": "Starbucks",
      "discount": "50% off",
      "details": "On your second drink",
      "logoAsset": "assets/img/starbucks_logo.png",
      "expires": "January 24, 2025",
      "qrAsset": "assets/img/qr_code.png",
      "color": Colors.red,
    },
    {
      "brand": "Target",
      "discount": "25% off",
      "details": "For home goods section",
      "logoAsset": "assets/img/target_logo.png",
      "expires": "March 01, 2025",
      "qrAsset": "assets/img/qr_code.png",
      "color": Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            AnimatedEntry(
              index: 0,
              controller: _animationController,
              child: _buildHeader(),
            ),
            const SizedBox(height: 25),
            AnimatedEntry(
              index: 1,
              controller: _animationController,
              child: _buildSummaryCard(),
            ),
            const SizedBox(height: 20),
            _buildCouponsList(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      decoration: BoxDecoration(
        color: TColor.gray70.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Promos & Coupons",
                        style: TextStyle(
                          color: TColor.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${coupons.length} available coupons",
                        style: TextStyle(
                          color: TColor.gray30,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: TColor.border.withOpacity(0.1),
                        ),
                        color: TColor.gray60.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.search,
                        color: TColor.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    int totalSavings = coupons.fold(0, (sum, coupon) {
      String discount = coupon["discount"];
      int percentage = int.parse(discount.replaceAll(RegExp(r'[^0-9]'), ''));
      return sum + percentage;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TColor.gray70.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: TColor.border.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem("Total Coupons", coupons.length.toString(), TColor.primary),
            Container(width: 1, height: 40, color: TColor.gray50),
            _buildSummaryItem("Total Savings", "$totalSavings%", Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: TColor.gray40,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available Coupons",
            style: TextStyle(
              color: TColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          ...coupons.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> coupon = entry.value;
            return AnimatedEntry(
              index: index + 2,
              controller: _animationController,
              child: _buildCouponCard(coupon),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PromoDetailView(coupon: coupon),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: TColor.border.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(16),
          color: TColor.gray70.withOpacity(0.2),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: coupon["color"].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                coupon["logoAsset"],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.local_offer,
                    size: 30,
                    color: coupon["color"],
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon["brand"],
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon["discount"],
                    style: TextStyle(
                      color: coupon["color"],
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon["details"],
                    style: TextStyle(
                      color: TColor.gray30,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: TColor.gray40,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}