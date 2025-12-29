import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcash_logging_android/services/amt_formatter.dart';
import 'package:gcash_logging_android/services/number_formatter.dart';
import 'package:gcash_logging_android/services/ref_formatter.dart';

class CashOutScreen extends StatefulWidget {
  const CashOutScreen({super.key});

  @override
  State<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController outdateController = TextEditingController();
  final TextEditingController outreceiverNameController =
      TextEditingController();
  final TextEditingController outnumberController = TextEditingController();
  final TextEditingController outamountController = TextEditingController();

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
                      'Date',
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
                    const Text(
                      'Amount to Cash-out',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: outamountController,
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
                            // handle submit here
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
