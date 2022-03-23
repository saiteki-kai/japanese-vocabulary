# Japanese vocabulary

Mobile app for learning Japanese vocabulary through a spaced repetition method. The user can review the vocabularies and evaluate himself.

<!-- ## Badges -->
<!--
[![pipeline](https://gitlab.com/saiteki-kai/japanese-vocabulary/badges/main/pipeline.svg)]()
[![coverage](https://gitlab.com/saiteki-kai/japanese-vocabulary/badges/main/coverage.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Latest Release](https://gitlab.com/saiteki-kai/japanese-vocabulary/-/badges/release.svg)](https://gitlab.com/saiteki-kai/japanese-vocabulary/-/releases)
-->

## Group

- Magazzù Gaetano, 829685
- Magazzù Giuseppe, 829612
- Malanchini Mirco, 829889
- Marino Mario, 829707
- Pietrasanta Davide, 844824

## Architecture

![Architecture](./images/High-level%20Architecture.png)

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

<!-- ## Installation -->

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
