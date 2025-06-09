# ArtGallery 2025

A SwiftUI + SwiftData gallery app, built with a clean architecture approach using Combine, Tuist, and Mockolo.

---

## 🧰 Requirements

| Tool            | Version / Info                        |
| --------------- | ------------------------------------- |
| macOS           | **Sequoia 15.0+**        |
| Xcode           | **16.0+**                              |
| Swift           | **6.0.0** (for Tuist)                           |
| Ruby (optional) | 3.1.0+ (for future Fastlane integration) |

> 💡 This project assumes you're running the latest macOS + Xcode release as of WWDC 2024.

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/liauli/ArtGallery.git
cd ArtGallery
```

---

## 🔧 Project Setup

### 2. Install Tuist

Tuist helps manage and generate the Xcode project.

```bash
brew tap tuist/tuist
brew install --formula tuist
```

After installation:

```bash
tuist generate
```

This generates the `.xcodeproj` or `.xcworkspace` file.

---

### 3. Install Mockolo (for generating mocks)

```bash
brew install mockolo
```

To manually run Mockolo:

```bash
mockolo \
  -s ./ArtGallery/Sources \
  -d ./ArtGallery/Tests/OutputMocks.swift \
  -x Images Strings \
  --testable-imports ArtGallery
```

* `-s`: Source directory for `@mockable` protocols
* `-d`: Output file for generated mocks
* `-x`: Excludes `Images`, `Strings`, etc.
* `--testable-imports`: Adds `@testable import ArtGallery` to generated mocks

✅ Re-run this anytime you add or update `@mockable` protocols.

---

### 4. Install Fastlane (Optional, for CI & automation)

Fastlane is used for automated testing and release workflows.

```bash
sudo gem install fastlane
```

To run test with fastlane (optional):

```bash
cd ArtGallery
fastlane run_test
```

---

## ✅ Build & Run

Open the project with Xcode:

```bash
open ArtGallery.xcworkspace
```

---

## 🧪 Running Tests

You can run unit tests via:

* **Xcode:** Product → Test (`⌘U`)
* **CLI:** `fastlane run_test` (see above)

Generated mocks are used in unit tests for ViewModels and UseCases.

---

## 📦 Directory Overview

```
ArtGallery/
├── Resources/           # Assets
├── Sources/           # Application source code
├── Tests/             # Unit tests (uses Mockolo-generated mocks)
├── Tuist/             # Tuist setup files
└── Project.swift      # Tuist configuration
```

---

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first.

---

## ✨ Credits

Developed by [@liauli](https://github.com/liauli) with ❤️ 

