import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcash_logging_android/summary_screen.dart';
import 'package:gcash_logging_android/services/amt_formatter.dart';
import 'package:gcash_logging_android/services/ref_formatter.dart';

class CashOutScreen extends StatefulWidget {
  const CashOutScreen({super.key});

  @override
  State<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController outdateController = TextEditingController();
  final TextEditingController outDateAddedController = TextEditingController();
  final TextEditingController outreceiverNameController =
      TextEditingController();
  final TextEditingController outnumberController = TextEditingController();
  final TextEditingController outamountController = TextEditingController();
  final TextEditingController outdiscountController = TextEditingController();
  final TextEditingController outfeeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    outdateController.text = DateTime.now().toString().split(' ')[0];
    outDateAddedController.text = DateTime.now().toString().split(' ')[0];
    outamountController.addListener(_recalculateFee);
  }

  void _recalculateFee() {
    final raw = outamountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isEmpty) {
      outfeeController.text = '';
      return;
    }

    final amount = int.parse(raw);
    final fee = computeFee(amount);

    outfeeController.text = fee.toString();
  }

  void _recomputeFee() {
    final feeRaw = outfeeController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final discRaw = outdiscountController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final fee = feeRaw.isEmpty ? 0 : int.parse(feeRaw);
    final discount = discRaw.isEmpty ? 0 : int.parse(discRaw);

    final result = (fee - discount).clamp(0, fee);

    outfeeController.text = result.toString();
  }

  void _onDiscountChanged(String value) {
    final feeRaw = outfeeController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final discRaw = value.replaceAll(RegExp(r'[^0-9]'), '');

    final fee = feeRaw.isEmpty ? 0 : int.parse(feeRaw);
    final discount = discRaw.isEmpty ? 0 : int.parse(discRaw);

    final maxDiscount = (fee * 0.55).floor();

    if (discount > maxDiscount) {
      outdiscountController.text = maxDiscount.toString();
      outdiscountController.selection = TextSelection.collapsed(
        offset: outdiscountController.text.length,
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
      appBar: AppBar(title: const Text('Cash Out')),
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
                      'Transaction Date (GCASH Receipt)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: outdateController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.today),
                          onPressed: () {
                            final now = DateTime.now();
                            outdateController.text = now.toString().split(
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
                          outdateController.text = picked.toString().split(
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
                      'Date Issued',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: outDateAddedController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.history),
                          onPressed: () {
                            final now = DateTime.now();
                            outDateAddedController.text = now.toString().split(
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
                          outDateAddedController.text = picked.toString().split(
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
                      'Receiver Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: outreceiverNameController,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Reference Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: outnumberController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        GcashRefFormatter(),
                      ],
                      onTap: () {
                        if (outnumberController.text.isEmpty) {
                          outnumberController.text = '';
                          outnumberController.selection =
                              TextSelection.fromPosition(
                                TextPosition(
                                  offset: outnumberController.text.length,
                                ),
                              );
                        }
                      },
                      validator: (value) {
                        final raw =
                            value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
                        if (raw.length < 13) {
                          return 'Enter an 13-digit number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // const Text(
                    //   'Amount to Cash-out',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // TextFormField(
                    //   controller: outamountController,
                    //   textAlign: TextAlign.center,
                    //   keyboardType: TextInputType.number,
                    //   inputFormatters: [MoneyFormatterNoCents()],
                    //   validator: (value) {
                    //     if (value == null || value.trim().isEmpty) {
                    //       return 'Required';
                    //     }

                    //     // Extract raw integer
                    //     final raw = value.replaceAll(RegExp(r'[^0-9]'), '');
                    //     final amount = raw.isEmpty ? 0 : int.parse(raw);

                    //     if (amount <= 0) {
                    //       return 'Invalid amount';
                    //     }

                    //     if (amount > 99999) {
                    //       return 'Max is 99,999';
                    //     }

                    //     return null;
                    //   },
                    // ),
                    Row(
                      children: [
                        // Amount (largest)
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Amount to Claim',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: outamountController,
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
                                controller: outfeeController,
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
                                controller: outdiscountController,
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
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SummaryScreen(
                                    date: outdateController.text,
                                    dateAdded: outDateAddedController.text,
                                    name: outreceiverNameController.text,
                                    number: outnumberController.text,
                                    amount: outamountController.text,
                                    type: 'CASH OUT',
                                    fee: outfeeController.text,
                                    dscnt: outdiscountController.text,
                                  ),
                                ),
                              );
                            }
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
