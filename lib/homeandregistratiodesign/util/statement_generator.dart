import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';

class StatementGenerator {
  final List<dynamic> transactions;

  StatementGenerator({required this.transactions});

  Future<void> generatePdf({required bool isSigned}) async {
    final pdf = pw.Document();
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/ansvel_logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _buildHeader(logoImage),
          _buildTable(),
        ],
        footer: (context) => _buildFooter(context, isSigned, logoImage),
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/Ansvel-Statement-${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(path);
  }

  Future<void> generateCsv() async {
    List<List<dynamic>> rows = [];
    rows.add([
      "Transaction Date",
      "Description",
      "Type",
      "Status",
      "Amount",
      "Balance After"
    ]);

    for (var tx in transactions) {
      rows.add([
        DateFormat('dd/MM/yyyy').format(DateTime.parse(tx['createdAt'])),
        tx['description'],
        tx['type'],
        tx['status'],
        tx['amount'],
        tx['balance_after'],
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/Ansvel-Statement-${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csv);
    OpenFile.open(path);
  }
  
  pw.Widget _buildHeader(pw.MemoryImage logo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Image(logo, height: 50),
        pw.Text('Account Statement', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
  
  pw.Widget _buildTable() {
     final headers = [
      'Date', 'Description', 'Type', 'Amount', 'Balance'
     ];
     
     return pw.Table.fromTextArray(
        headers: headers,
        data: transactions.map((tx) => [
             DateFormat('dd/MM/yy').format(DateTime.parse(tx['createdAt'])),
             tx['description'],
             tx['type'],
             '₦${tx['amount']}',
             '₦${tx['balance_after']}',
        ]).toList(),
     );
  }

  pw.Widget _buildFooter(pw.Context context, bool isSigned, pw.MemoryImage logo) {
    if (!isSigned) {
      return pw.Container();
    }
    
    return pw.Stack(
      children: [
        pw.Align(
          alignment: pw.Alignment.bottomRight,
          child: pw.Opacity(
            opacity: 0.1,
            child: pw.Image(logo, height: 100),
          ),
        ),
        pw.Align(
           alignment: pw.Alignment.bottomRight,
           child: pw.Padding(
             padding: const pw.EdgeInsets.only(right: 15, bottom: 25),
             child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                 pw.Text("Ansvel Nigeria Limited", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.grey)),
                 pw.Text(DateFormat('dd/MM/yyyy').format(DateTime.now()), style: const pw.TextStyle(color: PdfColors.grey)),
                 pw.Text("Approved Statement", style: const pw.TextStyle(color: PdfColors.grey)),
              ]
             ),
           )
        )
      ]
    );
  }
}