# Coindesk-API

### Design pattern
I chose the MVVM design pattern as I find it clear, well separated and easy to maintain.

### External libraries
#### Alamofire
I use Alamofire for the network request in my `Service` class. It is a small part of the code but I like to have it clear and Alamofire is a nice library for this kind of code.

#### SwiftyJSON
This library is not essential but it helps make the code a bit cleaner when parsing the data received from the Coindesk API.

### Accessibility
All texts in the app are dynamic. It allows automatic update of the font size when device's content size category changes.

### Offline mode
I chose to download the three currencies (USD, GBP and EUR) together when I'm fetching the EUR Bitcoin Price Index history for two reasons:

One is that it prevents making 3 requests for a specific date and currency each time I select a cell. Network requests are power consuming, especially if you need to bring the hardware up everytime to do so. We can see in the Energy report that the overhead is bringing the avera energy impact to High when there is a network request.

The second is that it allows the user to utilise the app offline and keeping the code simple. The `Last update` message is displayed in red if it is actually not up-to-date, but the user can still open each day of the history to see the details in 3 currencies.
