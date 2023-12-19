# 定义变量
TOP_MODULE = top_module
DOT_FILE = top.dot

# 生成top.dot文件
show : $(TOP_MODULE).v
	yosys \
		-p "read -sv $(TOP_MODULE).v" \
		-p "hierarchy -top $(TOP_MODULE)" \
		-p "flatten" \
		-p "show"

	mv $(HOME)/.yosys_show.dot $(DOT_FILE)


# 默认目标
all: show