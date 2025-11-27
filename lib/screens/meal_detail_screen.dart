import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';

class MealDetailScreen extends StatefulWidget {
  final String? mealId;
  final MealDetail? mealDetail;
  const MealDetailScreen({super.key, this.mealId, this.mealDetail});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  MealDetail? _meal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.mealDetail != null) {
      _meal = widget.mealDetail;
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final detail = await api.lookupMealById(widget.mealId ?? '');
      setState(() {
        _meal = detail;
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_meal?.strMeal ?? 'Recipe'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _meal == null
              ? const Center(child: Text('No data'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(_meal!.strMealThumb),
                      const SizedBox(height: 8),
                      Text(_meal!.strMeal, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Category: ${_meal!.strCategory} • Area: ${_meal!.strArea}'),
                      const SizedBox(height: 12),
                      const Text('Ingredients:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ..._meal!.ingredients.entries.map((e) => Text('• ${e.key} — ${e.value}')).toList(),
                      const SizedBox(height: 12),
                      const Text('Instructions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_meal!.strInstructions),
                      const SizedBox(height: 12),
                      if (_meal!.strYoutube.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            // open youtube link
                            // use url_launcher if you want
                          },
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text('Watch on YouTube'),
                        ),
                    ],
                  ),
                ),
    );
  }
}
