/// Returns a descriptive text for a given rating value
String getRatingText(int rating) {
  switch (rating) {
    case 1:
      return 'Poor';
    case 2:
      return 'Fair';
    case 3:
      return 'Good';
    case 4:
      return 'Very Good';
    case 5:
      return 'Excellent';
    default:
      return 'Tap a star to rate';
  }
}
