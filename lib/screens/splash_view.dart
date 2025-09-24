import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'portfolio_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _anim, curve: Curves.easeIn));
    _anim.forward();

    Timer(const Duration(seconds: 2), () {
      // Navigate to portfolio screen
      Get.off(() => const PortfolioView());
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Container(
          color: Colors.indigo,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.account_balance_wallet, size: 90, color: Colors.white),
                SizedBox(height: 16),
                Text('Zyvo', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Crypto Portfolio', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
