; RUN: llc -mtriple=x86_64-unknown-linux-gnu -print-machineinstrs=expand-isel-pseudos %s -o /dev/null 2>&1 | FileCheck %s --check-prefix=MCINSTR
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s 2>&1 | FileCheck %s --check-prefix=X86ASM

; X86ASM: imull   %eax, %eax
; X86ASM: xorl    %eax, %eax
; X86ASM: retq

; MCINSTR: %1:gr32 = IMPLICIT_DEF
; MCINSTR: %2:gr32 = IMUL32rr %1:gr32, %1:gr32,
; MCINSTR: %3:gr32 = XOR32rr %2:gr32, %1:gr32,
; MCINSTR: $eax = COPY %3:gr32
; MCINSTR: RET 0, $eax

define i32 @foo(i32 %x) {
  %y1 = freeze i32 undef
  %t1 = mul i32 %y1, %y1
  %t2 = xor i32 %t1, %y1
  ret i32 %t2
}
