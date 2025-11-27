class MealSummary {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  MealSummary({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory MealSummary.fromJson(Map<String, dynamic> j) {
    return MealSummary(
      idMeal: j['idMeal'] ?? '',
      strMeal: j['strMeal'] ?? '',
      strMealThumb: j['strMealThumb'] ?? '',
    );
  }
}
