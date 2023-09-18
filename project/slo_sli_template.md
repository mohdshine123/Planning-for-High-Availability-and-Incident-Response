# API Service

| Category     | SLI | SLO                                                                                                         |
|--------------|-----|-------------------------------------------------------------------------------------------------------------|
| Availability |  ( Successful requests/Total requests)/100  | 99%                                                                                                         |
| Latency      | count of requests less than 0.1 sec/count of all requests| 90% of requests below 100ms                                                                                 |
| Error Budget |  100 % -80% /Total number of API requests   | Error budget is defined at 20%. This means that 20% of the requests can fail and still be within the budget |
| Throughput   | Number of requests/total time  |  RPS indicates the application is functioning                                                              |
