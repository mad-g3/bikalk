import 'package:web/web.dart' as web;

// Web-only: dynamically injects the Google Maps JS API script tag.
void injectMapsScript(String apiKey) {
  if (apiKey.isEmpty) return;
  final script =
      web.document.createElement('script') as web.HTMLScriptElement;
  script.src = 'https://maps.googleapis.com/maps/api/js?key=$apiKey';
  script.async = true;
  web.document.head?.appendChild(script);
}
