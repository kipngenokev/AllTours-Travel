import 'dart:async';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../services/place_service.dart';
import '../theme/app_theme.dart';
import '../widgets/place_card.dart';
import 'place_detail_screen.dart';

/// Search for a specific place by name or country.
class SearchScreen extends StatefulWidget {
  final PlaceService service;
  const SearchScreen({super.key, required this.service});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Place>>? _results;
  String _query = '';

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      setState(() {
        _query = value.trim();
        _results = _query.isEmpty ? null : widget.service.search(_query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a place')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search a city or country…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          _onChanged('');
                        },
                      ),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_results == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Type to search destinations by name or country.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      );
    }
    return FutureBuilder<List<Place>>(
      future: _results,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final places = snap.data ?? [];
        if (places.isEmpty) {
          return Center(
            child: Text('No matches for “$_query”.',
                style: const TextStyle(color: AppColors.muted)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          itemCount: places.length,
          itemBuilder: (_, i) => PlaceCard(
            place: places[i],
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlaceDetailScreen(place: places[i]),
              ),
            ),
          ),
        );
      },
    );
  }
}
