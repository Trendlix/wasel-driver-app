import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';

class PdfService {
  // ── Colors (matching UI) ──────────────────────────────────────────────────
  static const _blue = PdfColor.fromInt(0xFF1565C0);
  static const _green = PdfColor.fromInt(0xFF22C55E);
  static const _greenDark = PdfColor.fromInt(0xFF15803D);
  static const _greenBg = PdfColor.fromInt(0xFFDCFCE7); // ~8% green
  static const _red = PdfColor.fromInt(0xFFEF4444);
  static const _orange = PdfColor.fromInt(0xFFF97316);
  static const _grey = PdfColor.fromInt(0xFF6B7280);
  static const _greyLight = PdfColor.fromInt(0xFFF8F9FC);
  static const _border = PdfColor.fromInt(0xFFE5E7EB);
  static const _textDark = PdfColor.fromInt(0xFF1F2937);
  static const _blueBg = PdfColor.fromInt(0xFFE3F2FD);
  static const _blueText = PdfColor.fromInt(0xFF1565C0);

  static Future<void> generateBookingReceipt(TripEntity trip) async {
    final pdf = pw.Document();

    final formattedDate = trip.date != null
        ? DateFormat('d MMMM y').format(trip.date!)
        : 'N/A';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // ── 1. Header ──────────────────────────────────────────────────
          _buildHeader(trip.tripNumber, formattedDate),
          pw.SizedBox(height: 20),

          // ── 2. Earning Summary ─────────────────────────────────────────
          _buildEarningSummary(trip),
          pw.SizedBox(height: 20),

          // ── 3. Customer Details ────────────────────────────────────────
          _sectionTitle('CUSTOMER DETAILS'),
          pw.SizedBox(height: 6),
          _infoRow('Customer Name:', trip.user.name ?? 'N/A'),
          _infoRow('Contact Phone:', trip.user.phone ?? 'N/A'),
          pw.SizedBox(height: 20),

          // ── 4. Trip Route ──────────────────────────────────────────────
          _sectionTitle('TRIP ROUTE'),
          pw.SizedBox(height: 6),
          _buildRouteSection(trip),
          pw.SizedBox(height: 20),

          // ── 5. Trip Summary (Distance + Time) ──────────────────────────
          _sectionTitle('TRIP SUMMARY'),
          pw.SizedBox(height: 6),
          _buildTripSummary(trip),
          pw.SizedBox(height: 20),

          // ── 6. Item Details ────────────────────────────────────────────
          _buildItemDetails(trip),
          pw.SizedBox(height: 20),

          // ── 7. Special Notes (if any) ──────────────────────────────────
          if (trip.specialNotes != null && trip.specialNotes!.isNotEmpty) ...[
            _sectionTitle('SPECIAL INSTRUCTIONS'),
            pw.SizedBox(height: 6),
            _buildSpecialNotes(trip.specialNotes!),
            pw.SizedBox(height: 20),
          ],

          // ── 8. Terms & Conditions ──────────────────────────────────────
          _buildTerms(),
          pw.SizedBox(height: 20),

          // ── 9. Signature ───────────────────────────────────────────────
          _buildSignature(trip.user.name ?? 'Customer'),
          pw.SizedBox(height: 16),

          // ── 10. Electronic Notice ──────────────────────────────────────
          _buildElectronicNotice(trip.tripNumber),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Receipt_${trip.tripNumber}.pdf',
    );
  }

  // ── Section Builders ──────────────────────────────────────────────────────

  static pw.Widget _buildHeader(String tripNumber, String date) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const pw.BoxDecoration(
        color: _blue,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'WASEL CONTRACT',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: pw.BoxDecoration(
              color: PdfColors.white.shade(0.85),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
            ),
            child: pw.Text(
              'Trip ID: $tripNumber',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                '📅  $date',
                style: const pw.TextStyle(color: PdfColors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildEarningSummary(TripEntity trip) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _greenBg,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        border: pw.Border.all(color: _green, width: 0.5),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              color: _green,
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Text(
              '\$',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(width: 14),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Total Contract Value',
                style: pw.TextStyle(
                  color: _greenDark,
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                '${trip.currency} ${trip.price.toStringAsFixed(0)}',
                style: pw.TextStyle(
                  color: _greenDark,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildRouteSection(TripEntity trip) {
    final stops = <pw.Widget>[];

    // Pickup
    stops.add(_routePoint(label: 'PICKUP', value: trip.pickup, color: _green));

    // Drop-offs
    for (int i = 0; i < trip.dropOff.length; i++) {
      final isLast = i == trip.dropOff.length - 1;
      stops.add(_routeConnector());
      stops.add(
        _routePoint(
          label: isLast ? 'FINAL DESTINATION' : 'DROP-OFF ${i + 1}',
          value: trip.dropOff[i],
          color: isLast ? _red : _orange,
        ),
      );
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _greyLight,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: stops,
      ),
    );
  }

  static pw.Widget _routePoint({
    required String label,
    required String value,
    required PdfColor color,
  }) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 10,
          height: 10,
          margin: const pw.EdgeInsets.only(top: 2, right: 10),
          decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                label,
                style: pw.TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                value,
                style: pw.TextStyle(
                  color: _textDark,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _routeConnector() {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 4, top: 3, bottom: 3),
      child: pw.Container(width: 2, height: 14, color: _border),
    );
  }

  static pw.Widget _buildTripSummary(TripEntity trip) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _statBox(
            label: 'Distance',
            value: trip.distanceBetween != null
                ? '${trip.distanceBetween} km'
                : 'N/A',
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: _statBox(
            label: 'Est. Time',
            value: '${trip.estimatedTime} min',
          ),
        ),
      ],
    );
  }

  static pw.Widget _statBox({required String label, required String value}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: _textDark,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            label,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 10, color: _grey),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemDetails(TripEntity trip) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _greyLight,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Item Details',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
              color: _textDark,
            ),
          ),
          pw.SizedBox(height: 10),
          _infoRow('Type of Goods:', trip.typeOfGoods),
          _infoRow(
            'Total Weight:',
            '${trip.totalWeight ?? trip.weight ?? "N/A"} KG',
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSpecialNotes(String notes) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _greyLight,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: _border),
      ),
      child: pw.Text(
        notes,
        style: const pw.TextStyle(fontSize: 11, color: _textDark),
      ),
    );
  }

  static const List<String> _terms = [
    'Both parties confirm the accuracy of item details listed in this contract.',
    'OTP verification required at pickup and delivery to storage facility.',
    'Any discrepancies in item count must be reported immediately.',
    'Storage duration can be extended by submitting a request within the application.',
    'This contract is valid for the duration specified above.',
  ];

  static pw.Widget _buildTerms() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('TERMS & CONDITIONS'),
        pw.SizedBox(height: 6),
        ...List.generate(_terms.length, (i) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${i + 1}. ',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    _terms[i],
                    style: const pw.TextStyle(fontSize: 11, color: _grey),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  static pw.Widget _buildSignature(String customerName) {
    return pw.Column(
      children: [
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
                    style: const pw.TextStyle(fontSize: 8, color: _grey),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    customerName,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: _textDark,
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
                    style: const pw.TextStyle(fontSize: 8, color: _grey),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'WASEL Logistics',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildElectronicNotice(String tripNumber) {
    final now = DateFormat('d MMMM y').format(DateTime.now());
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        color: _blueBg,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Text(
        'This is an electronically generated document. No physical signature required. '
        'Contract ID: $tripNumber. Generated on $now.',
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(fontSize: 10, color: _blueText),
      ),
    );
  }

  // ── Shared Helpers ────────────────────────────────────────────────────────

  static pw.Widget _sectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
        color: _textDark,
        letterSpacing: 0.5,
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: _grey, fontSize: 11)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }
}
