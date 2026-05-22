import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/consultation_request.dart';
import '../services/consultation_service.dart';
import '../theme/app_theme.dart';

/// Staff-only inbox: every traveller's planning request, filterable by status,
/// with the ability to open one and move it along its lifecycle.
class AdminInboxScreen extends StatefulWidget {
  const AdminInboxScreen({super.key});

  @override
  State<AdminInboxScreen> createState() => _AdminInboxScreenState();
}

class _AdminInboxScreenState extends State<AdminInboxScreen> {
  final _service = ConsultationService();
  late Future<List<ConsultationRequest>> _future;
  RequestStatus? _filter; // null = all

  @override
  void initState() {
    super.initState();
    _future = _service.allRequests();
  }

  Future<void> _refresh() async {
    setState(() => _future = _service.allRequests());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requests inbox')),
      body: Column(
        children: [
          _FilterBar(
            selected: _filter,
            onSelect: (s) => setState(() => _filter = s),
          ),
          const Divider(height: 1),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<ConsultationRequest>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return _Centered('Could not load the inbox.\n'
                        'Make sure your account is marked as admin.\n\n${snap.error}');
                  }
                  final all = snap.data ?? [];
                  final items = _filter == null
                      ? all
                      : all.where((r) => r.status == _filter).toList();
                  if (items.isEmpty) {
                    return ListView(children: const [
                      SizedBox(height: 120),
                      _Centered('Nothing here.'),
                    ]);
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _InboxCard(
                      request: items[i],
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AdminRequestDetailScreen(request: items[i]),
                          ),
                        );
                        await _refresh();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final RequestStatus? selected;
  final ValueChanged<RequestStatus?> onSelect;
  const _FilterBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, RequestStatus? value) {
      final active = selected == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          showCheckmark: false,
          backgroundColor: Colors.white,
          selectedColor: AppColors.primary.withValues(alpha: 0.12),
          side: BorderSide(
              color: active ? AppColors.primary : AppColors.line),
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : AppColors.ink,
          ),
          onSelected: (_) => onSelect(value),
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        children: [
          chip('All', null),
          for (final s in RequestStatus.values) chip(s.label, s),
        ],
      ),
    );
  }
}

class _InboxCard extends StatelessWidget {
  final ConsultationRequest request;
  final VoidCallback onTap;
  const _InboxCard({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final created = request.createdAt == null
        ? ''
        : DateFormat('d MMM yyyy').format(request.createdAt!);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.fullName.isEmpty ? 'Traveller' : request.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15.5),
                  ),
                ),
                _StatusPill(status: request.status),
              ],
            ),
            const SizedBox(height: 4),
            Text('${request.tierName} · ${request.priceLabel}',
                style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5)),
            const SizedBox(height: 8),
            Text(
              request.destinations,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            if (created.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(created,
                  style:
                      const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full request detail with status controls.
class AdminRequestDetailScreen extends StatefulWidget {
  final ConsultationRequest request;
  const AdminRequestDetailScreen({super.key, required this.request});

  @override
  State<AdminRequestDetailScreen> createState() =>
      _AdminRequestDetailScreenState();
}

class _AdminRequestDetailScreenState extends State<AdminRequestDetailScreen> {
  final _service = ConsultationService();
  late RequestStatus _status;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _status = widget.request.status;
  }

  Future<void> _setStatus(RequestStatus s) async {
    if (s == _status || widget.request.id == null) return;
    setState(() {
      _status = s;
      _saving = true;
    });
    try {
      await _service.updateStatus(widget.request.id!, s);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Marked as “${s.label}”')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = widget.request.status); // revert
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Update failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    return Scaffold(
      appBar: AppBar(title: const Text('Request')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          Text(r.fullName.isEmpty ? 'Traveller' : r.fullName,
              style: AppTheme.display(size: 26)),
          const SizedBox(height: 4),
          Text('${r.tierName} plan · ${r.priceLabel}',
              style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          const SizedBox(height: 20),

          _SectionLabel('Status'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in RequestStatus.values)
                ChoiceChip(
                  label: Text(s.label),
                  selected: _status == s,
                  showCheckmark: false,
                  backgroundColor: Colors.white,
                  selectedColor: s.color.withValues(alpha: 0.15),
                  side: BorderSide(
                      color: _status == s ? s.color : AppColors.line),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _status == s ? s.color : AppColors.ink,
                  ),
                  onSelected: _saving ? null : (_) => _setStatus(s),
                ),
            ],
          ),
          const SizedBox(height: 24),

          _SectionLabel('Contact'),
          _Field(icon: Icons.mail_outline, label: 'Email', value: r.email,
              selectable: true),
          const SizedBox(height: 16),

          _SectionLabel('Trip'),
          _Field(
              icon: Icons.place_outlined,
              label: 'Destinations',
              value: r.destinations),
          _Field(
            icon: Icons.group_outlined,
            label: 'Travellers',
            value: '${r.travelers}'
                '${r.tripLengthDays != null ? " · ${r.tripLengthDays} nights" : ""}',
          ),
          if (r.startDate != null)
            _Field(
              icon: Icons.calendar_today_outlined,
              label: 'Start date',
              value: DateFormat('d MMM yyyy').format(r.startDate!),
            ),
          if (r.budget != null && r.budget!.isNotEmpty)
            _Field(
                icon: Icons.payments_outlined,
                label: 'Budget',
                value: r.budget!),
          if (r.interests.isNotEmpty)
            _Field(
                icon: Icons.interests_outlined,
                label: 'Interests',
                value: r.interests.join(', ')),
          _Field(
            icon: Icons.support_agent_outlined,
            label: 'Consultation call',
            value: r.wantsCall ? 'Requested' : 'Not requested',
          ),
          if (r.notes != null && r.notes!.isNotEmpty)
            _Field(
                icon: Icons.notes_outlined,
                label: 'Notes',
                value: r.notes!),
          if (r.createdAt != null)
            _Field(
              icon: Icons.schedule_outlined,
              label: 'Submitted',
              value: DateFormat('d MMM yyyy, HH:mm').format(r.createdAt!),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            )),
      );
}

class _Field extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool selectable;
  const _Field({
    required this.icon,
    required this.label,
    required this.value,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 18, color: AppColors.muted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 12.5)),
                const SizedBox(height: 2),
                selectable
                    ? SelectableText(value,
                        style: const TextStyle(fontSize: 15, height: 1.4))
                    : Text(value,
                        style: const TextStyle(fontSize: 15, height: 1.4)),
              ],
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withValues(alpha: 0.4)),
      ),
      child: Text(status.label,
          style: TextStyle(
            color: status.color,
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          )),
    );
  }
}

class _Centered extends StatelessWidget {
  final String text;
  const _Centered(this.text);

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, height: 1.5)),
        ),
      );
}
