// RUN: heir-opt --color %s > %t
// RUN: FileCheck %s < %t

// This simply tests for syntax.

#my_poly = #polynomial.polynomial<1 + x**1024>
#ring1 = #polynomial.ring<cmod=463187969, ideal=#my_poly>
#ring2 = #polynomial.ring<cmod=33538049, ideal=#my_poly>
#rings = #bgv.rings<#ring1, #ring2>
#otherrings = #bgv.rings<#ring1>

// CHECK: module
module {
  func.func @test_multiply(%arg0 : !bgv.ciphertext<rings=#rings>, %arg1: !bgv.ciphertext<rings=#rings>) -> !bgv.ciphertext<rings=#rings> {
    %add = bgv.add(%arg0, %arg1) : !bgv.ciphertext<rings=#rings>
    %sub = bgv.sub(%arg0, %arg1) : !bgv.ciphertext<rings=#rings>
    %neg = bgv.negate(%arg0) : !bgv.ciphertext<rings=#rings>

    %0 = bgv.mul(%arg0, %arg1) : !bgv.ciphertext<rings=#rings> -> !bgv.ciphertext<rings=#rings, dim=3>
    %1 = bgv.relinearize(%0) {from_basis = array<i32: 0, 1, 2>, to_basis = array<i32: 0, 1> } : (!bgv.ciphertext<rings=#rings, dim=3>) -> !bgv.ciphertext<rings=#rings>
    %2 = bgv.modulus_switch(%1) {from_level = 1, to_level=0} : (!bgv.ciphertext<rings=#rings>) -> !bgv.ciphertext<rings=#rings, dim=2, level=0>
    // CHECK: <<cmod=463187969, ideal=#polynomial.polynomial<1 + x**1024>>, <cmod=33538049, ideal=#polynomial.polynomial<1 + x**1024>>>
    return %arg0 : !bgv.ciphertext<rings=#rings>
  }
}
