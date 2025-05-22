import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

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
    CurrencyData(code: 'TRY', name: 'Türk Lirası', rate: 1.0),
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
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Para Birimi Seç',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _currencies.length,
                  separatorBuilder: (context, index) => Divider(
                    color: isDark ? const Color(0xFF404040) : Colors.grey[200],
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      title: Text(
                        _currencies[index].code,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        _currencies[index].name,
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
          body: Column(
            children: [
              Container(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                child: TabBar(
                  controller: _tabController,
                  tabs: _tabs.map((name) => Tab(text: name)).toList(),
                  labelColor: isDark ? Colors.white : Colors.black,
                  indicatorColor: isDark 
                    ? const Color(0xFF6366F1) 
                    : const Color.fromRGBO(255, 193, 7, 1),
                  unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey,
                  indicatorWeight: 3,
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
                            // Para birimi seçim kartları
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectCurrency(true),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isDark 
                                          ? const Color(0xFF404040)
                                          : const Color(0xFFFFF8E1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark 
                                            ? const Color(0xFF525252)
                                            : const Color.fromRGBO(255, 193, 7, 0.3),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isDark 
                                              ? Colors.black.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _currencies[_fromCurrencyIndex].code,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark ? Colors.white : Colors.black,
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: isDark 
                                                  ? const Color(0xFF6366F1)
                                                  : const Color.fromRGBO(255, 193, 7, 1),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _currencies[_fromCurrencyIndex].name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark 
                                        ? const Color(0xFF6366F1)
                                        : const Color.fromRGBO(255, 193, 7, 1), 
                                      width: 2
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDark 
                                          ? Colors.black.withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.swap_horiz,
                                      color: isDark 
                                        ? const Color(0xFF6366F1)
                                        : const Color.fromRGBO(255, 193, 7, 1),
                                    ),
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
                                        color: isDark 
                                          ? const Color(0xFF404040)
                                          : const Color(0xFFFFF8E1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isDark 
                                            ? const Color(0xFF525252)
                                            : const Color.fromRGBO(255, 193, 7, 0.3),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isDark 
                                              ? Colors.black.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                color: isDark 
                                                  ? const Color(0xFF6366F1)
                                                  : const Color.fromRGBO(255, 193, 7, 1),
                                              ),
                                              Text(
                                                _showingTRY ? 'TRY' : _currencies[_toCurrencyIndex].code,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark ? Colors.white : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _showingTRY ? 'Türk Lirası' : _currencies[_toCurrencyIndex].name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Döviz kuru gösterimi
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark 
                                  ? const Color(0xFF6366F1).withOpacity(0.1)
                                  : const Color(0xFF3B82F6).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark 
                                    ? const Color(0xFF6366F1).withOpacity(0.3)
                                    : const Color(0xFF3B82F6).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: isDark 
                                      ? const Color(0xFF60A5FA)
                                      : const Color(0xFF3B82F6),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '1 ${_currencies[_fromCurrencyIndex].code} = ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isDark 
                                        ? const Color(0xFF60A5FA)
                                        : const Color(0xFF3B82F6),
                                    ),
                                  ),
                                  Text(
                                    _showingTRY
                                        ? '${_currencies[_fromCurrencyIndex].rate.toStringAsFixed(4)} TRY'
                                        : '${(_currencies[_fromCurrencyIndex].rate / _currencies[_toCurrencyIndex].rate).toStringAsFixed(4)} ${_currencies[_toCurrencyIndex].code}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark 
                                        ? const Color(0xFF60A5FA)
                                        : const Color(0xFF3B82F6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Miktar girişi ve sonuç
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 160,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                                      border: Border.all(
                                        color: isDark 
                                          ? const Color(0xFF404040)
                                          : Colors.grey[300]!,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark 
                                            ? Colors.black.withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: isDark 
                                            ? const Color(0xFF6366F1)
                                            : Colors.grey[600],
                                          size: 24,
                                        ),
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller: _amountController,
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            hintText: '0.00',
                                            hintStyle: TextStyle(
                                              color: isDark ? Colors.grey[500] : Colors.grey[400],
                                            ),
                                          ),
                                          onChanged: (value) {
                                            _calculateResult();
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _currencies[_fromCurrencyIndex].code,
                                          style: TextStyle(
                                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    height: 160,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                                      border: Border.all(
                                        color: isDark 
                                          ? const Color(0xFF6366F1).withOpacity(0.5)
                                          : const Color.fromRGBO(255, 193, 7, 0.5),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark 
                                            ? const Color(0xFF6366F1).withOpacity(0.1)
                                            : const Color.fromRGBO(255, 193, 7, 0.1),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calculate,
                                          color: isDark 
                                            ? const Color(0xFF6366F1)
                                            : const Color.fromRGBO(255, 193, 7, 1),
                                          size: 24,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _result.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _showingTRY ? 'TRY' : _currencies[_toCurrencyIndex].code,
                                          style: TextStyle(
                                            color: isDark 
                                              ? const Color(0xFF6366F1)
                                              : const Color.fromRGBO(255, 193, 7, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
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
      },
    );
  }
}