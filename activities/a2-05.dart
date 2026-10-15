void main() {
  Map<String, int> frutas = {};

  frutas["Pera"] = 5;
  print("Adicionando Pera: $frutas");

  frutas["Morango"] = 10;
  print("Adicionando Morango: $frutas");

  frutas["Abacaxi"] = 3;
  print("Adicionando Abacaxi: $frutas");

  frutas.remove("Morango");
  print("Removendo Morango: $frutas");

  frutas.remove("Pera");
  print("Removendo Pera: $frutas");
}