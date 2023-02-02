## 2.2.1

 - **FIX**: Discontinue the use of _query in the ManagedController.

## 2.2.0

 - **FEAT**: Upgrade to dart 2.19.0.

## 2.1.4

 - **FIX**: Upgrade conduit to 4.1.8.

## 2.1.3

 - **FIX**: Set the sdks of all packages to >=2.12.0.

## 2.1.2

 - Update a dependency to the latest release.

## 2.1.1

 - **FIX**: Change the repo value in pubspec.
 - **DOCS**: Add discord badge on all packages.

## 2.1.0

 - **FEAT**: Add butter_cli package.

## 2.0.1

 - **FIX**: Add core pubspec files.

## 2.0.0

> Note: This release has breaking changes.

 - **BREAKING** **CHANGE**: Configure packages for publishing.

## 1.6.2

* Downgrade logs in BaseModule to verbose level

## 1.6.1

* Configure logging to handle messages properly regardless of type

## 1.6.0

* Update async_redux and logger
* Setup fvm and set flutter to 3.0.1

## 1.5.0

* Update the async_redux package dependency

## 1.4.0

* Allow BaseStatefulPage.build to signal a loading op

## 1.3.1

* Expose async_redux objects
* Add asynchronous effect on BaseStatefulPageViews

## 1.3.0

* Refine BaseStatefulPageView lifecycle

## 1.2.0

* Breaking changes! Complying to async_redux v13.0.0-dev updates
* Added dispatchAction() as an alternative to dispatch!()
* Remove dispatchFutureModel(). Use dispatchModel() instead, which now returs a future.

## 1.1.0

* Discontinue returning FutureOr for reduce()

## 1.0.0

* Migrate to null safety
* Upgrade dependencies

## 0.6.1

* Fix infinite recursion in getChild if route is root
* Add dispatchFutureModel
* Allow single character paths
* Add the AppPersistor

## 0.6.0

* Fix the state access error produced in BasePageState
* Update async_redux
  
## 0.5.1

* Remove unused import
  
## 0.5.0

* Improve routing of submodules
* Handled submodules via routeName configuration
* Adapt a logger
* Update the submodules example to comply with framework updates

## 0.4.0

* Added type checking when retrieving data from the store
* Defined the types of BaseRoutes.routes and BaseRoutes.defaultModule properly
* Handled navigator routing for submodules
* Added BuildContext to BaseStatefulPageView.beforeLoad() and beforeUpdate()
* Fetched route objects based on either the context or the specified routeName
* Added BaseNavigation.getRouteName()
  
## 0.3.1

* Added repository to pubspec
  
## 0.3.0

* Provided full documentation on the API and README
* Defined type of BaseStatefulPageView.specs
* Updated the definitions of beforeLoad() and beforeUpdate() of BaseStatefulPageView

## 0.2.5

* Updated the butter logo
* Added pub.dev and travis badges

## 0.2.4

* Restored deleted BaseAction default constructor

## 0.2.3

* Removed BaseDispatcher.dispatchAttribs()
* Fixed the reduce() definition of BaseAction
* Added docs to BaseAction and BasePageState

## 0.2.2 

* Fixed various health issues and suggestions reported by pub.dev

## 0.2.1 

* Allowed models to overwrite data in the store
* write(), dispatchModel() and mutate() now have an overwrite parameter 

## 0.2.0]

* Split BasePageView into BaseStatefulPageView and BaseStatelessPageView
* Provided BaseStatefulPageView to support smart page loads and updates
* Provided baseline implementation for nested modules capability
* Allowed mother pages to retrieve elements from child pages

## 0.1.0 

* Incremented minor version due to breaking changes

## 0.0.3 

* Discontinued the use of store attributes
* Introduced model keys
* Properly define generic types

## 0.0.2 

* Made defaultTransition as optional in BaseRoutes

## 0.0.1 

* Initial release
