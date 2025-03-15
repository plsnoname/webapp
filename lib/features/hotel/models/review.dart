class Review {
  final String date;
  final String author;
  final int rating;
  final String message;

  Review({
    required this.date,
    required this.author,
    required this.rating,
    required this.message,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      date: json['date'],
      author: json['author'],
      rating: json['rating'],
      message: json['message'],
    );
  }
}
