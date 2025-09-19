import 'dart:io';

void main() {
  // Step 1: Take name and age input
  stdout.write("Enter your name: ");
  String name = stdin.readLineSync()!; // for input

  stdout.write("Enter your age: ");
  int age = int.parse(stdin.readLineSync()!);

  if (age < 18) {
    print("Sorry $name, you are not eligible to register.");
    return; // stop execution
  }

  // Step 2: Take N numbers input
  stdout.write("How many numbers do you want to enter? ");
  int n = int.parse(stdin.readLineSync()!);

  List<int> numbers = [];

  for (int i = 0; i < n; i++) {
    stdout.write("Enter number ${i + 1}: ");
    int num = int.parse(stdin.readLineSync()!);
    numbers.add(num);
  }

  // Step 3: Calculations
  int sumEven = 0;
  int sumOdd = 0;
  int largest = numbers[0];
  int smallest = numbers[0];

  for (int num in numbers) {
    if (num % 2 == 0) {
      sumEven += num;
    } else {
      sumOdd += num;
    }

    if (num > largest) largest = num;
    if (num < smallest) smallest = num;
  }

  // Step 4: Print results
  print("\n--- Results ---");
  print("Numbers Entered: $numbers");
  print("Sum of Even Numbers: $sumEven");
  print("Sum of Odd Numbers: $sumOdd");
  print("Largest Number: $largest");
  print("Smallest Number: $smallest");
}
