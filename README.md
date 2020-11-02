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

![steps](https://sun9-24.userapi.com/n08JKww8dIbcz2TzZRSXtOdSAKh2XLjt8HgCgQ/7S9rij4jeIw.jpg)

### Parsing file
LogFile is used to access the file with logs line by line. The class implements a convenient interface for interacting with a file line by line, providing url and ip arguments instead of raw string at each step.

### Create Log object
Based on the received data, an object of the Log class is initialized. It does the validation of the passed attributes. Invalid objects are skipped and do not participate in the further process. Information about such objects will be printed to stdout, including information about the number of the incorrect line in the file.

### Add created Log object to LogHistory
The validated Log object is used to populate the log data store. LogHistory is a class that describes an object that contains information about the number of calls to a specific URL and the set of IPs that participated in these calls.

### Output LogHistory
At this stage, the LogHistory contains all the information necessary for output. LogView is a class that is responsible for displaying information contained in the LogHistory storage 

## Possible improvements
- add IPv6 support
