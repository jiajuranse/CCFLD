#include "mex.h"
#include <cmath>
#include <vector>
#include <memory>
#include <algorithm>
#include <ctime>
/* The computational routine */
inline int sqr(int x) {
	return x * x;
}
inline int dist(uint8_t *img, uint8_t *t, int x, int k, int N) {
	int result = 0;
	for (int i = 0; i < 3; i++) {
		result += sqr(img[i * N + x] - t[k * 3 + i]);
	};
	return std::sqrt(result);
}
double gain(uint8_t *img, uint8_t *t, int height, int width, uint8_t *trans = nullptr) {

	int N = height * width, trueN = N;
    if (trans != nullptr) {
        int j = 0;
        for (int i = 0; i < N; i ++) {
            if (trans[i] == 255) {
                for (int k = 0; k < 3; k ++) {
                    img[k * N + j] = img[k * N + i];
                }
                j ++;
            }
        }
        trueN = j;
    }
    int M = trueN / 20;
#define sigma 5
#define beta 0.025
#define inf ((~0u) >> 1)

	double second_term = 0;
#pragma omp parallel for shared(img, t, second_term)
	for (int i = 0; i < trueN; i++) {
			int min_value = inf;
			for (int k = 0; k < 5; k++) {
				int norm = dist(img, t, i, k, N);
				min_value = std::min(min_value, std::max(norm, sigma));
			}
#pragma omp critical
			second_term += (double)min_value / trueN;
	}
	double third_term = 0, max_value = -inf;
	auto pxyv = std::make_unique<int[]>(trueN);
	for (int k = 0; k < 5; k++) {
#pragma omp parallel for shared(img, t, pxyv)
		for (int i = 0; i < trueN; i++) {
				pxyv[i] = dist(img, t, i, k, N);
		}
		std::sort(pxyv.get(), pxyv.get() + trueN);
		double this_sum = 0;
		for (int i = 0; i < M; i++) {
			this_sum += std::max(pxyv[i], sigma);
		}
		max_value = std::max(max_value, this_sum);
	}
	third_term = beta / M * max_value;
	return second_term + third_term;
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[],
	int nrhs, const mxArray *prhs[])
{
	uint8_t *img, *x, *trans;

	/* check for proper number of arguments */
	if (nrhs != 2 && nrhs != 3) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", "2 or 3inputs required.");
	}
	if (nlhs != 1) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs", "One output required.");
	}
	/* make sure the first input argument is scalar */
	if (!mxIsUint8(prhs[0]) ||
		mxGetNumberOfDimensions(prhs[0]) != 3 ||
		(mxGetDimensions(prhs[0])[2] != 3 && 
            mxGetDimensions(prhs[0])[2] != 4)){
		mexErrMsgIdAndTxt("MyToolbox:gain:imgerror", "Input img must be a h * w * 3 uint8 matrix");
	}

	/* make sure the second input argument is type double */
	if (!mxIsUint8(prhs[1])) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notDouble", "Input matrix must be type uint8.");
	}

	/* check that number of rows in second input argument is 1 */
	if (mxGetM(prhs[1]) != 1) {
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector", "Input must be a row vector.");
	}

	if (mxGetN(prhs[1]) != 15) {
		printf("%d\n", mxGetN(prhs[1]));
		mexErrMsgIdAndTxt("MyToolbox:arrayProduct:notRowVector", "Input have 15 colums");
	}
    
	/* create a pointer to the real data in the input matrix  */
	img = (uint8_t*)mxGetData(prhs[0]);
	x = (uint8_t*)mxGetPr(prhs[1]);
    if (nrhs == 2)
        plhs[0] = mxCreateDoubleScalar(gain(img, x, mxGetDimensions(prhs[0])[0], mxGetDimensions(prhs[0])[1]));
    else
        plhs[0] = mxCreateDoubleScalar(gain(img, x, mxGetDimensions(prhs[0])[0], mxGetDimensions(prhs[0])[1], (uint8_t*)mxGetPr(prhs[2])));
}
