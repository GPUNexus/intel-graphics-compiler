;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2024 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================

; REQUIRES: regkeys
; RUN: igc_opt --regkey=EnableGEPLSRMulExpr=1 -debugify --igc-gep-loop-strength-reduction -check-debugify -S < %s 2>&1 | FileCheck %s

; Reduced index is expressed with SCEVMulExpr.

; Debug-info related check
; CHECK: CheckModuleDebugify: PASS

define spir_kernel void @test(i32 addrspace(1)* %p, i32 %n, i64 %multiplier)  {
entry:
  %cmp1 = icmp slt i32 0, %n
  br i1 %cmp1, label %for.body.lr.ph, label %for.end

; CHECK-LABEL: for.body.lr.ph:
; CHECK:         [[MULL:%.*]] = mul i64 %multiplier, 44
; CHECK:         [[GEP_PHI1:%.*]] = getelementptr i32, i32 addrspace(1)* %p, i64 [[MULL]]
; CHECK:         [[STEP:%.*]] = shl i64 %multiplier, 1
; CHECK:         br label %for.body
for.body.lr.ph:                                   ; preds = %entry
  br label %for.body

; CHECK-LABEL: for.body:
; CHECK:         [[GEP:%.*]] = phi i32 addrspace(1)* [ [[GEP_PHI1]], %for.body.lr.ph ], [ [[GEP_PHI2:%.*]], %for.body ]
; CHECK:         %i.02 = phi i32 [ 39, %for.body.lr.ph ], [ %inc, %for.body ]
; CHECK:         store i32 11, i32 addrspace(1)* [[GEP]], align 4
; CHECK:         %inc = add nuw nsw i32 %i.02, 2
; CHECK:         %cmp = icmp slt i32 %inc, %n
; CHECK:         [[GEP_PHI2]] = getelementptr i32, i32 addrspace(1)* [[GEP]], i64 [[STEP]]
; CHECK:         br i1 %cmp, label %for.body, label %for.cond.for.end_crit_edge
for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %i.02 = phi i32 [ 39, %for.body.lr.ph ], [ %inc, %for.body ]
  %add = add nsw i32 %i.02, 5
  %zext = zext i32 %add to i64
  %idxprom = mul i64 %zext, %multiplier
  %arrayidx = getelementptr inbounds i32, i32 addrspace(1)* %p, i64 %idxprom
  store i32 11, i32 addrspace(1)* %arrayidx, align 4
  %inc = add nuw nsw i32 %i.02, 2
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.body, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.cond.for.end_crit_edge, %entry
  ret void
}

!igc.functions = !{!0}

!0 = !{void (i32 addrspace(1)*, i32, i64)* @test, !1}
!1 = !{!2}
!2 = !{!"function_type", i32 0}
