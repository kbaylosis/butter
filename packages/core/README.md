<img src="https://github.com/kbaylosis/butter/blob/master/logo.png?raw=true" width="400">

[![pub package](https://img.shields.io/pub/v/butter)](https://pub.dartlang.org/packages/butter) [![Build Status](https://travis-ci.com/kbaylosis/butter.svg?branch=master)](https://travis-ci.com/github/kbaylosis/butter)

A thin application framework for [flutter](https://flutter.dev/) making use of [async_redux](https://pub.dev/packages/async_redux/).

Butter allows you to structure your app into modules and submodules where each 
module is composed of pages, states, models and actions as already introduced by 
[redux](https://redux.js.org/).

It is best to be used together with its commandline companion called [butter_cli](https://pub.dev/packages/butter_cli) for easy scaffolding.

## Using

```
import 'package:butter/butter.dart';
```

Check out the [API Reference](https://pub.dev/documentation/butter/latest/butter/butter-library.html) for a more detailed information on usage.

Most common classes used to structure the app are as follows:
- [BaseAction](https://pub.dev/documentation/butter/latest/butter/BaseAction-class.html)
- [BaseModule](https://pub.dev/documentation/butter/latest/butter/BaseModule-class.html)
- [BasePageState](https://pub.dev/documentation/butter/latest/butter/BasePageState-class.html)
- [BaseStatefulPageView](https://pub.dev/documentation/butter/latest/butter/BaseStatefulPageView-class.html)
- [BaseStatelessPageView](https://pub.dev/documentation/butter/latest/butter/BaseStatelessPageView-class.html)

## Concepts

## Data Flow

<img src="https://github.com/kbaylosis/butter/blob/master/misc/butter_flow.png?raw=true" width="500">

#### Typical Flow
1. An event occurs on the Page that triggers an action
2. An Action is dispatched
3. Redux causes the associated Reducer of the Action to get called
4. The Reducer mutates the associated UI Model in the Store
5. Redux calls the State to check if the UI Model data has actually changed
6. If there is a significant change, redux triggers the Page to re-render with
   the updated UI Model data

#### On Initialization
1. Process starts with the State reading the UI Model data from the Store
2. UI Model data is passed to the Page for initial rendering

## Routing

<img src="https://github.com/kbaylosis/butter/blob/master/misc/butter_routing.png?raw=true" width="800">

The App object will contain a list of top level Modules. A typical Module contains
a list of routes of State and Page pairs but it can also contain a list of sub-Modules.
Sub-Modules can in turn nest further routes of State and Page pairs and sub-Modules
depending on how complex an app structure you want to design.

## Project Structure

```
lib
 |
 +-- app
 |    |
 |    +-- app.dart
 |    +-- routes.dart
 |    +-- theme.dart
 |
 +-- config
 |    |
 |    +-- app_config.dart
 |    +-- ..._config.dart
 | 
 +-- data
 |    |
 |    +-- ..._model.dart
 |
 +-- modules
 |    |
 |    +-- <module-name>
 |    |    |
 |    |    +-- actions
 |    |    |    |
 |    |    |    +-- ..._action.dart
 |    |    |    +-- ...
 |    |    |
 |    |    +-- components
 |    |    |    |
 |    |    |    +-- ...dart
 |    |    |    +-- ...
 |    |    |
 |    |    +-- models
 |    |    |    |    
 |    |    |    +-- ..._model.dart
 |    |    |    +-- ...
 |    |    |
 |    |    +-- pages
 |    |    |    |
 |    |    |    +-- ..._page.dart
 |    |    |    +-- ...
 |    |    |
 |    |    +-- states
 |    |    |    |
 |    |    |    +-- ..._state.dart
 |    |    |    +-- ...
 |    |    |
 |    |    +-- <module-name>.dart
 |    |
 |    +-- <module-name>
 |
 +-- services
 |    |
 |    +-- ..._service.dart
 |
 +-- utils
 |    |
 |    +-- sub_module_page_specs.dart
 |
 +-- main.dart
```

### Directories
[app](https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/app) - App specific codes

[config](https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/config) - App configurations separated depending on purpose, such as, security, API urls, etc.
  
[data](https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/data) - Data models to be used for things like API transactions

[modules](https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/modules) - All app modules

[services](https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/services) - All services pertaining to the device api encapsulations or 3rd party api middlewares

[utils](https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/utils) - Utility codes from shared components across modules and utility libraries that doesn't qualify elsewhere

### First Class Files
[main.dart](
https://github.com/kbaylosis/butter/blob/master/example/submodules/lib/main.dart) 
   - App boostrap code

[app/app.dart](
https://github.com/kbaylosis/butter/blob/master/example/submodules/lib/app/app.dart) 
   - The main app declaration
   - Where the navigation settings are loaded

[app/routes.dart](
https://github.com/kbaylosis/butter/blob/master/example/submodules/lib/app/routes.dart)
   - List of all top level modules
   - The first defined module in the list automatically gets assigned with the root route ('/')
   - See [BaseRoutes](https://pub.dev/documentation/butter/latest/butter/BaseRoutes-class.html) class

[app/theme.dart](
https://github.com/kbaylosis/butter/blob/master/example/submodules/lib/app/theme.dart)
   - App theming and branding definitions

[config/app_config.dart](
https://github.com/kbaylosis/butter/blob/master/example/submodules/lib/config/app_config.dart)
   - General app configurations and initial settings

### Module Organization 

[actions](
https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/modules/function_a/actions)
   - All actions
   - See [BaseAction](https://pub.dev/documentation/butter/latest/butter/BaseAction-class.html) class

[components](
https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/modules/function_a/components)
   - Components that can be shared across all pages within the module

[models](
https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/modules/function_a/models)
   - Page UI models
   - See [BaseUIModel](https://pub.dev/documentation/butter/latest/butter/BaseUIModel-class.html) class

[pages](
https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/modules/function_a/pages)
   - Page views
   - See [BaseStatefulPageView](https://pub.dev/documentation/butter/latest/butter/BaseStatefulPageView-class.html) and [BaseStatelessPageView](https://pub.dev/documentation/butter/latest/butter/BaseStatelessPageView-class.html) classes

[states](
https://github.com/kbaylosis/butter/tree/master/example/submodules/lib/modules/function_a/states)
   - Page states
   - See [BasePageState](https://pub.dev/documentation/butter/latest/butter/BasePageState-class.html) class

[<module-name.dart>](
https://github.com/kbaylosis/butter/blob/master/example/submodules/lib/modules/home/home.dart)
   - Root file of the module
   - Sub routing and child modules are defined here
   - See [BaseModule](https://pub.dev/documentation/butter/latest/butter/BaseModule-class.html) class

### Optional Files

[utils/sub_module_page_specs.dart](
https://github.com/kbaylosis/butter/blob/master/example/submodules/lib/utils/sub_module_page_specs.dart)
   - Page specs definition for sub-module data passing
   - See [BasePageSpecs](https://pub.dev/documentation/butter/latest/butter/BasePageSpecs-class.html) class

## Examples

[Todo](https://github.com/kbaylosis/butter/tree/master/example/todo)
   - demonstrates the basics of creating a single module with multiple screens
   - also shows how stateful components are constructed within a page

[Submodules](https://github.com/kbaylosis/butter/tree/master/example/submodules)
   - shows how an app with multiple modules looks like
   - demonstrates how submodules are constructed
   - provides the differences between a page inheriting from a [BaseStatefulPageView](https://pub.dev/documentation/butter/latest/butter/BaseStatefulPageView-class.html) and a [BaseStatelessPageView](https://pub.dev/documentation/butter/latest/butter/BaseStatelessPageView-class.html)

## References:
* [butter_cli](https://pub.dev/packages/butter_cli)
* [async_redux](https://pub.dev/packages/async_redux/)
* [redux](https://redux.js.org/)
