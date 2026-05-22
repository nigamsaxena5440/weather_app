import 'package:flutter/material.dart';
import 'package:weather_app/data/model/forecastday_model.dart';
import 'package:weather_app/screens/forecast/widgets/item_hourly_update.dart';

class ItemsForecastDay extends StatefulWidget {
  final ForecastdayModel forecastday;
  final int index;

  const ItemsForecastDay({
    super.key,
    required this.forecastday,
    this.index = 0,
  });

  @override
  State<ItemsForecastDay> createState() => _ItemsForecastDayState();
}

class _ItemsForecastDayState extends State<ItemsForecastDay>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnim;

  // Map condition text to a subtle accent color for each card
  Color _getAccentColor(String? condition) {
    if (condition == null) return const Color(0xFF22B1CD);
    final t = condition.toLowerCase();
    if (t.contains("sunny") || t.contains("clear")) return const Color(0xFFFFA726);
    if (t.contains("cloud")) return const Color(0xFF90A4AE);
    if (t.contains("rain") || t.contains("drizzle")) return const Color(0xFF5C6BC0);
    if (t.contains("thunder")) return const Color(0xFF78909C);
    if (t.contains("snow")) return const Color(0xFF4FC3F7);
    return const Color(0xFF22B1CD);
  }

  String _getConditionEmoji(String? condition) {
    if (condition == null) return '🌤️';
    final t = condition.toLowerCase();
    if (t.contains("sunny") || t.contains("clear")) return '☀️';
    if (t.contains("cloud")) return '☁️';
    if (t.contains("rain") || t.contains("drizzle")) return '🌧️';
    if (t.contains("thunder")) return '⛈️';
    if (t.contains("snow")) return '❄️';
    return '🌤️';
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      final parts = raw.split('-');
      if (parts.length < 3) return raw;
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final m = int.tryParse(parts[1]) ?? 0;
      final d = int.tryParse(parts[2]) ?? 0;
      return '${months[m]} $d';
    } catch (_) {
      return raw;
    }
  }

  String _getDayName(String? raw) {
    if (raw == null) return '';
    try {
      final date = DateTime.parse(raw);
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[date.weekday - 1];
    } catch (_) {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    // First card expanded by default
    if (widget.index == 0) {
      _expanded = true;
      _animController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final condition = widget.forecastday.day?.condition?.text;
    final accent = _getAccentColor(condition);
    final emoji = _getConditionEmoji(condition);
    final dateStr = _formatDate(widget.forecastday.date);
    final dayName = _getDayName(widget.forecastday.date);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header row — always visible
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                children: [
                  // Day + emoji circle
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withOpacity(0.18),
                      border: Border.all(
                        color: accent.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Day name + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Condition + temp range
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.forecastday.day?.maxtempC?.round() ?? 0}° / ${widget.forecastday.day?.mintempC?.round() ?? 0}°",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        condition ?? '',
                        style: TextStyle(
                          color: accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  // Chevron
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withOpacity(0.35),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable details
          SizeTransition(
            sizeFactor: _expandAnim,
            child: Column(
              children: [
                Divider(
                  color: Colors.white.withOpacity(0.08),
                  height: 1,
                  thickness: 1,
                  indent: 18,
                  endIndent: 18,
                ),

                // Stats grid
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
                  child: Row(
                    children: [
                      _StatChip(
                        icon: Icons.air_rounded,
                        label: "Wind",
                        value: "${widget.forecastday.day?.maxwindKph ?? 0} kph",
                        accent: accent,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.water_drop_rounded,
                        label: "Humidity",
                        value: "${widget.forecastday.day?.avghumidity ?? 0}%",
                        accent: accent,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                  child: Row(
                    children: [
                      _StatChip(
                        icon: Icons.wb_sunny_rounded,
                        label: "Sunrise",
                        value: widget.forecastday.astro?.sunrise ?? '—',
                        accent: accent,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.nightlight_round,
                        label: "Sunset",
                        value: widget.forecastday.astro?.sunset ?? '—',
                        accent: accent,
                      ),
                    ],
                  ),
                ),

                // Hourly scroll label
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                  child: Row(
                    children: [
                      Text(
                        "HOURLY",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 11,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Hourly strip
                SizedBox(
                  height: 112,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.forecastday.hour?.length ?? 0,
                    itemBuilder: (context, index) {
                      final hour = widget.forecastday.hour![index];
                      return ItemHourlyUpdate(hour: hour, accent: accent);
                    },
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(
            color: Colors.white.withOpacity(0.09),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: accent, size: 16),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
