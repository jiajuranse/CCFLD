test_data = CreateDataPointInput(datapoint, offset, scale);
rate = glmnetPredict(fit, 'response', test_data.features);