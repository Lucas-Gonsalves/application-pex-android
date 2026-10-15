void main() {
  List<int> numeros = [3, 1, 7, 10, 5, 4];

  int maior = numeros[0];

  for (int numero in numeros) {
    if (numero > maior) {
      maior = numero;
    }
  }

  print("O maior número é: $maior");
}