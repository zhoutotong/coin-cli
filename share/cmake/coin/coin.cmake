################################################################################
# coin.cmake
# - Config file for the Project package
# Some utils for coin
################################################################################
#[[
033[1;31;40m    <!--1-高亮显示 31-前景色红色  40-背景色黑色-->
033[0m          <!--采用终端默认设置，即取消颜色设置-->
显示方式  
0                终端默认设置
1                高亮显示
4                使用下划线
5                闪烁
7                反白显示
8                不可见

前景色            背景色           颜色
---------------------------------------
30                40              黑色
31                41              红色
32                42              绿色
33                43              黃色
34                44              蓝色
35                45              紫红色
36                46              青蓝色
37                47              白色
]]

string(ASCII 27 Esc)

# Esc[0;31m
set(R "${Esc}[0;31m")   # red
set(Y "${Esc}[1;33m")   # yellow
set(G "${Esc}[0;32m")   # green
#Esc[0m 
set(E "${Esc}[m" )        # color of end
set(B "${Esc}[1;34m")     # blue highlight
set(RB "${Esc}[1;31m") # red highlight

# message output
function(list2message msg)
    list(SUBLIST ARGV 1 -1 _list)
    foreach(_item ${_list})
        if(NOT "${${msg}}" STREQUAL "")
            set(${msg} "${${msg}} ${_item}")
        else()
            set(${msg} "${_item}")
        endif()
    endforeach()
    unset(_list)
    unset(_item)

    set(${msg} "${${msg}}" PARENT_SCOPE)
endfunction()

function(coin_info)
    list2message(str ${ARGV})
    message("${G}>> ${str}${E}")
endfunction()

function(coin_warn)
    list2message(str ${ARGV})
    message("${Y}!! ${str}${E}")
endfunction()

function(coin_error)
    list2message(str ${ARGV})
    message("${R}XX ${str}${E}")
endfunction()

function(coin_notice)
    list2message(str ${ARGV})
    message("${B}## ${str}${E}")
endfunction()

function(coin_fatal)
    list2message(str ${ARGV})
    message(FATAL_ERROR "${RB}** ${str}${E}")
endfunction()
