import 'package:equatable/equatable.dart';
import 'package:walleta/models/shared_expense.dart';

enum SharedExpenseStatus { initial, deleted, updated, success, loading, error }

class SharedExpenseState extends Equatable {
  final SharedExpenseStatus status;
  final List<SharedExpense> expenses;

  const SharedExpenseState({
    this.status = SharedExpenseStatus.initial,
    this.expenses = const [],
  });

  const SharedExpenseState.initial()
    : this(status: SharedExpenseStatus.initial);

  const SharedExpenseState.deleted()
    : this(status: SharedExpenseStatus.deleted);

  const SharedExpenseState.updated()
    : this(status: SharedExpenseStatus.updated);

  const SharedExpenseState.success(List<SharedExpense> expenses)
    : this(status: SharedExpenseStatus.success, expenses: expenses);

  const SharedExpenseState.loading()
    : this(status: SharedExpenseStatus.loading);

  const SharedExpenseState.error() : this(status: SharedExpenseStatus.error);

  @override
  List<Object?> get props => [status, expenses];
}
