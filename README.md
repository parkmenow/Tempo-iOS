# Tempo

Tempo is the iOS frontend for ride share [project](https://github.com/tempo-nksn/Tempo-Backend) with the same name 

## Installation

1. Clone the repo to any desired destination.
2. Change the bundle identifier to any unique value in the General tab of main project folder
3. Sign in to your Apple account to create a provisioning account and let check Automatically manage signing and close the project in xCode
4. Navigate to the project directory in the terminal and install required pods

```bash
pod install
```
5. Set required Global constants and variables

## Usage

To set Global context and variables create an empty swift file with any name and place the following code setting variables as needed

```swift
enum globalData {
    static let google_map_key : String = "Your Private key goes here"
    static var authToken = ""
    static var loginURL = "https://tempo-prod.herokuapp.com/login"
    static var registerURL = "https://tempo-prod.herokuapp.com/signup"
    static var dashboardURL = "https://tempo-prod.herokuapp.com/api/v1/dashboard/"
    static var paymentURL = "https://tempo-prod.herokuapp.com/api/v1/dashboard/payment"
    static var testURL = "https://tempo-prod.herokuapp.com/api/v1/"
    static var user = UserDashboard()
}
```
6. Open project with `Tempo.xcworkspace` and Clean build the project
7. Connect an iPhone and run the project with target set as that iPhone

## Contributing
1. Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

2. Unit and UI tests are not yet updated

3. Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
