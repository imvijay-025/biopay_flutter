import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF000000),
              const Color(0xFF1A0A2E),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Balance Card
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF9C27B0).withOpacity(0.8),
                        const Color(0xFFE91E63).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '₹ 12,450.00',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBalanceInfo('Total Income', '₹ 25,000', true),
                          _buildBalanceInfo('Total Expense', '₹ 12,550', false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Transaction History Section
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Transaction History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            _buildTransactionItem(
                              name: 'Rahul',
                              amount: '₹ 500',
                              date: 'Today, 2:30 PM',
                              isSent: true,
                              avatarColor: const Color(0xFF9C27B0),
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              name: 'Priya',
                              amount: '₹ 1,200',
                              date: 'Yesterday, 4:15 PM',
                              isSent: false,
                              avatarColor: const Color(0xFFE91E63),
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              name: 'Amit',
                              amount: '₹ 750',
                              date: '2 days ago, 10:20 AM',
                              isSent: true,
                              avatarColor: const Color(0xFF9C27B0),
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              name: 'Sneha',
                              amount: '₹ 2,000',
                              date: '3 days ago, 6:45 PM',
                              isSent: false,
                              avatarColor: const Color(0xFFE91E63),
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              name: 'Rahul',
                              amount: '₹ 300',
                              date: '5 days ago, 11:10 AM',
                              isSent: true,
                              avatarColor: const Color(0xFF9C27B0),
                            ),
                            const SizedBox(height: 12),
                            _buildTransactionItem(
                              name: 'Priya',
                              amount: '₹ 1,500',
                              date: '1 week ago, 3:30 PM',
                              isSent: false,
                              avatarColor: const Color(0xFFE91E63),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String amount, bool isIncome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String name,
    required String amount,
    required String date,
    required bool isSent,
    required Color avatarColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  avatarColor,
                  avatarColor.withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSent ? 'Paid to $name' : 'Received from $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isSent ? '-$amount' : '+$amount',
            style: TextStyle(
              color: isSent ? Colors.red : Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
