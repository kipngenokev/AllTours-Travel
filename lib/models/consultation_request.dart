import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Lifecycle of a planning request, mirrored by the `consultation_status_t`
/// enum in Supabase.
enum RequestStatus { submitted, reviewing, delivered, cancelled }

extension RequestStatusX on RequestStatus {
  String get wire => name; // matches the Postgres enum labels

  String get label => switch (this) {
        RequestStatus.submitted => 'Submitted',
        RequestStatus.reviewing => 'In review',
        RequestStatus.delivered => 'Delivered',
        RequestStatus.cancelled => 'Cancelled',
      };

  Color get color => switch (this) {
        RequestStatus.submitted => AppColors.muted,
        RequestStatus.reviewing => AppColors.accent,
        RequestStatus.delivered => AppColors.primary,
        RequestStatus.cancelled => const Color(0xFFB23B3B),
      };

  static RequestStatus parse(String? v) =>
      RequestStatus.values.firstWhere(
        (s) => s.name == v,
        orElse: () => RequestStatus.submitted,
      );
}

/// A traveller's trip-planning request tied to a chosen [ServiceTier].
class ConsultationRequest {
  final String? id;
  final String tierId;
  final String tierName;
  final String priceLabel;
  final String fullName;
  final String email;
  final String destinations;
  final DateTime? startDate;
  final int? tripLengthDays;
  final int travelers;
  final String? budget;
  final List<String> interests;
  final String? notes;
  final bool wantsCall;
  final RequestStatus status;
  final DateTime? createdAt;

  const ConsultationRequest({
    this.id,
    required this.tierId,
    required this.tierName,
    required this.priceLabel,
    required this.fullName,
    required this.email,
    required this.destinations,
    this.startDate,
    this.tripLengthDays,
    this.travelers = 1,
    this.budget,
    this.interests = const [],
    this.notes,
    this.wantsCall = false,
    this.status = RequestStatus.submitted,
    this.createdAt,
  });

  /// Payload for INSERT. `user_id` is attached by the service from the
  /// signed-in user so it always matches the RLS policy.
  Map<String, dynamic> toInsert(String userId) => {
        'user_id': userId,
        'tier_id': tierId,
        'tier_name': tierName,
        'price_label': priceLabel,
        'full_name': fullName,
        'email': email,
        'destinations': destinations,
        'start_date': startDate?.toIso8601String().substring(0, 10),
        'trip_length_days': tripLengthDays,
        'travelers': travelers,
        'budget': budget,
        'interests': interests,
        'notes': notes,
        'wants_call': wantsCall,
      };

  factory ConsultationRequest.fromMap(Map<String, dynamic> m) {
    List<String> strs(dynamic v) =>
        (v as List?)?.map((e) => e.toString()).toList() ?? const [];

    return ConsultationRequest(
      id: m['id']?.toString(),
      tierId: (m['tier_id'] ?? '').toString(),
      tierName: (m['tier_name'] ?? '').toString(),
      priceLabel: (m['price_label'] ?? '').toString(),
      fullName: (m['full_name'] ?? '').toString(),
      email: (m['email'] ?? '').toString(),
      destinations: (m['destinations'] ?? '').toString(),
      startDate: m['start_date'] != null
          ? DateTime.tryParse(m['start_date'].toString())
          : null,
      tripLengthDays: (m['trip_length_days'] as num?)?.toInt(),
      travelers: (m['travelers'] as num?)?.toInt() ?? 1,
      budget: m['budget']?.toString(),
      interests: strs(m['interests']),
      notes: m['notes']?.toString(),
      wantsCall: m['wants_call'] == true,
      status: RequestStatusX.parse(m['status']?.toString()),
      createdAt: m['created_at'] != null
          ? DateTime.tryParse(m['created_at'].toString())
          : null,
    );
  }
}
