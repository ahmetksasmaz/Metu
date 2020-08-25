/********************************************************
 * Kernels to be optimized for the CS:APP Performance Lab
 ********************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "defs.h"
/*
 * Please fill in the following student struct
 */
team_t team = {
    "e2237824",              /* Student ID */

    "Ahmet Kursad SASMAZ",     /* full name */
    "ahmet.sasmaz@metu.edu.tr",  /* email address */

    "",                   /* leave blank */
    ""                    /* leave blank */
};


/***************
 * Sobel KERNEL
 ***************/

/******************************************************
 * Your different versions of the sobel functions  go here
 ******************************************************/

 char sobel_longker_descr[] = "Dot product: Current working version with long kernel matrix";
 void sobel_longker(int dim,int *src,int *dst)
 {
   int ker[3][3] = {{-1, 0, 1},
                    {-2, 0, 2},
                    {-1, 0, 1}};
   int remain = dim-1;
   int counter;
   int lower;
   int upper;
   int x;
   int limit = dim*remain-1;
   for(x = 0; x <= dim; x++){
     dst[x] = 0;
   }
   for(counter = -2; x < limit; x++){
     if(counter & remain){
       lower = x-remain;
       upper = x+remain;
       dst[x] = src[lower-2] * ker[0][0] +
       src[lower-1] * ker[0][1] +
       src[lower] * ker[0][2] +
       src[x-1] * ker[1][0] +
       src[x] * ker[1][1] +
       src[x+1] * ker[1][2] +
       src[upper] * ker[2][0] +
       src[upper+1] * ker[2][1] +
       src[upper+2] * ker[2][2];
       counter--;
     }
     else{
       dst[x] = 0;
       x++;
       dst[x] = 0;
       counter = -2;
     }
   }
   limit += dim;
   for(; x <= limit; x++){
     dst[x] = 0;
   }
 }

 char sobel_shortker_descr[] = "Dot product: Current working version with short kernel matrix";
 void sobel_shortker(int dim,int *src,int *dst)
 {
   int ker[9] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
   int remain = dim-1;
   int counter;
   int lower;
   int upper;
   int x;
   int limit = dim*remain-1;
   for(x = 0; x <= dim; x++){
     dst[x] = 0;
   }
   for(counter = -2; x < limit; x++){
     if(counter & remain){
       lower = x-remain;
       upper = x+remain;
       dst[x] = src[lower-2] * ker[0] +
       src[lower-1] * ker[1] +
       src[lower] * ker[2] +
       src[x-1] * ker[3] +
       src[x] * ker[4] +
       src[x+1] * ker[5] +
       src[upper] * ker[6] +
       src[upper+1] * ker[7] +
       src[upper+2] * ker[8];
       counter--;
     }
     else{
       dst[x] = 0;
       x++;
       dst[x] = 0;
       counter = -2;
     }
   }
   limit += dim;
   for(; x <= limit; x++){
     dst[x] = 0;
   }
 }

 char sobel_miss_loop_descr[] = "Dot product: Current working version miss loop";
 void sobel_miss_loop(int dim,int *src,int *dst)
 {
   int remain = dim-1;
   int counter;
   int lower;
   int upper;
   int x;
   int limit = dim*remain-1;
   int up = limit + dim;
   for(x = 0; x <= dim; x++, up--){
     dst[x] = 0;
     dst[up] = 0;
   }
   for(counter = -2; x < limit; x++){
     if(counter & remain){
       lower = x-remain;
       upper = x+remain;
       dst[x] = src[lower] + src[upper+2] + ((src[x+1]-src[x-1]) << 1) - src[lower-2] - src[upper];
       counter--;
     }
     else{
       dst[x] = 0;
       x++;
       dst[x] = 0;
       counter = -2;
     }
   }
 }

 char sobel_loop_by_one_descr[] = "Dot product: Current working version loop by one";
 void sobel_loop_by_one(int dim,int *src,int *dst)
 {
   int remain = dim-1;
   int counter;
   int lower;
   int upper;
   int x;
   int limit = dim*remain-1;
   for(x = 0; x <= dim; x++){
     dst[x] = 0;
   }
   for(counter = -2; x < limit; x++){
     if(counter & remain){
       lower = x-remain;
       upper = x+remain;
       dst[x] = src[lower] + src[upper+2] + ((src[x+1]-src[x-1]) << 1) - src[lower-2] - src[upper];
       counter--;
     }
     else{
       dst[x] = 0;
       x++;
       dst[x] = 0;
       counter = -2;
     }
   }
   limit += dim;
   for(; x <= limit; x++){
     dst[x] = 0;
   }
 }


/*
 * naive_sobel - The naive baseline version of Sobel
 */
char naive_sobel_descr[] = "sobel: Naive baseline implementation";
void naive_sobel(int dim,int *src, int *dst) {
    int i,j,k,l;
    int ker[3][3] = {{-1, 0, 1},
                     {-2, 0, 2},
                     {-1, 0, 1}};

    for(i = 0; i < dim; i++)
        for(j = 0; j < dim; j++) {
	   dst[j*dim+i]=0;
            if(!((i == 0) || (i == dim-1) || (j == 0) || (j == dim-1))){
            for(k = -1; k <= 1; k++)
                for(l = -1; l <= 1; l++) {
                 dst[j*dim+i]=dst[j*dim+i]+src[(j + l)*dim+(i + k)] * ker[(l+1)][(k+1)];
                }


      }

}
}
/*
 * sobel - Your current working version of sobel
 * IMPORTANT: This is the version you will be graded on
 */

char sobel_descr[] = "Dot product: Current working version";
void sobel(int dim,int *src,int *dst)
{
  int remain = dim-1;
  int counter;
  int lower;
  int upper;
  int x;
  int limit = dim*remain-1;
  for(x = 0; x <= dim; x++){
    dst[x] = 0;
  }
  for(counter = -2; x < limit; x++){
    if(counter & remain){
      lower = x-remain;
      upper = x+remain;
      dst[x] = src[lower] + src[upper+2] + ((src[x+1]-src[x-1]) << 1) - src[lower-2] - src[upper];
      counter--;
    }
    else{
      dst[x] = 0;
      x++;
      dst[x] = 0;
      counter = -2;
    }
  }
  limit += dim;
  for(; x <= limit; x++){
    dst[x] = 0;
  }

  // dim+1 .. dim*dim-dim-1 // dim*dim-2dim-2
}

/*********************************************************************
 * register_sobel_functions - Register all of your different versions
 *     of the sobel functions  with the driver by calling the
 *     add_sobel_function() for each test function. When you run the
 *     driver program, it will test and report the performance of each
 *     registered test function.
 *********************************************************************/

void register_sobel_functions() {
    add_sobel_function(&naive_sobel, naive_sobel_descr);
    add_sobel_function(&sobel, sobel_descr);
    //add_sobel_function(&sobel_longker, sobel_longker_descr);
    //add_sobel_function(&sobel_shortker, sobel_shortker_descr);
    add_sobel_function(&sobel_miss_loop, sobel_miss_loop_descr);
    /* ... Register additional test functions here */
}




/***************
 * MIRROR KERNEL
 ***************/

/******************************************************
 * Your different versions of the mirror func  go here
 ******************************************************/

/*
 * naive_mirror - The naive baseline version of mirror
 */
char naive_mirror_descr[] = "Naive_mirror: Naive baseline implementation";
void naive_mirror(int dim,int *src,int *dst) {

 	 int i,j;

  for(j = 0; j < dim; j++)
        for(i = 0; i < dim; i++) {
            dst[RIDX(j,i,dim)]=src[RIDX(j,dim-1-i,dim)];

        }

}


/*
 * mirror - Your current working version of mirror
 * IMPORTANT: This is the version you will be graded on
 */
char mirror_descr[] = "Mirror: Current working version";
void mirror(int dim,int *src,int *dst)
{
  int i, j, addedi, addedj, dim2, limit;
  i = 0;
  j = dim-1;
  dim2 = dim >> 1;
  addedi = dim2 + 1;
  addedj = j + dim2;
  limit = dim*dim - addedi;
  while(i <= limit){
    dst[i] = src[j];
    dst[j] = src[i];
    if(j == i+1){
      i += addedi;
      j += addedj;
    }
    else{
      i++;
      j--;
    }
  }
}

/*********************************************************************
 * register_mirror_functions - Register all of your different versions
 *     of the mirror functions  with the driver by calling the
 *     add_mirror_function() for each test function. When you run the
 *     driver program, it will test and report the performance of each
 *     registered test function.
 *********************************************************************/

void register_mirror_functions() {
    add_mirror_function(&naive_mirror, naive_mirror_descr);
    add_mirror_function(&mirror, mirror_descr);
    /* ... Register additional test functions here */
}
