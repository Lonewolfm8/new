#ifndef LIB_CONVERSION_UTILS_H_
#define LIB_CONVERSION_UTILS_H_

#include "mlir/include/mlir/Transforms/DialectConversion.h"  // from @llvm-project

namespace mlir {
namespace heir {

// Adds the standard set of conversion patterns for
// converting types involved in func, cf, etc., which
// don't depend on the logic of the dialect beyond the
// type converter.
void addStructuralConversionPatterns(TypeConverter &typeConverter,
                                     RewritePatternSet &patterns,
                                     ConversionTarget &target);

}  // namespace heir
}  // namespace mlir

#endif  // LIB_CONVERSION_UTILS_H_
