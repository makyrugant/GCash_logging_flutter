import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcash_logging_android/cash_in_screen/cash_in_B.dart';
import 'package:gcash_logging_android/services/amt_formatter.dart';
import 'package:gcash_logging_android/services/number_formatter.dart';

class CashInScreen extends StatefulWidget {
  const CashInScreen({super.key});

  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController indateController = TextEditingController();
  final TextEditingController inaccountNameController = TextEditingController();
  final TextEditingController innumberController = TextEditingController();
  final TextEditingController inamountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cash In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16), // optional spacing
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Date',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: indateController,

                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.today),
                          onPressed: () {
                            final now = DateTime.now();
                            indateController.text = now.toString().split(
                              ' ',
                            )[0];
                          },
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          indateController.text = picked.toString().split(
                            ' ',
                          )[0];
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'GCash Account Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: inaccountNameController,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'GCash Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: innumberController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        GcashNumberFormatter(),
                      ],
                      onTap: () {
                        // Ensure it starts with "09" even before typing
                        if (innumberController.text.isEmpty) {
                          innumberController.text = '09';
                          innumberController.selection =
                              TextSelection.fromPosition(
                                TextPosition(
                                  offset: innumberController.text.length,
                                ),
                              );
                        }
                      },
                      validator: (value) {
                        final raw =
                            value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
                        if (raw.length != 11) {
                          return 'Enter an 11-digit number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Amount to be Sent',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: inamountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [MoneyFormatterNoCents()],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }

                        // Extract raw integer
                        final raw = value.replaceAll(RegExp(r'[^0-9]'), '');
                        final amount = raw.isEmpty ? 0 : int.parse(raw);

                        if (amount <= 0) {
                          return 'Invalid amount';
                        }

                        if (amount > 99999) {
                          return 'Max is 99,999';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CashInSummaryScreen(
                                  date: indateController.text,
                                  accountName: inaccountNameController.text,
                                  gcashNumber: innumberController.text,
                                  amount: inamountController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
