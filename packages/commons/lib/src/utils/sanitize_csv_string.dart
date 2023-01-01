String sanitizeCSVString(Object? value) =>
    (value ?? '').toString().replaceAll(',', ';').replaceAll('\n', ' ');
