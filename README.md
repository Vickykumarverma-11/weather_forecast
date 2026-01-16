# Weather Forecast

A simple weather app I built to practice clean architecture in Flutter. Nothing fancy, just a straightforward implementation that fetches forecast data and displays it nicely.

## What it does

- Pick a city from the dropdown (London, Delhi, or New York for now)
- See hourly weather forecast for the next 3 days
- That's pretty much it

## Screenshots

*TODO: Add screenshots*

## Tech Stack

- **Flutter** - because that's what I'm learning
- **BLoC** - went with bloc over cubit since events make debugging easier
- **Dio** - solid http client, better than the default one
- **Equatable** - makes state comparison way less painful
- **WeatherAPI** - free tier works fine for this

## Project Structure

I tried to follow clean architecture without going overboard. Here's how I organized it:

```
lib/
├── core/           → constants, shared stuff
├── data/           → api calls, models, repository impl
├── domain/         → entities, abstract repo, usecases
├── presentation/   → bloc, ui
└── main.dart
```

 

## Why I made certain choices

**BLoC over Cubit** - I know cubit is simpler but I wanted explicit events. Makes it easier to trace what triggered a state change when something breaks.

**No GetIt or injectable** - For a small app like this, manual DI in main.dart is fine. Adding a service locator felt like overkill.

**No Either/Result types** - Just used try/catch with an error state. Functional error handling is cool but adds complexity I didn't need here.

**Shimmer loading** - Looks way better than a boring spinner. Small detail but makes the app feel more polished.

**Lazy loading the list** - The API returns like 72 hours of data at once. Loading all of them felt sluggish so I paginate on the UI side.

## Getting Started

1. Clone this repo

2. Get a free API key from [weatherapi.com](https://www.weatherapi.com/)

3. Open `lib/core/constants/api_constants.dart` and paste your key:
   ```dart
   static const String apiKey = 'your_key_here';
   ```

4. Run it:
   ```bash
   flutter pub get
   flutter run
   ```

## Running Tests

```bash
flutter test
```

There's just basic widget tests for now. I should probably add bloc tests at some point.

 

## Dependencies

```yaml
flutter_bloc: ^9.0.0
equatable: ^2.0.7
dio: ^5.8.0
intl: ^0.20.2
shimmer: ^3.0.0
```

 
 
