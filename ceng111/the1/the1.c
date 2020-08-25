#include <stdio.h>

double f(double x);

int main(){

	double lower_bound , upper_bound , tolerance; /* Inputs */
	double  interval_mid , interval , last_root , x1 , fx , fprimex; /* Mid Variables */
	int i , interval_count , loop_count, root_count = 0; /* Counters */

	scanf("%lf %lf %lf" , &lower_bound , &upper_bound , &tolerance); /* Get Input */

	interval = tolerance * 10;
	interval_count = (upper_bound-lower_bound)/interval; /* No Roots Neared 10*Tolerance */
	interval_mid = tolerance*5;

	for(i = 0 ; i <= interval_count ; i++){

		x1 = lower_bound + i*interval + interval_mid; /* First x Starts With Middle Of The Temporary Interval */
		loop_count = 0;

		while(loop_count < 100){ /* If Root Couldn't Find In 100 Steps, Break The Loop (Works For x Value Loops) (Fails For Slow Convergence) */

			fx = f(x1);
			if(fx <= tolerance*tolerance && fx >= -tolerance*tolerance && !(x1 > (lower_bound+(i+1)*interval) || x1 < (lower_bound+i*interval))){ /* If There Is A Root */
				if(root_count){ /* Is It First Root? */
					if( !((last_root - x1) <= tolerance*10 && (last_root - x1) >= -tolerance*10)){ /* Is It Same With Last Root (For Root On Inverval Bounds) */
						printf("%f " , x1);
						last_root = x1;
						root_count++;
					}
				}
				else{
					printf("%f " , x1);
					last_root = x1;
					root_count++;
				}
				break;
			}
			else{
				fprimex = (f(x1+0.0000001) - f(x1-0.0000001))/0.0000002;
				if(fprimex <= 0.0000001 && fprimex >= 0.0000001){ x1 += tolerance/10; loop_count++; continue;} /* (Prevent Divide By Zero And No Convergence) */
				x1 = x1 - fx/fprimex; /* Newton - Raphson Method */
			}
			loop_count++;
		}
	}
	printf("\n");
	return 0;
}
