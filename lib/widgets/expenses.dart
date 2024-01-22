import 'dart:ffi';

import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expenselist/expenses_list.dart';
import 'package:expense_tracker_app/expense.dart';
import 'package:expense_tracker_app/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({
    super.key,
  });

  @override
  State<Expenses> createState() {
    return _Expensesstate();
  }
}

class _Expensesstate extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'FlutterCourse',
        amount: 18.66,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "McDonald's",
        amount: 12.66,
        date: DateTime.now(),
        category: Category.food)
  ];
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,

        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(
            onAddExpense: _addExpense,
          );
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    var expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense Deleted'),
      action: SnackBarAction(
        label: 'undo',
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    MediaQuery.of(context).size.height;
    Widget mainContent = const Center(
      child: Text('NO EXPENSES FOUND . Start Adding some ! '),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expenses Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        ],
      ),
      body: width < 600
          ? Column(
              //mainAxisAlignment:MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
