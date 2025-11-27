class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String strYoutube;
  final Map<String, String> ingredients; // ingredient -> measure

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strYoutube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> j) {
    // collect up to 20 ingredients
    final Map<String, String> ing = {};
    for (int i = 1; i <= 20; i++) {
      final keyIng = 'strIngredient$i';
      final keyMea = 'strMeasure$i';
      final valIng = (j[keyIng] ?? '').toString().trim();
      final valMea = (j[keyMea] ?? '').toString().trim();
      if (valIng.isNotEmpty) {
        ing[valIng] = valMea;
      }
    }
    return MealDetail(
      idMeal: j['idMeal'] ?? '',
      strMeal: j['strMeal'] ?? '',
      strCategory: j['strCategory'] ?? '',
      strArea: j['strArea'] ?? '',
      strInstructions: j['strInstructions'] ?? '',
      strMealThumb: j['strMealThumb'] ?? '',
      strYoutube: j['strYoutube'] ?? '',
      ingredients: ing,
    );
  }
}
