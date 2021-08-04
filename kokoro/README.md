# kokoro

To update routes and locator put the information in the `app.dart` file. Then run:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
This will generate the code needed to access these routes.


To run with HTML web render run:
```
flutter run -d chrome --web-renderer html
```


## How to Deploy Kokoro with Firebase Hosting

1. Change `Kokoro/kokoro/lib/app/app.locator.dart` file so that `final locator = StackedLocator.instance;` is `final locator = GetIt.instance;` note this requires the GetIt package. This should not be required and happens because of a bug in the StackedLocator.
2. From the `Kokoro/kokoro` directory run `flutter build web --web-renderer html` this will build the Flutter code into optimized HTML and Javascript. Once this process completes the `index.html` can be found at `Kokoro/kokoro/build/web`. 
3. Make sure the Firebase CLI is setup instructions for how to install it can be found [here](https://firebase.google.com/docs/cli).
4. If this is the first time using Firebase Hosting you need to run `firebase init hosting`. It will ask for the public directory, this is `Kokoro/kokoro/build/web`.
5. Once the init is completed, simply type `firebase deploy --only hosting` to deploy to Firebase hosting. Once the deployment is complete, the URL will be provided to the website. 

**Deploying Channels**
Sometimes you want to be able to deploy a site, but do not want to alter the main site. For example, providing a specific site for testers or IRB review. Firebase hosting makes this possible by altering the deploy command slightly. In step 5 above replace the existing command with the following command`firebase hosting:channel:deploy [CHANNEL NAME] --expires 7d`, where `[CHANNEL NAME]` is whatever you want to call the channel. The `--expires` flag is optional, but useful to not have something deployed that isn't in use.

For more information on Firebase Hosting check their quickstart guide [here](https://firebase.google.com/docs/hosting/quickstart). 


## How to have a loading screen for data
To make a simple loading screen you can use the `setBusy` method in the view model. For example, before loading data from the web call ` setBusy(true);`, once the data is loaded call ` setBusy(false);`. In the view add a switch statement that shows a loading icon if `model.isBusy` is true.

For more information look at the stacked documentation [here](https://github.com/FilledStacks/stacked/tree/master/packages/stacked) under the section "BaseViewModel functionality."

## Recent connections and recent intrests data
Both are stored in the user document and are arrays. For recent connections the array is of the user uids' of the recent connections. The reason for this is if all the needed information was stored it would take a lot of room in the users document, and also the recent connection's information might change. Similarly, the recent intrests array stores the uid of the planet the user interacted with. 
