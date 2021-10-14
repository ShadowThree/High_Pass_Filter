## 功能

1. 通过 `MATLAB` 产生一组数据
2. 将 `MATLAB` 产生的数据通过 `C` 程序进行高通滤波
3. 通过 `MATLAB` 对 `C` 程序滤波后的数据进行验证

## 文件说明

```C
C_program/
    main.c						// 实现高通滤波算法
HP_100taps_FIR_coeff.fcf 		// 由 MATLAB 的 fdatool 产生的 FIR 滤波器系数
HP_tap100_result.csv			// MCU 实际采集的加速度数据以及进行滤波后的数据
Readme.md  						// 说明文档
Verify_HP.m						// MATLAB 代码
result.txt  					// 由上面的 main.c 对模拟数据滤波后的结果
sin_data.h						// 由 MATLAB 生成的一个包含滤波器系数及模拟数据的 C 头文件
```

## 使用说明

1. 打开 `MATLAB` 输入 `fdatool` （也叫 `filterDesigner`）命令，通过如下参数生成滤波器系数：

（`File` --> `Export...` --> `Export to` `Coefficient File(ASCII)` ），就是 `HP_100taps_FIR_coeff.fcf` 文件）

![image-20211014195955282](C:\Users\shado\AppData\Roaming\Typora\typora-user-images\image-20211014195955282.png)

2. 将上一步产生的 `HP_100taps_FIR_coeff.fcf` 文件的 `Numerator:` 这行注释掉；
3. 将 `Verify_HP.m` 文件的 `PROCESS_CONTROL_FLAG` 值改为 `0`，然后在 `MATLAB` 中执行 `Verify_HP.m` 文件。这时将更新 `sin_data.h` 文件的数据，即模拟数据以及滤波参数。（`sin_data.h` 文件中两个数组的最后一个元素后多了一个逗号，需要去掉）
4. 通过 `gcc -Wall main.c ` 编译 `C` 语言，然后执行；这将更新 `result.txt` 文件，即滤波后的数据。
5. 将 `Verify_HP.m` 文件的 `PROCESS_CONTROL_FLAG` 值改为 `1`，然后在 `MATLAB` 中执行 `Verify_HP.m` 文件。将产生如下结果：（低频幅值明显降低了）

![image-20211014202307839](C:\Users\shado\AppData\Roaming\Typora\typora-user-images\image-20211014202307839.png)

6. 当 `MCU` 完成滤波后，将加速度原始数据和滤波后的数据按指定格式输出后存入 `HP_tap100_result.csv` 文件
7. 将 `Verify_HP.m` 文件的 `PROCESS_CONTROL_FLAG` 值改为 `2`，并且将 `acc_LEN` 的值改为实际采集的数据长度，然后在 `MATLAB` 中执行 `Verify_HP.m` 文件。得到如下结果：可以看到低频部分幅值明显降低了。

![image-20211014202935737](C:\Users\shado\AppData\Roaming\Typora\typora-user-images\image-20211014202935737.png)