import 'matching.dart';

class MatchData {
  final List<Matching> matchings;
  final Statistics statistics;
  final int runtime;

  MatchData(this.matchings, this.statistics, this.runtime);

  factory MatchData.fromJson(Map<String, dynamic> json) {
    final matchings = Matching.parseResponse(json['matches'] as List<dynamic>);

    return MatchData(matchings, Statistics.fromJson(json["statistics"]),
        json['runtime'] as int);
  }
}

class Statistics {
  final int unassignedCount;
  final List<int> profile;
  final double averageRank;
  final double rankStandardDeviation;
  final double averageRankWithUnassigned;
  final double averageStandardDeviationWithUnassigned;

  Statistics(
      this.unassignedCount,
      this.profile,
      this.averageRank,
      this.rankStandardDeviation,
      this.averageRankWithUnassigned,
      this.averageStandardDeviationWithUnassigned);

  factory Statistics.fromJson(Map<String, dynamic> json) {
    final profile = (json['profile'] as List<dynamic>)
        .map((item) => (item as double).floor())
        .toList();

    return Statistics(
        (json['unassignedCount'] as double).floor(),
        profile,
        json['averageRank'] as double,
        json['standardDeviationRank'] as double,
        json['averageRankWithUnassigned'] as double,
        json['standardDeviationWithUnassigned'] as double);
  }
}
