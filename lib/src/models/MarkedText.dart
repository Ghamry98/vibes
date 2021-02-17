/// Identifies the type of the text.
enum TextMark { text, url, tag }

class MarkedText {
  // Attributes
  String _text;
  TextMark _type;

  // Constructor
  MarkedText(
    this._text,
    this._type,
  );

  // Methods
  String get text => _text;
  TextMark get type => _type;
}
