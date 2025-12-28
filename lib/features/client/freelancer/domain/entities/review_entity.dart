import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userName;
  final String? userImage;
  final double rating;
  final String date;
  final String comment;

  const ReviewEntity({
    required this.id,
    required this.userName,
    this.userImage,
    required this.rating,
    required this.date,
    required this.comment,
  });

  @override
  List<Object?> get props => [id, userName, userImage, rating, date, comment];
}
