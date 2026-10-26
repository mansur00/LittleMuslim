import 'package:little_muslim/widgets/ds/parental_gate_dialog.dart';

/// Test-only token helper residing strictly under test/.
/// This helper cannot be imported or called from lib/ production code.
AdminElevationToken mintTestAdminToken({DateTime? createdAt, Duration? lifespan}) {
  return ParentalGate.mintForTesting(createdAt: createdAt, lifespan: lifespan);
}
