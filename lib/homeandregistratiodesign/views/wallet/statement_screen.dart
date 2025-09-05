import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/util/statement_generator.dart';
// import 'package:ansvel/utils/statement_generator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatementScreen extends StatefulWidget {
  final String customerId;

  const StatementScreen({super.key, required this.customerId});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<dynamic> _transactions = [];
  bool _isLoading = false;
  final WalletApiService _walletApiService = WalletApiService();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _fetchStatement() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a start and end date.')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final transactions = await _walletApiService.getAccountStatement(
        customerId: widget.customerId,
        startDate: _startDate!,
        endDate: _endDate!,
      );
      setState(() {
        _transactions = transactions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch statement: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _downloadStatement(String format, bool isSigned) async {
    final generator = StatementGenerator(transactions: _transactions);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generating $format...')),
    );
    try {
      if (format == 'PDF') {
        await generator.generatePdf(isSigned: isSigned);
      } else {
        await generator.generateCsv();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$format has been saved to your downloads.')),
      );
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate file: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Statement", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDateSelectors(),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_transactions.isEmpty)
              const Expanded(child: Center(child: Text("Select a date range and fetch your statement.")))
            else
              _buildStatementTable(),
            const SizedBox(height: 20),
            _buildDownloadButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _selectDate(context, true),
            icon: const Icon(Icons.calendar_today),
            label: Text(_startDate == null ? 'Start Date' : DateFormat('dd/MM/yyyy').format(_startDate!)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _selectDate(context, false),
            icon: const Icon(Icons.calendar_today),
            label: Text(_endDate == null ? 'End Date' : DateFormat('dd/MM/yyyy').format(_endDate!)),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.deepPurple),
          onPressed: _fetchStatement,
        ),
      ],
    );
  }

  Widget _buildStatementTable() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 10,
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Balance')),
            ],
            rows: _transactions.map((tx) {
              final isCredit = tx['type'] == 'CREDIT';
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('dd/MM/yy').format(DateTime.parse(tx['createdAt'])))),
                  DataCell(SizedBox(width: 150, child: Text(tx['description'], overflow: TextOverflow.ellipsis))),
                  DataCell(Text(tx['type'], style: TextStyle(color: isCredit ? Colors.green : Colors.red))),
                  DataCell(Text('₦${tx['amount']}', style: TextStyle(color: isCredit ? Colors.green : Colors.red))),
                  DataCell(Text('₦${tx['balance_after']}')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         ElevatedButton.icon(
          onPressed: _transactions.isEmpty ? null : () => _downloadStatement('PDF', false),
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Download PDF"),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _transactions.isEmpty ? null : () => _downloadStatement('CSV', false),
          icon: const Icon(Icons.table_chart),
          label: const Text("Download CSV"),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _transactions.isEmpty ? null : () => _downloadStatement('PDF', true),
          icon: const Icon(Icons.verified),
          label: const Text("Download Signed PDF"),
        ),
      ],
    );
  }
}