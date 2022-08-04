[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![](https://github.com/kwencel/helm-charts/workflows/Release%20Charts/badge.svg?branch=main)](https://github.com/kwencel/helm-charts/actions)

## Usage

[Helm v3](https://helm.sh) must be installed to use the charts. Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

### Adding the repository
Once Helm has been set up correctly, add the repo as follows:

    helm repo add kwencel https://kwencel.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.

You can then run `helm search repo kwencel` to see the available charts.

### Installing a chart
In general, you can install a chart with its default values by executing:

    helm install <your-chosen-name> kwencel/<chart-name>

To uninstall the chart:

    helm uninstall <your-chosen-name>

However, charts often require you to provide some values to compliment the default ones.
For this reason, **see the detailed installation instructions** in the README file of each chart.
