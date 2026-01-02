import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcash_logging_android/cash_in_screen/DELcash_in_B.dart';
import 'package:gcash_logging_android/summary_screen.dart';
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
  final TextEditingController feeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    inamountController.addListener(_recalculateFee);
  }

  void _recalculateFee() {
    final raw = inamountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isEmpty) {
      feeController.text = '';
      return;
    }

    final amount = int.parse(raw);
    final fee = computeFee(amount);

    feeController.text = fee.toString();
  }

  void _recomputeFee() {
    final feeRaw = feeController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final discRaw = discountController.text.replaceAll(RegExp(r'[^0-9]'), '');

    final fee = feeRaw.isEmpty ? 0 : int.parse(feeRaw);
    final discount = discRaw.isEmpty ? 0 : int.parse(discRaw);

    final result = (fee - discount).clamp(0, fee);

    feeController.text = result.toString();
  }

  void _onDiscountChanged(String value) {
    final feeRaw = feeController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final discRaw = value.replaceAll(RegExp(r'[^0-9]'), '');

    final fee = feeRaw.isEmpty ? 0 : int.parse(feeRaw);
    final discount = discRaw.isEmpty ? 0 : int.parse(discRaw);

    final maxDiscount = (fee * 0.55).floor();

    if (discount > maxDiscount) {
      discountController.text = maxDiscount.toString();
      discountController.selection = TextSelection.collapsed(
        offset: discountController.text.length,
      );
    }
    _recalculateFee();
    _recomputeFee();
  }

  int computeFee(int amount) {
    if (amount <= 150) return 10;
    if (amount < 201) return 15;
    if (amount < 1200) return 20;

    // start after 200
    int startAmount = 1200;
    int fee = 30;
    bool use700 = true; // first range is 700

    while (true) {
      int range = use700 ? 700 : 300;
      int endAmount = startAmount + range - 1;

      if (amount <= endAmount) {
        return fee;
      }

      // move to next range
      startAmount = endAmount + 1;
      fee += 10;
      use700 = !use700; // alternate
    }
  }

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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
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
                    Row(
                      children: [
                        // Amount (largest)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Amount to be Sent',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: inamountController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [MoneyFormatterNoCents()],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }

                                  final raw = value.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  );
                                  final amount = raw.isEmpty
                                      ? 0
                                      : int.parse(raw);

                                  if (amount <= 0) return 'Invalid amount';
                                  if (amount > 99999) return 'Max is 99,999';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Fee (small)
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Fee', style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: feeController,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Discount (small)
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Discount',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: discountController,
                                keyboardType: TextInputType.number,
                                onChanged: _onDiscountChanged,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                                builder: (_) => SummaryScreen(
                                  date: indateController.text,
                                  name: inaccountNameController.text,
                                  number: innumberController.text,
                                  amount: inamountController.text,
                                  type: 'CASH IN',
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
