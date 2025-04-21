![gif1](https://github.com/user-attachments/assets/10fc2780-bfbc-4c72-8931-8a8aaa70f314)# Matlab4Ltspice
Analysis and Plot .raw files from LTspice DPT Test by MATLAB
`Author :PNJIE`
`DATE: 2025/04/21`
`V0.0`
# Preface
This project is designed for processing LTspice .raw files by matlab, including Dynamic calculation and PLOT, some of the script is based on the project LTspice2Matlab:
[PeterFeicht/ltspice2matlab: LTspice2Matlab - Import LTspice data into MATLAB](https://github.com/PeterFeicht/ltspice2matlab)

# Using Princple
## Schematic
Due to LTspice varies its net name every simulation, the core net name need to be pinned by manually name the net, In this project the schematic name must be totally same as the reference shematic "CREE_ROOT.asc", which means you can not change the red part of the schematic including the red net name and name of the sampling components in the red suqare.
![image](https://github.com/user-attachments/assets/9c4f878b-6325-4d28-b2cc-25554c1c60cc)


## The name of .raw
The function parseFilename processing the file name and extract the setting information including: 
* The Project name
* Ron(0.1ohm) Roff(0.1ohm) 3 digits
* Von(0.1V) Voff(0.1V) 3 digits
* ID(1A) 3 digits
* VD(1V) 4 digits
So the name 
"CREE4pin_Ron100_Roff100_Von150_Voff040_ID040_VD0800.raw"
means the project CREE4Pin, Ron = Roff = 10.0ohm, Von =15V, Voff = -4V, ID = 40A, VD = 800V.
The name of the .raw file should be totally same as the example:

CREE4pin\_**Ron**100\_**Roff**100\_**Von**150\_**Voff**040\_**ID**040\_**VD**0800.raw

The bolded content should not be modified, and the digits should equal to the example.

# How to use 
## MATAPP:
Download RawPlot.mlappinstall and install the matlab app, The function explaination is :
![image](https://github.com/user-attachments/assets/629651e0-86a4-4631-a378-8c8940bbd50a)


## Matlab script
Download all the .m files and see main: try main to see how each function uses:
![image](https://github.com/user-attachments/assets/56c3185e-9a9b-44cd-ba09-df450fe19f3b)


## Function Preview

### MATLAB APP
![gif1](https://github.com/user-attachments/assets/b6b73d4c-c391-4929-a08a-af941358ac8f)

### .M Function
![动画2](https://github.com/user-attachments/assets/5f2955af-6bce-4bd9-89b1-4ee8c9d0c537)

# 前言 
该项目旨在使用Matlab处理LTspice的.raw文件，包括动态计算和绘图，部分脚本基于LTspice2Matlab项目： [PeterFeicht/ltspice2matlab: LTspice2Matlab - 将LTspice数据导入MATLAB](https://github.com/PeterFeicht/ltspice2matlab) 
# 使用原则 
## 电路图 
由于LTspice在每次仿真中都会改变网络名称，因此核心网络名称需要手动命名。在本项目中，电路图名称必须与参考电路图"CREE_ROOT.asc"完全相同，这意味着您不能更改电路图中的红色部分，包括红色网络名称和采样组件的名称。 
![image](https://github.com/user-attachments/assets/9c4f878b-6325-4d28-b2cc-25554c1c60cc)
## .raw文件名称 
函数parseFilename处理文件名称并提取设置信息，包括： 
* 项目名称
* Ron（0.1欧姆）Roff（0.1欧姆）3位数字
* Von（0.1V）Voff（0.1V）3位数字
* ID（1A）3位数字
* VD（1V）4位数字 因此，名称 "CREE4pin_Ron100_Roff100_Von150_Voff040_ID040_VD0800.raw" 表示项目CREE4Pin，Ron = Roff = 10.0欧姆，Von = 15V，Voff = -4V，ID = 40A，VD = 800V。 .raw文件的名称应该与示例完全相同： CREE4pin\_**Ron**100\_**Roff**100\_**Von**150\_**Voff**040\_**ID**040\_**VD**0800.raw 粗体内容不得修改，数字应等于示例。 
# 使用方法 
## MATAPP： 
下载RawPlot.mlappinstall并安装Matlab应用程序，函数解释如下：
![image](https://github.com/user-attachments/assets/629651e0-86a4-4631-a378-8c8940bbd50a)
## Matlab脚本 下载所有.m文件并查看main函数：尝试main函数以查看每个函数的使用方法： 
![image](https://github.com/user-attachments/assets/56c3185e-9a9b-44cd-ba09-df450fe19f3b)
### MATLAB APP
![gif1](https://github.com/user-attachments/assets/b6b73d4c-c391-4929-a08a-af941358ac8f)

### .M函数 
![动画2](https://github.com/user-attachments/assets/5f2955af-6bce-4bd9-89b1-4ee8c9d0c537)
