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

2. **Set up the config.json information:**
On new_app/assets/config.json
    ```sh
    {
      "mockup": false,
      "baseUrl": "https://api.unsplash.com",
      "clientId": <unplash_client_id>
    }
    ```

The mockup option allow the application to run with local json mockup response. This file was created to free test of functionalities without burn api limited calls.

4. **Run the Application:**

    ```sh
    flutter run
    ```

    This command will start the development server and open the application in the default web browser.

## Testing the Application

### Unit and Widget Tests

Run the unit and widget tests with the following commands:

```sh
dart run build_runner build
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
<img width="1087" alt="image" src="https://github.com/matheuslmpereira/new_app/assets/11295011/3c06149e-f2e7-470a-a2a0-7a5142742e1b">

