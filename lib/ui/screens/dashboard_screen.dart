import 'package:flutter/material.dart';
import '../../models/goal.dart';
import '../../state/app_state.dart';
import '../../models/enums.dart';
import '../widgets/goal_card.dart';
import 'choose_category_screen.dart';
import 'welcome_screen.dart';
import 'goal_tracking_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    var app = AppState.instance;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChooseCategoryScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 24),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _categoryHeader("Health", Icons.favorite, app.countByCategory(Category.health), primary),
                    _categoryHeader("Career", Icons.work, app.countByCategory(Category.career), primary),
                    _categoryHeader("Finance", Icons.attach_money, app.countByCategory(Category.finance), primary),
                    _categoryHeader("Growth", Icons.self_improvement, app.countByCategory(Category.personalGrowth), primary),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: app.goals.length,
                  itemBuilder: (_, i) {
                    Goal currentGoal = app.goals[i];
                    return Dismissible(
                      key: Key(currentGoal.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        int deletedIndex = i;
                        Goal deletedGoal = currentGoal;

                        app.removeGoal(currentGoal.id);
                        setState(() {});

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Goal deleted"),
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                app.goals.insert(deletedIndex, deletedGoal);
                                app.save();
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => GoalTrackingScreen(goalId: currentGoal.id)),
                          ).then((_) => setState(() {}));
                        },
                        child: GoalCard(goal: currentGoal),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryHeader(String name, IconData icon, int count, Color primary) {
    return Column(
      children: [
        Icon(icon, size: 32, color: primary),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)),
          child: Text("$count", style: TextStyle(fontWeight: FontWeight.bold, color: primary)),
        ),
      ],
    );
  }
}