# Log Parser

## Task

> Write a ruby script that:
>
> a. Receives a log as argument (webserver.log is provided)
>
> b. Returns the following:
> - list of webpages with most page views ordered from most pages views to less page views
>
> e.g.:
>
> /home 90 visits /index 80 visits etc...
>
> - list of webpages with most unique page views also ordered
>
> e.g.:
>
> /about/2 8 unique views
>
> /index 5 unique views etc...

***

## Install
```
bundle install
```
## Run app
```
./bin/main path/to/webserver.log
```
## Run specs
```
./bin/rspec
```
## Approach description
Script is split into several parts:
- Log file adapter. Allows to interact with the file as an enumerable. Enumerable included class. Processes the file along the lines. Validates missing path/file, wrong extension, empty file.
- Log model. Keeps ip and url as attrs. Validates url/ip format.
- Swap file. Describes interaction with swap file. Keeps log data.
- Log saver. Service for saving logs by batches.
- Log view. Generates output string.

## Possible improvements
- add IPv6 support