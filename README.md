# FxTracker - Currency Exchange Rates Tracking App

[![FxTracker Presentation](https://user-images.githubusercontent.com/77902674/235178721-4ba4e70a-3db5-4d99-a023-11a39b431c11.png)](https://github.com/Guimmam/fxtracker)

FxTracker is a Flutter-based application that allows you to check the current currency exchange rates based on data provided by the National Bank of Poland (NBP). With this application, you can track currency rates and stay updated with their changes.

## Key Features

- **Support for all NBP currencies**: The FxTracker app enables you to check the exchange rates for all currencies available in the National Bank of Poland's A table. With integration with the NBP API, you can be confident that you are receiving the latest data.

- **Offline Availability**: In case of no internet connection, the app displays an appropriate message, and the data is automatically fetched once the connection is restored.

- **Favorite Currencies**: In the details of a specific currency, you can add or remove it from your favorites. This allows for quick access to important currency rates without the need to search for them every time.

- **Historical Currency Charts**: FxTracker allows you to view historical currency charts. Users can select a time range (30, 60, and 90 days, 6 and 12 months) and see how a particular currency has performed in pair to Polish złoty.

- **Theme Switching**: FxTracker enables users to choose their preferred theme. You can customize the app's appearance by selecting a light, dark, or automatic theme that follows the system theme.

- **Configurable Chart Settings**: In the FxTracker app settings, users can customize the chart appearance. The option to round the chart enables displaying rounded values on the axes. Additionally, users can choose whether to enable vibration (HapticFeedback) upon interacting with the chart, adding interactivity and feedback while using the app.

## Technologies and Libraries

- Flutter
- Flutter_bloc
- hydrated_bloc
- http
- fl_chart
- internet_connection_checker
- flutter_native_splash

## Running the Project

To run the FxTracker project on your computer, follow these steps:

1. Clone the project repository:

```
git clone https://github.com/Guimmam/fxtracker.git
```

2. Navigate to the project directory:

```
cd fxtracker
```

3. Install the dependencies using a package manager (e.g., Flutter):

```
flutter pub get
```

4. Run the application on an emulator or physical device:

```
flutter run
```

## Contributions

I welcome contributions to the FxTracker project. If you would like to improve something or add a new feature, please submit a pull request.

## Disclaimer

FxTracker is an open-source project, and I am not responsible for the accuracy of the currency data provided by the National Bank of Poland (NBP). The application serves as a visualization tool and does not guarantee the accuracy or timeliness of the data.

Flags made by [Freepik](https://www.flaticon.com/packs/countrys-flags) from [www.flaticon.com](https://www.flaticon.com/).
