// RUN: %target-swift-emit-silgen -module-name preconcurrency -sdk %S/Inputs -I %S/Inputs -enable-source-import %s | %FileCheck %s

class C {
  @preconcurrency func f(_: Sendable) { }
  @preconcurrency static func g(_: Sendable) { }
}

@preconcurrency func f(_: Sendable) { }

// CHECK-LABEL: sil hidden [ossa] @$s14preconcurrency28testModuleMethodWithSendable3anyyyp_tF
func testModuleMethodWithSendable(any: Any) {
  // CHECK: function_ref @$s14preconcurrency1fyyypF : $@convention(thin) (@in_guaranteed Sendable) -> ()
  let _ = f

  // CHECK: function_ref @$s14preconcurrency1fyyypF : $@convention(thin) (@in_guaranteed Sendable) -> ()
  let _ = preconcurrency.f
  f(any)
  preconcurrency.f(any)
}

// CHECK-LABEL: sil hidden [ossa] @$s14preconcurrency30testInstanceMethodWithSendable1c3anyyAA1CC_yptF : $@convention(thin) (@guaranteed C, @in_guaranteed Any) -> () {
func testInstanceMethodWithSendable(c: C, any: Any) {
  // CHECK-LABEL: sil private [ossa] @$s14preconcurrency30testInstanceMethodWithSendable1c3anyyAA1CC_yptFyypcAFcfu_yypcfu0_
  // CHECK: class_method %1 : $C, #C.f : (C) -> (Sendable) -> ()
  let _ = c.f
  let _ = C.f
  let _ = C.g
  c.f(any)
}
