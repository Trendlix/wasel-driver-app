import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasel_driver/apps/core/utils/services/pdf_service.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';

class BookingContractScreen extends StatefulWidget {
  final TripEntity trip;
  const BookingContractScreen({super.key, required this.trip});

  @override
  State<BookingContractScreen> createState() => _BookingContractScreenState();
}

class _BookingContractScreenState extends State<BookingContractScreen> {
  bool _isDownloading = false;

  Future<void> _handleDownload() async {
    setState(() => _isDownloading = true);
    try {
      await PdfService.generateBookingReceipt(widget.trip);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating receipt: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.description_outlined,
            color: Color(0xFF1565C0),
            size: 22,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Contract',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Booking #${widget.trip.tripNumber}',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black54),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    _ContractHeader(date: widget.trip.date),

                    // Body
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionTitle('CUSTOMER DETAILS'),
                          const SizedBox(height: 10),
                          _InfoRow(
                            label: 'Name:',
                            value: widget.trip.user.name ?? 'N/A',
                          ),
                          const SizedBox(height: 6),
                          _InfoRow(
                            label: 'Phone:',
                            value: widget.trip.user.phone ?? 'N/A',
                          ),

                          const SizedBox(height: 20),
                          const _SectionTitle('TRIP DETAILS'),
                          const SizedBox(height: 10),
                          _LocationRow(
                            icon: Icons.location_on,
                            iconColor: const Color(0xFF1565C0),
                            label: 'Pickup Location:',
                            value: widget.trip.pickup,
                          ),
                          const SizedBox(height: 10),
                          _LocationRow(
                            icon: Icons.warehouse_outlined,
                            iconColor: const Color(0xFF1565C0),
                            label: 'Storage Location:',
                            value: widget.trip.dropOff.isNotEmpty
                                ? widget.trip.dropOff.last
                                : 'N/A',
                          ),

                          const SizedBox(height: 20),
                          _DurationSection(date: widget.trip.date),

                          const SizedBox(height: 20),
                          _ItemDetailsSection(
                            typeOfGoods: widget.trip.typeOfGoods,
                            weight:
                                widget.trip.totalWeight ?? widget.trip.weight,
                          ),

                          const SizedBox(height: 20),
                          const _TermsSection(),

                          const SizedBox(height: 24),
                          _SignatureSection(
                            customerName: widget.trip.user.name ?? 'Customer',
                          ),

                          const SizedBox(height: 16),
                          _ElectronicNotice(tripNumber: widget.trip.tripNumber),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isDownloading ? null : _handleDownload,
                icon: _isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.download_outlined, size: 20),
                label: Text(
                  _isDownloading ? 'Downloading...' : 'Download Receipt',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widgets ───────────────────────────────────────────────────────────────────

class _ContractHeader extends StatelessWidget {
  final DateTime? date;
  const _ContractHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = date != null
        ? DateFormat('d MMMM y').format(date!)
        : 'N/A';

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1565C0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          const Text(
            'WASEL CONTRACT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Electronic Storage Agreement',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            'Date: $formattedDate',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DurationSection extends StatelessWidget {
  final DateTime? date;
  const _DurationSection({required this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = date != null
        ? DateFormat('dd/MM/yy').format(date!)
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Color(0xFF1565C0),
              ),
              SizedBox(width: 6),
              Text(
                'Storage Duration',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('—', style: TextStyle(color: Colors.grey)),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'To',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ongoing',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemDetailsSection extends StatelessWidget {
  final String typeOfGoods;
  final dynamic weight;

  const _ItemDetailsSection({required this.typeOfGoods, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 16,
                color: Color(0xFF1565C0),
              ),
              SizedBox(width: 6),
              Text(
                'Item Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ItemRow(label: 'Type of Goods:', value: typeOfGoods),
          const SizedBox(height: 6),
          _ItemRow(label: 'Total Weight:', value: '$weight KG'),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String label;
  final String value;
  const _ItemRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection();

  static const List<String> _terms = [
    'Both parties confirm the accuracy of item details listed in this contract.',
    'OTP verification required at pickup and delivery to storage facility.',
    'Any discrepancies in item count must be reported immediately.',
    'Storage duration can be extended by submitting a request within the application.',
    'This contract is valid for the duration specified above.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('TERMS & CONDITIONS'),
        const SizedBox(height: 10),
        ...List.generate(_terms.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}. ',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    _terms[i],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _SignatureSection extends StatelessWidget {
  final String customerName;
  const _SignatureSection({required this.customerName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CUSTOMER SIGNATURE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    customerName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'STORAGE OWNER SIGNATURE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'WASEL Logistics',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
}

class _ElectronicNotice extends StatelessWidget {
  final String tripNumber;
  const _ElectronicNotice({required this.tripNumber});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('d MMMM y').format(now);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'This is an electronically generated document. No physical signature required. Contract ID: $tripNumber. Generated on $formattedDate.',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF1565C0),
          height: 1.5,
        ),
      ),
    );
  }
}
