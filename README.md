# Bonfire

A small project for exploring some interesting approaches to a delightful web application.

## Motivation

* to get inspirations on interesting books/papers from others
* to explore most recent technologies on building and deploying a web application
* try to use as little JavaScript as possible by leveraging [Phoenix LiveView]

Some of the frameworks/libraries used:

* [Phoenix] for web framework
* [Phoenix LiveView] for almost-no-javascript application
* [Commanded] for [Event Sourcing]
* [Pow] for authentification
* [Rio] for deployment
* [dockerize] for docker image building
* [AppSignal] for APM (Application Performance Monitoring) and exception watching. Grateful thanks to [AppSignal] for the sponsorship. 

Libraries are picked for practicing reason, you can find more background information in the [design document](https://github.com/qhwa/bonfire/blob/master/design/design.md). 

## Warning

This project is not ready for a serious production yet. It's still under active development. It needs more tests, a CI process, and contains bugs.

## Develop

[guides/develop](guides/develop.md)


## Roadmap

* 1.0: core features
  * [x] reading state CURD
  * [x] user authentication
  * [x] checkins
* 2.0: social features
  * [ ] following
  * [ ] email notification
* 3.0: gaming
  * [x] a game which will encourage users to do more reading
  * [ ] a game helping to form a reading habit

[Phoenix]: http://www.phoenixframework.org/
[Phoenix LiveView]: https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html
[Commanded]: https://github.com/commanded/commanded
[Event Sourcing]: https://martinfowler.com/eaaDev/EventSourcing.html
[Rio]: https://rio.io
[Pow]: https://powauth.com/
[credo]: https://github.com/rrrene/credo/
[dialyxir]: https://github.com/jeremyjh/dialyxir
[dockerize]: https://github.com/qhwa/dockerize
[AppSignal]: https://appsignal.com/
