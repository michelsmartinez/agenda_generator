import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'calendar_generator.dart';

class PdfGenerator {
  static Future<Uint8List> generateAgendaPdf({
    required int year,
    required int month,
    required String footerMessage,
  }) async {
    final pdf = pw.Document();

    final monthName = CalendarGenerator.getMonthName(month);
    final daysInMonth = CalendarGenerator.getDaysInMonth(year, month);

    // Add a cover page for the month
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Agenda - $monthName $year',
              style: pw.TextStyle(fontSize: 48, fontWeight: pw.FontWeight.bold),
            ),
          );
        },
      ),
    );

    // Add pages for each day
    for (var i = 0; i < daysInMonth.length; i += 2) { // Two days per page
      final day1 = daysInMonth[i];
      final day2 = (i + 1 < daysInMonth.length) ? daysInMonth[i + 1] : null;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildDaySection(day1, footerMessage),
                if (day2 != null) pw.SizedBox(height: 20), // Spacer between days
                if (day2 != null) _buildDaySection(day2, footerMessage),
                pw.Spacer(),
                pw.Align(
                  alignment: pw.Alignment.bottomCenter,
                  child: pw.Text(
                    'Página ${context.pageNumber}',
                    style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  static pw.Widget _buildDaySection(DateTime day, String footerMessage) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          DateFormat('dd/MM/yyyy (EEEE)').format(day),
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          height: 100, // Space for notes
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          footerMessage,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        ),
      ],
    );
  }
}
