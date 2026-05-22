import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/home/home_provider.dart';
import 'package:weather_app/providers/main/main_provider.dart';
import 'package:weather_app/screens/forecast/forecast_screen.dart';
import 'package:weather_app/screens/home/home_screen.dart';
import 'package:weather_app/screens/radar/radar_screen.dart';
import 'package:weather_app/screens/search/search_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();
    final homeProvider = context.watch<HomeProvider>();

    // Get lat/lon from HomeProvider location (set after GPS fetch)
    final double lat = homeProvider.location?.lat ?? 28.6139;
    final double lon = homeProvider.location?.lon ?? 77.2090;

    final List<Widget> widgets = [
      const HomeScreen(),
      const SearchScreen(),
      const ForecastScreen(),
      RadarScreen(
        lat: homeProvider.location?.lat ?? 28.6,
        lon: homeProvider.location?.lon ?? 77.4,
      ),
    ];

    return Scaffold(
      body: widgets[provider.currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0E27),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  currentIndex: provider.currentIndex,
                  onTap: () => provider.changeIndex(0),
                ),
                _NavItem(
                  icon: Icons.search_rounded,
                  label: 'Search',
                  index: 1,
                  currentIndex: provider.currentIndex,
                  onTap: () => provider.changeIndex(1),
                ),
                _NavItem(
                  icon: Icons.cloud_rounded,
                  label: 'Forecast',
                  index: 2,
                  currentIndex: provider.currentIndex,
                  onTap: () => provider.changeIndex(2),
                ),
                _NavItem(
                  icon: Icons.radar_rounded,
                  label: 'Radar',
                  index: 3,
                  currentIndex: provider.currentIndex,
                  onTap: () => provider.changeIndex(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding:  EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animated pill background
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF22B1CD).withOpacity(0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? const Color(0xFF22B1CD)
                      : Colors.white.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 2),
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF22B1CD)
                      : Colors.white.withOpacity(0.4),
                  fontSize: 11,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}