# Coindesk-API

Pods are included, you can simply download the project, open the `*.xcworkspace` file and run it.

### Design pattern
I chose the MVVM design pattern as I find it clear, good separation of concers without being too complicated and easy to maintain.

### External libraries
#### Alamofire
I use Alamofire for the network request in my `Service` class. It is a small part of the code but I like to have it clear and Alamofire is a nice library for this kind of code.

#### SwiftyJSON
This library is not essential but it helps make the code a bit cleaner when parsing the data received from the Coindesk API.

### Accessibility
All texts in the app are dynamic. It allows automatic update of the font size when device's content size category changes.

## The app

### User interface
The 1st screen displays the currente rate in € as well as the history. If you click on the current rate or on any cell, you have the rate in USD, GBP and EUR.

The red and green color in the table view indicates if the rate went up or went down compared to the previous day (I need to pull one extra day of data that I won't display in order to display the correct color for the last cell).

### Network requests
I know from the API documentation that today's BPI is updated every minute and that the history has only one value per day. As I store the data on the device, if the user presses the refresh button it will only make a network request if the current stored data is expired (and if there is an available internet connection).

### Offline mode
I chose to download the three currencies (USD, GBP and EUR) together when I'm fetching the EUR Bitcoin Price Index history for two reasons:

One is that it prevents making 3 requests for a specific date and currency each time I select a cell. Network requests are power consuming, especially if you need to bring the hardware up everytime to do so. We can see in the Energy report that the overhead is bringing the avera energy impact to High when there is a network request.

The second is that it allows the user to utilise the app offline and keeping the code simple. The `Last update` message is displayed in red if it is actually not up-to-date, but the user can still open each day of the history to see the details in 3 currencies.

### Utils & extensions
There is quite a few utils and extensions in the project. It helps make the code more readable, maintainable and safer.

### Tests
XCode 10 does not run classic XCTest UI tests on simulator with the new build system, which is why I'm using the legacy build system.
