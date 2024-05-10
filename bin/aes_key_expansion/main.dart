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

  int keyRowCount = currentRoundHexKey.length; //total row in current Round key
  int keyColumnCount =
      currentRoundHexKey[0].length; //total column in current Round key

  var sBoxProcessingColumn = []; //currently working column before Sbox
  var afterSBoxProcessingColumn = []; //after processing sbox column
  var nxtRoundHexKey = []; //next Round key or final result

  int n = keyColumnCount - 1;

//loop for finding column before processing sbox
  for (int i = 0; i < keyRowCount;) {
    i++;
    if (i == keyColumnCount) {
      i = 0;
      sBoxProcessingColumn.add(currentRoundHexKey[i][n]);
      break;
    }
    sBoxProcessingColumn.add(currentRoundHexKey[i][n]);
  }

//loop for finding column after processing sbox
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

//loop for xor operation
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

//function for complete rcon table
void rConTableValue(int round) {
  rConColumn.add(data.rCon_table[round]);
  rConColumn.add('00');
  rConColumn.add('00');
  rConColumn.add('00');
}

//function for Xor operation between two string
String xorHex(String hex1, String hex2) {
  int int1 = int.parse(hex1, radix: 16);
  int int2 = int.parse(hex2, radix: 16);

  int result = int1 ^ int2;

  String hexResult =
      result.toRadixString(16); // Convert result back to hexadecimal

  return hexResult.toUpperCase();
}
