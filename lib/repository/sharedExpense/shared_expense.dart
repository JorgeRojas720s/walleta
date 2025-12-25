import 'package:walleta/models/shared_expense.dart';

class SharedExpenseRepository {
  SharedExpenseRepository();

  Future<List<SharedExpense>> fetchSharedExpenses() async {
    // Implement fetching logic
    return [];
  }

  Future<void> addSharedExpense(SharedExpense expense) async {
    // Implement adding logic
  }

  Future<void> deleteSharedExpense(SharedExpense expenseId) async {
    // Implement deletion logic
  }

  Future<void> updateSharedExpense(SharedExpense expense) async {
    // Implement updating logic
  }
}
