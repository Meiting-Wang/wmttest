{smcl}

{* -----------------------------title------------------------------------ *}{...}
{p 0 17 2}
{bf:[W-2] wmttest} {hline 2} Output grouping T-means test to Stata interface, Word as well as LaTeX. The source code can be gained in {browse "https://github.com/Meiting-Wang/wmttest":github}.


{* -----------------------------Syntax------------------------------------ *}{...}
{title:Syntax}

{p 8 8 2}
{bf:wmttest} {it:varlist} [{it:if}] [{it:in}] [using {it:filename}] , by({it:groupvar}) [{it:other_options}]

{p 4 4 2}
where the subcommands can be :

{p2colset 5 20 24 2}{...}
{p2col :{it:subcommand}}Description{p_end}
{p2line}
{p2col :{opt {help varlist}}}a list of numeric variables{p_end}
{p2col :{opt {help using}}}output the result to Word with .rtf file or LaTeX with .tex file{p_end}
{p2line}
{p2colreset}{...}


{* -----------------------------Contents------------------------------------ *}{...}
{title:Contents}

{p 4 4 2}
{help wmttest##Description:Description}{break}
{help wmttest##Options:Options}{break}
{help wmttest##Examples:Examples}{break}
{help wmttest##Author:Author}{break}
{help wmttest##Also_see:Also see}{break}


{* -----------------------------Description------------------------------------ *}{...}
{marker Description}{title:Description}

{p 4 4 2}
{bf:wmttest}, based on esttab, can output grouped T-means test to Stata interface, Word as well as LaTeX. User can use this command easily due to its simple syntax. It is worth noting that this command can only be used in version 15.1 or later.

{p 4 4 2}
Users can also append the output from {bf:wmttest} to a existed word or LaTeX document,
which is more likely to be generated by {help wmtsum}, {help wmtcorr}, {help wmtreg} and {help wmtmat}.


{* -----------------------------Options------------------------------------ *}{...}
{marker Options}{title:Options}

{p2colset 5 28 32 2}{...}
{p2col :{it:option}}Description{p_end}
{p2line}
{p2col :For all}{p_end}
{p2col :{space 2}{bf:by(}{it:{help groupvar}}{bf:)}}groupvar should be a binary variable{p_end}
{p2col :{space 2}{opth s:tatistics(strings:string)}}{bf:N}, {bf:N1}, {bf:N2}, {bf:mean1}, {bf:mean2}, {bf:mean_diff}, {bf:se}, {bf:t} and {bf:p} can be included. You can set the format of every statistics, such as mean1(%9.3f), and set the location of the star, such as p(star){p_end}
{p2col :{space 2}{opth ti:tle(strings:string)}}Set the title for the table, {bf:Grouping T-means test} as the default{p_end}
{p2col :{space 2}{opt replace}}Replace a file if it already exists{p_end}
{p2col :{space 2}{opt append}}Append the result to a already existed file{p_end}

{p2col :For LaTeX only}{p_end}
{p2col :{space 2}{opth a:lignment(strings:string)}}Format the table columns in LaTeX, but it will not have influence on the Stata interface. {bf:math} or {bf:dot} can be included, {bf:math} as the default{p_end}
{p2col :{space 2}{bf:page(}{it:{help strings:string}}{bf:)}}Set the extra package for the LaTeX. Don't need to care about the package of booktabs, array and dcolumn, because option {bf:alignment} will deal with it automatically{p_end}
{p2line}
{p2colreset}{...}


{* -----------------------------Examples------------------------------------ *}{...}
{marker Examples}{title:Examples}

{p 4 4 2}Setup{p_end}
{p 8 8 2}. {stata sysuse auto.dta, clear}{p_end}

{p 4 4 2}Output Grouping T-means test for variables according to foreign{p_end}
{p 8 8 2}. {stata wmttest price rep78 weight mpg, by(foreign)}{p_end}

{p 4 4 2}Output Grouping T-means test of specified statistics and numeric format{p_end}
{p 8 8 2}. {stata wmttest price rep78 weight mpg, by(foreign) s(mean1(%9.2f) mean2 p(star 4))}{p_end}

{p 4 4 2}Add a custom title to the table{p_end}
{p 8 8 2}. {stata wmttest price rep78 weight mpg, by(foreign) ti(This is a custom title)}{p_end}

{p 4 4 2}Output the result to a .rtf file{p_end}
{p 8 8 2}. {stata wmttest price rep78 weight mpg using Myfile.rtf, replace by(foreign)}{p_end}

{p 4 4 2}Output the result to a .tex file{p_end}
{p 8 8 2}. {stata wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign)}{p_end}

{p 4 4 2}Format table column in LaTeX to decimal point alignment{p_end}
{p 8 8 2}. {stata wmttest price rep78 weight mpg using Myfile.tex, replace by(foreign) a(dot)}{p_end}


{* -----------------------------Author------------------------------------ *}{...}
{marker Author}{title:Author}

{p 4 4 2}
Meiting Wang{break}
School of Economics, South-Central University for Nationalities{break}
Wuhan, China{break}
wangmeiting92@gmail.com


{* -----------------------------Also see------------------------------------ *}{...}
{marker Also_see}{title:Also see}

{space 4}{help esttab}(already installed)  {col 40}{stata ssc install estout:install esttab}(to install)
{space 4}{help wmtsum}(already installed)  {col 40}{stata github install Meiting-Wang/wmtsum:install wmtsum}(to install)
{space 4}{help wmtcorr}(already installed) {col 40}{stata github install Meiting-Wang/wmtcorr:install wmtcorr}(to install)
{space 4}{help wmtreg}(already installed)  {col 40}{stata github install Meiting-Wang/wmtreg:install wmtreg}(to install)
{space 4}{help wmtmat}(already installed)  {col 40}{stata github install Meiting-Wang/wmtmat:install wmtmat}(to install)
