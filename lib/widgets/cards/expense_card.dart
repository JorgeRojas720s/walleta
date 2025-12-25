import 'package:flutter/material.dart';
import 'package:walleta/models/shared_expense.dart';

class ExpenseCard extends StatefulWidget {
  final SharedExpense expense;
  const ExpenseCard({super.key, required this.expense});

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    final progress = widget.expense.paid / widget.expense.total;
    final isComplete = progress >= 1.0;

    Color progressColor(double progress) {
      if (progress <= 0.25) return const Color(0xFFE57373); // rojo suave
      if (progress <= 0.50) return const Color(0xFFFFB74D); // naranja
      if (progress <= 0.75) return const Color(0xFFFFD54F); // amarillo
      if (progress < 1.0) return const Color(0xFF81C784); // verde claro
      return const Color(0xFF2ECC71); // verde éxito
    }

    final double amountProgress = (widget.expense.paid / widget.expense.total)
        .clamp(0.0, 1.0);

    final color = progressColor(amountProgress);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.expense.categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.expense.categoryIcon,
                        color: widget.expense.categoryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.expense.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.expense.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.expense.categoryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isComplete)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Color(0xFF10B981),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Pagado',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: widget.expense.paid),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutQuart,
                      builder: (context, value, _) {
                        final animatedProgress = (value / widget.expense.total)
                            .clamp(0.0, 1.0);

                        final animatedColor = progressColor(animatedProgress);

                        return Text(
                          '₡${value.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: animatedColor,
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 4),
                    Text(
                      ' / ₡${widget.expense.total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: progress.clamp(0.0, 1.0),
                    ),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutQuart,
                    builder: (context, value, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete
                                ? const Color(0xFF10B981)
                                : progressColor(value),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.expense.participants.join(', '),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
