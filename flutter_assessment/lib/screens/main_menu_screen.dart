import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/app_colors.dart';
import 'package:flutter_assessment/database/database.dart';
import 'package:flutter_assessment/screens/airline_list_screen.dart';
import 'package:flutter_assessment/screens/flight_list_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final AppDatabase database;
  const MainMenuScreen({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: toolbar(),
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            _buildMenuButton(
              context,
              "Ver lista de vuelos",
              Icons.flight_takeoff,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlightListScreen(database: database),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              context,
              "Ver lista de aerolineas",
              Icons.airline_seat_recline_extra,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AirlineListScreen(database: database),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar toolbar() => AppBar(
    title: Text("Flight App"),
    backgroundColor: AppColors.appBar,
    foregroundColor: Colors.white,
  );

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressend,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 200,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30, color: Colors.white),
        label: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.principalCard,
        ),
        onPressed: onPressend,
      ),
    );
  }
}
