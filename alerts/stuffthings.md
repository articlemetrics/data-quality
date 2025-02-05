

Summary of ALM alerts
========================================================

__Scott Chamberlain__
__14 November, 2014__

## Introduction

The [Lagotto application](http://alm.plos.org/) collects and provides article-level metrics data for scholarly articles. As part of a data integrity process, various alerts are given from Lagotto that help determine what may be going wrong with the application, data sources used in Lagotto, and any problems with users requesting data from the Lagotto application. Analyzing these alerts is helping to determine what errors are the most common, and what may lie behind errors.

Scott Chamberlain has been working on an R client to work with Lagotto application data, called `alm`. This R client can also interact with alerts data from Lagotto. 

As other publishers are starting to use Lagotto, the below is a discussion mostly of PLOS data, but includes some discussion of other publishers. 



## How to interpret alerts

|Alert class name                  | Description       |
|:---------------------------------|:------------------|
|Net::HTTPUnauthorized             | 401 - authorization likely missing |
|Net::HTTPForbidden                | xxxxxx |
|Net::HTTPRequestTimeOut           | 408 - request timeout |
|Net::HTTPGatewayTimeOut           | xxxxxx |
|Net::HTTPConflict                 | 409 - Document update conflict |
|Net::HTTPServiceUnavailable       | 503 - serve is down |
|Faraday::ResourceNotFound         | 404 - resource not found |
|ActiveRecord::RecordInvalid       | title is usually blank, and can't be |
|Delayed::WorkerTimeout            | xxxxxx |
|DelayedJobError                   | xxxxxx |
|TooManyErrorsBySourceError        | xxxxxx |
|SourceInactiveError               | xxxxxx |
|TooManyWorkersError               | xxxxxx |
|EventCountDecreasingError         | Event count decrease too fast, check on it |
|EventCountIncreasingTooFastError  | Event count increasing too fast, check on it |
|ApiResponseTooSlowError           | Alert if successful API responses took too long |
|HtmlRatioTooHighError             | HTML/PDF ratio higher than 50 |
|ArticleNotUpdatedError            | Alert if articles have not been updated within X days |
|SourceNotUpdatedError             | xxxxxx |
|CitationMilestoneAlert            | Alert if an article has been cited the specified number of times |
