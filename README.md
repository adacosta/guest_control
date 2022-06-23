# guest_control

[![Amber Framework](https://img.shields.io/badge/using-amber_framework-orange.svg)](https://amberframework.org)

This is a project written using [Amber](https://amberframework.org). Enjoy!

Guest control allows assigning control of a Chamberlain garage door opener within time windows.

*Example integration with Nest cam (using public url)*
<img width="1112" alt="Screenshot 2020-01-28 12 41 16" src="https://user-images.githubusercontent.com/37958/175189643-5f2940e5-e895-435f-a691-39a572eaffeb.png">
 
<img width="1114" alt="Screenshot 2020-01-09 16 50 37" src="https://user-images.githubusercontent.com/37958/175190214-952d55e4-5589-483f-865f-7dcff42c7f6d.png">

## Prerequisites

Docker

## Development

To start your Amber server:

1. ```docker compose up```

Now you can visit http://127.0.0.1:3003/ from your browser.

Getting an error message you need help decoding? Check the [Amber troubleshooting guide](https://docs.amberframework.org/amber/troubleshooting), post a [tagged message on Stack Overflow](https://stackoverflow.com/questions/tagged/amber-framework), or visit [Amber on Gitter](https://gitter.im/amberframework/amber).


## Tests

To run the test suite:

```
crystal spec
```
