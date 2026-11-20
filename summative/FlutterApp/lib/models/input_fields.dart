// the nine inputs the model needs: seven numbers and two categories

class NumField {
  final String key, label, hint;
  final bool whole;
  const NumField(this.key, this.label, this.hint, {this.whole = false});
}

const numFields = [
  NumField('gdp_per_capita', 'GDP per capita (US\$)', 'e.g. 900'),
  NumField('population', 'Population', 'e.g. 14000000', whole: true),
  NumField('land_area', 'Land area (sq km)', 'e.g. 24670'),
  NumField('urban_pct', 'Urban population (%)', 'e.g. 18'),
  NumField('internet_pct', 'Internet users (%)', 'e.g. 30'),
  NumField('tourism_receipts_pct', 'Tourism receipts (% of exports)', 'e.g. 20'),
  NumField('year', 'Year', 'e.g. 2023', whole: true),
];

const regions = [
  'East Asia & Pacific',
  'Europe & Central Asia',
  'Latin America & Caribbean',
  'Middle East, North Africa, Afghanistan & Pakistan',
  'North America',
  'South Asia',
  'Sub-Saharan Africa',
];

const incomeGroups = ['Low income', 'Lower middle income', 'Upper middle income', 'High income'];

final byKey = {for (final f in numFields) f.key: f};

final fieldLabels = {
  for (final f in numFields) f.key: f.label,
  'region': 'Region',
  'income_group': 'Income group',
};
