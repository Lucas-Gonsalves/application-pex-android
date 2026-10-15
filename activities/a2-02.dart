import 'dart:io';

void main() {
  print("Forneça a primeira nota:");
  double nota1 = double.parse(stdin.readLineSync()!);

  print("Forneça a segunda nota:");
  double nota2 = double.parse(stdin.readLineSync()!);

  print("Forneça a terceira nota:");
  double nota3 = double.parse(stdin.readLineSync()!);

  double media = (nota1 + nota2 + nota3) / 3;

  print("\nMédia: $media");

  if (media >= 6.0) {
    print("Aprovado!");
  } else {
    print("Reprovado!");
  }
}