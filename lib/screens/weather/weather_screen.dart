import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/model/search_model.dart';
import 'package:weather_app/providers/weather/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  final SearchModel item;
  const WeatherScreen({super.key, required this.item});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    context.read<WeatherProvider>().getCurrentWeather(
          '${widget.item.name ?? ''}, ${widget.item.country ?? 'India'}',
        );
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<Color> _getWeatherGradient(String? condition) {
    if (condition == null) {
      return [const Color(0xFF0F2027), const Color(0xFF2C5364)];
    }
    final text = condition.toLowerCase();
    if (text.contains("sunny") || text.contains("clear")) {
      return [const Color(0xFFFFA726), const Color(0xFFFFE082)];
    } else if (text.contains("cloud")) {
      return [const Color(0xFF90A4AE), const Color(0xFFCFD8DC)];
    } else if (text.contains("rain") || text.contains("drizzle")) {
      return [const Color(0xFF5C6BC0), const Color(0xFF7986CB)];
    } else if (text.contains("thunder")) {
      return [const Color(0xFF37474F), const Color(0xFF546E7A)];
    } else if (text.contains("snow")) {
      return [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)];
    } else {
      return [const Color(0xFF0F2027), const Color(0xFF2C5364)];
    }
  }

  Color _getDarkVariant(String? condition) {
    if (condition == null) return const Color(0xFF07111A);
    final text = condition.toLowerCase();
    if (text.contains("sunny") || text.contains("clear")) {
      return const Color(0xFFE65100);
    } else if (text.contains("cloud")) {
      return const Color(0xFF546E7A);
    } else if (text.contains("rain") || text.contains("drizzle")) {
      return const Color(0xFF283593);
    } else if (text.contains("thunder")) {
      return const Color(0xFF212121);
    } else if (text.contains("snow")) {
      return const Color(0xFF4FC3F7);
    } else {
      return const Color(0xFF07111A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final isTablet = w > 600;

    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A0E27),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF22B1CD),
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (!_animController.isAnimating && _animController.value == 0) {
          _animController.forward();
        }

        final location = provider.location;
        final current = provider.current;
        final conditionText = current?.condition?.text;
        final gradientColors = _getWeatherGradient(conditionText);
        final darkColor = _getDarkVariant(conditionText);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  darkColor,
                  gradientColors[0],
                  gradientColors[1],
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 680 : double.infinity,
                        ),
                        child: Column(
                          children: [
                            // Back button
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                isTablet ? 32 : 16,
                                isTablet ? 24 : 16,
                                isTablet ? 32 : 16,
                                0,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          isTablet ? 14 : 10),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                          color:
                                              Colors.white.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Colors.white,
                                        size: isTablet ? 22 : 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isTablet ? 28 : 18),

                            // Location
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 40 : 24,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        color:
                                            Colors.white.withOpacity(0.8),
                                        size: isTablet ? 24 : 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          "${location?.name ?? ''}, ${location?.country ?? ''}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isTablet ? 34 : 26,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 22 : 16,
                                      vertical: isTablet ? 8 : 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withOpacity(0.18),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            Colors.white.withOpacity(0.25),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      conditionText ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet ? 17 : 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isTablet ? 40 : 28),

                            // Hero weather display
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: w * (isTablet ? 0.35 : 0.5),
                                  height: w * (isTablet ? 0.35 : 0.5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Colors.white.withOpacity(0.08),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Image.network(
                                      current?.condition?.icon
                                              ?.replaceFirst(
                                                  '//', 'https://') ??
                                          '',
                                      width: w *
                                          (isTablet ? 0.18 : 0.28),
                                      height: w *
                                          (isTablet ? 0.18 : 0.28),
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      "${current?.tempC?.round() ?? 0}°",
                                      style: TextStyle(
                                        fontSize: w *
                                            (isTablet ? 0.14 : 0.22),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: isTablet ? 14 : 10),

                            Text(
                              "Feels like ${current?.feelslikeC?.round() ?? 0}°",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: isTablet ? 18 : 15,
                              ),
                            ),

                            SizedBox(height: isTablet ? 40 : 30),

                            // Quick stats row
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 40 : 20,
                              ),
                              child: Row(
                                children: [
                                  _QuickStat(
                                    icon: Icons.water_drop_rounded,
                                    label: "Humidity",
                                    value:
                                        "${current?.humidity ?? 0}%",
                                  ),
                                  _QuickStat(
                                    icon: Icons.air_rounded,
                                    label: "Wind",
                                    value:
                                        "${current?.windKph ?? 0} kph",
                                  ),
                                  _QuickStat(
                                    icon: Icons.wb_cloudy_rounded,
                                    label: "Cloud",
                                    value: "${current?.cloud ?? 0}%",
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isTablet ? 24 : 20),

                            // Details card
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 40 : 16,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(28),
                                  color: Colors.white.withOpacity(0.12),
                                  border: Border.all(
                                    color:
                                        Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    isTablet ? 28 : 20,
                                    isTablet ? 28 : 20,
                                    isTablet ? 28 : 20,
                                    isTablet ? 16 : 8,
                                  ),
                                  child: Column(
                                    children: [
                                      _buildDetailRow(
                                        context,
                                        Icons.map_rounded,
                                        "Region",
                                        location?.region ?? '',
                                      ),
                                      _buildDivider(),
                                      _buildDetailRow(
                                        context,
                                        Icons.thermostat_rounded,
                                        "Heat Index",
                                        "${current?.heatindexC ?? 0}°",
                                      ),
                                      _buildDivider(),
                                      _buildDetailRow(
                                        context,
                                        Icons.wb_sunny_rounded,
                                        "UV Index",
                                        "${current?.uv ?? 0}",
                                      ),
                                      _buildDivider(),
                                      _buildDetailRow(
                                        context,
                                        Icons.compress_rounded,
                                        "Pressure",
                                        "${current?.pressureMb ?? 0} mb",
                                      ),
                                      SizedBox(
                                          height: isTablet ? 16 : 12),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isTablet ? 40 : 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String title, String value) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 13),
      child: Row(
        children: [
          Container(
            width: isTablet ? 44 : 34,
            height: isTablet ? 44 : 34,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Icon(icon, color: Colors.white, size: isTablet ? 22 : 17),
          ),
          SizedBox(width: isTablet ? 18 : 14),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: isTablet ? 18 : 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 18 : 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.12),
      height: 1,
      thickness: 1,
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding:
            EdgeInsets.symmetric(vertical: isTablet ? 24 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: isTablet ? 30 : 22),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 20 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: isTablet ? 5 : 3),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: isTablet ? 14 : 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
