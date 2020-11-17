# Running benchmarks

In order to run benchmarks, we'll mostly use [Gatling](http://gatling.io/).

It will allow us to both use a quite complex scenario and very detailed reports to get all the data we need.

## Run simulation batches

### Prerequisites

Having docker available locally is pretty much all you need at this point.

### Run simulation

In order to make it quick and simple, running the `batch.sh` script should be enough to run the simulation.

But first, you'll need to update the script in order to input your own configuration, such as your shop's URL, number of users, and so on.

Current configuration parameters are:

* **STACK**: Because we used several stacks in our own tests, this parameter was relevant to distinguish them. Use it at your own convenience, may or may not be relevant in your case.
* **MAIN_SHOP_URL**: Pretty self explainatory, this should point to your testing shop URL, either being local (http://localhost:8080) or public (http://me.shop) or an IP (http://10.20.30.40).
* **BASE_COUNT**: How many users are crawling your shop, at first step (more on this letter).
* **CUSTOMER_COUNT**: How many customers are buying from your shop.
* **RAMP_DURATION**: Indicates how long the benchmark will run, in seconds - which is a very important parameter, as 3000 CUSTOMERS to manage in 5 minutes is not the same as 5000 CUSTOMERS in 50 minutes
* **NB_STEPS**: Number of times this script will run.
* **STEP_COUNT**: The script allowing to loop, STEP_COUNT is how much the CUSTOMER_COUNT is increased. For example, at the next step, if CUSTOMER_COUNT was at 30 and STEP_COUNT was at 5, then, at the next step, CUSTOMER_COUNT will be at 35. Hence, at _each_ STEP, the CUSTOMER_COUNT is increased by STEP_COUNT.
* **START**: The number of STEPS since the script has been launched, in order to be looped over.

Once configured, you can launch it as follow:

```
./batch.sh
```

It will run the gatling scenario, rename the gatling result directory, and extracts relevant data to a csv file.

### Results

Of course, running a gatling, you get all the detailed reports provided by the application.

For each simulation, gatling result directory is set into `results` with the name set in batch.sh (SIMULATION_NAME), followed by the timestamp.

This directory contains 
* `index.html`, which can be opened in a browser to get graphical results.
* `result.json` contains relevant data such as per-category response time, failed requests.

But sometimes, you just want some fewer data, and we've extracted those we found useful in the result.csv file.
So, each time you run the `batch.sh` file, the `results/results.csv` is updated with compiled data from the simulation.

## Run only Gatling locally

If you want to install gatling locally, and run the executable: use `user-files` directory content.
It contains all simulations scenarios and data.
