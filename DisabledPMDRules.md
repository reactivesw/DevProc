## 不需要的PMD检查规则
1. ShortClassName 最小类名的长度改成3
2. LawOfDemeter 与GRPC服务自动生成的调用方式不符，故去掉
3. DataflowAnomalyAnalysis 一个已经初始化的对象，需要在一些条件下调用方法更新属性后回传，从而更新对象
4. ShortVariable 变量名改成最小长度为2
5. LongVariable 变量名改成最大长度为37
6. AtLeastOneConstructor 大部分controller和service不需要构造函数
7. LoosePackageCoupling 这个暂时不需要
8. MethodArgumentCouldBeFinal 参数没有必要是final的
