# Stata 新命令：wmttest——分组 T 均值检验表格的输出

> 作者：王美庭  
> Email: wangmeiting92@gmail.com

## 摘要

本文主要介绍了个人编写的可将分组 T 均值检验结果输出至 Stata 界面、Word 以及 LaTeX 的`wmttest`命令。

## 目录

- **摘要**
- **一、引言**
- **二、命令的安装**
- **三、语法与选项**
- **四、实例**
- **五、输出效果展示**

## 一、引言

本文介绍的`wmttest`的命令，可以将分组 T 均值检验输出至 Stata 界面、Word 的 .rtf 文件和 LaTeX 的.tex 文件。基于`esttab`内核，`wmttest`不仅具有了`esttab`的优点，同时也简化了书写语法。

本文阐述的`wmttest`命令，和已经或即将推出`wmtsum`、`wmtcorr`、`wmtreg`和`wmtmat`命令，都可以通过`append`选项成为一个整体，将输出结果集中于一个 Word 或 LaTeX 文件中。关于以上系列命令更多的优点，可参阅[「Stata 新命令：wmtsum——描述性统计表格的输出」](https://mp.weixin.qq.com/s/oLgXf0KTgoePOnN1mJUllA)。

## 二、命令的安装

`wmttest`命令以及本人其他命令的代码都将托管于 GitHub 上，以使得同学们可以随时下载安装这些命令。

首先你需要有`github`命令，如果没有，可参照[「Stata 新命令：wmtsum——描述性统计表格的输出」](https://mp.weixin.qq.com/s/oLgXf0KTgoePOnN1mJUllA)进行安装。

然后你就可以运行以下命令安装最新的`wmttest`命令以及对应的帮助文件了。

```stata
github install Meiting-Wang/wmttest
```

当然，你也可以`github search`一下，也能找到`wmttest`命令安装的入口：

```stata
github search wmttest
```

## 三、语法与选项

**命令语法**：

```stata
wmttest varlist [if] [in] [using filename] , by(groupvar) [other_options]
```

> - `varlist`: 至少需输入一个变量，且要求为数值型变量。
> - `using`: 可以将结果输出至 Word（ .rtf 文件）和 LaTeX（ .tex 文件）中。

**选项（options）**：

- 一般选项
  - `by()`：设置要基于分组的变量。
  - `statistics()`：可输入的统计量有`N`、`N1`、`N2`、`mean1`、`mean2`、`mean_diff`、`se`、`t`和`p`。默认为`N1 mean1 N2 mean2 mean_diff(star)`。我们也可以自定义每一个统计量的数值格式以及显著性星号所在的位置，如`N1(%9.0g) mean1(4) p(%9.3f star)`。如果输入的语句中包含`star`，则将以`* p < 0.10, ** p < 0.05, *** p < 0.01`的形式在对应的位置标注星号。
  - `title()`：设置表格标题，默认为`Grouping T-means test`。
  - `replace`：将结果输出至 Word 或 LaTeX 时，替换已有的文件。
  - `append`：将结果输出至 Word 或 LaTeX 时，可附加在已经存在的文件中。
- LaTeX 专有选项
  - `alignment()`：设置 LaTeX 表格的列对齐格式，可输入`math`或`dot`，`math`设置列格式为居中对齐的数学格式（自动添加宏包`booktabs`和`array`），`dot`表示小数点对齐的数学格式（自动添加宏包`booktabs`、`array`和`dcolumn`）。默认为`math`。
  - `page()`：可添加用户额外需要的宏包。

> 以上其中的一些选项可以缩写，详情可以在安装完命令后`help wmttest`。

## 四、实例

```stata
* 分组 T 均值检验结果输出实例
sysuse auto.dta, clear
wmttest price rep78 weight mpg, by(foreign) //依据foreign对变量进行分组 T 均值检验
wmttest price rep78 weight mpg, by(foreign) s(mean1(%9.2f) mean2 p(star 4)) //自定义统计量及其数值格式和显著性星号标注的位置
wmttest price rep78 weight mpg, by(foreign) ti(This is a special title) //自定义标题
wmttest price rep78 weight mpg using Myfile.rtf, replace by(foreign) //将结果输出至 Word
wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign) //将结果输出至 LaTeX
wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign) a(dot) //将 LaTeX 列表格格式设置为小数点对齐
```

> 以上所有实例都可以在`help wmttest`中直接运行。
> ![image](https://user-images.githubusercontent.com/42256486/81492102-e36dea00-92c7-11ea-9b3b-9ecd4a0478e6.png)

## 五、输出效果展示

- **Stata**

```stata
wmttest price rep78 weight mpg, by(foreign)
```

```stata
Grouping T-means test
---------------------------------------------------------------
                  N1     mean1        N2     mean2 mean_diff
---------------------------------------------------------------
price             52  6072.423        22  6384.682  -312.259
rep78             48     3.021        21     4.286    -1.265***
weight            52  3317.115        22  2315.909  1001.206***
mpg               52    19.827        22    24.773    -4.946***
---------------------------------------------------------------
* p < 0.10, ** p < 0.05, *** p < 0.01
```

- **Word**

```stata
wmttest price rep78 weight mpg using Myfile.rtf, replace by(foreign)
```

![image](https://user-images.githubusercontent.com/42256486/81492106-ed8fe880-92c7-11ea-97ea-224e47fea139.png)

- **LaTeX**

```stata
wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign)
```

![image](https://user-images.githubusercontent.com/42256486/81492116-f2549c80-92c7-11ea-9012-30b1fc094518.png)

```stata
wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign) a(dot)
```

![image](https://user-images.githubusercontent.com/42256486/81492118-f7195080-92c7-11ea-9a84-0f99b68e70f4.png)

> 在将结果输出至 Word 或 LaTeX 时，Stata 界面上也会呈现对应的结果，以方便查看。
