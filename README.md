# Stata 命令 wmttest 的更新

> 作者：王美庭  
> Email: wangmeiting92@gmail.com

## 一、引言

感谢 Daniel 用户发邮件提示我该命令缺少了类似 `welch` 的选项。在此基础上我对命令做了如下更新：

- 增加了选项 `unequal`、`welch`、`listwise` 和 `casewise`。
- 消除了 `eststo` 命令对输出结果的影响。

同时我也更新了本文档（旧文档参见 [Stata 新命令：wmttest——分组 T 均值检验表格的输出](https://mp.weixin.qq.com/s/8w22ms0AttN1TqQZyN9dUA)），详情如下：

本文介绍的`wmttest`的命令，可以将分组 T 均值检验输出至 Stata 界面、Word 的 .rtf 文件和 LaTeX 的.tex 文件。基于`esttab`内核，`wmttest`不仅具有了`esttab`的优点，同时也简化了书写语法。

本文阐述的 `wmttest` 命令，和已经推出的 `wmtsum`、`wmtcorr`、`wmtreg`、`wmtmat`、`table2` 和 `tabstat2` 命令，都可以通过`append`选项将结果输出至一个 Word 或 LaTeX 文件中。

值得注意的是，该命令仅能使用于 15.1 及以上版本的 Stata 软件中。

## 二、命令的安装

`wmttest`及本人其他命令的代码都托管于 GitHub 上，读者可随时下载安装这些命令。

你可以通过系统自带的`net`命令进行安装：

```stata
net install wmttest, from("https://raw.githubusercontent.com/Meiting-Wang/wmttest/master")
```

也可以通过我所写的命令 `wmt` 进行安装：

```stata
wmt install wmttest
```

> `wmt` 命令可以查询并安装所有我写过的命令。该命令本身可以通过 `net install wmt, from("https://raw.githubusercontent.com/Meiting-Wang/wmt/main")` 进行安装。更多细节参见 [Stata 新命令：wmt——查询并安装个人写的 Stata 新命令](https://mp.weixin.qq.com/s/P2V_6et9crS5GeNNfO-6xQ)。

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
  - `unequal`: 设定分组的样本具有不同的方差，并使用 Satterthwaite's approximation formula(1946) 来计算近似的自由度。
  - `welch`: 设定分组的样本具有不同的方差，并使用 Welch's formula(1947) 来计算近似的自由度。
  - `listwise`: 如果观测值中有至少一个变量为缺漏值，则该观测值不会被用于该命令的计算中。
  - `casewise`: 等同于 `listwise` 选项。
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
wmttest price rep78 weight mpg, by(foreign) unequal //依据foreign对变量进行分组 T 均值检验，同时添加unequal选项
wmttest price rep78 weight mpg, by(foreign) welch //依据foreign对变量进行分组 T 均值检验，同时添加welch选项
wmttest price rep78 weight mpg, by(foreign) s(mean1(%9.2f) mean2 p(star 4)) //自定义统计量及其数值格式和显著性星号标注的位置
wmttest price rep78 weight mpg, by(foreign) ti(This is a special title) //自定义标题
wmttest price rep78 weight mpg using Myfile.rtf, replace by(foreign) //将结果输出至 Word
wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign) //将结果输出至 LaTeX
wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign) a(dot) //将 LaTeX 列表格格式设置为小数点对齐
```

> 以上所有实例都可以在`help wmttest`中直接运行。
>
> ![](https://cdn.jsdelivr.net/gh/Meiting-Wang/pictures/picgo/picgo-20210920020018.png)



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

> 点击【阅读原文】可进入该命令的 github 项目。
