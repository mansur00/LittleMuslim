// Fixture: Step data file referencing a non-existent translation key
class StepDataFixture {
  const StepDataFixture({
    required this.stepNumber,
    required this.titleKey,
    required this.descriptionKey,
  });

  final int stepNumber;
  final String titleKey;
  final String descriptionKey;
}

const invalidStep = StepDataFixture(
  stepNumber: 99,
  titleKey: 'qaida.step.99.title',
  descriptionKey: 'qaida.step.99.desc',
);
