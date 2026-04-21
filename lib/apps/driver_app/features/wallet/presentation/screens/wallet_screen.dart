import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/domain/entities/transaction_history_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/cubit/wallet_states.dart';
import 'package:wasel_driver/apps/driver_app/features/wallet/presentation/cubit/wallet_cubit.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().getWalletInfo();
    context.read<WalletCubit>().getTransactionsHistory();
  }

  List<TransactionEntity> allTransactions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocBuilder<WalletCubit, WalletStates>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await Future.wait([
                context.read<WalletCubit>().getWalletInfo(),
                context.read<WalletCubit>().getTransactionsHistory(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Blue Header + overlapping Balance Card ─────────────
                  _buildHeaderWithCard(context, state),
                  const SizedBox(height: 10),

                  // ── Body ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // ── Pending + Total Earned ───────────────────────
                        _buildStatsRow(),

                        const SizedBox(height: 20),

                        // ── Quick Actions ────────────────────────────────
                        _buildQuickActions(),

                        const SizedBox(height: 24),

                        // ── Recent Transactions ──────────────────────────
                        _buildTransactionsHeader(context),

                        const SizedBox(height: 12),

                        _buildTransactionsList(state),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Blue header with overlapping balance card ────────────────────────────────
  Widget _buildHeaderWithCard(BuildContext context, WalletStates state) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Blue background
        Container(
          width: double.infinity,
          height: topPadding + 180,
          decoration: const BoxDecoration(color: AppColors.primary),
          padding: EdgeInsets.only(top: topPadding + 20, left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Manage your earnings',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Floating balance card
        Positioned(
          left: 20,
          right: 20,
          top: topPadding + 72,
          child: _buildBalanceCard(context, state),
        ),

        // Spacer so stack has correct height
        SizedBox(height: topPadding + 72 + 155),
      ],
    );
  }

  // ── Balance Card ─────────────────────────────────────────────────────────────
  Widget _buildBalanceCard(BuildContext context, WalletStates state) {
    final balance = state.walletInfo?.balance.toStringAsFixed(2) ?? '0.00';
    final currency = state.walletInfo?.currency ?? 'EGP';
    final isLoading = state.walletInfoStatus == RequestStatus.loading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 4),
          if (isLoading)
            const SizedBox(
              height: 38, // Roughly the height of the 32px text
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            Text(
              '$currency $balance',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A2E),
                letterSpacing: -1,
              ),
            ),
          const SizedBox(height: 14),
          // Withdraw Button
          InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRouteNames.withdrawalSuccessScreen);
            },
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.north_east_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Withdraw Funds',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ────────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 242, 226),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromARGB(255, 250, 242, 226),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: Color(0xFFE8A020),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE8A020),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'EGP 150',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE8A020),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 224, 249, 233),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromARGB(255, 224, 249, 233),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 13,
                      color: Color(0xFF22C55E),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Total Earned',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'EGP 15,420',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF22C55E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Quick Actions ────────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          Icons.credit_card_outlined,
          'Add Card',
          const Color(0xFF3B82F6),
          const Color.fromARGB(255, 222, 235, 251),
          () {},
        ),
        _buildActionButton(
          Icons.date_range,
          'History',
          const Color(0xFF8B5CF6),
          const Color.fromARGB(255, 239, 237, 248),
          () {
            if (allTransactions.isNotEmpty) {
              Navigator.pushNamed(
                context,
                AppRouteNames.allTransactionsScreen,
                arguments: allTransactions,
              );
            }
          },
        ),
        // _buildActionButton(
        //   Icons.attach_money_rounded,
        //   'Invoices',
        //   const Color(0xFF22C55E),
        //   const Color.fromARGB(255, 225, 252, 233),
        // ),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color iconColor,
    Color bgColor,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ── Transactions Header ──────────────────────────────────────────────────────
  Widget _buildTransactionsHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        TextButton(
          onPressed: allTransactions.isEmpty
              ? null
              : () {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.allTransactionsScreen,
                    arguments: allTransactions,
                  );
                },
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  // ── Dynamic Transactions List ──────────────────────────────────────────────────
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildTransactionsList(WalletStates state) {
    if (state.walletTransactionsStatus == RequestStatus.loading ||
        state.walletTransactionsStatus == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state.walletTransactionsStatus == RequestStatus.error) {
      return Center(
        child: ErrorRetryWidget(
          message:
              state.walletTransactionsErrorMessage ??
              'Failed to load transactions',
          onRetry: () {
            context.read<WalletCubit>().getTransactionsHistory();
          },
        ),
      );
    }

    allTransactions =
        state.transactions?.expand((e) => e.transactions).toList() ?? [];

    if (allTransactions.isEmpty) {
      return _buildEmptyRequests();
    }

    // Show recent 5 transactions
    final recentTransactions = allTransactions.take(5).toList();

    return Column(
      children: recentTransactions.map((tx) {
        final isPositive = double.parse(tx.amount ?? '0') > 0;
        final iconWidget = isPositive
            ? const RotatedBox(
                quarterTurns: 1,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF22C55E),
                  size: 18,
                ),
              )
            : const Icon(
                Icons.north_east_rounded,
                color: Color(0xFFEF4444),
                size: 18,
              );
        final iconBgColor = isPositive
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFEE2E2);
        final amountColor = isPositive
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444);
        final amountPrefix = isPositive ? '+' : '-';

        // Truncating description if it exists
        String title = tx.description ?? '';
        if (title.length > 25) {
          title = '${title.substring(0, 25)}...';
        }

        return _buildTransactionItem(
          iconBgColor: iconBgColor,
          iconWidget: iconWidget,
          title: title,
          date: _formatDate(tx.createdAt ?? DateTime.now()),
          amount:
              '$amountPrefix EGP ${double.parse(tx.amount ?? '0').abs().toStringAsFixed(0)}',
          amountColor: amountColor,
          status: null,
        );
      }).toList(),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────

  Widget _buildEmptyRequests() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF9CA3AF)),
          const SizedBox(height: 12),
          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your transactions will appear here',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  // ── Transaction Item ─────────────────────────────────────────────────────────
  Widget _buildTransactionItem({
    required Color iconBgColor,
    required Widget iconWidget,
    required String title,
    required String date,
    required String amount,
    required Color amountColor,
    required String? status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 12),

          // Title + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          // Amount + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
              if (status != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE8A020),
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
