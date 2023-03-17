<p align="center">
<img src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/logo.png" width="250px">
</p>

# Nirikshak

[![pub package](https://img.shields.io/pub/v/nirikshak.svg)](https://pub.dartlang.org/packages/nirikshak)
[![pub package](https://img.shields.io/github/license/thealteria/nirikshak.svg?style=flat)](https://github.com/thealteria/nirikshak)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/thealteria/nirikshak)
[![pub package](https://img.shields.io/github/stars/thealteria/nirikshak?logo=github&logoColor=white)](https://github.com/thealteria/nirikshak)

Nirikshak is a lighweight Dio HTTP Inspector tool for Flutter which helps debugging http requests. Removed all the extra dependencies except Dio. It's a fork of [Alice](https://github.com/jhomlala/alice).

<table>
  <tr>
    <td>
		<img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/1.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/2.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/3.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/4.png">
    </td>
     <td>
       <img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/5.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/6.png">
    </td>
  </tr>
  <tr>
    <td>
	<img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/7.png">
    </td>
    <td>
       <img width="250px" src="https://raw.githubusercontent.com/thealteria/nirikshak/main/media/8.png">
    </td>
  </tr>

</table>

**Features:**  
✔️ Removed all the dependenices except Dio  
✔️ Detailed logs for each Dio HTTP calls (HTTP Request, HTTP Response)  
✔️ Inspector UI for viewing HTTP calls  
✔️ Statistics  
✔️ Error handling  
✔️ HTTP calls search

## Install

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  nirikshak: ^latest-version
```

2. Install it

```bash
$ flutter packages get
```

3. Import it

```dart
import 'package:nirikshak/nirikshak.dart';
```

## Usage
### Nirikshak configuration
1. Create Nirikshak instance:

```dart
Nirikshak nirikshak = Nirikshak();
```
And that's it! Nirikshak will automatically takes the theme mode as per your app.

### Dio configuration
You just need to add the Dio interceptor.

```dart
Dio dio = Dio();
dio.interceptors.add(nirikshak.getDioInterceptor());
```

## Show inspector manually

To view the Nirikshak, you need to call `showNirikshak` with `context`:

```dart
nirikshak.showNirikshak(context);
```


## Example
See complete example here: https://github.com/thealteria/nirikshak/blob/main/example/lib/main.dart
