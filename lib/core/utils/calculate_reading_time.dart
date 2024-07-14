int calculateReadingTime(String content) {
  final RegExp wordCountRegExp = RegExp(r'\s+');
  const int averageReadingTime = 225;
  final int contentWordCount = content.split(wordCountRegExp).length;

  final int readingTime = (contentWordCount / averageReadingTime).ceil();

  return readingTime;
}
