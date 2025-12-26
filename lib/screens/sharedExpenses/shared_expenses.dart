import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walleta/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:walleta/blocs/sharedExpense/bloc/shared_expense_bloc.dart';
import 'package:walleta/blocs/sharedExpense/bloc/shared_expense_event.dart';
import 'package:walleta/blocs/sharedExpense/bloc/shared_expense_state.dart';
import 'package:walleta/screens/sharedExpenses/add_expense.dart';
import 'package:walleta/widgets/cards/expense_card.dart';

class SharedExpensesScreen extends StatefulWidget {
  const SharedExpensesScreen({Key? key}) : super(key: key);

  @override
  State<SharedExpensesScreen> createState() => _SharedExpensesScreenState();
}

class _SharedExpensesScreenState extends State<SharedExpensesScreen> {
  // List<SharedExpense> expenses = [
  //   SharedExpense(
  //     title: 'Viaje a la playa',
  //     total: 45000,
  //     paid: 5000,
  //     participants: ['María', 'Juan', 'Ana'],
  //     category: 'Viajes',
  //     categoryIcon: Icons.flight,
  //     categoryColor: Colors.blue,
  //   ),
  //   SharedExpense(
  //     title: 'Cena restaurante',
  //     total: 28000,
  //     paid: 28000,
  //     participants: ['María', 'Juan'],
  //     category: 'Comida',
  //     categoryIcon: Icons.restaurant,
  //     categoryColor: Colors.orange,
  //   ),
  // ];

  @override
  void initState() {
    super.initState();

    final userId = context.read<AuthenticationBloc>().state.user.uid;

    context.read<SharedExpenseBloc>().add(LoadSharedExpenses(userId: userId));
  }

  void _showAddExpenseSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AddExpenseSheet(
            onSave: (expense) {
              setState(() {
                // expenses.insert(0, expense);
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color iconsColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Gastos Compartidos',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: iconsColor),
            onPressed: () {
              _showAddExpenseSheet();
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: iconsColor),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<SharedExpenseBloc, SharedExpenseState>(
        builder: (context, state) {
          if (state.status == SharedExpenseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SharedExpenseStatus.error) {
            return const Center(child: Text('Error al cargar los gastos'));
          }

          if (state.expenses.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.expenses.length,
            itemBuilder: (context, index) {
              return ExpenseCard(expense: state.expenses[index]);
            },
          );
        },
      ),
    );
  }

  //!Cuando no hay gastos compartidos, colocar la animacion que tengo en UnRide para cuando no hay datos, mientras se queda este
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              size: 80,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay gastos compartidos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea tu primer gasto compartido',
            style: TextStyle(fontSize: 16, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  //!Tarjeta individual de gasto compartido
}
