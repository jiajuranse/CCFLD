test_data = CreateDataPointInput(vectomat(datapoint), offset, scale);
rate = glmnetPredict(fit, 'response', test_data.features);