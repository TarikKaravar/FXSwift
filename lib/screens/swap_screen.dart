import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyData {
  final String code;
  final String name;
  final double rate;

  CurrencyData({required this.code, required this.name, required this.rate});
}

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController(text: '1');

  final List<String> _tabs = ['DÖVİZ ÇEVİRİCİ'];

  final List<CurrencyData> _currencies = [
    CurrencyData(code: 'USD', name: 'Amerikan Doları', rate: 38.76),
    CurrencyData(code: 'EUR', name: 'Avrupa Eurosu', rate: 41.25),
    CurrencyData(code: 'GBP', name: 'İngiliz Sterlini', rate: 49.35),
    CurrencyData(code: 'JPY', name: 'Japon Yeni', rate: 0.25),
    CurrencyData(code: 'CHF', name: 'İsviçre Frangı', rate: 43.80),
    CurrencyData(code: 'CAD', name: 'Kanada Doları', rate: 28.50),
    CurrencyData(code: 'AUD', name: 'Avustralya Doları', rate: 25.40),
  ];

  int _fromCurrencyIndex = 0;
  int _toCurrencyIndex = 0;

  bool _showingTRY = true;
  double _result = 38.76;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _calculateResult();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    setState(() {
      if (_showingTRY) {
        _showingTRY = false;
        _toCurrencyIndex = _fromCurrencyIndex;
        _fromCurrencyIndex = _currencies.length - 1;
      } else {
        final temp = _fromCurrencyIndex;
        _fromCurrencyIndex = _toCurrencyIndex;
        _toCurrencyIndex = temp;
      }
      _calculateResult();
    });
  }

  void _calculateResult() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _result = 0;
      });
      return;
    }

    final double amount = double.tryParse(_amountController.text) ?? 0;

    if (_showingTRY) {
      setState(() {
        _result = amount * _currencies[_fromCurrencyIndex].rate;
      });
    } else {
      final double fromRate = _currencies[_fromCurrencyIndex].rate;
      final double toRate = _currencies[_toCurrencyIndex].rate;
      setState(() {
        _result = (amount * fromRate) / toRate;
      });
    }
  }

  void _selectCurrency(bool isFrom) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.separated(
          itemCount: _currencies.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_currencies[index].code),
              subtitle: Text(_currencies[index].name),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    _fromCurrencyIndex = index;
                  } else {
                    _toCurrencyIndex = index;
                    _showingTRY = false;
                  }
                  _calculateResult();
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: _tabs.map((name) => Tab(text: name)).toList(),
              labelColor: const Color.fromARGB(255, 0, 0, 0),
              indicatorColor: Colors.indigo[900],
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectCurrency(true),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _currencies[_fromCurrencyIndex].code,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      ),
                                      Text(
                                        _currencies[_fromCurrencyIndex].name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Color.fromRGBO(255, 193, 7, 1), width: 2),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.swap_horiz, color: Color.fromRGBO(255, 193, 7, 1)),
                                onPressed: _swapCurrencies,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showingTRY
                                    ? setState(() {
                                        _showingTRY = false;
                                        _toCurrencyIndex = (_fromCurrencyIndex + 1) % _currencies.length;
                                        _calculateResult();
                                      })
                                    : _selectCurrency(false),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _showingTRY ? 'TRY' : _currencies[_toCurrencyIndex].code,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                      ),
                                      Text(
                                        _showingTRY ? 'Türk Lirası' : _currencies[_toCurrencyIndex].name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showingTRY
                              ? '${_currencies[_fromCurrencyIndex].rate}'
                              : '${(_currencies[_fromCurrencyIndex].rate / _currencies[_toCurrencyIndex].rate).toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 140,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.edit, color: Colors.grey),
                                    TextField(
                                      controller: _amountController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      onChanged: (value) {
                                        _calculateResult();
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                      ],
                                    ),
                                    Text(
                                      _currencies[_fromCurrencyIndex].code,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 140,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _result.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _showingTRY ? 'TRY' : _currencies[_toCurrencyIndex].code,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}