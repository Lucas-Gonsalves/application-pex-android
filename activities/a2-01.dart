import 'dart:io';

void main() {
  print("Digite seu nome:");
  String nome = stdin.readLineSync()!;

  print("Digite seu sobrenome:");
  String sobrenome = stdin.readLineSync()!;

  print("Digite seu endereço:");
  String endereco = stdin.readLineSync()!;

  print("Digite seu telefone:");
  String telefone = stdin.readLineSync()!;

  print("Digite seu e-mail:");
  String email = stdin.readLineSync()!;

  print("Digite seu CPF:");
  String cpf = stdin.readLineSync()!;

  print("Digite seu RG:");
  String rg = stdin.readLineSync()!;

  print("-----------MEUS DADOS-----------");
  print("Nome: $nome");
  print("Sobrenome: $sobrenome");
  print("Endereço: $endereco");
  print("Telefone: $telefone");
  print("E-mail: $email");
  print("CPF: $cpf");
  print("RG: $rg");
  print("-------------------------------");
}
