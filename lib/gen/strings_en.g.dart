///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	String get login => 'Login';
	String get welcomeText => 'Welcome back! Glad to see you, Again!';
	String get usernameHint => 'Enter your username';
	String get passwordHint => 'Enter your username';
	String get welcome => 'Welcome';
	String get appName => 'Fake Store';
	String get reviews => 'Reviews';
	String get addToCart => 'Add to cart';
	String get price => 'price';
	String get cartTotal => 'Cart total';
	String get logout => 'Log out';
	String get checkout => 'Checkout';
	String get wishlist => 'Wishlist';
	String get fieldRequired => 'This field is required';
	String get alreadyInCart => 'Already in cart';
	String get cart => 'Cart';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'login': return 'Login';
			case 'welcomeText': return 'Welcome back! Glad to see you, Again!';
			case 'usernameHint': return 'Enter your username';
			case 'passwordHint': return 'Enter your username';
			case 'welcome': return 'Welcome';
			case 'appName': return 'Fake Store';
			case 'reviews': return 'Reviews';
			case 'addToCart': return 'Add to cart';
			case 'price': return 'price';
			case 'cartTotal': return 'Cart total';
			case 'logout': return 'Log out';
			case 'checkout': return 'Checkout';
			case 'wishlist': return 'Wishlist';
			case 'fieldRequired': return 'This field is required';
			case 'alreadyInCart': return 'Already in cart';
			case 'cart': return 'Cart';
			default: return null;
		}
	}
}

