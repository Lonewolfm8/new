// RUN: heir-opt --yosys-optimizer %s | FileCheck %s

// CHECK-LABEL: @ops
func.func @ops(
    %arg0: !secret.secret<i3>,
    %arg1: !secret.secret<i3>,
    %arg2: !secret.secret<i3>,
    %arg3: !secret.secret<i3>) -> (!secret.secret<i3>) {
  %1 = secret.generic ins(%arg0, %arg1, %arg2, %arg3:
          !secret.secret<i3>, !secret.secret<i3>, !secret.secret<i3>, !secret.secret<i3>) {
  ^bb0(%a0: i3, %a1: i3, %a2: i3, %a3: i3):
    %0 = arith.subi %a0, %a1: i3
    %1 = arith.muli %a2, %a3: i3
    %2 = arith.andi %1, %a3: i3
    secret.yield %2 : i3
  } -> (!secret.secret<i3>)
  return %1 : !secret.secret<i3>
  // CHECK: secret.cast
  // CHECK-SAME: !secret.secret<i3> to !secret.secret<tensor<3xi1>>
  // CHECK: secret.cast
  // CHECK-SAME: !secret.secret<i3> to !secret.secret<tensor<3xi1>>
  // CHECK: secret.cast
  // CHECK-SAME: !secret.secret<i3> to !secret.secret<tensor<3xi1>>
  // CHECK: secret.cast
  // CHECK-SAME: !secret.secret<i3> to !secret.secret<tensor<3xi1>>

  // Main computation
  // CHECK: secret.generic
  // CHECK-COUNT-7: comb.truth_table
  // CHECK: secret.yield
  // CHECK-SAME: tensor<3xi1>

  // CHECK: secret.cast
  // CHECK-SAME: !secret.secret<tensor<3xi1>> to !secret.secret<i3>
  // CHECK: return
}
