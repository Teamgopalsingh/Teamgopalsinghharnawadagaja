class ElectionData {
  final String constituencyName;
  final String constituencyCode;
  final int totalElectorate;
  final double historicalTurnoutPercent;
  final List<Map<String, String>> pollingStations;
  final String sourceDetails;

  ElectionData({
    required this.constituencyName,
    required this.constituencyCode,
    required this.totalElectorate,
    required this.historicalTurnoutPercent,
    required this.pollingStations,
    required this.sourceDetails,
  });

  factory ElectionData.fromJson(Map<String, dynamic> json) {
    return ElectionData(
      constituencyName: json['constituency_name'] ?? 'Jhalrapatan',
      constituencyCode: json['constituency_code'] ?? 'AC-198',
      totalElectorate: json['total_electorate'] ?? 285000,
      historicalTurnoutPercent: json['historical_turnout_percent'] != null ? (json['historical_turnout_percent'] as num).toDouble() : 78.4,
      pollingStations: List<Map<String, String>>.from((json['polling_stations'] as List? ?? []).map((e) => Map<String, String>.from(e))),
      sourceDetails: json['source_details'] ?? 'Election Commission of India / Chief Electoral Officer Rajasthan Public Portal (ceorajasthan.nic.in)',
    );
  }
}
