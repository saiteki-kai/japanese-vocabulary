# Japanese vocabulary

<!-- ## Badges -->
[![pipeline](https://gitlab.com/saiteki-kai/japanese-vocabulary/badges/ci/pipeline.svg)](https://gitlab.com/saiteki-kai/japanese-vocabulary/-/pipelines)
[![coverage](https://gitlab.com/saiteki-kai/japanese-vocabulary/badges/ci/coverage.svg)]()
<!--[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Latest Release](https://gitlab.com/saiteki-kai/japanese-vocabulary/-/badges/release.svg)](https://gitlab.com/saiteki-kai/japanese-vocabulary/-/releases)-->

Mobile app for learning Japanese vocabulary through a spaced repetition method. The user can review the vocabularies and evaluate himself.

## Group

- Magazzù Gaetano, 829685
- Magazzù Giuseppe, 829612
- Malanchini Mirco, 829889
- Marino Mario, 829707
- Pietrasanta Davide, 844824

## Architecture

![Architecture](./images/High-level%20Architecture.png)

### Data Layer

This layer interacts with the database and other data sources. The data is accessed directly via a repository.

The **repository pattern** decouples the data layer from the business logic layer by hiding access to the data. Since we have only one data source, we don't use DAOs but only repository implementations to avoid excessive abstraction.

### Business Logic Layer

This layer is the core of the application and processes the business logic.

The [**BloC pattern**](https://bloclibrary.dev/#/) decouples the business layer from the presentation layer, allowing changes to the UI to be made without impacting business logic and simplifying business logic testing.

[![bloc pattern](images/bloc_architecture_full.png)](https://bloclibrary.dev/#/coreconcepts)

The Bloc receives events via user input and sends a request to the data layer. Then the response is processed and the result is returned by changing the state and rerender the user interface.

### Presentation Layer

This layer displays the interface and gets information from the user. The user interface is presented using Flutter widgets.

## Folder Structure

```text
lib
├── bloc                        # Business logic (BloC pattern)
├── config                      # Routes, themes, ...
├── data                        # Data folder
│   ├─ models                   # Models
│   ├─ repositories             # Repository implementations
│   └─ app_database.dart        # Database instance
├── ui                          # UI folder
│   ├─ screens                  # Screens
│   │  ├─ home                  # Home screen folder 
│   │  │  ├─ widgets            # Widgets used only in the home screen
│   │  │  └─ home_screen.dart   # Home screen widget
│   │  ├─ settings              
│   │  └─ ...
│   └─ widgets                  # Common widgets shared between screens  
├── utils                       # Utility functions  
└── main.dart
```

## Installation

Install packages

```bash
flutter pub get
```

Code generation

```bash
flutter pub run build_runner build
```

## Tests

Install the library objectbox (see https://github.com/objectbox/objectbox-dart/issues/280)

```bash
bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh)
```

Unit/Widget test

```bash
flutter test
```

Integration tests

```bash
flutter test integration_test/
```

<!--
Generate the documentation

```bash
dart pub global activate dartdoc
export PATH="$PATH":"$HOME/.pub-cache/bin"

dartdoc
```
-->

<!-- ##  Usage -->

<!-- Link to the docs -->

<!-- ## License -->
