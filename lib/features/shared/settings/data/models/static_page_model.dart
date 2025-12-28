import '../../domain/entities/static_page.dart';

class StaticPageModel extends StaticPage {
  StaticPageModel({required super.content});

  factory StaticPageModel.fromJson(Map<String, dynamic> json) {
    return StaticPageModel(content: json['content'] ?? '');
  }
}
