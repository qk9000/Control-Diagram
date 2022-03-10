# Should not substitute "|"
function comment_filter(l_comment, l_type) {
	# '<', '>', ':' have special meanings
	#l_comment = gensub(/[<]/, "◃", "g", l_comment);
	#l_comment = gensub(/[>]/, "▹", "g", l_comment);
	#l_comment = gensub(/[<][-]/, "⪡-", "g", l_comment);
	#l_comment = gensub(/[-][>]/, "-⪢", "g", l_comment);
	#l_comment = gensub(/[<][ ]/, "≺ ", "g", l_comment);
	#l_comment = gensub(/[ ][>]/, "≻ ", "g", l_comment);
	l_comment = gensub(/["]/, "‟", "g", l_comment);
	l_comment = gensub(/[']/, "‛", "g", l_comment);

	if (l_type == 1) {
		# EOL
		l_comment = gensub(/[ ][/][-][ ][/][-][ ]/, "\\\\n\\\\n", "g", l_comment);
		l_comment = gensub(/[ ][/][-][/][-][ ]/, "\\\\n\\\\n", "g", l_comment);
		l_comment = gensub(/[ ][/][-][ ]/, "\\\\n", "g", l_comment);

		#l_comment = gensub(/[)][ ]/, ")\\\\n ", "g", l_comment);
		#l_comment = gensub(/[-][ ]/, "-\\\\n ", "g", l_comment);
		#l_comment = gensub(/[:][ ]/, ":\\\\n ", "g", l_comment);
		l_comment = gensub(/[,][ ]/, ",\\\\n ", "g", l_comment);
		l_comment = gensub(/[.][ ]/, ".\\\\n ", "g", l_comment);
		l_comment = gensub(/[;][ ]/, ";\\\\n ", "g", l_comment);
		l_comment = gensub(/[?][ ]/, "?\\\\n ", "g", l_comment);
		l_comment = gensub(/[!][ ]/, "!\\\\n ", "g", l_comment);
		#l_comment = gensub(/[）]/,   "）\\\\n ", "g", l_comment);
		#l_comment = gensub(/[—][—]/, "——\\\\n ", "g", l_comment);
		#l_comment = gensub(/[：]/,   "：\\\\n ", "g", l_comment);
		l_comment = gensub(/[，]/,   "，\\\\n ", "g", l_comment);
		l_comment = gensub(/[。]/,   "。\\\\n ", "g", l_comment);
		l_comment = gensub(/[；]/,   "；\\\\n ", "g", l_comment);
		l_comment = gensub(/[？]/,   "？\\\\n ", "g", l_comment);
		l_comment = gensub(/[！]/,   "！\\\\n ", "g", l_comment);
		#l_comment = gensub(/[、]/,   "、\\\\n ", "g", l_comment);

		l_comment = l_comment "\\n "
	}
	else {
		# EOL
		l_comment = gensub(/[ ][/][-][ ][/][-][ ]/, "\\\\l\\\\l", "g", l_comment);
		l_comment = gensub(/[ ][/][-][/][-][ ]/, "\\\\l\\\\l", "g", l_comment);
		l_comment = gensub(/[ ][/][-][ ]/, "\\\\l", "g", l_comment);

		#l_comment = gensub(/[)][ ]/, ")\\\\l ", "g", l_comment);
		#l_comment = gensub(/[-][ ]/, "-\\\\l ", "g", l_comment);
		#l_comment = gensub(/[:][ ]/, ":\\\\l ", "g", l_comment);
		l_comment = gensub(/[,][ ]/, ",\\\\l ", "g", l_comment);
		l_comment = gensub(/[.][ ]/, ".\\\\l ", "g", l_comment);
		l_comment = gensub(/[;][ ]/, ";\\\\l ", "g", l_comment);
		l_comment = gensub(/[?][ ]/, "?\\\\l ", "g", l_comment);
		l_comment = gensub(/[!][ ]/, "!\\\\l ", "g", l_comment);
		#l_comment = gensub(/[）]/,   "）\\\\l ", "g", l_comment);
		#l_comment = gensub(/[—][—]/, "——\\\\l ", "g", l_comment);
		#l_comment = gensub(/[：]/,   "：\\\\l ", "g", l_comment);
		l_comment = gensub(/[，]/,   "，\\\\l ", "g", l_comment);
		l_comment = gensub(/[。]/,   "。\\\\l ", "g", l_comment);
		l_comment = gensub(/[；]/,   "；\\\\l ", "g", l_comment);
		l_comment = gensub(/[？]/,   "？\\\\l ", "g", l_comment);
		l_comment = gensub(/[！]/,   "！\\\\l ", "g", l_comment);
		#l_comment = gensub(/[、]/,   "、\\\\l ", "g", l_comment);

		l_comment = l_comment "\\l "
	}

	return l_comment;
}

function name_filter(l_node, l_type) {
	line_label = "";
	sub_cell = "";

	# Filter sub_cell and line-label
	loc_line_label = match(l_node, " [/][/] ");
	is_sub = 0;
	loc_sub_cell = match(l_node, " [/][_] ");
	if (loc_sub_cell > 0 ) {
		is_sub = 1;
	}
	else {
		loc_sub_cell = match(l_node, " [/][|] ");
		if (loc_sub_cell > 0) {
			is_sub = 2;
		}
	}

	if ((loc_line_label > 0) && ((loc_sub_cell <= 0) || (loc_line_label < loc_sub_cell)))
		name = substr(l_node, 1, loc_line_label - 1);
	else if ((loc_sub_cell > 0) && ((loc_line_label <= 0) || (loc_sub_cell < loc_line_label)))
		name = substr(l_node, 1, loc_sub_cell - 1);
	else
		name = l_node;

	# Space is acceptable
	#name = gensub(/[ \t]+$/, "", "g", name);
	mark = "";
	loc_mark = match(name, " [/][>] ");
	if (loc_mark > 0) {
		mark = ":" substr(name, loc_mark + 4);
		name = substr(name, 1, loc_mark - 1);
		#name = "\\\"" name "\\\"" ":" mark
	}
	name = comment_filter(name, l_type);
	# Direct newline look ugly
	#node = node gensub(/ [|] /, "\n\n", "g", sub_cell);
	#node = name gensub(/ [|] /, "\\\\n\\\\n", "g", sub_cell);

	if (loc_line_label > 0) {
		if (loc_sub_cell > loc_line_label) {
			line_label = substr(l_node, loc_line_label + 4, loc_sub_cell - loc_line_label - 4);
		}
		else {
			line_label = substr(l_node, loc_line_label + 4);
		}
		#line_label = gensub(/[ \t]+$/, "", "g", line_label);
		line_label = comment_filter(line_label, l_type);
	}

	if (loc_sub_cell > 0) {
		if (loc_line_label > loc_sub_cell) {
			sub_cell = substr(l_node, loc_sub_cell, loc_line_label - loc_sub_cell);
		}
		else {
			sub_cell = substr(l_node, loc_sub_cell);
		}
		#sub_cell = gensub(/[ \t]+$/, "", "g", sub_cell);
		sub_cell = comment_filter(sub_cell, l_type);
		sub_cell = gensub(/([^/])[|]/, "\\1│", "g", sub_cell);
		# For subcell in a choose node
		if (l_type == 1) {
			if (is_sub == 1) {
				node = name gensub(/ [/][_] /, "\\\\n", "g", sub_cell);
			}
			else if (is_sub == 2) {
				node = name gensub(/ [/][|] /, "\\\\n", "g", sub_cell);
			}

			node = name gensub(/ [|] /, "\\\\n", "g", sub_cell);
		}
		# Class nodes
		else {
			if (is_sub == 1) {
				sub_cell = gensub(/ [/][_] /, "\\\\l\\| ", "g", sub_cell);
			}
			else if (is_sub == 2) {
				sub_cell = gensub(/ [/][|] /, "\\\\l\\| ", "g", sub_cell);
			}

			node = name;

			if (is_sub == 1) {
				# Fix Bug: Miss the first chinese sentence in node declaration which has subcell, adding a space after '{' can fix it.
				#printf("\t\"%s\" [label=\"{ %s%s}\"];\n", node, name, sub_cell);
				if (direction == "TB") {
					printf("\t\"%s\" [label=\"{ %s%s}\"];\n", name, name, sub_cell);
				}
				else {
					printf("\t\"%s\" [label=\"%s%s\"];\n", name, name, sub_cell);
				}
			}
			else if (is_sub == 2) {
				#printf("\t\"%s\" [label=\"%s%s\"];\n", node, name, sub_cell);
				if (direction == "TB") {
					printf("\t\"%s\" [label=\"%s%s\"];\n", name, name, sub_cell);
				}
				else {
					printf("\t\"%s\" [label=\"{ %s%s}\"];\n", name, name, sub_cell);
				}
			}
		}
	}
	else {
		node = name;
	}

	return node;
}

#function print_subgraph(l_mod, l_node) {
function print_subgraph(l_node) {
	#if (l_mod != "") {
		#tmp_mod = gensub(/[^0-9A-Z_a-z]/, "_", "g", l_mod);
		#printf("\tsubgraph cluster_%s {fontname=\"%s\";fontsize=15;label=\"%s\";\"%s\";};\n", tmp_mod, cluster_font, l_mod, l_node);
	#}
	if (module_depth == 0) {
		return
	}
		#rank=min;
		printf("\tsubgraph cluster_%s {labeljust=l;color=purple;fontname=\"%s\";fontsize=15;label=\"%s\";", module_c, cluster_font, module);
	if (module_depth >= 2) {
		printf("\tsubgraph cluster_%s {labeljust=l;color=purple;fontname=\"%s\";fontsize=15;label=\"%s\";", module2_c, cluster_font, module2);
	}
	if (module_depth >= 3) {
		printf("\tsubgraph cluster_%s {labeljust=l;color=purple;fontname=\"%s\";fontsize=15;label=\"%s\";", module3_c, cluster_font, module3);
	}
	if (module_depth >= 4) {
		printf("\tsubgraph cluster_%s {labeljust=l;color=purple;fontname=\"%s\";fontsize=15;label=\"%s\";", module4_c, cluster_font, module4);
	}
	if (module_depth >= 5) {
		printf("\tsubgraph cluster_%s {labeljust=l;color=purple;fontname=\"%s\";fontsize=15;label=\"%s\";", module5_c, cluster_font, module5);
	}
		printf("\"%s\";", l_node);
	if (module_depth >= 5) {
		printf("};");
	}
	if (module_depth >= 4) {
		printf("};");
	}
	if (module_depth >= 3) {
		printf("};");
	}
	if (module_depth >= 2) {
		printf("};");
	}
		printf("};\n");
}

BEGIN {
	oldnodedepth = -1;
	oldnode = ""; nodep[-1] = ""; oldmark = ""; mark_a[-1] = "";
	nodefirst = 0;
	module    = "";
	module_c  = "";
	module2   = "";
	module2_c = "";
	module3   = "";
	module3_c = "";
	module_depth = 0;
	# 4 spaces per step
	nodebase = 4;
	oldswimlane = "";
	olddirection = "";
	tmp_cell_color = cell_color;
	tmp_choose_color = choose_color;

	# Print some setting info
	if (output == "dot") {
		printf("digraph G {\n");
		# line's location might not be re-arranged
		#printf("\tordering=out;\n");
		#printf("\tlayout=fdp;\n");
		#printf("\tclusterrank=global;\n");
		printf("\tcompound=true;\n");
		printf("\tlabeljust=l;\n");
		printf("\tratio=fill;\n");
		printf("\tesep=-0.4;\n");
		#printf("\tnodesep=0.25;\n");
		#printf("\tranksep=0.02;\n");
		printf("\tpack=false;\n");
		printf("\tpad=0.01;\n");
		printf("\tmodel=sgd;\n");
		printf("\tmaxiter=999;\n");
		printf("\tlevelsgap=-999;\n");
		printf("\tlen=0.01;\n");
		printf("\tminlen=0.01;\n");
		printf("\tdefaultdist=epsilon;\n");
		printf("\tK=0;\n");
		#printf("\tsep=0;\n");
		#printf("\tlabeldistance=0;\n");
		printf("\tbgcolor=%s;\n", bgcolor);
		printf("\tnode [shape=%s,fontname=%s,fontsize=9,fontcolor=black,color=\"#800000\",style=\"filled,rounded\",fillcolor=\"%s\"];\n",
			   shape, font, tmp_cell_color);
		printf("\tedge [fontname=%s,fontsize=9,fontcolor=black,arrowsize=1,penwidth=1,color=\"%s\"];\n", font, line_color);
	}
}
{
	# Get the node, and its depth(nodedepth)
	nodedepth = match($0, "[^[:space:]]");
	if (nodedepth == 0) {
		next;
	}
	else if (match($0, "^[#]") || match($0, "^[/][/]")) {
		if (match($0, "^[#][ \t]*-d[ \t]LR")) {
			direction="LR";
		}
		else if (match($0, "^[#][ \t]*-d[ \t]TB")) {
			direction="TB";
		}
		else if (match($0, "^[#][ \t]*-s")) {
			swimlane="yes";
		}
		next;
	}
	else if (nodedepth == 1) {
		# Reset root node as "none"
		nodep[0] = "";
		mark_a[0] = "";
		oldnodedepth = -1;
		nodefirst = 1;
	}

	if (swimlane != oldswimlane) {
		if (swimlane == "yes") {
			#printf("\tnewrank=false;\n");
			#printf("\tsplines=ortho;\n");
			printf("\tnewrank=true;\n");
			printf("\tsplines=polyline;\n");
		}
		else {
			#printf("\tsplines=line;\n");
			printf("\tsplines=spline;\n");
			printf("\trank=max;\n");
			printf("\tnodesep=2;\n");
			printf("\tranksep=0.2;\n");
		}
		oldswimlane = swimlane;
	}

	if (direction != olddirection) {
		printf("\trankdir=%s;\n", direction);
		olddirection = direction;
	}

	node = substr($0, nodedepth);
	nodedepth = nodedepth - 1;
	if (nodedepth == 0) {
		tmp_cell_color = cell_color;
		tmp_choose_color = choose_color;
		printf("\tedge [fontname=%s,fontsize=9,fontcolor=black,color=%s];\n",
			   font, line_color);
		printf("\tnode [shape=%s,fontname=%s,fontsize=9,fontcolor=black,color=\"#800000\",style=\"filled,rounded\",fillcolor=\"%s\"];\n",
			   shape, font, tmp_cell_color);
		# module
		if (match($0, "^[+] ")) {
			module   = substr($0, 3);
			module_c = gensub(/[^0-9A-Z_a-z]/, "_", "g", module);
			module_depth = 1;
			next;
		}
		else if (match($0, "^[+][+] ")) {
			module2   = substr($0, 4);
			module2_c = gensub(/[^0-9A-Z_a-z]/, "_", "g", module2);
			module_depth = 2;
			next;
		}
		else if (match($0, "^[+][+][+] ")) {
			module3    = substr($0, 5);
			module3_c  = gensub(/[^0-9A-Z_a-z]/, "_", "g", module3);
			module_depth = 3;
			next;
		}
		else if (match($0, "^[+][+][+][+] ")) {
			module4    = substr($0, 6);
			module4_c  = gensub(/[^0-9A-Z_a-z]/, "_", "g", module4);
			module_depth = 4;
			next;
		}
		else if (match($0, "^[+][+][+][+][+] ")) {
			module5    = substr($0, 7);
			module5_c  = gensub(/[^0-9A-Z_a-z]/, "_", "g", module5);
			module_depth = 5;
			next;
		}
		else {
			module_depth = 0;
		}
	}

	node = gensub(/[ \t]+$/, "", "g", node);

	nodedepth = int((nodedepth) / nodebase);

	if ((maxdepth > 0) && (nodedepth > maxdepth)) {
		next;
	}

	# If whose depth is 1 less than him, who is his parent
	if ((oldnodedepth != -1) && (nodedepth - oldnodedepth) >= 1) {
		step = nodedepth - oldnodedepth;
		nodep[nodedepth - step] = oldnode;
		mark_a[nodedepth - step] = oldmark;
	}

	n = gensub(/^[!] |^[#] |^[:] |^[=] |^[[] |^[-] |^[-][-] |^[<] |^[~] |^[<][~] |^[{] |^[{][{] |^[\\^] |^[\\^][\\^] /, "", "g", node);

	if (match(node, "^[!] ")) {
		if (n == "default") {
			tmp_cell_color = cell_color;
			tmp_choose_color = choose_color;
			printf("\tnode [shape=%s,fontname=%s,fontsize=9,fontcolor=black,color=\"#800000\",style=\"filled,rounded\",fillcolor=\"%s\"];\n", shape, font, tmp_cell_color);
			printf("\tedge [fontname=%s,fontsize=9,fontcolor=black,arrowsize=1,penwidth=1,color=\"%s\"];\n", font, line_color);
		}
		else {
			if (n == "red") {
				tmp_cell_color = "#ff5f5f";
			}
			else if (n == "blue") {
				tmp_cell_color = "#87d7ff";
			}
			else if (n == "green") {
				tmp_cell_color = "#87ffaf";
			}
			else if (n == "yellow") {
				tmp_cell_color = "#d7ff00";
			}
			else if (n == "orange") {
				tmp_cell_color = "#ffd700";
			}
			else if (n == "pink") {
				tmp_cell_color = "#ffd7ff";
			}
			else if (n == "gray") {
				tmp_cell_color = "#dadada";
			}
			else if (n == "purple") {
				tmp_cell_color = "#af87ff";
			}
			tmp_choose_color = tmp_cell_color;
			#printf("\tnode [shape=%s,fontname=%s,fontsize=12,fontcolor=white,color=\"#800000\",style=\"filled,rounded,bold\",fillcolor=\"%s\"];\n", shape, font, n);
			printf("\tnode [shape=%s,fontname=%s,fontsize=9,fontcolor=black,color=\"#800000\",style=\"filled,rounded\",fillcolor=\"%s\"];\n", shape, font, tmp_cell_color);
			printf("\tedge [fontname=%s,fontsize=9,fontcolor=black,arrowsize=1,penwidth=1,color=\"%s\"];\n", font, line_color);
		}
		next;
	}

	if (nodedepth == 0 || nodep[nodedepth - step] == "" || nodefirst == 1) {
		nodefirst = 0;
		n = name_filter(n, 0);
		print_subgraph(n);
	}
	else if (nodep[nodedepth - step] != "") {
		p_n = nodep[nodedepth - step];
		p_mark = mark_a[nodedepth - step];

		# comment
		if (match(node, "^[#] ")) {
			#n = name_filter(n, 1);
			#printf("\t\"%s\" [shape=note,style=\"dashed,filled\",fillcolor=aliceblue];\n", n);
			n = name_filter(n, 0);
			printf("\t\"%s\" [style=\"dashed,filled\",fillcolor=aliceblue];\n", n);
			#printf("\t\"%s\"%s -> \"%s\"%s [dir=none,label=\"%s\",style=dashed,arrowhead=none];{rank=same; \"%s\"%s; \"%s\"%s;};\n",
			#	   p_n, p_mark, n, mark, line_label, p_n, p_mark, n, mark);
			printf("\t\"%s\"%s -> \"%s\"%s [dir=none,label=\"%s\",style=dashed,arrowhead=none];\n",
				   p_n, p_mark, n, mark, line_label);
			#printf("\t\"%s\"%s -> \"%s\"%s [color=%s,arrowhead=none];\n",
			#	   n, mark, p_n, p_mark, bgcolor);
			print_subgraph(n);
		}
		## package
		#else if (match(node, "^[[] ")) {
		#	n = name_filter(n, 1);
		#	printf("\t\"%s\" [shape=tab,style=\"filled\",fillcolor=white];\n", n);
		#	print_subgraph(n);
		#}
		# choose
		else if (match(node, "^[:] ")) {
			n = name_filter(n, 1);
			printf("\t\"%s\" [shape=diamond,fontname=%s,fontsize=9,fontcolor=black,color=\"#800000\",style=\"filled,rounded\",fillcolor=\"%s\"];\n",
				   n, font, tmp_choose_color);
			printf("\t\"%s\"%s -> \"%s\"%s [label=\"%s\",style=solid,arrowhead=curve];\n", p_n, p_mark, n, mark, line_label);
			print_subgraph(n);
		}
		## link to another module
		#else if (match(node, "^[+] ")) {
		#	module_attach = name_filter(n, 0);
		#	next;
		#}
		# next - same as invoke
		else if (match(node, "^[-] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [color=%s,arrowhead=none];\n",
				   p_n, p_mark, n, mark, bgcolor);
			print_subgraph(n);
		}
		else if (match(node, "^[-][-] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [style=solid,arrowhead=none];\n",
				   p_n, p_mark, n, mark);
			print_subgraph(n);
		}
		# trigger or 依赖
		else if (match(node, "^[~] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [label=\"%s\",style=dashed,arrowhead=curve];\n", p_n, p_mark, n, mark, line_label);
			if (module_attach != "") {
				printf("\t\"%s\" -> \"%s\" [style=dashed,arrowhead=curve];\n", n, module_attach" "name);
				module_attach = "";
			}
			print_subgraph(n);
		}
		# triggered
		else if (match(node, "^[<][~] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [label=\"%s\",style=dashed,arrowhead=curve];\n", n, mark, p_n, p_mark, line_label);
			if (module_attach != "") {
				printf("\t\"%s\" -> \"%s\" [style=dashed,arrowhead=curve];\n", module_attach" "name, n);
				module_attach = "";
			}
			print_subgraph(n);
		}
		# linked
		else if (match(node, "^[<] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [label=\"%s\",style=solid,arrowhead=curve];\n", n, mark, p_n, p_mark, line_label);
			if (module_attach != "") {
				printf("\t\"%s\" -> \"%s\" [style=solid,arrowhead=curve];\n", module_attach" "name, n);
				module_attach = "";
			}
			print_subgraph(n);
		}
		# 聚合
		else if (match(node, "^[{] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [dir=back,label=\"%s\",style=solid,arrowhead=odiamond];\n", p_n, p_mark, n, mark, line_label);
			print_subgraph(n);
		}
		# 组合
		else if (match(node, "^[{][{] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [dir=back,label=\"%s\",style=solid,arrowhead=diamond];\n", p_n, p_mark, n, mark, line_label);
			print_subgraph(n);
		}
		# 继承
		else if (match(node, "^[\\^] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [dir=back,label=\"%s\",style=solid,arrowhead=empty];\n", p_n, p_mark, n, mark, line_label);
			print_subgraph(n);
		}
		# 实现
		else if (match(node, "^[\\^][\\^] ")) {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [dir=back,label=\"%s\",style=dashed,arrowhead=empty];\n", p_n, p_mark, n, mark, line_label);
			print_subgraph(n);
		}
		# equal
		else if (match(node, "^[=] ")) {
			n = name_filter(n, 0);
			#printf("\t\"%s\"%s -> \"%s\"%s [dir=none,label=\"%s\",style=dotted,arrowhead=none];{rank=same; \"%s\"%s; \"%s\"%s;};\n",
			#	   p_n, p_mark, n, mark, line_label, p_n, p_mark, n, mark);
			printf("\t\"%s\"%s -> \"%s\"%s [dir=none,label=\"%s\",style=dotted,arrowhead=none];\n",
				   p_n, p_mark, n, mark, line_label);
			#printf("\t\"%s\"%s -> \"%s\"%s [color=%s,arrowhead=none];\n",
			#	   n, mark, p_n, p_mark, bgcolor);
			#printf("\t\"%s\"%s -> \"%s\"%s [style=dotted,color=%s,arrowhead=none];\n",
			#	   n, mark, p_n, p_mark, equal_color);
			print_subgraph(n);
		}
		# invoke
		else {
			n = name_filter(n, 0);
			printf("\t\"%s\"%s -> \"%s\"%s [label=\"%s\",style=solid,arrowhead=curve];\n", p_n, p_mark, n, mark, line_label);
			print_subgraph(n);
		}
	}

	oldnodedepth = nodedepth;
	oldnode = node;
	oldmark = mark;
} END {
	if (output == "dot")
		printf("}");
}
