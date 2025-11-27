import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../screens/meal_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealCard extends StatelessWidget {
  final MealSummary meal;
  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.idMeal)));
      },
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: meal.strMealThumb,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(meal.strMeal, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
