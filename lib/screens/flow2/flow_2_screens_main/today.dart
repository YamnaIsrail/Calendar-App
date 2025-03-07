import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/provider/showhide.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/edit_period.dart';
import 'package:calender_app/screens/flow2/detail%20page/today_cycle_phase/period_phase.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:calender_app/widgets/cycle_phase_card.dart';
import 'package:calender_app/widgets/flow2_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../admob/ad_service.dart';
import '../../../firebase/analytics/analytics_service.dart';
import '../../../hive/pets_services.dart';
import '../../homeScreen.dart';
import '../../pets/choose_pet.dart';
import '../../settings/auth/password/enter_pin.dart';
import 'package:calender_app/admob/banner_ad.dart';
import 'progress_arcs.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CycleStatusScreen extends StatefulWidget {
  final String? userImageUrl;

  CycleStatusScreen({this.userImageUrl});

  @override
  State<CycleStatusScreen> createState() => _CycleStatusScreenState();
}

class _CycleStatusScreenState extends State<CycleStatusScreen> {
  String? selectedPet;
  String get screenName => "CycleStatusScreen";
  final AdManager _adManager = AdManager(); // Create AdManager instance

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(screenName);
    _loadSelectedPet();
    _adManager.loadInterstitialAd(() {}, () {}); // Preload ad

  }
  @override
  void dispose() {
    _adManager.dispose(); // Dispose ad when screen is closed
    super.dispose();
  }

  Future<void> _loadSelectedPet() async {
    String? savedPet = await HiveService.getSelectedPet();
    setState(() {
      selectedPet = savedPet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showHideProvider = context.watch<ShowHideProvider>();

    String formatDate(DateTime date) {
      String selectedFormat = context.watch<SettingsModel>().dateFormat;
      if (selectedFormat == "System Default") {
        return DateFormat.yMd().format(date); // Use system locale's default
      } else {
        return DateFormat(selectedFormat).format(date); // Use selected format
      }
    }

    String formatDateMonthDay(DateTime date) {
      return DateFormat("MMM dd").format(date); // Formats to "Oct 29"
    }

// Function to show the confirmation dialog
    Future<bool?> _showConfirmationDialog() {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm End of Pregnancy Mode"),
            content: Text("Are you sure you want to end the pregnancy mode?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // No, don't end pregnancy mode
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Yes, end pregnancy mode
                },
                child: Text("Yes"),
              ),
            ],
          );
        },
      );
    }

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          pageTitle: "",
          onCancel: () {},
          onBack: () {
            AnalyticsService.logEvent("navigate_to_settings", parameters: {
              "from_screen": "CycleStatusScreen(Home)",
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        body: Consumer3<CycleProvider, PregnancyModeProvider,
            IntercourseProvider>(
          builder: (context, cycleProvider, pregnancyModeProvider,
              intercourseProvider, child) {
            final daysUntilNextPeriod = cycleProvider.getDaysUntilNextPeriod();
            final nextPeriodDate = cycleProvider.getNextPeriodDate();
            final currentCycleDay = cycleProvider.daysElapsed + 1;
            final lastPeriodDate = cycleProvider.lastPeriodStart;
            final periodLength = cycleProvider.periodLength;
            final cycleLength = cycleProvider.cycleLength;
            final endDate = cycleProvider.lastPeriodStart
                .add(Duration(days: periodLength - 1));
            ;

            String getFormattedDueDate(DateTime? dueDate) {
              if (dueDate == null) return "No due date";
              return DateFormat(context.watch<SettingsModel>().dateFormat)
                  .format(dueDate);
            }

            final screenSize = MediaQuery.of(context).size;
            final containerSize =
                screenSize.width * 0.5; // Adjust the multiplier as needed

            // Determine if in pregnancy mode
            bool isPregnancyMode = pregnancyModeProvider.isPregnancyMode;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  Column(
                    children: [
                     Stack(
                        children: [
                          Container(
                              height: containerSize,
                              width: containerSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/cal.png"),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (pregnancyModeProvider
                                        .isPregnancyMode) ...[
                                      // Pregnancy Mode Active
                                      Text(
                                        pregnancyModeProvider.gestationWeeks !=
                                                null
                                            ? "Expected due date\n ${getFormattedDueDate(pregnancyModeProvider.dueDate)}"
                                            : "Pregnancy Mode Active",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      SizedBox(height: 5),
                                      if (pregnancyModeProvider
                                              .gestationStart !=
                                          null) ...[
                                        Text(
                                          "${pregnancyModeProvider.gestationWeeks!} Weeks ${pregnancyModeProvider.gestationDays!} Days",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ] else ...[
                                      // Not in Pregnancy Mode, show period-related information
                                      if (currentCycleDay <=
                                          periodLength - 1) ...[
                                        // Show current cycle details
                                        Text(
                                          "Periods", // Show the period end date
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 8, color: Colors.black),
                                        ),
                                        Text(
                                          "Day $currentCycleDay", // Show the period day
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        // Show the period end date
                                        Text(
                                          "Period will end on \n ${formatDate(endDate)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      ] else ...[
                                        // Period is over, show future period details
                                        Text(
                                          showHideProvider.visibilityMap[
                                                      'Future Period'] ==
                                                  true
                                              ? (daysUntilNextPeriod == 0
                                                  ? "Today" // If the period is due today, show "Today"
                                                  : (daysUntilNextPeriod < 0
                                                      ? "${daysUntilNextPeriod.abs()} Day(s) Late"
                                                      : "$daysUntilNextPeriod Day(s) Left"))
                                              : "Future Period\n is Disabled",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 5),
                                        // Show next period details
                                        Text(
                                          showHideProvider.visibilityMap[
                                                      'Future Period'] ==
                                                  true
                                              ? (daysUntilNextPeriod == 0
                                                  ? "Period is expected to begin \n ${formatDate(nextPeriodDate)}"
                                                  : (daysUntilNextPeriod < 0
                                                      ? "Your period was expected\non ${formatDate(nextPeriodDate)}."
                                                      : "Next period will start\non ${formatDate(nextPeriodDate)}"))
                                              : " ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ],
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: containerSize,
                            width: containerSize,

                            // height: 220,
                            // width: 220,
                            child: CustomPaint(
                              painter: isPregnancyMode
                                  ? PregnancyProgressPainter(
                                      pregnancyProvider: pregnancyModeProvider,
                                    )
                                  : CycleProgressPainter(
                                      cycleProvider: CycleProvider(),
                                    ),
                            ),
                          ),
                        ],
                      ),

                      //buttons for editing
                      if (!pregnancyModeProvider.isPregnancyMode)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: daysUntilNextPeriod <= 0
                                  ? Colors.green // Start button color
                                  : (currentCycleDay <= periodLength - 1
                                      ? Colors.blue // End button color
                                      : Colors.orange), // Edit button color
                              foregroundColor: Colors.white, // Text color
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners
                              ),
                            ),
                            onPressed: () {
                              if (daysUntilNextPeriod <= 0) {
                                AnalyticsService.logEvent("start_period_button_clicked", parameters: {
                                  "button_name": "Start Periods",
                                });
                                _selectStartDate(context);

                              } else if (currentCycleDay <= periodLength - 1) {
                                  AnalyticsService.logEvent("end_period_button_clicked", parameters: {
                              "button_name": "End Periods",
                              });
                                _selectEndDate(context);
                              } else {
                                AnalyticsService.logEvent("edit_periods_button_clicked", parameters: {
                                  "button_name": "Edit Periods",
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CalendarScreen()),
                                );
                              }
                            },
                            child: Text(
                              daysUntilNextPeriod <= 0
                                  ? "Start Periods"
                                  : (currentCycleDay <= periodLength - 1
                                      ? "End Periods"
                                      : "Edit Periods"),
                            ),
                          ),
                        )
                      else
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              // Condition to check if the pregnancy due date has passed
                              pregnancyModeProvider.dueDate != null &&
                                      pregnancyModeProvider.dueDate!
                                          .isBefore(DateTime.now())
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.red, // End button color
                                        foregroundColor:
                                            Colors.white, // Text color
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // Rounded corners
                                        ),
                                      ),
                                      onPressed: () async {
                                        // Show the confirmation dialog before toggling the pregnancy mode
                                        bool? shouldEndPregnancyMode =
                                            await _showConfirmationDialog();

                                        // If user confirms, then toggle the pregnancy mode
                                        if (shouldEndPregnancyMode != null &&
                                            shouldEndPregnancyMode) {
                                          AnalyticsService.logEvent("end_pregnancy_mode_confirmed", parameters: {
                                            "action": "End Pregnancy Mode",
                                          });
                                          pregnancyModeProvider
                                              .togglePregnancyMode(false);
                                        }
                                      },
                                      child: Text("End Pregnancy Mode"),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.blue, // Edit button color
                                        foregroundColor:
                                            Colors.white, // Text color
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // Rounded corners
                                        ),
                                      ),
                                      onPressed: () {
                                        _showDatePicker(
                                            context, pregnancyModeProvider);
                                      },
                                      child: Text("Edit Pregnancy Start"),
                                    ),
                              SizedBox(height: 16), // Spacing between buttons
                            ],
                          ),
                        ),

                      SizedBox(
                        height: 10,
                      ),
                      // Cycle Phase Card Section
                      Container(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cycle Phase",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_rounded),
                                  onPressed: () async {
                                    try {
                                      AnalyticsService.logEvent("navigate_to_period_phase", parameters: {
                                        "from_screen": "CycleStatusScreen(Home)",
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PeriodPhaseScreen(),
                                        ),
                                      );
                                    } catch (e) {
                                     }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 120,
                              child: SizedBox(
                                height: 120,
                                child: isPregnancyMode
                                    ? ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          CyclePhaseCard(
                                            image: AssetImage(
                                                'assets/phases/Ovum.png'),
                                            color: Colors.red[100]!,
                                            phase: "First Trimester",
                                            date: pregnancyModeProvider
                                                        .gestationStart !=
                                                    null
                                                ? "${formatDateMonthDay(pregnancyModeProvider.gestationStart!)}"
                                                : "",
                                          ),
                                          CyclePhaseCard(
                                            myicon: Icon(
                                              Icons.child_care_sharp,
                                              color: Colors.pink[100],
                                              size: 49,
                                            ),
                                            color: Colors.green[100]!,
                                            phase: "Second Trimester",
                                            date: pregnancyModeProvider
                                                        .secondTrimesterStart !=
                                                    null
                                                ? " ${formatDateMonthDay(pregnancyModeProvider.secondTrimesterStart!)} "
                                                : "",
                                          ),
                                          CyclePhaseCard(
                                            myicon: Icon(
                                              Icons.hourglass_bottom,
                                              color: Colors.grey,
                                              size: 49,
                                            ),
                                            color: Colors.orange[100]!,
                                            phase: "Third Trimester",
                                            date: pregnancyModeProvider
                                                        .thirdTrimesterStart !=
                                                    null
                                                ? " ${formatDateMonthDay(pregnancyModeProvider.thirdTrimesterStart!)} "
                                                : "",
                                          ),
                                          CyclePhaseCard(
                                            myicon: Icon(
                                              Icons.next_plan,
                                              size: 49,
                                              color: Colors.yellow,
                                            ),
                                            color: Colors.purple[100]!,
                                            phase: "Due Date",
                                            date: pregnancyModeProvider
                                                        .dueDate !=
                                                    null
                                                ? "${formatDateMonthDay(pregnancyModeProvider.dueDate!)}"
                                                : "",
                                          ),
                                        ],
                                      )
                                    : ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          CyclePhaseCard(
                                            image: AssetImage(
                                                'assets/phases/Ovum.png'),
                                            color: Colors.green[100]!,
                                            phase: "Fertility Window",
                                            date: showHideProvider
                                                            .visibilityMap[
                                                        'Ovulation / Fertile'] ==
                                                    true
                                                ? "${formatDateMonthDay(cycleProvider.getFertilityWindowStart())} "
                                                : "Disabled",
                                          ),
                                          CyclePhaseCard(
                                            image: AssetImage(
                                                'assets/phases/Uterus.png'),
                                            color: Colors.orange[100]!,
                                            phase: "Ovulation",
                                            date: showHideProvider
                                                            .visibilityMap[
                                                        'Future Period'] ==
                                                    true
                                                ? "${formatDateMonthDay(cycleProvider.getOvulationDate())}"
                                                : "Disabled",
                                          ),
                                          CyclePhaseCard(
                                            image: AssetImage(
                                                'assets/phases/drop.png'),
                                            color: Colors.purple[100]!,
                                            phase: "Next Period",
                                            date: showHideProvider
                                                            .visibilityMap[
                                                        'Future Period'] ==
                                                    true
                                                ? "${formatDateMonthDay(cycleProvider.getNextPeriodDate())}"
                                                : "Disabled",
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Today's Cycle Status with pregnancy logic
                      buildCycleInfoCard(
                        icon: Icons.replay_5,
                        title: isPregnancyMode
                            ? "Pregnancy Progress"
                            : 'Today - Cycle Day $currentCycleDay',
                        subtitle: isPregnancyMode
                            ? "Track your pregnancy milestones"
                            : (showHideProvider.visibilityMap[
                                        'Chance of getting pregnant'] ==
                                    true
                                ? getpPregnancyChanceText(
                                    context,
                                    lastPeriodDate,
                                    periodLength,
                                    currentCycleDay,
                                    cycleLength,
                                    intercourseProvider)
                                : "Feature is disabled"),
                        progressLabelStart: isPregnancyMode
                            ? pregnancyModeProvider.gestationStart != null
                                ? formatDate(
                                    pregnancyModeProvider.gestationStart!)
                                : ""
                            : formatDate(cycleProvider.lastPeriodStart),
                        progressLabelEnd: isPregnancyMode
                            ? pregnancyModeProvider.dueDate != null
                                ? formatDate(pregnancyModeProvider.dueDate!)
                                : ""
                            : formatDate(
                                cycleProvider.lastPeriodStart.add(
                                  Duration(days: cycleProvider.cycleLength),
                                ),
                              ),
                        progressValue: isPregnancyMode
                            ? ((pregnancyModeProvider.gestationWeeks +
                                    (pregnancyModeProvider.gestationDays / 7)) /
                                40)
                            : (cycleProvider.daysElapsed /
                                    cycleProvider.cycleLength)
                                .clamp(0.0, 1.0),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BannerAdWidget(),
                      SizedBox(height: 12),
                    ],
                  ),
                  Positioned(
                    left: screenSize.width * 0.65,
                    top: screenSize.height * 0.2,
                    // left: 290,
                    // top: 135,
                    child: GestureDetector(
                      onTap: (selectedPet == null ||
                              selectedPet == "assets/pets/anopets.png")
                          ? null // Disable tap when no pet is selected
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PetSelectionScreen()),
                              );
                            },
                      child: Container(
                        width: 112,
                        height: 112,
                        child: (selectedPet == null ||
                                selectedPet == "assets/pets/anopets.png")
                            ? SizedBox.shrink()
                            : Image.asset(selectedPet!,
                                width: 112, height: 112),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectStartDate(BuildContext context) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    final DateTime? pickedStartDate = await _pickDate(context, isStart: true);

    if (pickedStartDate != null) {
      provider.updateLastPeriodStart(pickedStartDate);

      _adManager.showInterstitialAd(context, () {
        setState(() {}); // Refresh UI after ad
      });

      }
  }

  void _selectEndDate(BuildContext context) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    final DateTime? pickedEndDate = await _pickDate(context, isStart: false);

    if (pickedEndDate != null) {
      final startDate = provider.getLastPeriodStartForEnd();
      if (startDate != null) {
        if (pickedEndDate.isAfter(startDate) ||
            pickedEndDate.isAtSameMomentAs(startDate)) {
          provider.addPastPeriod(startDate, pickedEndDate);

          final periodLength = pickedEndDate.difference(startDate).inDays + 1;
          provider.updatePeriodLength(periodLength); // Update the period length

          _adManager.showInterstitialAd(context, () {
            setState(() {}); // Refresh UI after ad
          });
        } else {
          _showSnackbar(context, "End date cannot be before start date");
        }
      } else {
        _showSnackbar(context, "Please select a valid start date first");
      }
    }
  }

  Future<DateTime?> _pickDate(BuildContext context,
      {required bool isStart}) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    DateTime? initialDate;

    if (isStart) {
      // Allow the user to select the start date independently
      initialDate = DateTime.now(); // Start date can be any date
    } else {
      // For end date, check if a start date is already selected
      final startDate = provider.getLastPeriodStartForEnd();
      if (startDate == null) {
        // Show a Snackbar if no start date has been selected
        _showSnackbar(context, "Please select a valid start date first.");
        return null; // Return null if no start date is selected
      }
      initialDate =
          startDate; // For the end date, set the initial date as the start date
    }
    _adManager.loadInterstitialAd(() {}, () {}); // Load ad when opening calendar

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    return pickedDate;
  }

  void _showDatePicker(
      BuildContext context, PregnancyModeProvider pregnancyModeProvider) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: pregnancyModeProvider.gestationStart ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      if (newDate.isAfter(DateTime.now())) {
        // Show a message to the user about selecting a valid date
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please select a valid date (not in the future).')),
        );
        return; // Do not proceed further if the date is in the future
      } else {
        pregnancyModeProvider.gestationStart = newDate;
        pregnancyModeProvider.calculateGestationWeeksAndDays();
        pregnancyModeProvider.notifyListeners();
      }
    }
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

String getpPregnancyChanceText(
  BuildContext context,
  DateTime lastPeriodDate,
  int periodLength,
  int currentCycleDay,
  int cycleLength,
  IntercourseProvider intercourseProvider,
) {
  // Calculate ovulation window
  int ovulationStart = (cycleLength ~/ 2) - 1; // Adjust as needed
  int ovulationEnd = ovulationStart + 4;

  // Determine the condom protection status
  bool isProtected = intercourseProvider.condomOption == 'Protected';
  int numberOfTimes = intercourseProvider.times;

  double pregnancyChancePercentage = 0.0;
  String chanceText = '';

  // No intercourse detected
  if (numberOfTimes == 0) {
    return 'No chance of pregnancy (0%).';
  }

  // Current period check
  if (currentCycleDay <= periodLength) {
    pregnancyChancePercentage = 5.0; // Low chance during period
    chanceText = 'Low chance of pregnancy';
  }
  // Fertile window check
  else if (currentCycleDay >= ovulationStart &&
      currentCycleDay <= ovulationEnd) {
    if (!isProtected) {
      pregnancyChancePercentage =
          intercourseProvider.femaleOrgasm == 'Happened' ? 90.0 : 70.0;
      chanceText = 'High chance of pregnancy';
    } else {
      pregnancyChancePercentage = 20.0; // Low chance with protection
      chanceText = 'Low chance of pregnancy';
    }
  }
  // Approaching fertile window (late period)
  else if (currentCycleDay > periodLength && currentCycleDay < ovulationStart) {
    pregnancyChancePercentage =
        isProtected ? 10.0 : (30.0 + (numberOfTimes * 5.0));
    chanceText =
        isProtected ? 'Low chance of pregnancy' : 'Medium chance of pregnancy';
  }
  // Luteal phase (after ovulation)
  else if (currentCycleDay > ovulationEnd && currentCycleDay <= cycleLength) {
    pregnancyChancePercentage = isProtected ? 5.0 : 30.0;
    chanceText =
        isProtected ? 'Low chance of pregnancy' : 'Medium chance of pregnancy';
  }
  // Late periods and post-cycle
  else if (currentCycleDay > cycleLength) {
    pregnancyChancePercentage =
        20.0; // Some chance of pregnancy after periods end
    chanceText = ' Medium chance of pregnancy';
  }
  // Cycle has ended, no chance
  else {
    return 'No chance of pregnancy (0%).';
  }

  // Cap the percentage at 100%
  pregnancyChancePercentage = pregnancyChancePercentage.clamp(0.0, 100.0);

  return '$chanceText (${pregnancyChancePercentage.toStringAsFixed(1)}%).';
}
