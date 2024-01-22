import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/expense.dart';
import 'package:expense_tracker_app/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}
class _NewExpenseState extends State<NewExpense> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  DateTime? selectedDate;
  Category selectedCategory = Category.leisure;

  final formatter = DateFormat.yMd();

  @override
  void initState() {
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1, now.month, now.day),
        lastDate: now);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input '),
          content: const Text(
              'Please ensure you have entered correct Title , Amount and category '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('okay'),
            )
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: selectedDate!,
        category: selectedCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            // width: 200,
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title '),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '₹',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title '),
                    ),
                  ),
                if (width >= 600)
                  Row(children: [
                    Expanded(
                      child: DropdownButton(
                          //value: selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          }),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedDate == null
                                ? 'No Date Selected '
                                : formatter.format(selectedDate!),
                          ),
                          IconButton(
                            onPressed: () {
                              _presentDatePicker();
                            },
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    ),
                  ],)
                else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '₹',
                          label: Text('Amount'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedDate == null
                                ? 'No Date Selected '
                                : formatter.format(selectedDate!),
                          ),
                          IconButton(
                            onPressed: () {
                              _presentDatePicker();
                            },
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                if(width>=600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Exit"),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: submitExpenseData,
                        child: const Text("Submit Expense"),
                      ),
                    ],
                  )
                else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              selectedCategory = value;
                            });
                          }),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Exit"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: submitExpenseData,
                      child: const Text("Submit Expense"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
