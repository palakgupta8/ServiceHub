class ServiceProviderModel {
  final String id;
  final String name;
  final double rating;
  final int completedJobs;
  final int yearsExperience;
  final String specialization;

  const ServiceProviderModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.completedJobs,
    required this.yearsExperience,
    required this.specialization,
  });

  // e.g. 1250 → "1.2k"
  String get formattedJobs {
    if (completedJobs >= 1000) {
      return '${(completedJobs / 1000).toStringAsFixed(1)}k';
    }
    return completedJobs.toString();
  }
}
