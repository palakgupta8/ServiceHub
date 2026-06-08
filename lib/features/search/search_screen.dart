import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/data/mock_data.dart';
import '../../shared/models/service_model.dart';
import '../../shared/utils/category_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

// Popular search suggestions shown before user types anything
const _suggestions = [
  'Home Cleaning', 'Plumbing', 'AC Repair',
  'Electrical', 'Beauty', 'Painting',
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  // _results: filtered list — null means "user hasn't typed yet"
  // We distinguish null (no query) from empty list (query but no matches)
  List<ServiceModel>? _results;

  // Recent search history — max 5 entries, stored in SharedPreferences
  List<String> _history = [];

  static const _historyKey = 'search_history';

  @override
  void initState() {
    super.initState();
    // addListener: fires every time the text changes — live search
    _controller.addListener(_onQueryChanged);
    _loadHistory();
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _history = prefs.getStringList(_historyKey) ?? [];
    });
  }

  Future<void> _saveToHistory(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    // Remove duplicate if exists, then prepend — max 5 entries
    final updated = [
      trimmed,
      ..._history.where((h) => h.toLowerCase() != trimmed.toLowerCase()),
    ].take(5).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, updated);
    if (!mounted) return;
    setState(() => _history = updated);
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    if (!mounted) return;
    setState(() => _history = []);
  }

  void _onQueryChanged() {
    final query = _controller.text.trim().toLowerCase();

    if (query.isEmpty) {
      // Clear results → show suggestions again
      setState(() => _results = null);
      return;
    }

    // Filter services: match name OR category name
    final filtered = MockData.popularServices.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.categoryName.toLowerCase().contains(query);
    }).toList();

    setState(() => _results = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        // Search field directly in AppBar — common pattern for search screens
        title: TextField(
          controller: _controller,
          autofocus: true, // keyboard opens immediately when screen opens
          decoration: InputDecoration(
            hintText: 'Search for services...',
            border: InputBorder.none,      // no border inside AppBar
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          style: AppTextStyles.bodyMedium,
          textInputAction: TextInputAction.search,
          // Save to history when user submits the search query
          onSubmitted: (value) => _saveToHistory(value),
        ),
        // Clear button — only shows when there's text
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () {
                _controller.clear();
                // _onQueryChanged fires automatically via listener
              },
            ),
        ],
      ),
      body: _results == null
          ? _buildSuggestions()
          : _results!.isEmpty
              ? _buildEmptyState()
              : _buildResults(),
    );
  }

  // ── Suggestions (shown before typing) ─────────────────────────────────
  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Recent searches (only shown when history exists) ───────────
          if (_history.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Searches', style: AppTextStyles.headingSmall),
                GestureDetector(
                  onTap: _clearHistory,
                  child: Text(
                    'Clear',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _history.map((s) {
                return GestureDetector(
                  onTap: () => _controller.text = s,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history_rounded,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          s,
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // ── Popular searches ───────────────────────────────────────────
          Text('Popular Searches', style: AppTextStyles.headingSmall),
          const SizedBox(height: 14),

          // Wrap: chip tags that wrap to next line
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _suggestions.map((s) {
              return GestureDetector(
                onTap: () {
                  _saveToHistory(s);
                  _controller.text = s;
                  // setting .text triggers listener → live search fires
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(s, style: AppTextStyles.labelSmall),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Results list ───────────────────────────────────────────────────────
  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            '${_results!.length} result${_results!.length == 1 ? '' : 's'} found',
            style: AppTextStyles.bodySmall,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM),
            itemCount: _results!.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final service = _results![index];
              return _SearchResultTile(
                service: service,
                query: _controller.text.trim(),
                onTap: () {
                                  _saveToHistory(_controller.text.trim());
                                  context.push('/service/${service.id}');
                                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text('No results found', style: AppTextStyles.headingSmall),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Single search result row ─────────────────────────────────────────────────
class _SearchResultTile extends StatelessWidget {
  final ServiceModel service;
  final String query;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.service,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: service.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                CategoryUtils.iconFor(service.categoryId),
                size: 24,
                color: CategoryUtils.colorFor(service.categoryId),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Highlighted text: matched portion shown in primary color
                  _HighlightedText(text: service.name, query: query),
                  const SizedBox(height: 3),
                  Text(service.categoryName, style: AppTextStyles.bodySmall),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(service.formattedPrice, style: AppTextStyles.price.copyWith(fontSize: 15)),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 12, color: AppColors.star),
                    const SizedBox(width: 2),
                    Text(service.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Highlights the matched portion of text in primary color
class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedText({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: AppTextStyles.headingSmall);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final matchIndex = lowerText.indexOf(lowerQuery);

    // No match in this specific text (matched via category instead)
    if (matchIndex == -1) {
      return Text(text, style: AppTextStyles.headingSmall);
    }

    // Split into 3 parts: before match, match, after match
    final before = text.substring(0, matchIndex);
    final match = text.substring(matchIndex, matchIndex + query.length);
    final after = text.substring(matchIndex + query.length);

    // RichText: multiple TextSpan with different styles in one Text widget
    return RichText(
      text: TextSpan(
        style: AppTextStyles.headingSmall,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: match,
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.primary,
              backgroundColor: AppColors.primaryLight,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
