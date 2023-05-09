import 'package:intl/intl.dart';
import 'package:test/test.dart' as test;


List<String> generateNames(List<String> input) {
  final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  // Map to store the photo groups by city
  final cityGroups = <String, List<DateTime>>{};

  // Parse the input and group the photos by city
  for (final photoData in input) {
    final parts = photoData.split(', ');
    final city = parts[1];
    final photoTime = dateFormat.parse(parts[2]);

    if (!cityGroups.containsKey(city)) {
      cityGroups[city] = [];
    }

    cityGroups[city]!.add(photoTime);
  }

  // Sort the photos in each city group by date/time taken
  for (final city in cityGroups.keys) {
    cityGroups[city]!.sort();
  }

  // Map to store the generated names of the photos
  final generatedNames = <String, String>{};

  // Generate names for each photo based on its chronological order in the city group
  for (final photoData in input) {
    final parts = photoData.split(', ');
    final city = parts[1];
    final extension = parts[0].split('.').last;
    final photoTime = dateFormat.parse(parts[2]);

    final sequenceNumber = cityGroups[city]!.indexOf(photoTime) + 1;
    final maxSequenceNumber = cityGroups[city]!.length;
    final numDigits = maxSequenceNumber.toString().length;
    final sequenceString = sequenceNumber.toString().padLeft(numDigits, '0');

    final newName = '$city$sequenceString.$extension';

    generatedNames[photoData] = newName;
  }

  // Return the generated names of the photos as a newline-delimited string in the same order as input
  return input.map((photoData) => generatedNames[photoData]!).toList();
}

void main() {
  final input = [
    'DSC012333.jpg, Madrid, 2016-10-01 13:02:34',
    'DSC044322.jpg, Milan, 2015-03-05 10:11:22',
    'DSC130033.raw, Rio, 2018-06-02 17:01:30',
    'DSC044322.jpeg, Milan, 2015-03-04 14:55:01',
    'DSC130033.jpg, Rio, 2018-06-02 17:05:10',
    'DSC012335.jpg, Milan, 2015-03-05 10:11:24',
  ];

  final output = generateNames(input);
  print(output.join(
      '\n'));
}

