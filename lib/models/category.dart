class Category {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> j) {
    return Category(
      idCategory: j['idCategory'] ?? '',
      strCategory: j['strCategory'] ?? '',
      strCategoryThumb: j['strCategoryThumb'] ?? '',
      strCategoryDescription: j['strCategoryDescription'] ?? '',
    );
  }
}
