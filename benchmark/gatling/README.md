# Run Gatling scenarios on a Prestashop shop

## Run simulation batches

### Prerequisites

Have docker available locally

### Build gatling image

`This part is not more required`

Official gatling image needs to be lightly customized. 

More precisely we need to pass some java arguments to the scenarios.

docker build -t prestashop/performance-gatling -f gatling/Dockerfile gatling

### Run simulation

The simplest way to run simulation and process results is to use `batch.sh` script

Update the content of `batch.sh` with your simulation data. You can chain the simulations by copying content multiple times.

Then simply run 

```
./batch.sh
```

It runs gatling scenarios, rename the gatling result directory, and extracts relevant data to csv and json files.

### Results

`results/results.csv` contains compiled simulations results

For each simulation, gatling result directory is set into `results` with the name set in batch.sh (SIMULATION_NAME), followed by the timestamp.

This directory contains 
* `index.html`, which can be opened in a browser to get graphical results.
* `result.json` contains relevant data such as per-category response time, failed requests.

## Run only Gatling locally

If you want to install gatling locally, and run the executable: use `user-files` directory content. It contains all simulations scenarios and data.
