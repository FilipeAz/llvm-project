; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mergeicmps -mtriple=x86_64-unknown-unknown -S | FileCheck %s --check-prefix=X86

%"struct.std::pair" = type { i32, i32, i32, i32 }

declare void @foo(...)  nounwind readnone

; We can split %entry and create a memcmp(16 bytes).
define zeroext i1 @opeq1(
; X86-LABEL: @opeq1(
;
; Make sure this call is moved to the beginning of the entry block.
; X86:      entry:
; X86-NEXT:    call void (...) @foo()
; X86-NEXT:    [[THIRD_I:%.*]] = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* [[A:%.*]], i64 0, i32 0
; X86-NEXT:    [[THIRD1_I:%.*]] = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* [[B:%.*]], i64 0, i32 0
; X86-NEXT:    [[CSTR:%.*]] = bitcast i32* [[THIRD_I]] to i8*
; X86-NEXT:    [[CSTR1:%.*]] = bitcast i32* [[THIRD1_I]] to i8*
; X86-NEXT:    [[MEMCMP:%.*]] = call i32 @memcmp(i8* [[CSTR]], i8* [[CSTR1]], i64 16)
; X86-NEXT:    [[TMP0:%.*]] = icmp eq i32 [[MEMCMP]], 0
; X86-NEXT:    br label [[OPEQ1_EXIT:%.*]]
;
  %"struct.std::pair"* nocapture readonly dereferenceable(16) %a,
  %"struct.std::pair"* nocapture readonly dereferenceable(16) %b) local_unnamed_addr #0 {
entry:
  %first.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 0
  %0 = load i32, i32* %first.i, align 4
  %first1.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 0
  %1 = load i32, i32* %first1.i, align 4
  ; Does other work.
  call void (...) @foo()
  %cmp.i = icmp eq i32 %0, %1
  br i1 %cmp.i, label %land.rhs.i, label %opeq1.exit

land.rhs.i:
  %second.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 1
  %2 = load i32, i32* %second.i, align 4
  %second2.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 1
  %3 = load i32, i32* %second2.i, align 4
  %cmp2.i = icmp eq i32 %2, %3
  br i1 %cmp2.i, label %land.rhs.i.2, label %opeq1.exit

land.rhs.i.2:
  %third.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 2
  %4 = load i32, i32* %third.i, align 4
  %third2.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 2
  %5 = load i32, i32* %third2.i, align 4
  %cmp3.i = icmp eq i32 %4, %5
  br i1 %cmp3.i, label %land.rhs.i.3, label %opeq1.exit

land.rhs.i.3:
  %fourth.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 3
  %6 = load i32, i32* %fourth.i, align 4
  %fourth2.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 3
  %7 = load i32, i32* %fourth2.i, align 4
  %cmp4.i = icmp eq i32 %6, %7
  br label %opeq1.exit

opeq1.exit:
  %8 = phi i1 [ false, %entry ], [ false, %land.rhs.i] , [ false, %land.rhs.i.2 ], [ %cmp4.i, %land.rhs.i.3 ]
  ret i1 %8
}


; We will not be able to merge anything, make sure the call is not moved out.
define zeroext i1 @opeq1_discontiguous(
; X86-LABEL: @opeq1_discontiguous(
;
; Make sure this call is moved in the entry block.
; X86:      entry:
; X86:        [[FIRST_I:%.*]] = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* [[A:%.*]], i64 0, i32 1 
; X86:        [[FIRST1_I:%.*]] = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* [[B:%.*]], i64 0, i32 0
; X86:        call void (...) @foo()
  %"struct.std::pair"* nocapture readonly dereferenceable(16) %a,
  %"struct.std::pair"* nocapture readonly dereferenceable(16) %b) local_unnamed_addr #0 {
entry:
  %first.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 1 
  %0 = load i32, i32* %first.i, align 4
  %first1.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 0 
  %1 = load i32, i32* %first1.i, align 4
  ; Does other work.
  call void (...) @foo()
  %cmp.i = icmp eq i32 %0, %1
  br i1 %cmp.i, label %land.rhs.i, label %opeq1.exit

land.rhs.i:
  %second.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 2 
  %2 = load i32, i32* %second.i, align 4
  %second2.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 1
  %3 = load i32, i32* %second2.i, align 4
  %cmp2.i = icmp eq i32 %2, %3
  br i1 %cmp2.i, label %land.rhs.i.2, label %opeq1.exit

land.rhs.i.2:
  %third.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 2
  %4 = load i32, i32* %third.i, align 4
  %third2.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 3
  %5 = load i32, i32* %third2.i, align 4
  %cmp3.i = icmp eq i32 %4, %5
  br i1 %cmp3.i, label %land.rhs.i.3, label %opeq1.exit

land.rhs.i.3:
  %fourth.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 1
  %6 = load i32, i32* %fourth.i, align 4
  %fourth2.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 3 
  %7 = load i32, i32* %fourth2.i, align 4
  %cmp4.i = icmp eq i32 %6, %7
  br label %opeq1.exit

opeq1.exit:
  %8 = phi i1 [ false, %entry ], [ false, %land.rhs.i] , [ false, %land.rhs.i.2 ], [ %cmp4.i, %land.rhs.i.3 ]
  ret i1 %8
}
