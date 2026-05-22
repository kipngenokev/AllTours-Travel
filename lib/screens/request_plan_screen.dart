import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/consultation_request.dart';
import '../models/service_tier.dart';
import '../services/auth_service.dart';
import '../services/consultation_service.dart';
import '../theme/app_theme.dart';
import 'my_requests_screen.dart';

/// Intake form: the traveller describes their trip, we file a request against
/// the chosen [ServiceTier].
class RequestPlanScreen extends StatefulWidget {
  final ServiceTier tier;
  const RequestPlanScreen({super.key, required this.tier});

  @override
  State<RequestPlanScreen> createState() => _RequestPlanScreenState();
}

class _RequestPlanScreenState extends State<RequestPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ConsultationService();

  late final TextEditingController _name;
  late final TextEditingController _email;
  final _destinations = TextEditingController();
  final _length = TextEditingController();
  final _budget = TextEditingController();
  final _notes = TextEditingController();

  DateTime? _startDate;
  int _travelers = 2;
  bool _wantsCall = false;
  bool _submitting = false;

  static const _interestOptions = [
    'Safari & wildlife',
    'Beach & coast',
    'City & culture',
    'Adventure',
    'Family-friendly',
    'Honeymoon',
    'Budget travel',
    'Food',
  ];
  final Set<String> _interests = {};

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthService>();
    _name = TextEditingController(text: auth.displayName ?? '');
    _email = TextEditingController(text: auth.currentUser?.email ?? '');
    _wantsCall = widget.tier.includesCall;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _destinations.dispose();
    _length.dispose();
    _budget.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final request = ConsultationRequest(
      tierId: widget.tier.id,
      tierName: widget.tier.name,
      priceLabel: widget.tier.priceLabel,
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      destinations: _destinations.text.trim(),
      startDate: _startDate,
      tripLengthDays: int.tryParse(_length.text.trim()),
      travelers: _travelers,
      budget: _budget.text.trim().isEmpty ? null : _budget.text.trim(),
      interests: _interests.toList(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      wantsCall: _wantsCall,
    );

    try {
      await _service.submit(request);
      if (!mounted) return;
      await _showSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not submit: $e')),
      );
    }
  }

  Future<void> _showSuccess() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary),
            const SizedBox(width: 10),
            Text('Request sent', style: AppTheme.display(size: 20)),
          ],
        ),
        content: const Text(
          'Thank you. We have your trip details and will be in touch shortly '
          'with your quote and next steps. You can track it under “My requests”.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              Navigator.of(context).pop(); // back to consultancy screen
            },
            child: const Text('Done'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(120, 44)),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyRequestsScreen()),
              );
            },
            child: const Text('My requests'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tier = widget.tier;
    final dateLabel = _startDate == null
        ? 'Not sure yet'
        : DateFormat('d MMM yyyy').format(_startDate!);

    return Scaffold(
      appBar: AppBar(title: Text('${tier.name} plan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // Selected tier summary.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('You selected', style: AppTheme.display(size: 14)),
                        const SizedBox(height: 2),
                        Text('${tier.name} · ${tier.priceLabel}',
                            style: const TextStyle(
                                color: AppColors.muted, fontSize: 13.5)),
                      ],
                    ),
                  ),
                  const Icon(Icons.workspace_premium_outlined,
                      color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _Label('Your name'),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              validator: _required,
              decoration: const InputDecoration(hintText: 'Full name'),
            ),
            const SizedBox(height: 18),

            _Label('Email'),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
              decoration: const InputDecoration(hintText: 'you@example.com'),
            ),
            const SizedBox(height: 18),

            _Label('Where do you want to go?'),
            TextFormField(
              controller: _destinations,
              minLines: 2,
              maxLines: 4,
              validator: _required,
              decoration: const InputDecoration(
                hintText:
                    'e.g. Combine Nairobi, a Maasai Mara safari and Diani coast',
              ),
            ),
            const SizedBox(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Start date'),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 18, color: AppColors.muted),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(dateLabel,
                                    style: TextStyle(
                                        color: _startDate == null
                                            ? AppColors.muted
                                            : AppColors.ink,
                                        fontSize: 15)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Nights'),
                      TextFormField(
                        controller: _length,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'e.g. 7'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _Label('Travellers'),
            _Stepper(
              value: _travelers,
              onChanged: (v) => setState(() => _travelers = v),
            ),
            const SizedBox(height: 18),

            _Label('Budget per person (optional)'),
            TextFormField(
              controller: _budget,
              decoration: const InputDecoration(
                hintText: 'e.g. \$1,500 USD',
                prefixIcon: Icon(Icons.payments_outlined,
                    color: AppColors.muted, size: 20),
              ),
            ),
            const SizedBox(height: 18),

            _Label('Interests'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final opt in _interestOptions)
                  FilterChip(
                    label: Text(opt),
                    selected: _interests.contains(opt),
                    showCheckmark: false,
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary.withValues(alpha: 0.12),
                    side: BorderSide(
                      color: _interests.contains(opt)
                          ? AppColors.primary
                          : AppColors.line,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _interests.contains(opt)
                          ? AppColors.primary
                          : AppColors.ink,
                    ),
                    onSelected: (sel) => setState(() {
                      sel ? _interests.add(opt) : _interests.remove(opt);
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 18),

            _Label('Safety questions or anything else'),
            TextFormField(
              controller: _notes,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText:
                    'Concerns about safety, getting overcharged, must-sees, '
                    'mobility needs, dietary needs…',
              ),
            ),
            const SizedBox(height: 18),

            if (widget.tier.includesCall)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.line),
                ),
                child: SwitchListTile(
                  value: _wantsCall,
                  activeThumbColor: AppColors.primary,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  title: const Text('Include the consultation call',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: const Text('A live walkthrough of your plan + Q&A',
                      style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  onChanged: (v) => setState(() => _wantsCall = v),
                ),
              ),
            const SizedBox(height: 28),

            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white),
                    )
                  : const Text('Submit request'),
            ),
            const SizedBox(height: 12),
            const Text(
              'No payment now. We review your trip and reply with an exact '
              'quote and how to proceed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.ink)),
      );
}

class _Stepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _Stepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
            color: AppColors.primary,
          ),
          Expanded(
            child: Text(
              '$value ${value == 1 ? "traveller" : "travellers"}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          IconButton(
            onPressed: value < 30 ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
