import 'dart:io';

import 'list_data.dart';

var rConColumn = [];
var round;
Data data = Data();

void main() {
  round = 03;
  var currentRoundHexKey = [
    ['47', '40', 'A3', '4C'],
    ['37', 'D4', '70', '9F'],
    ['94', 'E4', '3A', '42'],
    ['ED', 'A5', 'AE', 'BC'],
  ];

  int keyRowCount = currentRoundHexKey.length; //total row
  int keyColumnCount = currentRoundHexKey[0].length; //total column

  var sBoxProcessingColumn = []; //currently working column
  var afterSBoxProcessingColumn = []; //previous working column
  var nxtRoundHexKey = []; //nextRound key or final result

  int n = keyColumnCount - 1;

  for (int i = 0; i < keyRowCount;) {
    i++;
    if (i == keyColumnCount) {
      i = 0;
      sBoxProcessingColumn.add(currentRoundHexKey[i][n]);
      break;
    }
    sBoxProcessingColumn.add(currentRoundHexKey[i][n]);
  }

  for (int i = 0; i < sBoxProcessingColumn.length; i++) {
    String firstChar = sBoxProcessingColumn[i].substring(0, 1);
    String secondChar = sBoxProcessingColumn[i].substring(1);

    int row = int.parse(firstChar, radix: 16);
    int colmn = int.parse(secondChar, radix: 16);

    String value = data.s_Box[row][colmn];
    afterSBoxProcessingColumn.add(value);
  }

  rConTableValue(round);
  String? result;

  for (int i = 0; i < keyRowCount; i++) {
    nxtRoundHexKey.add([]);
  }

  for (int i = 0; i < keyColumnCount; i++) {
    if (i == 0) {
      for (int j = 0; j < keyRowCount; j++) {
        String result1 =
            xorHex(afterSBoxProcessingColumn[j], currentRoundHexKey[j][i]);
        result = xorHex(result1, rConColumn[j]);
        nxtRoundHexKey[i].add(result);
      }
    } else {
      for (int j = 0; j < keyRowCount; j++) {
        result = xorHex(nxtRoundHexKey[i - 1][j], currentRoundHexKey[j][i]);
        nxtRoundHexKey[i].add(result);
      }
    }
  }
  //Next Round Key Output
  print('Round ${round + 1} AES Key : ');
  for (int i = 0; i < keyRowCount; i++) {
    for (int j = 0; j < keyColumnCount; j++) {
      stdout.write('${nxtRoundHexKey[j][i]}  ');
    }
    print('');
  }
}

void rConTableValue(int round) {
  rConColumn.add(data.rCon_table[round]);
  rConColumn.add('00');
  rConColumn.add('00');
  rConColumn.add('00');
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
