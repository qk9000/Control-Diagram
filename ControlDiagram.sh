#!/bin/bash
## **Control Flow** v1.2
### 示例一
#```
#./flowchart.sh.sh example/exmaple1.txt
#```
#![20211229_142333](example/20211229_142333.svg)
### 示例二
#```
#./flowchart.sh.sh example/exmaple2.txt
#```
#![20211229_135103](example/20211229_135103.svg)
### 示例三
#```
#./flowchart.sh.sh example/example3.txt
#```
#![20211228_140518](example/20211228_140518.svg)
### 示例四
#```
#./flowchart.sh.sh -c example/code.c example/code2.c
#```
#![20211228_140756](example/20211228_140756.svg)
### 示例五
#按反向被调用关系的顺序
#```
#./flowchart.sh.sh -c linux/
#```
### 示例六
#可以表达时序的泳道图
### 介绍
#在设计与开发中，工程、笔记、文档和图纸通常是关联的，但又是时空隔离的；对于复杂的画图方式、需要转换角度和一定重复工作，并且可能需要不断的修改、调整和重构，多少令人头疼。
#Control Flow希望帮助用户真正提高效率，同步完成这几件事情，引导用户在研究、设计与开发的过程中，已经在产生一定形式的输出，并且起到互补，帮助归纳，反哺的作用。希望让文档和图纸从一开始就变得有用起来。
#如果您不希望介入和控制，只需要对简单程序进行自动图形化，并且不关注整理图纸中的内容，这个工具可能更适合你：https://github.com/petersenna/codeviz
#如果您喜欢先画图，并自动生成代码框架，这些工具可能更适合你： [Flowgorithm - Flowchart Programming Language](http://flowgorithm.org/)、https://www.gituml.com/、 [Code Generation - Turn Your Diagram to Code - Software Ideas Modeler](https://www.softwareideas.net/code-generation-diagram-to-code) 
#如果您希望使用复杂的IDE，并具有行业认可的工具： Enterprise Architect （个人观点： 不迷信 UML，更关注用适当易懂的方式去传达意图）；轻量级推荐免费的Umbrello、亿图和Topology
#如果您希望在图纸中更细致地添加个性、多样的修饰，这些工具可能更适合你： [GitHub - jgraph/drawio-desktop: Official electron build of diagrams.net](https://github.com/jgraph/drawio-desktop) 、 [yEd - Graph Editor (yworks.com)](https://www.yworks.com/products/yed) 
#如果您希望自己再次借鉴目前已有的开源工具，可以参考： [GitHub - antvis/G6: ♾ A Graph Visualization Framework in JavaScript](https://github.com/antvis/G6) 、 [GitHub - mingrammer/diagrams: Diagram as Code for prototyping cloud system architectures](https://github.com/mingrammer/diagrams) 、 [GitHub - adrai/flowchart.js: Draws simple SVG flow chart diagrams from textual representation of the diagram](https://github.com/adrai/flowchart.js) 、PlantUML、Mermaid、Graphviz和多种Markdown工具
### 运行环境
#Based on Linux console，graphviz（for 图纸），cflow（for 文本）。
#Debian-based：
#```
#apt install gawk graphviz cflow
#```
#Windows环境下可以运行，目录“for windows”已提供MingW安装包，和运行环境：
#选项1，
#```
#cd [Directory of ControlFlow]
#export PATH=`pwd`/for_windows/env:$PATH
#```
#选项2，
#也可以简单将需要的cflow或浏览器的可执行文件拷贝到“C:\Program Files\Git\usr\bin\”或“C:\Windows\System32\”。
### 命令
#```
#$ flowchart.sh
#-d <[TB|LR]> - direction (default is TB) (example: '-d LR')
#-D <num> - depth
#-f <name> - function name (-f '' means all functions)
#-F <string [string]> - strings to filter out
#-c <code-file> - input file is raw code
#-s enable swimlane
#-r reverse flow as order as called by
#```
### 语法
#缩进可以使用4个空格，也可以使用Tab。
#| 无符号       | 图形                                   |
#| ------------ | -------------------------------------- |
#| 无（仅缩进） | invoke flow（程序）or associate（UML） |
#下面的符号需要空格作为与内容之间的分隔符
#| 符号 | 图形                                                                           |
#| ---- | ------------------------------------------------------------------------------ |
#| `+`  | 标题模块(支持多个'+'，即多层)，但其下方不应存在跨模块连接                      |
#| `:`  | 条件判断                                                                       |
#| `<`  | invoked flow（程序）or associated by（UML）                                    |
#| `~`  | asynchronous transmission（程序）or depend（UML）                              |
#| `<~` | backward asynchronous transmission（程序）or depended by（UML）                |
#| `#`  | 批注框                                                                         |
#| `!`  | customize color (default/darkgoldenrod/deeppink/darkgreen/darkviolet/blue/...) |
#| `!`  | customize color (default/red/blue/green/yellow/orange/pink/gray/purple)        |
#| `-`  | queue up with no line                                                          |
#| `--` | queue up with line                                                             |
#| `=`  | link                                                                           |
#| `{`  | aggregation（UML）                                                             |
#| `{{` | composition（UML）                                                             |
#| `^`  | extend（UML）                                                                  |
#| `^^` | implement（UML）                                                               |
#| 连接符 | 图形                              |
#| ------ | --------------------------------- |
#| `/_`   | subcell (can have multiple ones)  |
#| `/|`   | paracell (can have multiple ones) |
#| `//`   | 连线上的文字                      |
#| `/-`   | 换行 (can have multiple ones)     |
#| 前缀      | 内部单元的别名                             |
#| --------- | ------------------------------------------ |
#| `<alias>` | define an alias of the subcell or paracell |
#| 后缀       | 指向内部单元的别名                    |
#| ---------- | ------------------------------------- |
#| `/> alias` | refer to a subcell or paracell        |
# flowchart -- Generate a flowchart of a specified function or all contents in specified file/directory
# -- Based on cflow(text) or graphviz(graph)
# Usage:
# $ flowchart
#   -D depth
#   -f function name
#   -F strings to filter out
# 关系                           | 方向
# -------------------------------------
# 依赖（求助）（公交），不同宗   | 正
# 关联（控制）（轿车），不同宗   | 正
# 聚合（附属）（戒指），不同宗   | 反
# 组合（融合）（假肢），不同宗   | 反
# 继承（扩展）（同源），同宗     | 反
# 实现（含有）（体内），自身     | 反
# C语言结构体数据关系图（生命周期的关联关系由弱到强）
# -------------------------------------
# 依赖 - 主体，链接不同宗的公用主体，与主体的生命周期完全无关
# 关联 - 主体，链接不同宗的专用主体，与主体的生命周期部分相关
# 聚合 - 链接的成员，与主体的生命周期部分相关
# 组合 - 链接的成员，与主体的生命周期高度重合
# 继承 - 衍生的主体
# C语言模块对象关系图
# -------------------------------------
# 依赖 - 主体，引用不同宗的公用主体，与主体的生命周期完全无关
# 关联 - 主体，引用不同宗的专用主体，与主体的生命周期部分相关
# 聚合 - 引用的成员，与主体的生命周期部分相关
# 组合 - 引用的成员，与主体的生命周期高度重合
# 继承 - 衍生的主体
# 实现 - 实现的主体或成员
# 先看宗亲或从属关系，再看密切程度
# ! - color - (node)(default/lightpink/darkgreen/violet/skyblue)
# = - module_attach (head)
# # - comment
# : - choose
#   - invoke（程序）or link
# < - invoked or linked
# ~ - affect（程序）or depend
# <~ - affected or depended
# { - 聚合
# {{ - 组合
# ^ - 继承
# ^^ - 实现
# - - next
# +_ - subcell (multipliable)
# +| - paracell (multipliable)
# <aliase> - cell alias (prefix)
# /> aliase - point to alias (postfix)
# // - label
# | - EOL
# 缩进使用4个空格
OS=$(uname)
CDIR=$(dirname $(echo "${BASH_SOURCE[0]}"))
if [[ "${CDIR}" == "." ]]; then
    CDIR=`pwd`"/"
elif [[ "${CDIR}" =~ ^[^/] ]]; then
	CDIR=`pwd`"/""${CDIR}"
fi
#TDIR="/tmp"
TDIR=`pwd`/out
#read -r -e -p "Output directory: " TDIR
#TDIR="/media/sf_Downloads"
mkdir -p "${TDIR}"
PIC_TYPE=jpg
#PIC_TYPE=png
PIC_TYPE2=svg
func=
dir=
depth=
# 增加'-b'后, 省略相同的调用流程
brief="-b"
# Specify the symbols you not concern with space as decollator here
#filterstr="${FLOWCHART_FILTER_STR}"
filterstr="printk printf ASSERT"
browser_opt=
text=""
BROWSER=""
# Have same effect on direction to connect next node
direction="TB"
shape="record"
# output: dot, flame
output="dot"
font="Consolas"
#font="times"
cluster_font="Consolas:bold"
#cluster_font="times:bold"
bgcolor="white"
line_color="black"
choose_color="beige"
cell_color="#ffffbf"
equal_color="mediumseagreen"
reverse=""
swimlane="no"

# Usage
function usage
{
    echo ""
    echo "  $0 "
    echo ""
    echo "   -d <[TB|LR]> - direction (default is TB) (example: '-d LR')"
    echo "   -D <num> - depth"
    echo "   -f <name> - function name (-f '' means all functions)"
    echo "   -F <string [string]> - strings to filter out"
    echo "   -c <code-file> - input file is raw code"
    echo "   -s enable swimlane"
    echo "   -S disable swimlane"
    echo "   -r reverse flow as order as called by"
    echo ""
}

while getopts "b:Bd:D:f:F:rscw:h" opt;
do
    case $opt in
        b)
            BROWSER=$OPTARG
        ;;
        B)
            brief=""
        ;;
        d)
            direction=$OPTARG
        ;;
        D)
            depth=$OPTARG
        ;;
        f)
            func=$OPTARG
        ;;
        F)
            filterstr="$filterstr $OPTARG"
        ;;
        r)
            reverse=1
        ;;
        s)
            swimlane="yes"
        ;;
        c)
            text=1
        ;;
        w)
            width=$OPTARG
        ;;
        h|?)
            usage $0;
            exit 1;
        ;;
    esac
done
shift $(($OPTIND - 1))

file="`find -L $@ -type f | tr '\n' ' '`"
_DATA=$(date '+%Y%m%d_%H%M%S')

if [[ $text == 1 ]]; then
    [ -n "$depth" ] && maxdepth=" -d $depth " || maxdepth=""
    if [[ "x${func}" == "x" ]]; then
        calltree="-A $brief $maxdepth"
    else
        calltree="$brief $maxdepth -m ${func}"
    fi
    which cflow >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: cflow doesn't exist, please install it..."
        exit 1
    fi
    # '-i' include, 's' means include static, '^s' means not include static, '_' includes symbols whose names begin with an underscore, 'x' includes both global and static
    if [[ -z $reverse ]]; then
        cflow           --omit-arguments --omit-symbol-names -i _ ${calltree} --level-indent 4 --level 0='    ' --level 1='    ' --level end0='    ' --level end1='    ' ${file} | sed "s?^    ??" | sed "s? <.*\$??" |                           grep -vwE "^\W*${filterstr// /|^\\W*}" > ${TDIR}/${_DATA}.txt
    else
        cflow --reverse --omit-arguments --omit-symbol-names -i _ ${calltree} --level-indent 4 --level 0='    ' --level 1='    ' --level end0='    ' --level end1='    ' ${file} | sed "s?^    ??" | sed "s? <.*\$??" | sed "s?^\(\s\+\)?\1< ?" | grep -vwE "^\W*${filterstr// /|^\\W*}" > ${TDIR}/${_DATA}.txt
    fi
    file=${TDIR}/${_DATA}.txt
fi

which dot >/dev/null 2>&1
[ $? -ne 0 ] && "Error: dot doesn't exist, please install graphviz..."
pic=${_DATA}.${PIC_TYPE}
pic2=${_DATA}.${PIC_TYPE2}
long_pic=${TDIR}/${pic}
long_pic2=${TDIR}/${pic2}
[ ! -n "$depth" ] && maxdepth=0 || maxdepth=$depth
cat ${file} | expand -t 4 -i \
| grep -vE ^\s*$ \
| grep -vwE "^\W*${filterstr// /|^\\W*}" \
| gawk -v fstr="$filterstr" \
	  -v output="$output" \
	  -v direction="$direction" \
	  -v bgcolor="$bgcolor" \
	  -v shape="$shape" \
	  -v font="$font" \
	  -v swimlane="$swimlane" \
	  -v line_color="$line_color" \
	  -v choose_color="$choose_color" \
	  -v cluster_font="$cluster_font" \
	  -v cell_color="$cell_color" \
	  -v equal_color="$equal_color" \
	  -v maxdepth=$maxdepth \
	  -f ${CDIR}/ControlDiagram.awk \
> ${TDIR}/${_DATA}.tmp
cat ${TDIR}/${_DATA}.tmp | dot -T${PIC_TYPE} -o "${long_pic}"
cat ${TDIR}/${_DATA}.tmp | dot -T${PIC_TYPE2} -o "${long_pic2}"

#if [ "x$BROWSER" == "x" ]; then
#	if [ "x$OS" == "xDarwin" ]; then
#		BROWSER=/Applications/Safari.app/Contents/MacOS/Safari
#	elif [[ "$OS" =~ ^MINGW ]]; then
#		BROWSER=LanGuang
#	else
#		which firefox >/dev/null 2>&1
#		if [ $? -eq 0 ]; then
#			BROWSER=firefox
#			#if [`id -u` -eq 0 ]; then
#			#	# Enable to open firefox as root
#			#	mkdir -p ~/.Xauthority
#			#	chown root: ~/.Xauthority
#			#	export XAUTHORITY=~/.Xauthority
#			#fi
#		else
#			BROWSER=chromium-browser
#		fi
#	fi
#fi
#which $BROWSER >/dev/null 2>&1
#[ $? -ne 0 ] && exit 0
#if [[ "$BROWSER" == "google-chrome" ]]; then
#	browser_opt="--no-sandbox"
#fi
#if [[ "$BROWSER" == "FirefoxPortable" ]]; then
#	$BROWSER $browser_opt file:///"${long_pic}" >/dev/null 2>&1 &
#else
#	$BROWSER $browser_opt "${long_pic}" >/dev/null 2>&1 &
#fi
