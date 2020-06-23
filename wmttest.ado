* Description: output Grouping t-means test to Stata interface, Word and LaTeX
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: wangmeiting92@gmail.com
* Created on May 7, 2020


program define wmttest
version 15.1

syntax varlist(numeric) [if] [in] [using/] , by(varname numeric) [ ///
	replace append Statistics(string) TItle(string) Alignment(string) PAGE(string)]


*--------设置默认格式------------
*Stata界面显示和Word输出默认格式
local N_default_fmt "%11.0f"
local others_default_fmt "%11.3f"

*LaTeX默认输出格式
local N_default_la_fmt "%11.0fc"
local others_default_la_fmt "%11.3fc"

*默认下会输出的统计量(界面、Word、LaTeX)
if "`statistics'" == "" {
	local statistics "N1 mean1 N2 mean2 mean_diff(star)"
}


*--------输入选项不合规的报错信息-------
if ("`replace'`append'"!="")&("`using'"=="") {
	dis "{error:replace or append can't appear when you don't need to output result to a file.}"
	exit
}

if ("`replace'"!="")&("`append'"!="") {
	dis "{error:replace and append cannot appear at the same time.}"
	exit
}

if (~ustrregexm("`using'",".tex"))&("`alignment'`page'"!="") { 
	dis "{error:alignment and page can only be used in the LaTeX output.}"
	exit
}


*---------前期语句处理----------
*普通选项语句的处理
if "`using'" != "" {
	local us_ing "using `using'"
}

if "`title'" == "" {
	local title "Grouping T-means test"
} //设置默认标题

local addnotes_stata ""
local addnotes_word ""
local addnotes_latex ""
if ustrregexm("`statistics'", "star") {
	local addnotes_stata `"addnotes("* p < 0.10, ** p < 0.05, *** p < 0.01")"'
	local addnotes_word `"addnotes("* \i p \i0 < 0.10, ** \i p \i0 < 0.05, *** \i p \i0 < 0.01")"'
	local addnotes_latex `"addnotes("$^{*}\ p < 0.10,\ ^{**}\ p < 0.05,\ ^{***}\ p < 0.01$")"'
} //依据是否有star设定表格标注

*构建esttab中cells("")内部的语句
//对`statistics'进行预处理
tokenize "`statistics'", parse("()")
local statistics ""
local i = 1
while "``i''" != "" {
	if (mod(`i'+1,4)==0) {
		local `i' = ustrregexra("``i''"," ","-")
	}
	if (mod(`i',4)==0) {
		local `i' "``i'' "
	}
	local statistics "`statistics'``i''"
	local `i' "" //置空`i'
	local i = `i' + 1
}
local statistics = ustrtrim("`statistics'")

//对`statistics'进行正式处理
tokenize "`statistics'"
local i = 1
while "``i''" != "" {
	local inp_`i' "``i''"
	local inp_pure_`i' = ustrregexrf("``i''","\(.*","")
	local `i' "" //将`i'置空
	local i = `i' + 1
} //分解"`statistics'"
local stat_num = `i' - 1 //记录要输出的统计量的总数

local N "count"   //以下几条local下面循环要用；这些也是该命令可以输出的全部统计量
local N1 "N_1"
local N2 "N_2"
local mean1 "mu_1"
local mean2 "mu_2"
local mean_diff "b"
local se "se"
local t "t"
local p "p"

local i = 1
local st ""                 //界面显示和Word输出中cells("")内部的语句
local stl ""                //LaTeX输出中cells("")内部的语句
local alignment_default ""  //LaTeX输出中alignment()内部的默认语句

while "`inp_pure_`i''" != "" {
	if ustrregexm("`inp_pure_`i''", "\bN\w*") {
		local default_fmt "`N_default_fmt'"
		local default_la_fmt "`N_default_la_fmt'"
		local alignment_default "`alignment_default'>{$}c<{$}"
	}
	else {
		local default_fmt "`others_default_fmt'"
		local default_la_fmt "`others_default_la_fmt'"
		local alignment_default "`alignment_default'D{.}{.}{-1}"
	}
	if ustrregexm("`inp_`i''", "\("){
		local fmt = ustrregexrf("`inp_`i''",".*\(","") //将左括号及之前的内容移除
		local fmt = ustrregexrf("`fmt'","\)","") //将右括号移除
		local fmt = ustrregexra("`fmt'","-+"," ") //将"-"号替换成空格
		tokenize "`fmt'"
		local j = 1
		local fmt_st ""
		while "``j''" != "" {
			if "``j''" == "star" {
				local fmt_st "`fmt_st'star "
			}
			else {
				local fmt_st "`fmt_st'fmt(``j'') "
			}
			local `j' ""  //将`j'置空
			local j = `j' + 1
		}
		local fmt_st = ustrtrim("`fmt_st'")
		if ustrregexm("`fmt_st'", "\d"){
			local st "`st'``inp_pure_`i'''(`fmt_st' label(`inp_pure_`i'')) "
			local stl "`stl'``inp_pure_`i'''(`fmt_st' label(\multicolumn{1}{c}{`inp_pure_`i''})) "
		}
		else {
			local st "`st'``inp_pure_`i'''(`fmt_st' fmt(`default_fmt') label(`inp_pure_`i'')) "
			local stl "`stl'``inp_pure_`i'''(`fmt_st' fmt(`default_la_fmt') label(\multicolumn{1}{c}{`inp_pure_`i''})) "
		}
	}
	else {
		local st "`st'``inp_pure_`i'''(fmt(`default_fmt') label(`inp_pure_`i'')) "
		local stl "`stl'``inp_pure_`i'''(fmt(`default_la_fmt') label(\multicolumn{1}{c}{`inp_pure_`i''})) "
	}
	local i = `i' + 1
}
local st = ustrtrim("`st'")
local stl = ustrtrim("`stl'")

*构建esttab中alignment()和page()内部的语句(LaTeX输出专属)
if "`alignment'" == "" {
	local alignment "math"
} //默认下LaTeX输出的列格式

if "`page'" != "" {
	local page ",`page'"
}

if "`alignment'" == "math" {
	local page "array`page'"
	local alignment "*{`stat_num'}{>{$}c<{$}}"
}
else {
	local page "array,dcolumn`page'"
	local alignment "`alignment_default'"
}
//加上array宏包可使得表格线之间的衔接没有空缺

*---------------------主程序----------------------------------
eststo clear
qui estpost ttest `varlist' `if' `in', by(`by')
esttab, cells("`st'") compress ///
	noobs nomti nonum starlevels(* 0.10 ** 0.05 *** 0.01) ///
	`addnotes_stata' title(`title') //Stata 界面显示
if ustrregexm("`us_ing'",".rtf") {
	esttab `us_ing', cells("`st'") compress `replace'`append' ///
		noobs nomti nonum starlevels(* 0.10 ** 0.05 *** 0.01) ///
		`addnotes_word' title(`title')	  
} //Word 显示
if ustrregexm("`us_ing'",".tex") { 
	esttab `us_ing', cells("`stl'") compress `replace'`append' ///
		starlevels(\sym{*} 0.10 \sym{**} 0.05 \sym{***} 0.01) ///
		noobs nomti nonum `addnotes_latex' title(`title') ///
		booktabs width(\hsize) page(`page') alignment(`alignment')
} //LaTeX 显示
end
