/// Client-side profanity / restricted-words filter for advertisements.
///
/// The app blocks publishing when an ad's title or description contains any of
/// these words and shows a toast. The backend also enforces a server-side
/// validation rule (per the API contract); this is the client-side guard so the
/// user gets immediate feedback before the request is sent.
///
/// To extend the list, just add entries to [_words] (Arabic or English).
class BannedWords {
  BannedWords._();

  static const List<String> _words = [
    // ---------- Arabic ----------
    'كلب',
    'حقير',
    'غبي',
    'غبية',
    'احمق',
    'أحمق',
    'حمار',
    'وسخ',
    'قذر',
    'تافه',
    'لعنة',
    'لعين',
    'خنزير',
    'منيك',
    'عرص',
    'خول',
    'زفت',
    'نذل',
    'سافل',
    'قواد',
    'شرموط',
    'شرموطة',
    'عاهرة',
    'متخلف',
    'كافر',
    'نصاب',
    'محتال',
    'مزور',
    'احتيال',
    'نصب',
    // ---------- English ----------
    'fuck',
    'fucking',
    'shit',
    'bitch',
    'bastard',
    'asshole',
    'dick',
    'damn',
    'crap',
    'idiot',
    'stupid',
    'moron',
    'slut',
    'whore',
    'porn',
    'sex',
    'nigger',
    'cunt',
    'scam',
    'fraud',
    'fake',
  ];

  /// Lower-cases and strips Arabic diacritics / tatweel and normalizes the most
  /// common Arabic letter variants so matching is resilient to spelling style.
  static String _normalize(String input) {
    var s = input.toLowerCase();
    // Remove Arabic diacritics (tashkeel) + tatweel.
    s = s.replaceAll(RegExp('[ؐ-ًؚ-ٰٟـ]'), '');
    // Unify alef / ya / ta-marbuta variants.
    s = s
        .replaceAll(RegExp('[أإآٱ]'), 'ا') // أ إ آ ٱ -> ا
        .replaceAll('ى', 'ي') // ى -> ي
        .replaceAll('ة', 'ه'); // ة -> ه
    return s;
  }

  static final Set<String> _normalizedWords =
      _words.map(_normalize).toSet();

  /// Returns the first banned word found in [text], or null when clean.
  static String? firstMatch(String text) {
    if (text.trim().isEmpty) return null;
    final normalized = _normalize(text);
    // Word-level tokens to limit false positives on innocent substrings.
    final tokens = normalized
        .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
        .where((t) => t.isNotEmpty)
        .toSet();
    for (final w in _normalizedWords) {
      if (w.contains(' ')) {
        if (normalized.contains(w)) return w;
      } else if (tokens.contains(w)) {
        return w;
      }
    }
    return null;
  }

  /// True when [text] contains any banned word.
  static bool contains(String text) => firstMatch(text) != null;
}
