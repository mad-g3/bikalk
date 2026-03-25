// Selects the web implementation on web, stub on native platforms.
export 'maps_script_injector_web.dart'
    if (dart.library.io) 'maps_script_injector_stub.dart';
