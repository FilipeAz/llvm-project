// RUN: %clang_cc1 -triple i386-apple-darwin10 -mms-bitfields -emit-llvm %s -o - | FileCheck %s

struct s1 {
  int       f32;
  long long f64;
} s1;

// CHECK: %struct.s1 = type { i32, [4 x i8], i64 }

struct s2 {
  int       f32;
  long long f64[4];
} s2;

// CHECK: %struct.s2 = type { i32, [4 x i8], [4 x i64] }

struct s3 {
  int       f32;
  struct s1 s;
} s3;

// CHECK: %struct.s3 = type { i32, [4 x i8], %struct.s1 }

// PR32482:

#pragma pack (push,1)

typedef unsigned int UINT32;

struct Inner {
  UINT32    A    :  1;
  UINT32    B    :  1;
  UINT32    C    :  1;
  UINT32    D    : 30;
} Inner;

#pragma pack (pop)

// CHECK: %struct.Inner = type \{ i1, i1, i1, i5, [3 x i8], i30, i2 }/

// CHECK: %struct.A = type \{ i3, i9, i12, i8, i17, i7, i4, i4, i3, i5, [3 x i8] }/

#pragma pack(push, 1)

union HEADER {
  struct A {
    int                                         :  3;  // Bits 2:0
    int a                                       :  9;  // Bits 11:3
    int                                         :  12;  // Bits 23:12
    int b                                       :  17;  // Bits 40:24
    int                                         :  7;  // Bits 47:41
    int c                                       :  4;  // Bits 51:48
    int                                         :  4;  // Bits 55:52
    int d                                       :  3;  // Bits 58:56
    int                                         :  5;  // Bits 63:59
  } Bits;
} HEADER;

#pragma pack(pop)

struct Inner variable = { 1,0,1, 21 };
union HEADER hdr = {{1,2,3,4}};

// CHECK: @variable = global \{ i1, i1, i1, i29, i30, i2 }/ \{ i1 true, i1 false, i1 true, i29 0, i30 21, i2 0 }/, align 1
// CHECK: @hdr = global { \{ i3, i9, i20, i17, i7, i4, i4, i3, i5, [3 x i8] }/ } { \{ i3, i9, i20, i17, i7, i4, i4, i3, i5, [3 x i8] }/ \{ i3 0, i9 1, i20 0, i17 2, i7 0, i4 3, i4 0, i3 -4, i5 0, [3 x i8] undef }/ }, align 1
