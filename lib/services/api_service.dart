import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_base/categories.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final list = (data['categories'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$_base/filter.php?c=${Uri.encodeComponent(category)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['meals'] == null) return [];
      final list = (data['meals'] as List).cast<Map<String, dynamic>>();
      return list.map((e) => MealSummary.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals for category');
    }
  }

  Future<List<MealSummary>> searchMeals(String query) async {
    final url = Uri.parse('$_base/search.php?s=${Uri.encodeComponent(query)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['meals'] == null) return [];
      final list = (data['meals'] as List).cast<Map<String, dynamic>>();
      // search.php returns full meal objects; convert to summary
      return list.map((j) => MealSummary.fromJson({
            'idMeal': j['idMeal'],
            'strMeal': j['strMeal'],
            'strMealThumb': j['strMealThumb']
          })).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<MealDetail?> lookupMealById(String id) async {
    final url = Uri.parse('$_base/lookup.php?i=${Uri.encodeComponent(id)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['meals'] == null) return null;
      final j = (data['meals'] as List).first as Map<String, dynamic>;
      return MealDetail.fromJson(j);
    } else {
      throw Exception('Failed to lookup meal');
    }
  }

  Future<MealDetail?> fetchRandomMeal() async {
    final url = Uri.parse('$_base/random.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['meals'] == null) return null;
      final j = (data['meals'] as List).first as Map<String, dynamic>;
      return MealDetail.fromJson(j);
    } else {
      throw Exception('Failed to fetch random meal');
    }
  }
}
