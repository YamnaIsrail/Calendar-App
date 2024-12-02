import 'package:calender_app/provider/cycle_provider.dart';
import 'package:share_plus/share_plus.dart';

void shareAsText(CycleProvider cycleProvider) {
  final textData = '''
Cycle Data Report:

Name: ${cycleProvider.userName}
Last Period Start: ${cycleProvider.lastPeriodStart}
Cycle Length: ${cycleProvider.cycleLength} days
Period Length: ${cycleProvider.periodLength} days
Luteal Phase Length: ${cycleProvider.lutealPhaseLength} days
Total Cycles Logged: ${cycleProvider.totalCyclesLogged}
Days Until Next Period: ${cycleProvider.getDaysUntilNextPeriod()}
''';

  Share.share(textData, subject: "Cycle Data Report");
}
