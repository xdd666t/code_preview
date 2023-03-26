// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//

import 'package:flutter/cupertino.dart';

import 'ascii.dart';

/// https://pub.dev/packages/string_scanner/install
/// A class that scans through a string using [Pattern]s.
class StringScanner {
  /// The URL of the source of the string being scanned.
  ///
  /// This is used for error reporting. It may be `null`, indicating that the
  /// source URL is unknown or unavailable.
  final Uri? sourceUrl;

  /// The string being scanned through.
  final String string;

  /// The current position of the scanner in the string, in characters.
  int get position => _position;

  set position(int position) {
    if (position < 0 || position > string.length) {
      throw ArgumentError('Invalid position $position');
    }

    _position = position;
    _lastMatch = null;
  }

  int _position = 0;

  /// The data about the previous match made by the scanner.
  ///
  /// If the last match failed, this will be `null`.
  Match? get lastMatch {
    // Lazily unset [_lastMatch] so that we avoid extra assignments in
    // character-by-character methods that are used in core loops.
    if (_position != _lastMatchPosition) _lastMatch = null;
    return _lastMatch;
  }

  Match? _lastMatch;
  int? _lastMatchPosition;

  /// The portion of the string that hasn't yet been scanned.
  String get rest => string.substring(position);

  /// Whether the scanner has completely consumed [string].
  bool get isDone => position == string.length;

  /// Creates a new [StringScanner] that starts scanning from [position].
  ///
  /// [position] defaults to 0, the beginning of the string. [sourceUrl] is the
  /// URL of the source of the string being scanned, if available. It can be
  /// a [String], a [Uri], or `null`.
  StringScanner(this.string, {sourceUrl, int? position})
      : sourceUrl = sourceUrl == null
            ? null
            : sourceUrl is String
                ? Uri.parse(sourceUrl)
                : sourceUrl as Uri {
    if (position != null) this.position = position;
  }

  /// Consumes a single character and returns its character code.
  ///
  /// This throws a [FormatException] if the string has been fully consumed. It
  /// doesn't affect [lastMatch].
  int readChar() {
    if (isDone) _fail('more input');
    return string.codeUnitAt(_position++);
  }

  /// Returns the character code of the character [offset] away from [position].
  ///
  /// [offset] defaults to zero, and may be negative to inspect already-consumed
  /// characters.
  ///
  /// This returns `null` if [offset] points outside the string. It doesn't
  /// affect [lastMatch].
  int? peekChar([int? offset]) {
    offset ??= 0;
    final index = position + offset;
    if (index < 0 || index >= string.length) return null;
    return string.codeUnitAt(index);
  }

  /// If the next character in the string is [character], consumes it.
  ///
  /// Returns whether or not [character] was consumed.
  bool scanChar(int character) {
    if (isDone) return false;
    if (string.codeUnitAt(_position) != character) return false;
    _position++;
    return true;
  }

  /// If the next character in the string is [character], consumes it.
  ///
  /// If [character] could not be consumed, throws a [FormatException]
  /// describing the position of the failure. [name] is used in this error as
  /// the expected name of the character being matched; if it's `null`, the
  /// character itself is used instead.
  void expectChar(int character, {String? name}) {
    if (scanChar(character)) return;

    if (name == null) {
      if (character == $backslash) {
        name = r'"\"';
      } else if (character == $double_quote) {
        name = r'"\""';
      } else {
        name = '"${String.fromCharCode(character)}"';
      }
    }

    _fail(name);
  }

  /// If [pattern] matches at the current position of the string, scans forward
  /// until the end of the match.
  ///
  /// Returns whether or not [pattern] matched.
  bool scan(Pattern pattern) {
    final success = matches(pattern);
    if (success) {
      _position = _lastMatch!.end;
      _lastMatchPosition = _position;
    }
    return success;
  }

  /// If [pattern] matches at the current position of the string, scans forward
  /// until the end of the match.
  ///
  /// If [pattern] did not match, throws a [FormatException] describing the
  /// position of the failure. [name] is used in this error as the expected name
  /// of the pattern being matched; if it's `null`, the pattern itself is used
  /// instead.
  void expect(Pattern pattern, {String? name}) {
    if (scan(pattern)) return;

    if (name == null) {
      if (pattern is RegExp) {
        final source = pattern.pattern;
        name = '/$source/';
      } else {
        name =
            pattern.toString().replaceAll('\\', '\\\\').replaceAll('"', '\\"');
        name = '"$name"';
      }
    }
    _fail(name);
  }

  /// If the string has not been fully consumed, this throws a
  /// [FormatException].
  void expectDone() {
    if (isDone) return;
    _fail('no more input');
  }

  /// Returns whether or not [pattern] matches at the current position of the
  /// string.
  ///
  /// This doesn't move the scan pointer forward.
  bool matches(Pattern pattern) {
    _lastMatch = pattern.matchAsPrefix(string, position);
    _lastMatchPosition = _position;
    return _lastMatch != null;
  }

  /// Returns the substring of [string] between [start] and [end].
  ///
  /// Unlike [String.substring], [end] defaults to [position] rather than the
  /// end of the string.
  String substring(int start, [int? end]) {
    end ??= position;
    return string.substring(start, end);
  }

  // TODO(nweiz): Make this handle long lines more gracefully.
  /// Throws a [FormatException] describing that [name] is expected at the
  /// current position in the string.
  void _fail(String name) {
    debugPrint('expected $name., position: $position');
  }
}
