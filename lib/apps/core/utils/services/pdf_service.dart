import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';

class PdfService {
  static Future<void> generateBookingReceipt(TripEntity trip) async {
    final pdf = pw.Document();

    final date = trip.date != null
        ? DateFormat('d MMMM y').format(trip.date!)
        : 'N/A';
    final tripDate = trip.date != null
        ? DateFormat('dd/MM/yy').format(trip.date!)
        : 'N/A';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.blue700,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text(
                        'WASEL CONTRACT',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Electronic Storage Agreement',
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Booking #${trip.tripNumber}',
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),

                // Date
                pw.Text('Date: $date', style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 20),

                // Customer Details
                _sectionTitle('CUSTOMER DETAILS'),
                _infoRow('Name:', trip.user.name ?? 'N/A'),
                _infoRow('Phone:', trip.user.phone ?? 'N/A'),
                pw.SizedBox(height: 20),

                // Trip Details
                _sectionTitle('TRIP DETAILS'),
                _infoRow('Pickup Location:', trip.pickup),
                _infoRow(
                  'Storage Location:',
                  trip.dropOff.isNotEmpty ? trip.dropOff.last : 'N/A',
                ),
                pw.SizedBox(height: 20),

                // Storage Duration
                _sectionTitle('STORAGE DURATION'),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'From',
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          tripDate,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.Text('—'),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'To',
                          style: pw.TextStyle(
                            color: PdfColors.grey700,
                            fontSize: 10,
                          ),
                        ),
                        pw.Text(
                          'Ongoing',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Item Details
                _sectionTitle('ITEM DETAILS'),
                _infoRow('Type of Goods:', trip.typeOfGoods),
                _infoRow(
                  'Total Weight:',
                  '${trip.totalWeight ?? trip.weight ?? "N/A"} KG',
                ),
                pw.SizedBox(height: 30),

                // Terms
                _sectionTitle('TERMS & CONDITIONS'),
                pw.Bullet(
                  text:
                      'Both parties confirm the accuracy of item details listed in this contract.',
                ),
                pw.Bullet(
                  text:
                      'OTP verification required at pickup and delivery to storage facility.',
                ),
                pw.Bullet(
                  text:
                      'Any discrepancies in item count must be reported immediately.',
                ),
                pw.Bullet(
                  text:
                      'Storage duration can be extended by submitting a request within the application.',
                ),
                pw.Bullet(
                  text:
                      'This contract is valid for the duration specified above.',
                ),
                pw.SizedBox(height: 30),

                // Signature Section
                pw.Divider(thickness: 0.5),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'CUSTOMER SIGNATURE',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            trip.user.name ?? 'Customer',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'STORAGE OWNER SIGNATURE',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'WASEL Logistics',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Electronic Notice
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Text(
                    'This is an electronically generated document. No physical signature required. Contract ID: ${trip.tripNumber}. Generated on ${DateFormat('d MMMM y').format(DateTime.now())}.',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Save or Share the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Receipt_${trip.tripNumber}.pdf',
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 11),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
