import 'package:bloc/bloc.dart';
import 'package:walleta/blocs/sharedExpense/bloc/shared_expense_event.dart';
import 'package:walleta/blocs/sharedExpense/bloc/shared_expense_state.dart';
import 'package:walleta/repository/sharedExpense/shared_expense.dart';

class SharedExpenseBloc extends Bloc<SharedExpenseEvent, SharedExpenseState> {
  final SharedExpenseRepository _sharedExpenseRepository;

  SharedExpenseBloc({required SharedExpenseRepository sharedExpenseRepository})
    : _sharedExpenseRepository = sharedExpenseRepository,
      super(const SharedExpenseState.initial()) {
    on<LoadSharedExpenses>((event, emit) async {
      emit(const SharedExpenseState.loading());
      try {
        final expenses = await _sharedExpenseRepository.fetchSharedExpenses();
        emit(SharedExpenseState.success(expenses));
      } catch (_) {
        emit(const SharedExpenseState.error());
      }
    });

    on<AddSharedExpense>((event, emit) async {
      emit(const SharedExpenseState.loading());
      try {
        await _sharedExpenseRepository.addSharedExpense(event.expense);
        final expenses = await _sharedExpenseRepository.fetchSharedExpenses();
        emit(SharedExpenseState.success(expenses));
      } catch (_) {
        emit(const SharedExpenseState.error());
      }
    });

    on<DeleteSharedExpense>((event, emit) async {
      emit(const SharedExpenseState.loading());
      try {
        await _sharedExpenseRepository.deleteSharedExpense(event.expense);
        emit(const SharedExpenseState.deleted());
      } catch (_) {
        emit(const SharedExpenseState.error());
      }
    });

    on<UpdateSharedExpense>((event, emit) async {
      emit(const SharedExpenseState.loading());
      try {
        await _sharedExpenseRepository.updateSharedExpense(event.expense);
        emit(const SharedExpenseState.updated());
      } catch (_) {
        emit(const SharedExpenseState.error());
      }
    });
  }
}
