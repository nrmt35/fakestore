import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fakestore/app/core/themes/app_theme.dart';
import 'package:fakestore/app/core/themes/themes.dart';

part 'string.dart';
part 'theme.dart';

extension ObjectContextExtension on Object {
  T cast<T>() => this as T;
}

extension Unique<E, Id> on List<E> {
  List<E> unique(
    Id Function(E element)? id, {
    bool inplace = true,
  }) {
    final ids = <Id>{};
    return (inplace ? this : List<E>.from(this))
      ..retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
  }
}

extension CryptSHA1 on String {
  String generateSHA1(String key) {
    final List<int> bytes = utf8.encode(key + this);
    return sha1.convert(bytes).toString();
  }
}

extension StringExtensions on String {
  String removeWhitespace() => replaceAll(' ', '');

  String extractUnformattedPhoneNumber() => replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );

  String getPureNumbers() => replaceAll(RegExp(r'[^0-9]'), '');
}

extension TimestampDate on int {
  String? toSimpleDataFormat() {
    final BuildContext? getContext = Get.context;
    if (getContext != null) {
      final String? tag =
          Localizations.maybeLocaleOf(getContext)?.toLanguageTag();
      final DateTime dateTimeData =
          DateTime.fromMillisecondsSinceEpoch(this * 1000);
      final DateFormat formatter = DateFormat('d MMMM в HH:mm', tag);
      return formatter.format(dateTimeData);
    }
    return null;
  }
}

extension FileEncodeData on File {
  String toBase64ImageString() {
    final List<int> imageBytes = readAsBytesSync();
    return base64Encode(imageBytes);
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final T element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  Iterable<T> distinctBy(Object? Function(T e) getCompareValue) {
    final result = <T>[];
    forEach(
      (T element) {
        if (!result
            .any((T x) => getCompareValue(x) == getCompareValue(element))) {
          result.add(element);
        }
      },
    );
    return result;
  }
}

extension FormattedMessage on Exception {
  String get getMessage {
    if (toString().startsWith("Exception: ")) {
      return toString().substring(11);
    } else {
      return toString();
    }
  }
}
