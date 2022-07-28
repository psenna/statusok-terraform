# statusok-terraform
Terraform configuration to deploy a http endpoint monitor (statusok + influxdb + grafana) in docker provider


## Todo 
- [ ] Create alarms
- [ ] Influx retention policy

# Getting started

## Dependencies
* Docker
* Terraform

# Customization
There is some variables available to customize the deploy. See the table below or the variables.tf file. 

**Todo: Variables table**

To change the created requests, change the "statusok_request" variable, you can change the check interval, the request method (http methods like "GET", "POST", "PUT", ...), the headers, the form Params and the expected response code.


```
statusok_requests = {
    "mywebapp.com login" = {
      checkEvery   = 30
      requestType  = "POST"
      headers      = {}
      formParams   = {
        "login" = "userlogin",
        "password" = "mypass"
      }
      responseTime = 800
      responseCode = 200
      url          = "https://mywebapp.com"
  }}
```

## Connect to remote host through ssh

You can use ssh to connect to a remote host and deploy this configuration it.