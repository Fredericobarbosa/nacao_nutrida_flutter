import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  // Sistema funcionando em modo de simulação local com persistência

  // Cache de métricas para envio em batch (temporário na memória)
  final List<Map<String, dynamic>> _metricsCache = [];

  // Chave para armazenamento persistente
  static const String _storageKey = 'analytics_metrics';

  // Flag para indicar se os dados já foram carregados
  bool _dataLoaded = false;

  /// Coleta dados de páginas mais acessadas
  void trackPageView(String pageName, {Map<String, dynamic>? additionalData}) {
    final metric = {
      'type': 'page_view',
      'page_name': pageName,
      'timestamp': DateTime.now().toIso8601String(),
      'user_agent': _getUserAgent(),
      'additional_data': additionalData ?? {},
    };

    _addMetric(metric);

    if (kDebugMode) {
      print('📊 Page View: $pageName');
    }
  }

  /// Coleta tempo de renderização das páginas
  void trackPageLoadTime(
    String pageName,
    int loadTimeMs, {
    bool isHeavyPage = false,
  }) {
    final metric = {
      'type': 'page_load_time',
      'page_name': pageName,
      'load_time_ms': loadTimeMs,
      'is_heavy_page': isHeavyPage,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _addMetric(metric);

    if (kDebugMode) {
      print(
        '⏱️ Page Load: $pageName - ${loadTimeMs}ms ${isHeavyPage ? "(Heavy)" : ""}',
      );
    }
  }

  /// Coleta dados de botões mais clicados
  void trackButtonClick(
    String buttonName,
    String pageName, {
    Map<String, dynamic>? context,
  }) {
    final metric = {
      'type': 'button_click',
      'button_name': buttonName,
      'page_name': pageName,
      'timestamp': DateTime.now().toIso8601String(),
      'context': context ?? {},
    };

    _addMetric(metric);

    if (kDebugMode) {
      print('👆 Button Click: $buttonName on $pageName');
    }
  }

  /// Coleta dados de páginas pesadas (demoram mais para renderizar)
  void trackHeavyPageMetrics(
    String pageName, {
    required int loadTimeMs,
    int? memoryUsageMb,
    int? numberOfWidgets,
    List<String>? heavyOperations,
  }) {
    final metric = {
      'type': 'heavy_page_metrics',
      'page_name': pageName,
      'load_time_ms': loadTimeMs,
      'memory_usage_mb': memoryUsageMb,
      'number_of_widgets': numberOfWidgets,
      'heavy_operations': heavyOperations ?? [],
      'timestamp': DateTime.now().toIso8601String(),
    };

    _addMetric(metric);

    if (kDebugMode) {
      print(
        '🐌 Heavy Page: $pageName - ${loadTimeMs}ms, Memory: ${memoryUsageMb}MB',
      );
    }
  }

  /// Carrega métricas salvas do armazenamento local
  Future<void> _loadStoredMetrics() async {
    if (_dataLoaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString(_storageKey);

      if (storedData != null) {
        final List<dynamic> decoded = jsonDecode(storedData);
        _metricsCache.clear();
        _metricsCache.addAll(decoded.cast<Map<String, dynamic>>());

        if (kDebugMode) {
          print(
            '💾 Carregadas ${_metricsCache.length} métricas do armazenamento local',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao carregar métricas: $e');
      }
    }

    _dataLoaded = true;
  }

  /// Salva métricas no armazenamento local
  Future<void> _saveMetrics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_metricsCache);
      await prefs.setString(_storageKey, encoded);

      if (kDebugMode) {
        print(
          '💾 ${_metricsCache.length} métricas salvas no armazenamento local',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao salvar métricas: $e');
      }
    }
  }

  /// Adiciona métrica ao cache
  void _addMetric(Map<String, dynamic> metric) async {
    // Carrega dados existentes se ainda não foi feito
    await _loadStoredMetrics();

    _metricsCache.add(metric);

    // Salva automaticamente após cada nova métrica
    await _saveMetrics();

    // Envia automaticamente quando atingir 50 métricas (aumentei o limite)
    if (_metricsCache.length >= 50) {
      sendMetricsToAPI();
    }
  }

  /// Simula envio para API (para desenvolvimento/academia)
  Future<void> sendMetricsToAPI() async {
    if (_metricsCache.isEmpty) return;

    try {
      // Dados que seriam enviados para API em produção
      if (kDebugMode) {
        print('📦 Payload simulado:');
        print('   Session: ${_getSessionId()}');
        print('   Version: 1.0.0');
        print('   Platform: ${_getPlatform()}');
        print('   Metrics Count: ${_metricsCache.length}');
      }

      if (kDebugMode) {
        print(
          '📤 [SIMULAÇÃO] Enviando ${_metricsCache.length} métricas para API...',
        );
        print('📊 Dados coletados:');

        // Organiza e exibe as métricas de forma estruturada
        final pageViews = <String, int>{};
        final buttonClicks = <String, int>{};
        final loadTimes = <String, int>{};

        for (final metric in _metricsCache) {
          switch (metric['type']) {
            case 'page_view':
              final pageName = metric['page_name'] as String;
              pageViews[pageName] = (pageViews[pageName] ?? 0) + 1;
              break;
            case 'button_click':
              final buttonName = metric['button_name'] as String;
              buttonClicks[buttonName] = (buttonClicks[buttonName] ?? 0) + 1;
              break;
            case 'page_load_time':
              final pageName = metric['page_name'] as String;
              final loadTime = metric['load_time_ms'] as int;
              loadTimes[pageName] = loadTime;
              break;
          }
        }

        print('  📄 Páginas: $pageViews');
        print('  🖱️ Botões: $buttonClicks');
        print('  ⏱️ Tempos: $loadTimes');
      }

      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 500));

      // Simula sucesso da API
      if (kDebugMode) {
        print('✅ [SIMULAÇÃO] Métricas "enviadas" com sucesso!');
        print('🗃️ Dados mantidos no cache local para o dashboard');
      }

      // NÃO limpa o cache para manter dados no dashboard
      // _metricsCache.clear();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro na simulação: $e');
      }
    }
  }

  /// Obtém relatório das métricas coletadas
  Future<Map<String, dynamic>> getMetricsReport() async {
    // Carrega dados salvos se ainda não foi feito
    await _loadStoredMetrics();
    final pageViews = <String, int>{};
    final buttonClicks = <String, int>{};
    final loadTimes = <String, List<int>>{};
    final heavyPages = <String, int>{};

    for (final metric in _metricsCache) {
      switch (metric['type']) {
        case 'page_view':
          final pageName = metric['page_name'] as String;
          pageViews[pageName] = (pageViews[pageName] ?? 0) + 1;
          break;

        case 'button_click':
          final buttonName = metric['button_name'] as String;
          buttonClicks[buttonName] = (buttonClicks[buttonName] ?? 0) + 1;
          break;

        case 'page_load_time':
          final pageName = metric['page_name'] as String;
          final loadTime = metric['load_time_ms'] as int;
          loadTimes[pageName] ??= [];
          loadTimes[pageName]!.add(loadTime);
          break;

        case 'heavy_page_metrics':
          final pageName = metric['page_name'] as String;
          heavyPages[pageName] = (heavyPages[pageName] ?? 0) + 1;
          break;
      }
    }

    // Calcula médias de tempo de carregamento
    final avgLoadTimes = <String, double>{};
    loadTimes.forEach((page, times) {
      avgLoadTimes[page] = times.reduce((a, b) => a + b) / times.length;
    });

    return {
      'total_metrics': _metricsCache.length,
      'most_accessed_pages': _sortByValue(pageViews),
      'most_clicked_buttons': _sortByValue(buttonClicks),
      'average_load_times': avgLoadTimes,
      'heavy_pages': _sortByValue(heavyPages),
    };
  }

  /// Força o envio imediato de todas as métricas
  Future<void> flushMetrics() async {
    await sendMetricsToAPI();
  }

  // Métodos auxiliares
  String _getSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _getPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  String _getUserAgent() {
    return 'NacaoNutrida/1.0.0 (${_getPlatform()})';
  }

  Map<String, int> _sortByValue(Map<String, int> map) {
    final sortedEntries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries);
  }

  /// Limpa todos os dados de analytics salvos
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      _metricsCache.clear();
      _dataLoaded = false;

      if (kDebugMode) {
        print('🗑️ Todos os dados de analytics foram limpos');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao limpar dados: $e');
      }
    }
  }

  /// Obtém total de métricas armazenadas
  Future<int> getTotalMetricsCount() async {
    await _loadStoredMetrics();
    return _metricsCache.length;
  }
}
