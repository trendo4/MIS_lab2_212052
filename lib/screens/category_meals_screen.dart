import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_card.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;
  const CategoryMealsScreen({super.key, required this.category});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  final ApiService api = ApiService();
  List<MealSummary> _all = [];
  List<MealSummary> _filtered = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() async {
    final q = _searchController.text.trim();
    if (q.isEmpty) {
      setState(() => _filtered = _all);
    } else {
      // use search endpoint (global) then filter by category if needed
      final results = await api.searchMeals(q);
      // keep only those that are in current category by comparing id or name.
      // safer: simply show search results (user expects search across all)
      setState(() {
        _filtered = results.where((m) => m.strMeal.toLowerCase().contains(q.toLowerCase())).toList();
      });
    }
  }

  Future<void> _load() async {
    try {
      final meals = await api.fetchMealsByCategory(widget.category);
      setState(() {
        _all = meals;
        _filtered = meals;
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
        title: Text(widget.category),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search meals in this category'),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.78, crossAxisSpacing: 8, mainAxisSpacing: 8),
                    itemCount: _filtered.length,
                    itemBuilder: (c, i) => MealCard(meal: _filtered[i]),
                  ),
                ),
              ],
            ),
    );
  }
}
