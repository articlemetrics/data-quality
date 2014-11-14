

Summary of ALM alerts
========================================================

__Scott Chamberlain__
__04 November, 2014__

## Introduction

The Lagotto application collects and provides article-level metrics data for scholarly articles. As part of a data integrity process, various alerts are given from Lagotto that help determine what may be going wrong with the application, data sources used in Lagotto, and any problems with users requesting data from the Lagotta application. Analyzing these alerts is helping to determine what errors are the most common, and what may lie behind errors.

Scott Chamberlain has been working on an R client to work with Lagotto application data, called `alm`. This R client can also interact with alerts data from Lagotto. 

As other publishers are starting to use Lagotto, the below is a discussion mostly of PLOS data, but includes some talk of other publishers. 



## PLOS


```r
print("hello world")
```

```
## [1] "hello world"
```

## Crossref

Crossref has the biggest collection of articles in any Lagotta application, with xx as of today.


|class_name                              |    n|
|:---------------------------------------|----:|
|ActiveRecord::RecordInvalid             | 6067|
|Net::HTTPServiceUnavailable             |  814|
|Net::HTTPRequestTimeOut                 |  317|
|Faraday::ClientError                    |  285|
|Net::HTTPUnauthorized                   |   79|
|Net::HTTPConflict                       |   56|
|FaradayMiddleware::RedirectLimitReached |   21|
|StandardError                           |   11|
|Faraday::ResourceNotFound               |    5|
|Net::HTTPInternalServerError            |    4|
|ArgumentError                           |    1|
|Net::HTTPBadRequest                     |    1|
