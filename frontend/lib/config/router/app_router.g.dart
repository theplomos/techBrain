// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Router de la app.
///
/// Se mantiene vivo durante toda la sesión: recrearlo perdería el historial
/// de navegación de cada pestaña.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Router de la app.
///
/// Se mantiene vivo durante toda la sesión: recrearlo perdería el historial
/// de navegación de cada pestaña.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Router de la app.
  ///
  /// Se mantiene vivo durante toda la sesión: recrearlo perdería el historial
  /// de navegación de cada pestaña.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'e4e2d6ae9b2704aa485a5294c3203857fcadecae';
