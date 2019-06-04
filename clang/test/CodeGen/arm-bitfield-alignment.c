// RUN: %clang_cc1 -triple arm-none-eabi -ffreestanding -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64 -ffreestanding -emit-llvm -o - %s | FileCheck %s

extern struct T {
  int b0 : 8;
  int b1 : 24;
  int b2 : 1;
} g;

int func() {
  return g.b1;
}

// CHECK: @g = external global %struct.T, align 4
// CHECK: %{{.*}} = load i24, i24* getelementptr inbounds (%struct.T, %struct.T* @g, i32 0, i32 1), align 4
