import 'package:flutter/material.dart';
import 'package:tbo_the_best_one/components/custom_container.dart';
import 'package:tbo_the_best_one/models/wallet.dart';

class WalletStatementCard extends StatelessWidget {
  final WalletStatement statement;

  const WalletStatementCard(this.statement);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text("${transaction.date}  |  ${transaction.time}"),
                    Text(
                      statement.amountAsString,
                      style: TextStyle(
                        color: statement.status == "CREDITED"
                            ? Colors.green
                            : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(statement.statement),
              ],
            ),
          ),
          Container(
            color: Color(0xFFFFF8F5),
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text(
              "Transaction ID: ${statement.transId}",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
