import 'json_data.dart';

void main() {
  Data data = Data();

  var round = 3;
  var currentRoundHexKey = [
    ['47', '40', 'A3', '4C'],
    ['37', 'D4', '70', '9F'],
    ['94', 'E4', '3A', '42'],
    ['ED', 'A5', 'AE', 'BC'],
  ];

  int keyRowCount = currentRoundHexKey.length;
  int keyColumnCount = currentRoundHexKey[0].length;

  var newProcessingColumn = [];
  var previousProcessingColumn = [];

  var nxtRoundHexKey = [];
  int n = keyColumnCount - 1;

  for (int i = 0; i < keyRowCount;) {
    i++;
    if (i == keyColumnCount) {
      i = 0;
      newProcessingColumn.add(currentRoundHexKey[i][n]);
      break;
    }
    newProcessingColumn.add(currentRoundHexKey[i][n]);
  }

  previousProcessingColumn = newProcessingColumn;

  print(previousProcessingColumn);


  for(int i=0; i< previousProcessingColumn.length; i++){
    String firstChar = previousProcessingColumn[i].substring(0,1);
    String secondChar = previousProcessingColumn[i].substring(1);

    int row = int.parse(firstChar, radix: 16);
    int colmn = int.parse(secondChar, radix: 16);

    String value = data.s_Box[row][colmn];
    newProcessingColumn.add(value);
  }

  // String hex1 ='';
  // String hex2 ='';

  // String result = xorHex(hex1, hex2);
  // print('nextRoun: $result');
}

String xorHex(String hex1, String hex2) {
  // Convert hexadecimal strings to integers
  int int1 = int.parse(hex1, radix: 16);
  int int2 = int.parse(hex2, radix: 16);

  // Perform XOR operation
  int result = int1 ^ int2;

  // Convert result back to hexadecimal
  String hexResult = result.toRadixString(16);

  return hexResult.toUpperCase(); 
}
