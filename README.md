# VirtualTourist
Virtual Tourist is an application that allows the user to drop pins in the map by long tapping in any place in the map. Then, the user can click on the pins to explore random images fetched from FlickerAPI using the pin coordinates.

Deployment Target: iOS 12.1,    iPhone XR (For best experience)

The application launches with a map view the display the map of the whole world.. 

•   The user can drop pins wherever he wants by long pressing in anyplace.. This pin will be stored in the mobile local memory so if the user closed then re-opened the app the previously added pins will be loaded into the map

•   If the user clicks on a pin.. A new screen will appear that contains a close up look on the pin location along with a set of photos taken by people from that location retreived from Flicker API that will be stored in the mobile local memory, so whenever the user clicks on that pin again it will display the same photo set.

•   If the user clicks on any photo from the collection, that photo will be removed from both the list and the local memory.

•   If the user clicks on "New Collection" button.. All photos will be deleted from mobile local memory and a new set will be downloaded.

•   If the user clicks on "Back" button, the first screen of the map view will be displayed again.

•   If the user clicks "Clear Pins" button.. All the pins will be removed from both the map and the mobile local memory.


# KingFisher library

Requirements:
iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
Swift 4.0+

I used on this project KingFisher Swift Library that helped me in manipulating photos.. I managed to do that by using Cocoapods, the way on how to install or update this library is as follows:

•   Run the terminal and type                                                sudo gem install cocoapods

•   After the installation finishes type                                    sudo setup --verbose

•   After that navigate to your project directory and type     pod init

•   Then open the Podfile on the line after use_frameworks!     type    pod 'Kingfisher', '~> 5.0'

•   After saving the file, go back to the terminal and type    pod install

•   After it finishes make sure to use .xcworkspace project and whenever you want to use the library in the code, make sure to import the library first "import Kingfisher"







