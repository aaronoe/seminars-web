import 'matching.dart';

class MatchData {
  final List<Matching> matchings;
  final int unassignedCount;
  final List<int> profile;

  MatchData(this.matchings, this.unassignedCount, this.profile);

  factory MatchData.fromJson(Map<String, dynamic> json) {
    final matchings = Matching.parseResponse(json['matches'] as List<dynamic>);
    final profile =
        (json['profile'] as List<dynamic>).map((item) => item as int).toList();

    return MatchData(matchings, json['unassignedCount'] as int, profile);
  }
}
