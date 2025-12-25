import 'package:walleta/models/shared_expense.dart';

abstract class SharedExpenseEvent {}

class LoadSharedExpenses extends SharedExpenseEvent {}

class AddSharedExpense extends SharedExpenseEvent {
  final SharedExpense expense;

  AddSharedExpense(this.expense);
}

class UpdateSharedExpense extends SharedExpenseEvent {
  final SharedExpense expense;

  UpdateSharedExpense(this.expense);
}

class DeleteSharedExpense extends SharedExpenseEvent {
  final SharedExpense expense;

  DeleteSharedExpense(this.expense);
}
