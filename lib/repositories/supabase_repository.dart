import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRepository {
  SupabaseRepository._internal();
  static final SupabaseRepository _instance = SupabaseRepository._internal();
  static SupabaseRepository get instance => _instance;
  static SupabaseClient get client => Supabase.instance.client;

  final _logger = Logger(
    level: Level.debug,
  );
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isInitialized = false;

  void _setupConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        _logger.i('Internet connection restored');
        await _trySignIn();
      } else {
        _logger.w('Internet connection lost');
      }
    });
  }

  Future<void> _trySignIn() async {
    try {
      final currentUser = client.auth.currentUser;
      if (currentUser == null) {
        await client.auth.signInAnonymously();
        _logger.i('Signed in anonymously after connection restored');
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to sign in after connection restored',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.i('Supabase already initialized');
      return;
    }

    try {
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
        debug: true,
      );
      _logger.i('Supabase initialized successfully');
      _isInitialized = true;
      _setupConnectivityListener();
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize Supabase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Add methods for common Supabase operations here
  Future<User?> getCurrentUser() async {
    return client.auth.currentUser;
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  // Add more methods as needed for your specific use cases
}
