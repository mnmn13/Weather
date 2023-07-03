# Weather

Welcome to Weather! This project is a replica of Apple's weather application, both in terms of design and functionality. It follows the MVVM-C (Model-View-ViewModel-Coordinator) architecture and utilizes URLSession for online API requests.

## Features

- User Authentication: The app allows users to authenticate and store their preferences in the cloud. This enables them to log in on different devices and access their tracked cities for temperature monitoring.
- City Search: Users can search for any city and add it to their tracked cities, regardless of their current location.
- CoreData: All data, including user settings and tracked cities, is stored using CoreData.
- Weather Forecast: The app provides a 3-day weather forecast, as this is the maximum limit provided by the free API.
- Map View: Users can view their tracked cities on a map with temperature markers.

## Installation

To run the Weather app locally, follow these steps:

1. Clone the repository: `git clone https://github.com/mnmn13/Weather.git`
2. Open the project in Xcode.
3. Build and run the app on the desired simulator or device.

## License

This project is licensed under the [MIT License](LICENSE).
