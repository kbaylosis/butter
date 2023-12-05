# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2023-12-05

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`butter_api_commons` - `v2.4.1`](#butter_api_commons---v241)
 - [`butter_toolkit` - `v2.4.1`](#butter_toolkit---v241)

---

#### `butter_api_commons` - `v2.4.1`

 - **FIX**(api_commons): Prevent the creation of a transaction if there is no body.

#### `butter_toolkit` - `v2.4.1`

 - **DOCS**: Update the ui toolkit README.md.


## 2023-08-01

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`butter` - `v2.4.0`](#butter---v240)
 - [`butter_api_commons` - `v2.4.0`](#butter_api_commons---v240)
 - [`butter_cli` - `v2.4.0`](#butter_cli---v240)
 - [`butter_commons` - `v2.4.0`](#butter_commons---v240)
 - [`butter_toolkit` - `v2.4.0`](#butter_toolkit---v240)
 - [`sample_api` - `v2.4.0`](#sample_api---v240)
 - [`sample_flutter` - `v2.4.0`](#sample_flutter---v240)
 - [`submodules` - `v2.3.1`](#submodules---v231)
 - [`todo` - `v2.3.1`](#todo---v231)

---

#### `butter` - `v2.4.0`

 - **FIX**(dep): Update intl to 0.18.0.
 - **FIX**: Prevent a null check crash in BaseModule.
 - **FIX**: Upgrade to conduit v4.3.9.
 - **FIX**(api_commons): Discontinue the use of _query in the ManagedController.
 - **FIX**: Upgrade conduit to 4.1.8.
 - **FIX**: Set the sdks of all packages to >=2.12.0.
 - **FIX**(core): Change the repo value in pubspec.
 - **FIX**: Add core pubspec files.
 - **FEAT**: Upgrade to dart 2.19.0.
 - **FEAT**: Add butter_cli package.
 - **DOCS**: Add discord badge on all packages.

#### `butter_api_commons` - `v2.4.0`

 - **FIX**: Upgrade to conduit v4.3.9.
 - **FIX**: Set the module and service attributes back to iterables.
 - **FIX**: Discontinue clearing the services and module lists.
 - **FIX**: Export the printStacktrace util.
 - **FIX**: Print a stacktrace everytime the ReqestNotAllowedException is used.
 - **FIX**(api_commons): Discontinue the use of _query in the ManagedController.
 - **FIX**: Ensure that the module and service registries are released after init.
 - **FIX**: Upgrade conduit to 4.1.8.
 - **FIX**: Set the sdks of all packages to >=2.12.0.
 - **FIX**(core): Modify definition of BasicController.addPredicate and addPredicates; Remove addCustomPredicate.
 - **FIX**: Apply new linting rules; Change didFindObject and didFindObjects definitions.
 - **FIX**(api_commons): Update conduit lib version to 4.0.0.
 - **FIX**: Update documentation of the api_commons and commons packages.
 - **FEAT**: Upgrade to dart 2.19.0.
 - **FEAT**(api_commons): Improve implementations of BasicController, CustomPredicate, ReducerQuery and Auditable.
 - **DOCS**: Add discord badge on all packages.

#### `butter_cli` - `v2.4.0`

 - **FIX**(dep): Update intl to 0.18.0.
 - **FIX**: Upgrade to conduit v4.3.9.
 - **FIX**(api_commons): Discontinue the use of _query in the ManagedController.
 - **FIX**(cli): Fix pubspec.yaml error.
 - **FIX**(cli): Change copyPaths to copyPathSyncs.
 - **FIX**(cli): Provide fallback value when printing butter_cli version if PubCache() is not working.
 - **FIX**(cli): Provide fallback value if Paths.getPubCacheDir if PubCache() is not working.
 - **FEAT**: Upgrade to dart 2.19.0.
 - **FEAT**: Add butter_cli package.
 - **DOCS**: Add discord badge on all packages.

#### `butter_commons` - `v2.4.0`

 - **PERF**(commons): Add noComma to Formats.toMoney.
 - **FIX**(dep): Update intl to 0.18.0.
 - **FIX**: Fix Formats.getYYMM.
 - **FIX**: Set the sdks of all packages to >=2.12.0.
 - **FIX**: Apply new linting rules; Change didFindObject and didFindObjects definitions.
 - **FIX**: Update documentation of the api_commons and commons packages.
 - **FEAT**: Upgrade to dart 2.19.0.
 - **DOCS**: Add discord badge on all packages.

#### `butter_toolkit` - `v2.4.0`

 - **FIX**(ui_toolkit): Fix for publishing.
 - **FEAT**: Add ui_toolkit.

#### `sample_api` - `v2.4.0`

 - **FIX**: Upgrade to conduit v4.3.9.
 - **FIX**: Ensure that the module and service registries are released after init.
 - **FIX**: Upgrade conduit to 4.1.8.
 - **FEAT**: Upgrade to dart 2.19.0.

#### `sample_flutter` - `v2.4.0`

 - **FIX**(dep): Update intl to 0.18.0.
 - **FIX**: Upgrade to conduit v4.3.9.
 - **FEAT**: Add butter_cli package.

#### `submodules` - `v2.3.1`

 - **FIX**(dep): Update intl to 0.18.0.
 - **FIX**: Upgrade to conduit v4.3.9.
 - **FIX**: Upgrade conduit to 4.1.8.

#### `todo` - `v2.3.1`

 - **FIX**(dep): Update intl to 0.18.0.
 - **FIX**: Upgrade to conduit v4.3.9.
 - **FIX**: Upgrade conduit to 4.1.8.


## 2023-08-01

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`butter` - `v2.3.0`](#butter---v230)

---

#### `butter` - `v2.3.0`

 - Synchronize package versioning


## 2023-07-12

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`butter` - `v2.2.4`](#butter---v224)
 - [`butter_cli` - `v0.3.2+3`](#butter_cli---v0323)
 - [`butter_commons` - `v2.1.2`](#butter_commons---v212)
 - [`butter_api_commons` - `v2.2.8`](#butter_api_commons---v228)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `butter_api_commons` - `v2.2.8`

---

#### `butter` - `v2.2.4`

 - **FIX**(dep): Update intl to 0.18.0.

#### `butter_cli` - `v0.3.2+3`

 - **FIX**(dep): Update intl to 0.18.0.

#### `butter_commons` - `v2.1.2`

 - **FIX**(dep): Update intl to 0.18.0.


## 2023-06-28

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`butter` - `v2.2.3`](#butter---v223)
 - [`butter_commons` - `v2.1.1`](#butter_commons---v211)
 - [`butter_api_commons` - `v2.2.7`](#butter_api_commons---v227)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `butter_api_commons` - `v2.2.7`

---

#### `butter` - `v2.2.3`

 - **FIX**: Prevent a null check crash in BaseModule.

#### `butter_commons` - `v2.1.1`

 - **FIX**: Fix Formats.getYYMM.


## 2023-03-12

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`butter` - `v2.2.2`](#butter---v222)
 - [`butter_api_commons` - `v2.2.6`](#butter_api_commons---v226)
 - [`butter_cli` - `v0.3.2+2`](#butter_cli---v0322)

---

#### `butter` - `v2.2.2`

 - **FIX**: Upgrade to conduit v4.3.9.

#### `butter_api_commons` - `v2.2.6`

 - **FIX**: Upgrade to conduit v4.3.9.

#### `butter_cli` - `v0.3.2+2`

 - **FIX**: Upgrade to conduit v4.3.9.

