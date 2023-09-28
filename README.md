## Running the Application

### Prerequisites

Before you can run the application, ensure that you have the following software installed on your system:

- [Dart SDK](https://dart.dev/get-dart)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Steps

1. **Clone the Repository:**

    ```sh
    git clone git@github.com:matheuslmpereira/new_app.git
    cd your_project_name
    ```

2. **Get the Dependencies:**

    ```sh
    flutter pub get
    ```

3. **Run the Application:**

    ```sh
    flutter run
    ```

    This command will start the development server and open the application in the default web browser.

## Testing the Application

### Unit and Widget Tests

Run the unit and widget tests with the following command:

```sh
flutter test
```

This command will execute all the tests in the `test` directory and report the results in the terminal.

### Code Coverage

To generate a code coverage report, you can use the following commands:

```sh
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open `coverage/html/index.html
```

<img width="1088" alt="Captura de Tela 2023-09-28 às 07 46 55" src="https://github.com/matheuslmpereira/new_app/assets/11295011/abc9623d-b0db-4920-8ba6-cc3d7a8e0958">

