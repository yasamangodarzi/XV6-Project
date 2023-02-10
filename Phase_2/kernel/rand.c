///* The following code is added by Justine George JXG210092, Gautham Shaji GXS210034
// */
///* A C-program for MT19937: Real number version                */
///*   genrand() generates one pseudorandom real number (double) */
///* which is uniformly distributed on [0,1]-interval, for each  */
///* call. sgenrand(seed) set initial values to the working area */
///* of 624 words. Before genrand(), sgenrand(seed) must be      */
///* called once. (seed is any 32-bit integer except for 0).     */
///* Integer generator is obtained by modifying two lines.       */
///*   Coded by Takuji Nishimura, considering the suggestions by */
///* Topher Cooper and Marc Rieffel in July-Aug. 1997.           */
//
///* This library is free software; you can redistribute it and/or   */
///* modify it under the terms of the GNU Library General Public     */
///* License as published by the Free Software Foundation; either    */
///* version 2 of the License, or (at your option) any later         */
///* version.                                                        */
///* This library is distributed in the hope that it will be useful, */
///* but WITHOUT ANY WARRANTY; without even the implied warranty of  */
///* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.            */
///* See the GNU Library General Public License for more details.    */
///* You should have received a copy of the GNU Library General      */
///* Public License along with this library; if not, write to the    */
///* Free Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA   */
///* 02111-1307  USA                                                 */
//
///* Copyright (C) 1997 Makoto Matsumoto and Takuji Nishimura.       */
///* Any feedback is very welcome. For any question, comments,       */
///* see http://www.math.keio.ac.jp/matumoto/emt.html or email       */
///* matumoto@math.keio.ac.jp                                        */
//
//// Period parameters
//#define N 624
//#define M 397
//#define MATRIX_A 0x9908b0df   /* constant vector a */
//#define UPPER_MASK 0x80000000 /* most significant w-r bits */
//#define LOWER_MASK 0x7fffffff /* least significant r bits */
//
//// Tempering parameters
//#define TEMPERING_MASK_B 0x9d2c5680
//#define TEMPERING_MASK_C 0xefc60000
//#define TEMPERING_SHIFT_U(y)  (y >> 11)
//#define TEMPERING_SHIFT_S(y)  (y << 7)
//#define TEMPERING_SHIFT_T(y)  (y << 15)
//#define TEMPERING_SHIFT_L(y)  (y >> 18)
//
//#define RAND_MAX 0x7fffffff
//
//static unsigned long mt[N]; /* the array for the state vector  */
//static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */
//
//// Initializing the array with a NONZERO seed
//void
//sgenrand(unsigned long seed)
//{
//    /* setting initial seeds to mt[N] using         */
//    /* the generator Line 25 of Table 1 in          */
//    /* [KNUTH 1981, The Art of Computer Programming */
//    /*    Vol. 2 (2nd Ed.), pp102]                  */
//    mt[0]= seed & 0xffffffff;
//    for (mti=1; mti<N; mti++)
//        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
//}
//
//// For integer generation
//long
//genrand()
//{
//    unsigned long y;
//    static unsigned long mag01[2]={0x0, MATRIX_A};
//    /* mag01[x] = x * MATRIX_A  for x=0,1 */
//
//    if (mti >= N) { /* generate N words at one time */
//        int kk;
//
//        if (mti == N+1)   /* if sgenrand() has not been called, */
//            sgenrand(4357); /* a default initial seed is used   */
//
//        for (kk=0;kk<N-M;kk++) {
//            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
//            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
//        }
//        for (;kk<N-1;kk++) {
//            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
//            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
//        }
//        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
//        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
//
//        mti = 0;
//    }
//
//    y = mt[mti++];
//    y ^= TEMPERING_SHIFT_U(y);
//    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
//    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
//    y ^= TEMPERING_SHIFT_L(y);
//
//    // Strip off uppermost bit because we want a long,
//    // not an unsigned long
//    return y & RAND_MAX;
//}
//
//// Assumes 0 <= max <= RAND_MAX
//// Returns in the half-open interval [0, max]
//// This function is used to get random numbers to find
//// the winner for the lottery scheduler
//long getrand(long max) {
//    unsigned long
//    // max <= RAND_MAX < ULONG_MAX, so this is okay.
//    num_bins = (unsigned long) max + 1,
//            num_rand = (unsigned long) RAND_MAX + 1,
//            bin_size = num_rand / num_bins,
//            defect   = num_rand % num_bins;
//
//    long x;
//    do {
//        x = genrand();
//    }
//        // This is carefully written not to overflow
//    while (num_rand - defect <= (unsigned long)x);
//
//    // Truncated division is intentional
//    return x/bin_size;
//}
///* End of code added */







#include "param.h"
#include "types.h"

// Return a integer between 0 and ((2^32 - 1) / 2), which is 2147483647.
uint
random(void)
{
    // Take from http://stackoverflow.com/questions/1167253/implementation-of-rand
    static unsigned int z1 = 12345, z2 = 12345, z3 = 12345, z4 = 12345;
    unsigned int b;
    b  = ((z1 << 6) ^ z1) >> 13;
    z1 = ((z1 & 4294967294U) << 18) ^ b;
    b  = ((z2 << 2) ^ z2) >> 27;
    z2 = ((z2 & 4294967288U) << 2) ^ b;
    b  = ((z3 << 13) ^ z3) >> 21;
    z3 = ((z3 & 4294967280U) << 7) ^ b;
    b  = ((z4 << 3) ^ z4) >> 12;
    z4 = ((z4 & 4294967168U) << 13) ^ b;

    return (z1 ^ z2 ^ z3 ^ z4) / 2;
}

// Return a random integer between a given range.
int
randomrange(int lo, int hi)
{
    if (hi < lo) {
        int tmp = lo;
        lo = hi;
        hi = tmp;
    }
    int range = hi - lo + 1;
    return random() % (range) + lo;
}