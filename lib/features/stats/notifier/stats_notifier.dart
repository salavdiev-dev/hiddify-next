import 'package:ysp/features/connection/notifier/connection_notifier.dart';
import 'package:ysp/features/stats/data/stats_data_providers.dart';
import 'package:ysp/hiddifycore/generated/v2/hcore/hcore.pb.dart';
import 'package:ysp/utils/custom_loggers.dart';
import 'package:ysp/utils/riverpod_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_notifier.g.dart';

@riverpod
class StatsNotifier extends _$StatsNotifier with AppLogger {
  @override
  Stream<SystemInfo> build() async* {
    ref.disposeDelay(const Duration(seconds: 10));
    final serviceRunning = await ref.watch(serviceRunningProvider.future);
    if (serviceRunning) {
      yield* ref
          .watch(statsRepositoryProvider)
          .watchStats()
          .map((event) => event.getOrElse((_) => SystemInfo.create()));
    } else {
      yield* Stream.value(SystemInfo.create());
    }
  }
}
