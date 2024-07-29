
# The indie_flow App

The indie flow test app by Itai Shitrit

## About the project
This project is a Flutter application designed to fetch and display character data from the Rick and Morty API.

### libraries
**Providers**: Change notifiers are used for state management.


## Major features
**filter**: Characters can be filter the characters based on their status (alive, dead, unknown), and/or  by gender.
**Character details**: Users can view detailed information about a character by tapping on a character card.
**Cache Data**: Data is saved to local storage for use without network after first success fetching the data.

## How to run the project
- Clone the repository
- Run `flutter pub get` to install dependencies
- Run `flutter run` to start the app

## Known issues and assumptions:
- It is assumed that there is no localization in the app. The app is only available in English.
- The app doesn't support no-internet scenarios, other than an error that displayed when data could not be fetched. It must have at lease one time internet connection to save the data.
