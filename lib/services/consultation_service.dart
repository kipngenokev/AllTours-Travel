import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/consultation_request.dart';

/// Submits and reads the signed-in traveller's trip-planning requests.
class ConsultationService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Stores a new request against the current user. Returns the saved row.
  Future<ConsultationRequest> submit(ConsultationRequest request) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('You need to be signed in to request a plan.');
    }
    final row = await _client
        .from('consultation_requests')
        .insert(request.toInsert(uid))
        .select()
        .single();
    return ConsultationRequest.fromMap(row);
  }

  /// All of the current user's requests, newest first.
  Future<List<ConsultationRequest>> myRequests() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _client
        .from('consultation_requests')
        .select('*')
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return rows.map(ConsultationRequest.fromMap).toList();
  }

  // ---- Staff inbox (requires an admin profile + RLS admin policy) ----

  /// Every request across all travellers, newest first. Returns an empty
  /// list for non-admins (their RLS only exposes their own rows anyway).
  Future<List<ConsultationRequest>> allRequests() async {
    final rows = await _client
        .from('consultation_requests')
        .select('*')
        .order('created_at', ascending: false);
    return rows.map(ConsultationRequest.fromMap).toList();
  }

  /// Moves a request along its lifecycle (admin only).
  Future<void> updateStatus(String id, RequestStatus status) async {
    await _client
        .from('consultation_requests')
        .update({'status': status.wire}).eq('id', id);
  }
}
