import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/consultation_request.dart';
import '../services/consultation_service.dart';
import '../theme/app_theme.dart';

/// Lists the traveller's submitted planning requests and their status.
class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final _service = ConsultationService();
  late Future<List<ConsultationRequest>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.myRequests();
  }

  Future<void> _refresh() async {
    setState(() => _future = _service.myRequests());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My requests')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<ConsultationRequest>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return _Centered(
                  'Could not load your requests.\n${snap.error}');
            }
            final items = snap.data ?? [];
            if (items.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  _Centered(
                    'No requests yet.\n'
                    'Choose a plan and tell us about your trip to get started.',
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _RequestCard(request: items[i]),
            );
          },
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final ConsultationRequest request;
  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final created = request.createdAt == null
        ? ''
        : DateFormat('d MMM yyyy').format(request.createdAt!);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${request.tierName} plan',
                        style: AppTheme.display(size: 19)),
                    if (request.priceLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(request.priceLabel,
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5)),
                    ],
                  ],
                ),
              ),
              _StatusPill(status: request.status),
            ],
          ),
          const SizedBox(height: 14),
          if (request.destinations.isNotEmpty)
            _Detail(
                icon: Icons.place_outlined, text: request.destinations),
          _Detail(
            icon: Icons.group_outlined,
            text:
                '${request.travelers} ${request.travelers == 1 ? "traveller" : "travellers"}'
                '${request.tripLengthDays != null ? " · ${request.tripLengthDays} nights" : ""}',
          ),
          if (request.startDate != null)
            _Detail(
              icon: Icons.calendar_today_outlined,
              text: 'From ${DateFormat('d MMM yyyy').format(request.startDate!)}',
            ),
          if (request.budget != null && request.budget!.isNotEmpty)
            _Detail(
                icon: Icons.payments_outlined,
                text: 'Budget: ${request.budget}'),
          if (request.wantsCall)
            const _Detail(
                icon: Icons.support_agent_outlined,
                text: 'Consultation call requested'),
          if (created.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Submitted $created',
                style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Detail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: AppColors.muted),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final RequestStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  final String text;
  const _Centered(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.5)),
      ),
    );
  }
}
