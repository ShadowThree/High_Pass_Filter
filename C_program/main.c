#include <stdio.h>
#include "../sin_data.h"

static float result[SAMPLE_DATA_LEN] = {0};

int main(void)
{
    float *curPos = sin_data;
    FILE *fid = fopen("../result.txt", "w");

    for (int i = 0; i < SAMPLE_DATA_LEN; i++)
    {
        for (int j = 0; j < NUM_TAPS + 1; j++)
        {
            result[i] += coeff[j] * curPos[NUM_TAPS - j];
        }
        fprintf(fid, "%+.10f ", result[i]);
        curPos++;
    }

    fclose(fid);

    return 0;
}